import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/untils/validators.dart';
import '../../../domain/usecase/request_reset_code_usecase.dart';
import '../../../domain/usecase/verify_reset_code_usecase.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final RequestResetCodeUseCase requestResetCodeUseCase;
  final VerifyResetCodeUseCase verifyResetCodeUseCase;

  ForgotPasswordBloc({
    required this.requestResetCodeUseCase,
    required this.verifyResetCodeUseCase,
  }) : super(const ForgotPasswordState()) {
    on<ForgotPasswordEmailChanged>(_onEmailChanged);
    on<ForgotPasswordCodeChanged>(_onCodeChanged);
    on<ForgotPasswordSendCodePressed>(_onSendCodePressed);
    on<ForgotPasswordVerifyCodePressed>(_onVerifyCodePressed);
  }

  void _onEmailChanged(
      ForgotPasswordEmailChanged event, Emitter<ForgotPasswordState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        isEmailValid: Validators.isValidEmail(event.email),
        status: ForgotPasswordStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onCodeChanged(
      ForgotPasswordCodeChanged event, Emitter<ForgotPasswordState> emit) {
    emit(
      state.copyWith(
        code: event.code,
        isCodeValid: event.code.length == 4,
        status: ForgotPasswordStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSendCodePressed(
      ForgotPasswordSendCodePressed event,
      Emitter<ForgotPasswordState> emit) async {
    if (!state.isEmailValid || state.email.isEmpty) return;

    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    final result = await requestResetCodeUseCase(
      RequestResetCodeParams(email: state.email),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.success,
          step: ForgotPasswordStep.enterCode,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onVerifyCodePressed(
      ForgotPasswordVerifyCodePressed event,
      Emitter<ForgotPasswordState> emit) async {
    if (!state.isCodeValid || state.code.isEmpty) return;

    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    final result = await verifyResetCodeUseCase(
      VerifyResetCodeParams(
        email: state.email,
        code: state.code,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.success,
          errorMessage: null,
        ),
      ),
    );
  }
}


