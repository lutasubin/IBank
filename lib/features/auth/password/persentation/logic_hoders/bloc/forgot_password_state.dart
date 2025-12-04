enum ForgotPasswordStep { enterEmail, enterCode }

enum ForgotPasswordStatus { initial, loading, success, failure }

class ForgotPasswordState {
  final ForgotPasswordStep step;
  final ForgotPasswordStatus status;
  final String email;
  final String code;
  final bool isEmailValid;
  final bool isCodeValid;
  final String? errorMessage;

  const ForgotPasswordState({
    this.step = ForgotPasswordStep.enterEmail,
    this.status = ForgotPasswordStatus.initial,
    this.email = '',
    this.code = '',
    this.isEmailValid = true,
    this.isCodeValid = true,
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStep? step,
    ForgotPasswordStatus? status,
    String? email,
    String? code,
    bool? isEmailValid,
    bool? isCodeValid,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      step: step ?? this.step,
      status: status ?? this.status,
      email: email ?? this.email,
      code: code ?? this.code,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isCodeValid: isCodeValid ?? this.isCodeValid,
      errorMessage: errorMessage,
    );
  }
}


