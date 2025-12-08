enum ForgotPasswordStatus { initial, loading, success, failure }

class ForgotPasswordState {
  final ForgotPasswordStatus status;
  final String email;
  final bool isEmailValid;
  final String? errorMessage;

  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.initial,
    this.email = '',
    this.isEmailValid = true,
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? email,
    bool? isEmailValid,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      errorMessage: errorMessage,
    );
  }
}


