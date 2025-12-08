enum UserRole { user, admin }

extension UserRoleX on UserRole {
  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'user':
      default:
        return UserRole.user;
    }
  }

  String get asString => name;
}

class UserEntity {
  final String id;
  final String email;
  final String name;
  final UserRole role;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.role = UserRole.user,
  });
}