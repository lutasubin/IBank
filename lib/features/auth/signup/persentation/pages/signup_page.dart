import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../injection_container.dart' as di;
import '../logic_hoders/bloc/signup_bloc.dart';
import '../logic_hoders/bloc/signup_state.dart';
import '../widgets/signup_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SignUpBloc>(),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary1,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      // Quay về màn SignIn thay vì pop (vì có thể được mở bằng pushReplacement)
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sign up',
                    style: AppTextStyles.title2.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            // White Card Content
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: BlocListener<SignUpBloc, SignUpState>(
                  listener: (context, state) {
                    if (state.status == SignUpStatus.success) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/home',
                        arguments: {
                          'userName': state.user?.name ?? 'User',
                          'userEmail': state.user?.email ?? '',
                        },
                      );
                    } else if (state.status == SignUpStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage ?? 'Sign up failed'),
                          backgroundColor: AppColors.error,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: const SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: SignUpForm(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
