abstract class ForgotPasswordEvent {}

class ForgotPasswordEmailChanged extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordEmailChanged(this.email);
}

class ForgotPasswordCodeChanged extends ForgotPasswordEvent {
  final String code;
  ForgotPasswordCodeChanged(this.code);
}

class ForgotPasswordSendCodePressed extends ForgotPasswordEvent {}

class ForgotPasswordVerifyCodePressed extends ForgotPasswordEvent {}


