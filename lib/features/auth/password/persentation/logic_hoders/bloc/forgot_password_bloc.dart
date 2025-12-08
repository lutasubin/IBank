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
    on<ForgotPasswordSendCodePressed>(_onSendCodePressed);
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
          errorMessage: null,
        ),
      ),
    );
  }
}


