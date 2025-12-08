abstract class ForgotPasswordEvent {}

class ForgotPasswordEmailChanged extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordEmailChanged(this.email);
}

class ForgotPasswordSendCodePressed extends ForgotPasswordEvent {}


