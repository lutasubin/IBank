import '../../../signin/data/models/user_model.dart';

abstract class SignUpRemoteDataSource {
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });
}

