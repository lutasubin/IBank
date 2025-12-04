import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/untils/validators.dart';
import '../../../../../injection_container.dart' as di;
import '../logic_hoders/bloc/forgot_password_bloc.dart';
import '../logic_hoders/bloc/forgot_password_event.dart';
import '../logic_hoders/bloc/forgot_password_state.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ForgotPasswordBloc>(),
      child: const ForgotPasswordView(),
    );
  }
}

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
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
                    'Forgot password',
                    style: AppTextStyles.title2.copyWith(
                      color: AppColors.neutral1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                  listenWhen: (prev, curr) =>
                      prev.status != curr.status &&
                      (curr.status == ForgotPasswordStatus.failure ||
                          curr.status == ForgotPasswordStatus.success),
                  listener: (context, state) {
                    if (state.status == ForgotPasswordStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage ?? 'Error'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    } else if (state.status ==
                            ForgotPasswordStatus.success &&
                        state.step == ForgotPasswordStep.enterCode &&
                        state.code.isEmpty) {
                      // Gửi code thành công (sau bước nhập email)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Verification code has been sent (8422)'),
                        ),
                      );
                    } else if (state.status ==
                            ForgotPasswordStatus.success &&
                        state.step == ForgotPasswordStep.enterCode &&
                        state.code.isNotEmpty) {
                      // Verify code thành công -> sang màn change password
                      Navigator.pushReplacementNamed(
                        context,
                        '/change-password',
                        arguments: {'email': state.email},
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.step == ForgotPasswordStep.enterEmail) {
                      return _buildEmailStep(context, state);
                    }
                    return _buildCodeStep(context, state);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailStep(
      BuildContext context, ForgotPasswordState state) {
    if (_emailController.text != state.email) {
      _emailController.value = TextEditingValue(
        text: state.email,
        selection: TextSelection.collapsed(offset: state.email.length),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type your email',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  context
                      .read<ForgotPasswordBloc>()
                      .add(ForgotPasswordEmailChanged(value));
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: AppTextStyles.body2.copyWith(
                    color: AppColors.neutral4,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: state.isEmailValid
                          ? AppColors.neutral4
                          : AppColors.error,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: state.isEmailValid
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
              const SizedBox(height: 12),
              Text(
                'We texted you a code to verify your email.',
                style: AppTextStyles.caption2.copyWith(
                  color: AppColors.neutral3,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: !state.isEmailValid ||
                          !Validators.isValidEmail(_emailController.text) ||
                          state.status == ForgotPasswordStatus.loading
                      ? null
                      : () {
                          context
                              .read<ForgotPasswordBloc>()
                              .add(ForgotPasswordSendCodePressed());
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
                  child: state.status == ForgotPasswordStatus.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Send'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCodeStep(BuildContext context, ForgotPasswordState state) {
    if (_codeController.text != state.code) {
      _codeController.value = TextEditingValue(
        text: state.code,
        selection: TextSelection.collapsed(offset: state.code.length),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type a code',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                onChanged: (value) {
                  context
                      .read<ForgotPasswordBloc>()
                      .add(ForgotPasswordCodeChanged(value));
                },
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Code',
                  hintStyle: AppTextStyles.body2.copyWith(
                    color: AppColors.neutral4,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: state.isCodeValid
                          ? AppColors.neutral4
                          : AppColors.error,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: state.isCodeValid
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
              const SizedBox(height: 12),
              Text(
                'This code will expire in 10 minutes after this message. If you don\'t get a message, you can resend.',
                style: AppTextStyles.caption2.copyWith(
                  color: AppColors.neutral3,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: !state.isCodeValid ||
                          _codeController.text.length != 4 ||
                          state.status == ForgotPasswordStatus.loading
                      ? null
                      : () {
                          context
                              .read<ForgotPasswordBloc>()
                              .add(ForgotPasswordVerifyCodePressed());
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
                  child: state.status == ForgotPasswordStatus.loading
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
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Change your email',
                    style: AppTextStyles.caption2.copyWith(
                      color: AppColors.primary1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


