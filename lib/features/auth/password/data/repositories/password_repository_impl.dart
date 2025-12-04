import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/repositories/password_repository.dart';
import '../models/password_remote_datasource.dart';

class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordRemoteDataSource remoteDataSource;

  PasswordRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> requestResetCode({
    required String email,
  }) async {
    try {
      await remoteDataSource.requestResetCode(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      await remoteDataSource.verifyResetCode(email: email, code: code);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        email: email,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}


