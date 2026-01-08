// lib/features/auth/signin/persentation/pages/signin_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../injection_container.dart' as di;
import '../logic_hoders/bloc/signin_bloc.dart';
import '../logic_hoders/bloc/signin_event.dart';
import '../logic_hoders/bloc/signin_state.dart';
import '../widgets/signin_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SignInBloc>(),
      child: const SignInView(),
    );
  }
}

class SignInView extends StatelessWidget {
  const SignInView({super.key});

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
                  // IconButton(
                  //   icon: const Icon(Icons.arrow_back, color: Colors.white),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                  const SizedBox(width: 8),
                  Text(
                    'Sign in',
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
                child: BlocListener<SignInBloc, SignInState>(
                  listenWhen: (previous, current) {
                    // CHỈ lắng nghe khi status thay đổi từ loading -> success/failure
                    return previous.status != current.status &&
                        (current.status == SignInStatus.success ||
                            current.status == SignInStatus.failure);
                  },
                  listener: (context, state) {
                    if (state.status == SignInStatus.success) {
                      // Navigate to home screen
                      Navigator.pushReplacementNamed(
                        context,
                        '/home',
                        arguments: {
                          'userName': state.user?.name ?? 'User',
                          'userEmail': state.user?.email ?? '',
                        },
                      );
                    } else if (state.status == SignInStatus.failure) {
                      // Show error và dismiss ngay sau đó
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                            SnackBar(
                              content: Text(
                                state.errorMessage ?? 'Sign in failed',
                              ),
                              backgroundColor: AppColors.error,
                              duration: const Duration(seconds: 3),
                            ),
                          )
                          .closed
                          .then((_) {
                            // Reset error state sau khi SnackBar đóng
                            // ignore: use_build_context_synchronously
                            context.read<SignInBloc>().add(
                              SignInErrorDismissed(),
                            );
                          });
                    }
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SignInForm(),

                        
                        //! demo phan quyen
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/admin-signin');
                            },
                            child: const Text('Đăng nhập quản trị'),
                          ),
                        ),
                      ],
                    ),
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
