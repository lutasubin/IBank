// lib/features/auth/data/datasources/auth_remote_datasource.dart
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String email,
    required String password,
  });
}