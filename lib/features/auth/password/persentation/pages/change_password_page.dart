import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/untils/validators.dart';
import '../../../../../injection_container.dart' as di;
import '../logic_hoders/bloc/change_password_bloc.dart';
import '../logic_hoders/bloc/change_password_event.dart';
import '../logic_hoders/bloc/change_password_state.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final email = args?['email'] as String? ?? '';

    return BlocProvider(
      create: (_) => di.sl<ChangePasswordBloc>(param1: email),
      child: const ChangePasswordView(),
    );
  }
}

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status &&
                (curr.status == ChangePasswordStatus.failure ||
                    curr.status == ChangePasswordStatus.success),
            listener: (context, state) {
              if (state.status == ChangePasswordStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Error'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.step == ChangePasswordStep.success) {
                return _buildSuccess(context);
              }
              return _buildForm(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, ChangePasswordState state) {
    if (_newController.text != state.newPassword) {
      _newController.value = TextEditingValue(
        text: state.newPassword,
        selection: TextSelection.collapsed(offset: state.newPassword.length),
      );
    }
    if (_confirmController.text != state.confirmPassword) {
      _confirmController.value = TextEditingValue(
        text: state.confirmPassword,
        selection:
            TextSelection.collapsed(offset: state.confirmPassword.length),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            Text(
              'Change password',
              style: AppTextStyles.title2.copyWith(
                color: AppColors.neutral1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Type your new password',
          style: AppTextStyles.body2.copyWith(color: AppColors.neutral2),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _newController,
                obscureText: true,
                onChanged: (value) {
                  context
                      .read<ChangePasswordBloc>()
                      .add(ChangePasswordNewChanged(value));
                },
                decoration: InputDecoration(
                  hintText: 'New password',
                  hintStyle: AppTextStyles.body2.copyWith(
                    color: AppColors.neutral4,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: state.isNewValid
                          ? AppColors.neutral4
                          : AppColors.error,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: state.isNewValid
                          ? AppColors.neutral4
                          : AppColors.error,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary1,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmController,
                obscureText: true,
                onChanged: (value) {
                  context
                      .read<ChangePasswordBloc>()
                      .add(ChangePasswordConfirmChanged(value));
                },
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  hintStyle: AppTextStyles.body2.copyWith(
                    color: AppColors.neutral4,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: state.isConfirmValid
                          ? AppColors.neutral4
                          : AppColors.error,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: state.isConfirmValid
                          ? AppColors.neutral4
                          : AppColors.error,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary1,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: !state.isFormValid ||
                          !Validators.isValidPassword(_newController.text) ||
                          state.status == ChangePasswordStatus.loading
                      ? null
                      : () {
                          context
                              .read<ChangePasswordBloc>()
                              .add(ChangePasswordSubmitted());
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary1,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.primary1.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: state.status == ChangePasswordStatus.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Change password'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         // Illustration
            Center(
              child: SizedBox(
                width: 327,
                height: 216,
                child: SvgPicture.asset(
                  'assets/icons/Illustration_2.svg',
                ),
              ),
            ),
        const SizedBox(height: 24),
        Text(
          'Change password successfully!',
          style: AppTextStyles.title2.copyWith(
            color: AppColors.neutral1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'You have successfully changed password.\nPlease use the new password when Sign in.',
          style: AppTextStyles.body3.copyWith(
            color: AppColors.neutral3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary1,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Ok'),
          ),
        ),
      ],
    );
  }
}


