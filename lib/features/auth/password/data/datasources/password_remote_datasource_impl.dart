import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/error/exceptions.dart';
import 'package:ibank/features/auth/password/data/models/password_remote_datasource.dart';

class PasswordRemoteDataSourceImpl implements PasswordRemoteDataSource {
  // Firebase reset flow chuẩn:
  // - requestResetCode: gửi email reset (Firebase tự xử lý code trong link)
  // - verifyResetCode: không dùng (link đã chứa oobCode do Firebase quản lý)
  // - changePassword: dùng confirmPasswordReset(oobCode, newPassword) khi bạn bắt link trong app/web

  @override
  Future<void> requestResetCode({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
          // TODO: cập nhật domain website bạn sở hữu (đã add vào Authorized domains)
          url: 'https://www.ibank.com/reset',
          handleCodeInApp: true,
          androidPackageName: 'com.example.ibank',
          androidInstallApp: true,
          iOSBundleId: 'com.example.ibank',
        ),
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Failed to send reset email');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    // Không cần verify code thủ công trong flow reset email của Firebase.
    // Nếu vẫn muốn giữ API, coi như pass-through.
    return;
  }

  @override
  Future<void> changePassword({
    required String code,
    required String newPassword,
  }) async {
    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Failed to reset password');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}


