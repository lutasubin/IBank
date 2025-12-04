import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repositories/password_repository.dart';

class RequestResetCodeParams {
  final String email;

  const RequestResetCodeParams({required this.email});
}

class RequestResetCodeUseCase
    implements UseCase<void, RequestResetCodeParams> {
  final PasswordRepository repository;

  RequestResetCodeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RequestResetCodeParams params) {
    return repository.requestResetCode(email: params.email);
  }
}


