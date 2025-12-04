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

### 4. Forgot Password (email + code 8422)

- **UI**: `ForgotPasswordPage` (Stateful) với 2 bước:
  1. **Nhập email**
     - TextField email với `TextEditingController` giữ state.
     - Nút **Send** chỉ active khi email hợp lệ và không loading.
  2. **Nhập code**
     - TextField code 4 số, bàn phím số.
     - Nút **Change password** active khi code đủ 4 kí tự và hợp lệ.
     - Link `"Change your email"` → `Navigator.pop()` quay lại bước email.
- **BLoC**:
  - `ForgotPasswordBloc` + `ForgotPasswordState` + `ForgotPasswordEvent`.
  - `step`: `enterEmail` / `enterCode`.
  - `status`: `initial/loading/success/failure`.
  - Use cases:
    - `RequestResetCodeUseCase(email)`.
    - `VerifyResetCodeUseCase(email, code)`.
- **Logic listener**:
  - Gửi code thành công:
    - `status == success`, `step == enterCode`, `state.code.isEmpty` → show SnackBar `"Verification code has been sent (8422)"`.
  - Verify code thành công:
    - `status == success`, `step == enterCode`, `state.code.isNotEmpty` → `pushReplacementNamed('/change-password', args: {'email': state.email})`.
- **Data / domain**:
  - `PasswordRemoteDataSourceImpl` dùng `MockAuthStore`:
    - `requestResetCode(email)` → `MockAuthStore.requestPasswordReset(email)` (set code `'8422'`).  
    - `verifyResetCode(email, code)` → `MockAuthStore.verifyResetCode`.

> **Firebase TODO** (gợi ý):
> - Dùng `FirebaseAuth.sendPasswordResetEmail(email)` hoặc custom OTP với Firestore/Cloud Functions.
> - Khi dùng flow reset của Firebase, có thể bỏ phần verify code custom và chỉ mở link reset trong app/webview.

---

### 5. Change Password

- **UI**: `ChangePasswordPage` (Stateful):
  - Nhận `email` qua `ModalRoute.arguments` từ màn Forgot.
  - Hai trạng thái:
    1. **Form**: nhập `New password` + `Confirm password`.
    2. **Success**: màn hình thành công với illustration + nút **Ok** quay về `'/'` và clear stack (`pushNamedAndRemoveUntil`).
  - TextField dùng controller `_newController`, `_confirmController` được đồng bộ một chiều với state để tránh lỗi “gõ ngược/nhảy con trỏ”.
- **BLoC**:
  - `ChangePasswordBloc` + `ChangePasswordState` + `ChangePasswordEvent`.
  - Domain:
    - `ChangePasswordUseCase(ChangePasswordParams(email, newPassword))`.
  - Validate:
    - `Validators.isValidPassword(newPassword)`.
    - `confirmPassword == newPassword`.
  - Thành công: `step = success`, hiển thị màn thành công.
- **Data / domain**:
  - `PasswordRemoteDataSourceImpl.changePassword` → `MockAuthStore.changePassword(email, newPassword)`.

> **Firebase TODO**:
> - Với flow reset chính thức của Firebase, đổi mật khẩu thường do Firebase xử lý qua link email; nếu muốn giữ flow custom, có thể dùng Cloud Functions để verify OTP và cập nhật password trong Firebase Auth.

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
  - `'/change-password'` → `ChangePasswordPage`.
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
   - `PasswordRemoteDataSourceImpl` (3 method) → triển khai bằng `FirebaseAuth` hoặc flow OTP custom.
4. Xoá/disable `MockAuthStore` khi đã có backend thật.
5. Không cần thay đổi BLoC, UI, UseCase, route – chúng đã tách biệt với tầng data.


