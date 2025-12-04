abstract class ChangePasswordEvent {}

class ChangePasswordNewChanged extends ChangePasswordEvent {
  final String password;
  ChangePasswordNewChanged(this.password);
}

class ChangePasswordConfirmChanged extends ChangePasswordEvent {
  final String password;
  ChangePasswordConfirmChanged(this.password);
}

class ChangePasswordSubmitted extends ChangePasswordEvent {}


