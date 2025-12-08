abstract class PasswordRemoteDataSource {
  Future<void> requestResetCode({
    required String email,
  });

  Future<void> verifyResetCode({
    required String email,
    required String code,
  });

  Future<void> changePassword({
    required String code,
    required String newPassword,
  });
}


