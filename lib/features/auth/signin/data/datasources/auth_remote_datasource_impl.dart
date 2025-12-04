// lib/features/auth/data/datasources/auth_remote_datasource_impl.dart
import '../../../shared/mock_auth_store.dart';
import '../models/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // TODO(Firebase Auth):
  //  - Thay toàn bộ logic bên trong signIn() bằng gọi FirebaseAuth.signInWithEmailAndPassword
  //  - Map từ UserCredential -> UserModel (id, email, name)
  //  - MockAuthStore chỉ dùng cho môi trường local demo, có thể xoá khi dùng Firebase thật
  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    // Mock delay
    await Future.delayed(const Duration(seconds: 2));

    // Ủy quyền cho MockAuthStore để chia sẻ user với luồng sign up
    return MockAuthStore.signIn(email: email, password: password);
  }
}