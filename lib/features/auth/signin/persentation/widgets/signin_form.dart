import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ibank/core/theme/app_text_styles.dart';
import 'package:ibank/features/auth/signin/persentation/logic_hoders/bloc/signin_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../logic_hoders/bloc/signin_event.dart';
import '../logic_hoders/bloc/signin_state.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isFormValid(SignInState state) {
    return state.isEmailValid &&
        state.isPasswordValid &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        final isFormValid = _isFormValid(state);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Title
            Text(
              'Welcome Back',
              style: AppTextStyles.title1.copyWith(color: AppColors.primary1),
            ),
            const SizedBox(height: 4),
            Text(
              'Hello there, sign in to continue',
              style: AppTextStyles.body3.copyWith(color: AppColors.neutral3),
            ),
            const SizedBox(height: 32),

            // Lock Icon Illustration with SVG
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: SvgPicture.asset(
                  'assets/icons/Illustration.svg',
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Email Input
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                context.read<SignInBloc>().add(SignInEmailChanged(value));
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

            // Password Input
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              onChanged: (value) {
                context.read<SignInBloc>().add(SignInPasswordChanged(value));
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
            const SizedBox(height: 8),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to forgot password
                },
                child: Text(
                  'Forgot your password ?',
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.neutral3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sign In Button - Active when form is valid
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: state.status == SignInStatus.loading
                    ? null
                    : (isFormValid
                        ? () {
                            context.read<SignInBloc>().add(
                                  SignInSubmitted(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        : null),
                style: ElevatedButton.styleFrom(
                  // Màu sáng (primary1) khi form valid, mờ khi invalid
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
                child: state.status == SignInStatus.loading
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
                        'Sign in',
                        style: AppTextStyles.body1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Fingerprint
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary3.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fingerprint,
                  size: 36,
                  color: AppColors.primary1,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sign Up Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?  ",
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.neutral2,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: Navigate to sign up
                  },
                  child: Text(
                    'Sign Up',
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