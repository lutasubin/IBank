import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../signin/domain/entities/user_entity.dart';
import '../repositories/signup_repository.dart';

class SignUpParams {
  final String name;
  final String email;
  final String password;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

class SignUpUseCase implements UseCase<UserEntity, SignUpParams> {
  final SignUpRepository repository;

  SignUpUseCase(this.repository);

  @override
  // ignore: override_on_non_overriding_member
  Future<Either<Failure, UserEntity>> call(SignUpParams params) async {
    return await repository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

