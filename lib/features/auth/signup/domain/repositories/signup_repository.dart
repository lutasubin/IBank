import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../signin/domain/entities/user_entity.dart';

abstract class SignUpRepository {
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  });
}

