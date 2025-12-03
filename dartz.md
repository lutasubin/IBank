# Thư viện Dartz trong Flutter/Dart

## 1. Dartz là gì?

**Dartz** là một thư viện cho **Functional Programming (FP)** trong Dart.  
Nó cung cấp các **cấu trúc dữ liệu và toán tử FP** giúp viết code **an toàn, rõ ràng, dễ test**, rất phù hợp với **Clean Architecture**.

---

## 2. Các khái niệm quan trọng

### a) Either<L, R>

- Dùng để **trả về kết quả thành công hoặc lỗi**.  
- `L` = Left = thường là lỗi (Failure/Error)  
- `R` = Right = thành công (Result/Data)  

**Ví dụ:**

```dart
import 'package:dartz/dartz.dart';

Either<String, int> parseNumber(String str) {
  try {
    final num = int.parse(str);
    return Right(num); // Thành công
  } catch (e) {
    return Left('Invalid number'); // Lỗi
  }
}

void main() {
  final result = parseNumber("123");
  result.fold(
    (l) => print("Error: $l"), 
    (r) => print("Parsed: $r")
  );
}
Kết quả: Parsed: 123

b) Option<T>
Giống như nullable nhưng an toàn hơn.

Some(value) = có giá trị

None() = không có giá trị

Ví dụ:

dart
Sao chép mã
import 'package:dartz/dartz.dart';

Option<int> findEven(List<int> numbers) {
  return numbers.firstWhere((x) => x % 2 == 0, orElse: () => null)
      ?.let((v) => Some(v)) ?? None();
}
c) Task<T> / TaskEither<L, R>
Task là một hàm trả về Future, giúp chain async theo kiểu functional.

TaskEither = kết hợp Task + Either → xử lý async + lỗi an toàn.

Ví dụ:

dart
Sao chép mã
import 'package:dartz/dartz.dart';

Future<Either<String, int>> fetchNumber(bool succeed) async {
  if (succeed) return Right(42);
  return Left("Failed to fetch number");
}

void main() async {
  final result = await fetchNumber(true);
  result.fold(
    (l) => print("Error: $l"),
    (r) => print("Success: $r")
  );
}
3. Lợi ích chính
Tách biệt lỗi và dữ liệu → không cần try/catch khắp nơi.

Chainable & composable → dễ kết hợp nhiều hàm mà không phải unwrap/null check thủ công.

Dễ test → test logic mà không phụ thuộc UI hoặc side effects.

Phù hợp Clean Architecture → Repository trả Either<Failure, Data> cho UseCase, UI xử lý Right/Left.

4. Sử dụng Dartz trong Clean Architecture
a) Repository
dart
Sao chép mã
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });
}
Trả về Right(UserEntity) nếu thành công

Trả về Left(Failure) nếu thất bại

b) UseCase
dart
Sao chép mã
class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password) {
    return repository.signIn(email: email, password: password);
  }
}
c) UI / Bloc
dart
Sao chép mã
final result = await signInUseCase(email, password);
result.fold(
  (failure) => emit(SignInState.failure(failure.message)),
  (user) => emit(SignInState.success(user)),
);
5. Khi nào nên dùng Dartz
Khi muốn xử lý lỗi rõ ràng mà không cần try/catch liên tục.

Khi viết Repository → UseCase → UI theo Clean Architecture.

Khi muốn code an toàn, dễ maintain, dễ test.

6. Lưu ý
Dartz mang phong cách Functional Programming, nên cú pháp hơi khác với lập trình OOP thuần Dart.

Kết hợp tốt với Bloc / Cubit để xử lý state dựa trên Either hoặc Option.