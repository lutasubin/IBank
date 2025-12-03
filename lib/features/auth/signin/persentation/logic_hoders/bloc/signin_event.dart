abstract class SignInEvent {}

class SignInSubmitted extends SignInEvent {
  final String email;
  final String password;

  SignInSubmitted({
    required this.email,
    required this.password,
  });
}

class SignInEmailChanged extends SignInEvent {
  final String email;
  SignInEmailChanged(this.email);
}

class SignInPasswordChanged extends SignInEvent {
  final String password;
  SignInPasswordChanged(this.password);
}

// NEW: Event để reset error state
class SignInErrorDismissed extends SignInEvent {}