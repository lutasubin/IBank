// ==================== DEPENDENCY INJECTION ====================
// lib/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:ibank/features/auth/signin/data/datasources/auth_remote_datasource_impl.dart';
import 'package:ibank/features/auth/signin/data/models/auth_remote_datasource.dart';
import 'package:ibank/features/auth/signin/data/repositories/auth_repository_impl.dart';
import 'package:ibank/features/auth/signin/domain/repositories/auth_repository.dart';
import 'package:ibank/features/auth/signin/domain/usecase/signin_usecase.dart';
import 'package:ibank/features/auth/signin/persentation/logic_hoders/bloc/signin_bloc.dart';
import 'package:ibank/features/auth/signup/data/datasources/signup_remote_datasource_impl.dart';
import 'package:ibank/features/auth/signup/data/models/signup_remote_datasource.dart';
import 'package:ibank/features/auth/signup/data/repositories/signup_repository_impl.dart';
import 'package:ibank/features/auth/signup/domain/repositories/signup_repository.dart';
import 'package:ibank/features/auth/signup/domain/usecase/signup_usecase.dart';
import 'package:ibank/features/auth/signup/persentation/logic_hoders/bloc/signup_bloc.dart';
import 'package:ibank/features/auth/password/data/datasources/password_remote_datasource_impl.dart';
import 'package:ibank/features/auth/password/data/models/password_remote_datasource.dart';
import 'package:ibank/features/auth/password/data/repositories/password_repository_impl.dart';
import 'package:ibank/features/auth/password/domain/repositories/password_repository.dart';
import 'package:ibank/features/auth/password/domain/usecase/request_reset_code_usecase.dart';
import 'package:ibank/features/auth/password/domain/usecase/verify_reset_code_usecase.dart';
import 'package:ibank/features/auth/password/persentation/logic_hoders/bloc/forgot_password_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==================== Features - Auth ====================
  
  // Bloc
  sl.registerFactory(
    () => SignInBloc(signInUseCase: sl()),
  );
  sl.registerFactory(
    () => SignUpBloc(signUpUseCase: sl()),
  );
  sl.registerFactory(
    () => ForgotPasswordBloc(
      requestResetCodeUseCase: sl(),
      verifyResetCodeUseCase: sl(),
    ),
  );
  

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => RequestResetCodeUseCase(sl()));
  sl.registerLazySingleton(() => VerifyResetCodeUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SignUpRepository>(
    () => SignUpRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PasswordRepository>(
    () => PasswordRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<SignUpRemoteDataSource>(
    () => SignUpRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<PasswordRemoteDataSource>(
    () => PasswordRemoteDataSourceImpl(),
  );
}