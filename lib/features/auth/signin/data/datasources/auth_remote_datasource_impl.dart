// lib/features/auth/data/datasources/auth_remote_datasource_impl.dart
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../signin/domain/entities/user_entity.dart';
import '../models/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final user = credential.user;
      if (user == null) {
        throw const ServerException('User not found');
      }

      // Lấy custom claims để phân role (nếu đã set ở backend). Mặc định user.
      final token = await user.getIdTokenResult();
      final roleClaim = (token.claims?['role'] as String?) ?? 'user';

      return UserModel(
        id: user.uid,
        email: user.email ?? email,
        name: user.displayName ?? '',
        role: UserRoleX.fromString(roleClaim),
      );
    } on FirebaseAuthException catch (e) {
      // Map lỗi Firebase -> ServerException để repository xử lý
      throw ServerException(e.message ?? 'Sign in failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}