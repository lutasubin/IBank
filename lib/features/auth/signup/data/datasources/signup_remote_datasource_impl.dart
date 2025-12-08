import 'package:firebase_auth/firebase_auth.dart';
import 'package:ibank/features/auth/signin/domain/entities/user_entity.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../signin/data/models/user_model.dart';
import '../models/signup_remote_datasource.dart';

class SignUpRemoteDataSourceImpl implements SignUpRemoteDataSource {
  // TODO(Firebase Auth + Firestore):
  //  - Thay signUp() bằng:
  //      1. FirebaseAuth.createUserWithEmailAndPassword(email, password)
  //      2. Lưu thêm thông tin user (name, createdAt, ...) vào Firestore
  //      3. Map dữ liệu Firebase -> UserModel
  //  - Khi đó không cần dùng MockAuthStore nữa.
  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.user,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = credential.user;
      if (user == null) {
        throw const ServerException('Cannot create user');
      }

      // Cập nhật displayName để UI có tên
      await user.updateDisplayName(name);

      // Lấy custom claims role nếu backend đã set (ví dụ qua Cloud Functions)
      final token = await user.getIdTokenResult(true);
      final roleClaim = (token.claims?['role'] as String?) ?? role.asString;

      return UserModel(
        id: user.uid,
        email: user.email ?? email,
        name: user.displayName ?? name,
        role: UserRoleX.fromString(roleClaim),
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Sign up failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

