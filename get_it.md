# Thư viện GetIt trong Flutter/Dart

## 1. GetIt là gì?

**GetIt** là một **Service Locator** cho Dart/Flutter, dùng để **quản lý dependency (các class, service, repository, bloc, use case…)** một cách tập trung.

- Thay vì tạo instance thủ công hoặc truyền dependency qua constructor khắp nơi, bạn chỉ cần **đăng ký** các class với GetIt và **lấy ra** khi cần.
- Giúp code **gọn gàng, dễ maintain, dễ test** và phù hợp với **Clean Architecture**.

---

## 2. Lợi ích của GetIt

1. **Quản lý dependency tập trung**  
   Tất cả các service, repository, use case đều được đăng ký ở một nơi (ví dụ `injection_container.dart`).

2. **Tách biệt UI và logic**  
   UI chỉ cần lấy bloc hoặc service từ GetIt, không cần biết cách tạo các dependency bên trong.

3. **Dễ test**  
   Có thể thay thế các dependency bằng mock class khi viết unit test.

4. **Không cần context**  
   Khác với Provider hay InheritedWidget, GetIt có thể lấy instance bất cứ đâu mà không cần `BuildContext`.

---

## 3. Các kiểu đăng ký dependency

| Method | Ý nghĩa |
|--------|---------|
| `registerFactory(() => MyClass())` | Mỗi lần gọi `sl<MyClass>()` → tạo **instance mới** |
| `registerLazySingleton(() => MyClass())` | Tạo **instance lần đầu tiên** khi cần, sau đó **dùng lại** |
| `registerSingleton(MyClass())` | Tạo **instance ngay khi đăng ký**, mọi lần gọi đều dùng lại instance đó |
| `registerSingletonAsync(() => MyClass().init())` | Dùng cho async initialization (ví dụ SharedPreferences, Database) |

---

## 4. Cách sử dụng cơ bản

### a) Đăng ký

```dart
import 'package:get_it/get_it.dart';
final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton(() => ApiService());
  sl.registerFactory(() => UserBloc(apiService: sl()));
}

b) Lấy instance
dart
Sao chép mã
final api = sl<ApiService>(); // Lấy singleton ApiService
final bloc = sl<UserBloc>();  // Tạo mới UserBloc, tự động inject ApiService
c) Trong Widget (ví dụ với BlocProvider)
dart
Sao chép mã
BlocProvider(
  create: (_) => sl<UserBloc>(),
  child: UserScreen(),
);
5. Luồng dependency trong Clean Architecture
Ví dụ SignIn trong Flutter:

csharp
Sao chép mã
UI Layer (SignInPage)
        │
        ▼
Bloc (SignInBloc) <- sl<SignInBloc>()
        │
        ▼
UseCase (SignInUseCase) <- sl<SignInUseCase>()
        │
        ▼
Repository (AuthRepositoryImpl) <- sl<AuthRepository>()
        │
        ▼
DataSource (AuthRemoteDataSourceImpl) <- sl<AuthRemoteDataSource>()
        │
        ▼
API/Database
Giải thích:

Khi UI gọi sl<SignInBloc>(), GetIt tự động tạo tất cả dependency bên dưới: UseCase → Repository → DataSource.

UI không cần gọi trực tiếp UseCase, Repository hay DataSource.

6. Khi nào dùng GetIt
Quản lý các service/logic tập trung.

Xây dựng Clean Architecture: UI, Bloc, UseCase, Repository, DataSource tách biệt.

Khi muốn code dễ maintain, dễ test.

7. Lưu ý
GetIt không quản lý state trực tiếp.

Bạn vẫn cần Bloc, Cubit, GetX, hoặc ValueNotifier để quản lý state.

Dùng GetIt để inject dependency, tránh phải tạo class thủ công hoặc truyền qua constructor dài dòng.