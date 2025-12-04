import '../../../../signin/domain/entities/user_entity.dart';

enum SignUpStatus { initial, loading, success, failure }

class SignUpState {
  final SignUpStatus status;
  final String name;
  final String email;
  final String password;
  final bool isNameValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isTermsAccepted;
  final String? errorMessage;
  final UserEntity? user;

  const SignUpState({
    this.status = SignUpStatus.initial,
    this.name = '',
    this.email = '',
    this.password = '',
    this.isNameValid = true,
    this.isEmailValid = true,
    this.isPasswordValid = true,
    this.isTermsAccepted = false,
    this.errorMessage,
    this.user,
  });

  SignUpState copyWith({
    SignUpStatus? status,
    String? name,
    String? email,
    String? password,
    bool? isNameValid,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isTermsAccepted,
    String? errorMessage,
    UserEntity? user,
  }) {
    return SignUpState(
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isNameValid: isNameValid ?? this.isNameValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }
}

