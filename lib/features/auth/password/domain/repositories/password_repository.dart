import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';

abstract class PasswordRepository {
  Future<Either<Failure, void>> requestResetCode({
    required String email,
  });

  Future<Either<Failure, void>> verifyResetCode({
    required String email,
    required String code,
  });

  Future<Either<Failure, void>> changePassword({
    required String code,
    required String newPassword,
  });
}


