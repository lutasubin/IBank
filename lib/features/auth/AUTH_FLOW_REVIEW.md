## Auth Flow Review (Mock + Firebase-ready)

### 1. Tổng quan kiến trúc

- **Pattern**: Clean Architecture + BLoC + GetIt DI.
- **Features chính**:
  - `signin`: đăng nhập với email/password.
  - `signup`: tạo tài khoản mới.
  - `password/forgot`: quên mật khẩu (gửi & xác thực mã).
  - `password/change`: đổi mật khẩu sau khi xác thực mã.
- **Mock backend dùng chung**: `lib/features/auth/shared/mock_auth_store.dart`.
  - Lưu danh sách user + password.
  - Lưu mã reset password (code 4 số) cho từng email.
  - Mọi luồng SignIn / SignUp / Forgot / Change đều đi qua mock này.

> Khi nối Firebase, chỉ cần thay implementation ở tầng *remote datasource* (và có thể bỏ `MockAuthStore`), UI/BLoC/UseCase giữ nguyên.

---

### 2. Sign In

- **UI**:
  - `SignInPage` + `SignInForm` (Feature: `auth/signin/persentation`).
  - Validate email/password, hiển thị lỗi, loading spinner khi submit.
  - Link:
    - `"Forgot your password?"` → `'/forgot-password'`.
    - `"Sign Up"` → `'/signup'` (pushReplacement).
- **BLoC**:
  - `SignInBloc` + `SignInState` + `SignInEvent`.
  - Gọi `SignInUseCase` → `AuthRepository.signIn`.
  - Thành công: điều hướng `Navigator.pushReplacementNamed('/home', args user)`.
  - Thất bại: hiển thị `SnackBar` + reset error bằng `SignInErrorDismissed`.
- **Data / domain**:
  - `AuthRemoteDataSourceImpl.signIn` → `MockAuthStore.signIn(email, password)`.
  - `AuthRepositoryImpl` map `ServerException` → `ServerFailure`.

> **Firebase TODO**: trong `AuthRemoteDataSourceImpl`, thay thân hàm `signIn` bằng `FirebaseAuth.signInWithEmailAndPassword`, map `UserCredential` → `UserModel`.

---

### 3. Sign Up

- **UI**:
  - `SignUpPage` + `SignUpForm` (Feature: `auth/signup/persentation`).
  - Field: Name, Email, Password, checkbox điều khoản, illustration SVG.
  - `"Have an account? Sign In"` → `Navigator.pushReplacementNamed('/', ...)`.
- **BLoC**:
  - `SignUpBloc` + `SignUpState` + `SignUpEvent`.
  - Validate:
    - `name` không rỗng.
    - `email` hợp lệ (`Validators.isValidEmail`).
    - `password` không rỗng (rule chi tiết có thể dùng `Validators.isValidPassword` khi cần).
    - Phải tick *Terms & Conditions*.
  - Submit: gọi `SignUpUseCase` → thành công điều hướng `/home` với user.
- **Data / domain**:
  - `SignUpRemoteDataSourceImpl.signUp` → `MockAuthStore.signUp(name, email, password)`.
  - `SignUpRepositoryImpl` wrap datasource, map exception → `Failure`.

> **Firebase TODO**: trong `SignUpRemoteDataSourceImpl.signUp` thay bằng:
> - `FirebaseAuth.createUserWithEmailAndPassword(email, password)`.
> - Lưu `name` + info khác vào Firestore.
> - Map dữ liệu Firebase → `UserModel`.

---

### 4. Forgot Password (Firebase email reset)

- **UI**: `ForgotPasswordPage` chỉ còn 1 bước nhập email, bấm gửi → hiển thị thông báo “Email reset đã được gửi…”, sau đó quay lại màn trước.
- **BLoC**:
  - `ForgotPasswordBloc` + `ForgotPasswordState` + `ForgotPasswordEvent` (chỉ còn email + send).
  - `status`: `initial/loading/success/failure`.
  - Use case: `RequestResetCodeUseCase(email)` (gọi Firebase `sendPasswordResetEmail`).
- **Logic listener**:
  - Thành công: SnackBar hướng dẫn kiểm tra email, rồi `Navigator.pop`.
  - Thất bại: SnackBar lỗi.
- **Data / domain**:
  - `PasswordRemoteDataSourceImpl.requestResetCode` → `FirebaseAuth.sendPasswordResetEmail`.
  - `verifyResetCode` không dùng; `changePassword` ném lỗi hướng dẫn dùng link reset (Firebase xử lý oobCode).

