import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/untils/validators.dart';
import '../../../domain/usecase/change_password_usecase.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;
  final String email;

  ChangePasswordBloc({
    required this.changePasswordUseCase,
    required this.email,
  }) : super(const ChangePasswordState()) {
    on<ChangePasswordNewChanged>(_onNewChanged);
    on<ChangePasswordConfirmChanged>(_onConfirmChanged);
    on<ChangePasswordSubmitted>(_onSubmitted);
  }

  void _onNewChanged(
      ChangePasswordNewChanged event, Emitter<ChangePasswordState> emit) {
    final isValid = Validators.isValidPassword(event.password);
    emit(
      state.copyWith(
        newPassword: event.password,
        isNewValid: isValid,
        isConfirmValid: state.confirmPassword == event.password,
        status: ChangePasswordStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onConfirmChanged(
      ChangePasswordConfirmChanged event, Emitter<ChangePasswordState> emit) {
    emit(
      state.copyWith(
        confirmPassword: event.password,
        isConfirmValid: event.password == state.newPassword,
        status: ChangePasswordStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSubmitted(
      ChangePasswordSubmitted event, Emitter<ChangePasswordState> emit) async {
    if (!state.isFormValid || state.status == ChangePasswordStatus.loading) {
      return;
    }

    emit(state.copyWith(status: ChangePasswordStatus.loading));

    final result = await changePasswordUseCase(
      ChangePasswordParams(email: email, newPassword: state.newPassword),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChangePasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: ChangePasswordStatus.success,
          step: ChangePasswordStep.success,
          errorMessage: null,
        ),
      ),
    );
  }
}


