import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../logic_hoders/bloc/signup_bloc.dart';
import '../logic_hoders/bloc/signup_event.dart';
import '../logic_hoders/bloc/signup_state.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isFormValid(SignUpState state) {
    return state.isNameValid &&
        state.isEmailValid &&
        state.isPasswordValid &&
        state.isTermsAccepted &&
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        final isFormValid = _isFormValid(state);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Title
            Text(
              'Welcome to us,',
              style: AppTextStyles.title1.copyWith(color: AppColors.primary1),
            ),
            const SizedBox(height: 4),
            Text(
              'Hello there, create new account',
              style: AppTextStyles.body3.copyWith(color: AppColors.neutral3),
            ),
            const SizedBox(height: 32),

            // Illustration
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: SvgPicture.asset(
                  'assets/icons/Illustration_1.svg',
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Name
            TextField(
              controller: _nameController,
              onChanged: (value) {
                context.read<SignUpBloc>().add(SignUpNameChanged(value));
              },
              decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: AppTextStyles.body2.copyWith(
                  color: AppColors.neutral4,
                ),
                filled: true,
                fillColor: AppColors.neutral6,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color:
                        state.isNameValid ? AppColors.neutral4 : AppColors.error,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color:
                        state.isNameValid ? AppColors.neutral4 : AppColors.error,
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

            // Email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                context.read<SignUpBloc>().add(SignUpEmailChanged(value));
              },
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: AppTextStyles.body2.copyWith(
                  color: AppColors.neutral4,
                ),
                filled: true,
                fillColor: AppColors.neutral6,
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
            if (!state.isEmailValid && _emailController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 12),
                child: Text(
                  'Please enter a valid email',
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Password
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              onChanged: (value) {
                context.read<SignUpBloc>().add(SignUpPasswordChanged(value));
              },
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: AppTextStyles.body2.copyWith(
                  color: AppColors.neutral4,
                ),
                filled: true,
                fillColor: AppColors.neutral6,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.neutral4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.neutral4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary1,
                    width: 2,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.neutral3,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),

            // Terms & Conditions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: state.isTermsAccepted,
                  activeColor: AppColors.primary1,
                  onChanged: (value) {
                    context
                        .read<SignUpBloc>()
                        .add(SignUpTermsToggled(value ?? false));
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.caption2.copyWith(
                        color: AppColors.neutral3,
                      ),
                      children: [
                        const TextSpan(
                          text: 'By creating an account you agree\n',
                        ),
                        const TextSpan(text: 'to our '),
                        TextSpan(
                          text: 'Term and Conditions',
                          style: AppTextStyles.caption2.copyWith(
                            color: AppColors.primary1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: state.status == SignUpStatus.loading
                    ? null
                    : (isFormValid
                        ? () {
                            context.read<SignUpBloc>().add(
                                  SignUpSubmitted(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        : null),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid
                      ? AppColors.primary1
                      : AppColors.primary3.withOpacity(0.3),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: isFormValid
                      ? AppColors.primary1.withOpacity(0.7)
                      : AppColors.primary3.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: state.status == SignUpStatus.loading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        'Sign up',
                        style: AppTextStyles.body1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Link to Sign In
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Have an account?  ',
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.neutral2,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: Text(
                    'Sign In',
                    style: AppTextStyles.body3.copyWith(
                      color: AppColors.primary1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}


