import 'package:ibank/features/auth/shared/mock_auth_store.dart';

import 'package:ibank/features/auth/password/data/models/password_remote_datasource.dart';

class PasswordRemoteDataSourceImpl implements PasswordRemoteDataSource {
  // TODO(Firebase Auth):
  //  - requestResetCode: dùng FirebaseAuth.sendPasswordResetEmail(email)
  //  - verifyResetCode + changePassword: tuỳ flow custom, hoặc dùng link reset của Firebase
  //  - MockAuthStore chỉ phục vụ cho demo local.

  @override
  Future<void> requestResetCode({required String email}) async {
    await MockAuthStore.requestPasswordReset(email: email);
  }

  @override
  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    await MockAuthStore.verifyResetCode(email: email, code: code);
  }

  @override
  Future<void> changePassword({
    required String email,
    required String newPassword,
  }) async {
    await MockAuthStore.changePassword(
      email: email,
      newPassword: newPassword,
    );
  }
}


