abstract class SignUpEvent {}

class SignUpNameChanged extends SignUpEvent {
  final String name;
  SignUpNameChanged(this.name);
}

class SignUpEmailChanged extends SignUpEvent {
  final String email;
  SignUpEmailChanged(this.email);
}

class SignUpPasswordChanged extends SignUpEvent {
  final String password;
  SignUpPasswordChanged(this.password);
}

class SignUpTermsToggled extends SignUpEvent {
  final bool isAccepted;
  SignUpTermsToggled(this.isAccepted);
}

class SignUpSubmitted extends SignUpEvent {
  final String name;
  final String email;
  final String password;

  SignUpSubmitted({
    required this.name,
    required this.email,
    required this.password,
  });
}

