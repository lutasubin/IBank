import 'package:ibank/features/auth/shared/mock_auth_store.dart';

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
  }) async {
    // Mock delay để giả lập call API / Firebase
    await Future.delayed(const Duration(seconds: 2));

    // Đăng ký user mới vào MockAuthStore (dùng chung với sign in)
    return MockAuthStore.signUp(
      name: name,
      email: email,
      password: password,
    );
  }
}

