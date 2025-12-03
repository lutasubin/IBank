import '../../../domain/entities/user_entity.dart';

enum SignInStatus { initial, loading, success, failure }

class SignInState {
  final SignInStatus status;
  final String email;
  final String password;
  final String? errorMessage;
  final UserEntity? user;
  final bool isEmailValid;
  final bool isPasswordValid;

  const SignInState({
    this.status = SignInStatus.initial,
    this.email = '',
    this.password = '',
    this.errorMessage,
    this.user,
    this.isEmailValid = true,
    this.isPasswordValid = true,
  });

  SignInState copyWith({
    SignInStatus? status,
    String? email,
    String? password,
    String? errorMessage,
    UserEntity? user,
    bool? isEmailValid,
    bool? isPasswordValid,
  }) {
    return SignInState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage, // IMPORTANT: Không dùng ?? để có thể set null
      user: user ?? this.user,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    );
  }
}