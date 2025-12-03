// lib/features/auth/data/datasources/auth_remote_datasource_impl.dart
import '../models/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // TODO: Replace with Firebase later
  
  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    // Mock delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock validation
    if (email == 'test@gmail.com' && password == 'thanh123') {
      return const UserModel(
        id: '1',
        email: 'test@gmail.com',
        name: 'DucThanhNguyen',
      );
    } else {
      throw Exception('Invalid email or password');
    }
  }
}