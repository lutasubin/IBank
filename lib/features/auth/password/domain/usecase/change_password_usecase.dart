import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repositories/password_repository.dart';

class ChangePasswordParams {
  final String email;
  final String newPassword;

  const ChangePasswordParams({
    required this.email,
    required this.newPassword,
  });
}

class ChangePasswordUseCase
    implements UseCase<void, ChangePasswordParams> {
  final PasswordRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) {
    return repository.changePassword(
      email: params.email,
      newPassword: params.newPassword,
    );
  }
}