---

### 5. Change Password

- App hiện không dùng màn ChangePassword (reset thực hiện trên trang web qua link email của Firebase).
- Nếu muốn đổi mật khẩu trong app bằng oobCode: cần bắt deep link và dùng `confirmPasswordReset(oobCode, newPassword)`, thêm route/màn hình khi cần.

---

### 6. GetIt DI & Routes

- **DI** (`lib/injection_container.dart`):
  - SignIn: `SignInBloc`, `SignInUseCase`, `AuthRepositoryImpl`, `AuthRemoteDataSourceImpl`.
  - SignUp: `SignUpBloc`, `SignUpUseCase`, `SignUpRepositoryImpl`, `SignUpRemoteDataSourceImpl`.
  - Password:
    - `PasswordRemoteDataSourceImpl`.
    - `PasswordRepositoryImpl`.
    - `RequestResetCodeUseCase`, `VerifyResetCodeUseCase`, `ChangePasswordUseCase`.
    - `ForgotPasswordBloc` (factory).
    - `ChangePasswordBloc` (factoryParam nhận `email`).
- **Routes** (`lib/Ibank_app.dart`):
  - `'/'` → `SignInPage`.
  - `'/signup'` → `SignUpPage`.
  - `'/forgot-password'` → `ForgotPasswordPage`.
  - `'/home'` → `HomePage`.

---

### 7. Những điểm đã fix UX

- **Controllers bị tạo trong build** gây cảm giác “gõ ngược / xoá ngược”:
  - Đã chuyển `ForgotPasswordView` và `ChangePasswordView` sang **StatefulWidget** với controller riêng, đồng bộ một chiều từ state → controller.
- **Back từ SignUp không về được SignIn**:
  - AppBar back button trên `SignUpPage` giờ dùng `Navigator.pushReplacementNamed(context, '/')` thay vì `pop()`.
- **Flow Forgot không điều hướng / không báo code**:
  - Đã tách rõ 2 case SnackBar (gửi code) và điều hướng (verify thành công) như mô tả ở mục 4.

---

### 8. Checklist khi nối Firebase sau này

1. Cài dependency Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore`, ...).
2. Khởi tạo Firebase trong `main()` trước khi `runApp`.
3. Thay thế logic trong các datasource sau:
   - `AuthRemoteDataSourceImpl.signIn` → dùng `FirebaseAuth`.
   - `SignUpRemoteDataSourceImpl.signUp` → `FirebaseAuth` + `Firestore`.
   - `PasswordRemoteDataSourceImpl`:
     - `requestResetCode` → `FirebaseAuth.sendPasswordResetEmail` (đã làm).
       - Sử dụng `actionCodeSettings` với domain website của bạn (ví dụ `https://www.ibank.com/reset`), `handleCodeInApp=true`, `androidPackageName com.example.ibank`, `iOSBundleId com.example.ibank`.
     - `changePassword` → `FirebaseAuth.confirmPasswordReset(oobCode, newPassword)` (đã làm).
     - `verifyResetCode` bỏ qua (oobCode trong link Firebase).
4. Xoá/disable `MockAuthStore` khi đã có backend thật.
5. Không cần thay đổi BLoC, UI, UseCase, route – chúng đã tách biệt với tầng data.
6. Flow reset email:
   - Gửi email với `actionCodeSettings` (handleCodeInApp=true) dùng domain website đã add vào Authorized domains.
   - Bắt `oobCode` qua deep link (App Links/Universal Links) và truyền vào `ChangePasswordPage` qua `arguments['oobCode']`.
   - `ChangePasswordPage` gọi `confirmPasswordReset` để đặt mật khẩu mới.

### 9. Gán quyền admin bằng custom claim (script kèm sẵn)
- Service account: `serviceAccountKey/ibank-12730-firebase-adminsdk-fbsvc-ccbbbe56dc.json`.
- Script gán claim: `tools/set_admin_role.js`.
- Lệnh chạy (bash/Git Bash):
  ```
  cd /c/ibank && export GOOGLE_APPLICATION_CREDENTIALS="/c/ibank/serviceAccountKey/ibank-12730-firebase-adminsdk-fbsvc-ccbbbe56dc.json" && node tools/set_admin_role.js admin@gmail.com
  ```
- Sau khi gán claim, đăng xuất/đăng nhập lại để token có claim mới, rồi dùng luồng `/admin-signin`.


