import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibank/core/theme/app_colors.dart';
import 'package:ibank/core/theme/app_text_styles.dart';
import 'package:ibank/features/auth/signin/domain/entities/user_entity.dart';
import 'package:ibank/features/auth/signin/domain/usecase/signin_usecase.dart';
import 'package:ibank/features/auth/signin/persentation/logic_hoders/bloc/signin_bloc.dart';
import 'package:ibank/features/auth/signin/persentation/logic_hoders/bloc/signin_event.dart';
import 'package:ibank/features/auth/signin/persentation/logic_hoders/bloc/signin_state.dart';
import 'package:ibank/features/auth/signin/persentation/widgets/signin_form.dart';
import 'package:ibank/injection_container.dart' as di;

class AdminSignInPage extends StatelessWidget {
  const AdminSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInBloc(
        signInUseCase: di.sl<SignInUseCase>(),
        allowedRole: UserRole.admin,
      ),
      child: const AdminSignInView(),
    );
  }
}

class AdminSignInView extends StatelessWidget {
  const AdminSignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary1,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    'Admin Sign in',
                    style: AppTextStyles.title2.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
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
                  listenWhen: (previous, current) =>
                      previous.status != current.status &&
                      (current.status == SignInStatus.success ||
                          current.status == SignInStatus.failure),
                  listener: (context, state) {
                    if (state.status == SignInStatus.success) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/admin-home',
                        arguments: {
                          'userEmail': state.user?.email ?? '',
                        },
                      );
                    } else if (state.status == SignInStatus.failure) {
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
                            // ignore: use_build_context_synchronously
                            context.read<SignInBloc>().add(
                                  SignInErrorDismissed(),
                                );
                          });
                    }
                  },
                  child: const SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: SignInForm(),
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

