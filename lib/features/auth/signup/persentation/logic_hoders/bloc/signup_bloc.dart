import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibank/features/auth/signup/persentation/logic_hoders/bloc/signup_event.dart';

import '../../../../../../core/untils/validators.dart';

import '../../../domain/usecase/signup_usecase.dart';
import 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase signUpUseCase;

  SignUpBloc({required this.signUpUseCase}) : super(const SignUpState()) {
    on<SignUpNameChanged>(_onNameChanged);
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpTermsToggled>(_onTermsToggled);
    on<SignUpSubmitted>(_onSubmitted);
  }

  void _onNameChanged(SignUpNameChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        name: event.name,
        isNameValid: event.name.isNotEmpty,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onEmailChanged(SignUpEmailChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        isEmailValid: Validators.isValidEmail(event.email),
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onPasswordChanged(
      SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        password: event.password,
        isPasswordValid: event.password.isNotEmpty,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onTermsToggled(
      SignUpTermsToggled event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        isTermsAccepted: event.isAccepted,
        status: SignUpStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSubmitted(
      SignUpSubmitted event, Emitter<SignUpState> emit) async {
    if (!state.isNameValid ||
        !state.isEmailValid ||
        !state.isPasswordValid ||
        !state.isTermsAccepted) {
      return;
    }

    emit(state.copyWith(status: SignUpStatus.loading));

    final result = await signUpUseCase(
      SignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: SignUpStatus.success,
          user: user,
          errorMessage: null,
        ),
      ),
    );
  }
}

