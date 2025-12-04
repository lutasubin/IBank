enum ChangePasswordStep { form, success }

enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordState {
  final ChangePasswordStep step;
  final ChangePasswordStatus status;
  final String newPassword;
  final String confirmPassword;
  final bool isNewValid;
  final bool isConfirmValid;
  final String? errorMessage;

  const ChangePasswordState({
    this.step = ChangePasswordStep.form,
    this.status = ChangePasswordStatus.initial,
    this.newPassword = '',
    this.confirmPassword = '',
    this.isNewValid = true,
    this.isConfirmValid = true,
    this.errorMessage,
  });

  bool get isFormValid => isNewValid && isConfirmValid && newPassword.isNotEmpty;

  ChangePasswordState copyWith({
    ChangePasswordStep? step,
    ChangePasswordStatus? status,
    String? newPassword,
    String? confirmPassword,
    bool? isNewValid,
    bool? isConfirmValid,
    String? errorMessage,
  }) {
    return ChangePasswordState(
      step: step ?? this.step,
      status: status ?? this.status,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isNewValid: isNewValid ?? this.isNewValid,
      isConfirmValid: isConfirmValid ?? this.isConfirmValid,
      errorMessage: errorMessage,
    );
  }
}


