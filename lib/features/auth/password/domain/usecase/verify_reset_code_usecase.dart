import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repositories/password_repository.dart';

class VerifyResetCodeParams {
  final String email;
  final String code;

  const VerifyResetCodeParams({
    required this.email,
    required this.code,
  });
}

class VerifyResetCodeUseCase
    implements UseCase<void, VerifyResetCodeParams> {
  final PasswordRepository repository;

  VerifyResetCodeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(VerifyResetCodeParams params) {
    return repository.verifyResetCode(
      email: params.email,
      code: params.code,
    );
  }
}


