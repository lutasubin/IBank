import '../../auth/signin/data/models/user_model.dart';
import '../../../core/error/exceptions.dart';

// TODO(Firebase):
//  - File này CHỈ dùng cho mock local.
//  - Khi chuyển sang Firebase, bạn có thể xoá toàn bộ MockAuthStore
//    và thay bằng implementation thật trong AuthRemoteDataSourceImpl
//    và SignUpRemoteDataSourceImpl (Firebase Auth + Firestore).

class _StoredUser {
  final UserModel user;
  final String password;

  const _StoredUser({
    required this.user,
    required this.password,
  });
}

class MockAuthStore {
  // Danh sách user mock dùng chung cho sign in & sign up
  static final List<_StoredUser> _users = [
    _StoredUser(
      user: const UserModel(
        id: '1',
        email: 'test@gmail.com',
        name: 'DucThanhNguyen',
      ),
      password: 'thanh123',
    ),
  ];

  // Mã reset password mock, key theo email
  static final Map<String, String> _resetCodes = {};

  static Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final stored = _users.firstWhere(
        (u) => u.user.email == email && u.password == password,
      );
      return stored.user;
    } catch (_) {
      throw const ServerException('Invalid email or password');
    }
  }

  static Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final exists = _users.any((u) => u.user.email == email);
    if (exists) {
      throw const ServerException('Email already in use');
    }

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
    );

    _users.add(
      _StoredUser(
        user: user,
        password: password,
      ),
    );

    return user;
  }

  /// Yêu cầu reset password: kiểm tra user tồn tại và sinh mã code mock
  static Future<void> requestPasswordReset({
    required String email,
  }) async {
    final exists = _users.any((u) => u.user.email == email);
    if (!exists) {
      throw const ServerException('User not found');
    }

    // Trong thực tế sẽ gửi code qua email/SMS. Ở đây mock một code cố định.
    _resetCodes[email] = '8422';
  }

  /// Xác thực mã reset password
  static Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    final saved = _resetCodes[email];
    if (saved == null || saved != code) {
      throw const ServerException('Invalid or expired code');
    }
  }

  /// Đổi mật khẩu sau khi đã verify code
  static Future<void> changePassword({
    required String email,
    required String newPassword,
  }) async {
    final index = _users.indexWhere((u) => u.user.email == email);
    if (index == -1) {
      throw const ServerException('User not found');
    }

    final updated = _StoredUser(
      user: _users[index].user,
      password: newPassword,
    );
    _users[index] = updated;

    // Sau khi đổi mật khẩu thì xoá code reset
    _resetCodes.remove(email);
  }
}


