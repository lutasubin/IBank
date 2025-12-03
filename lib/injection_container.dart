// ==================== DEPENDENCY INJECTION ====================
// lib/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:ibank/features/auth/signin/data/datasources/auth_remote_datasource_impl.dart';
import 'package:ibank/features/auth/signin/data/models/auth_remote_datasource.dart';
import 'package:ibank/features/auth/signin/data/repositories/auth_repository_impl.dart';
import 'package:ibank/features/auth/signin/domain/repositories/auth_repository.dart';
import 'package:ibank/features/auth/signin/domain/usecase/signin_usecase.dart';
import 'package:ibank/features/auth/signin/persentation/logic_hoders/bloc/signin_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==================== Features - Auth ====================
  
  // Bloc
  sl.registerFactory(
    () => SignInBloc(signInUseCase: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
}