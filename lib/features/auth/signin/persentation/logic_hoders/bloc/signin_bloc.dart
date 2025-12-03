import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibank/core/untils/validators.dart';
import 'package:ibank/features/auth/signin/domain/usecase/signin_usecase.dart';

import 'signin_event.dart';
import 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase signInUseCase;

  SignInBloc({required this.signInUseCase}) : super(const SignInState()) {
    on<SignInEmailChanged>(_onEmailChanged);
    on<SignInPasswordChanged>(_onPasswordChanged);
    on<SignInSubmitted>(_onSubmitted);
    on<SignInErrorDismissed>(_onErrorDismissed); // NEW
  }

  void _onEmailChanged(SignInEmailChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(
      email: event.email,
      isEmailValid: Validators.isValidEmail(event.email),
      status: SignInStatus.initial, // Reset status khi thay đổi
      errorMessage: null, // Clear error
    ));
  }

  void _onPasswordChanged(
      SignInPasswordChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(
      password: event.password,
      isPasswordValid: event.password.isNotEmpty,
      status: SignInStatus.initial, // Reset status khi thay đổi
      errorMessage: null, // Clear error
    ));
  }

  Future<void> _onSubmitted(
      SignInSubmitted event, Emitter<SignInState> emit) async {
    if (!state.isEmailValid || !state.isPasswordValid) {
      return;
    }

    emit(state.copyWith(status: SignInStatus.loading));

    final result = await signInUseCase(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: SignInStatus.failure,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        status: SignInStatus.success,
        user: user,
        errorMessage: null,
      )),
    );
  }

  // NEW: Reset error state
  void _onErrorDismissed(
      SignInErrorDismissed event, Emitter<SignInState> emit) {
    emit(state.copyWith(
      status: SignInStatus.initial,
      errorMessage: null,
    ));
  }
}