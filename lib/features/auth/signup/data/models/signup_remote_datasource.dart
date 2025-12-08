import '../../../signin/data/models/user_model.dart';
import '../../../signin/domain/entities/user_entity.dart';

abstract class SignUpRemoteDataSource {
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    UserRole role,
  });
}

