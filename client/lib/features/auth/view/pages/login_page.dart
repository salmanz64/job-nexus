import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobnexus/core/enums/roles.dart';
import 'package:jobnexus/core/utils.dart';
import 'package:jobnexus/core/widgets/loader.dart';
import 'package:jobnexus/features/auth/view/pages/signup_page.dart';
import 'package:jobnexus/features/auth/view/widgets/auth_button.dart';
import 'package:jobnexus/core/widgets/custom_field.dart';
import 'package:jobnexus/core/theme/app_pallete.dart';
import 'package:jobnexus/features/auth/viewmodal/auth_view_model.dart';
import 'package:jobnexus/features/home/view/pages/home_page.dart';
import 'package:jobnexus/main_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authViewModelProvider.select((value) => value?.isLoading == true),
    );

    ref.listen(authViewModelProvider, (previous, next) {
      next?.when(
        data: (data) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder:
                  (context) => MainPage(
                    isRecruiter: data.role == UserRole.recruiter ? true : false,
                  ),
            ),
            (_) => false,
          );
        },
        error: (error, stackTrace) {
          showSnackbar(error.toString(), context);
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body:
          isLoading
              ? Loader()
              : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Login In.',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Login Form
                      CustomField(
                        hintText: 'Email',
                        controller: emailController,
                      ),
                      const SizedBox(height: 15),
                      CustomField(
                        hintText: 'Password',
                        controller: passwordController,
                        isObscure: true,
                      ),
                      const SizedBox(height: 20),

                      // Login Button with user type context
                      AuthButton(
                        text: 'Log In',
                        onTap: () async {
                          // Handle login logic based on _isRecruiter value
                          if (formKey.currentState!.validate()) {
                            await ref
                                .read(authViewModelProvider.notifier)
                                .loginUser(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Sign up link
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: const [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: Pallete.purpleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
