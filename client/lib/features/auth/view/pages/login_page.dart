import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobnexus/features/auth/view/pages/signup_page.dart';
import 'package:jobnexus/features/auth/view/widgets/auth_button.dart';
import 'package:jobnexus/core/widgets/custom_field.dart';
import 'package:jobnexus/core/widgets/theme/app_pallete.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isRecruiter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login In.',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // User Type Toggle
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Pallete.greyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Pallete.greyColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'I am a:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Pallete.greyColor,
                      ),
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Pallete.greyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Pallete.greyColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Candidate Option
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isRecruiter = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _isRecruiter
                                        ? Colors.transparent
                                        : Pallete.purpleColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 18,
                                    color:
                                        _isRecruiter
                                            ? Pallete.greyColor
                                            : Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Candidate',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          _isRecruiter
                                              ? Pallete.greyColor
                                              : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Recruiter Option
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isRecruiter = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _isRecruiter
                                        ? Pallete.purpleColor
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.business_center_outlined,
                                    size: 18,
                                    color:
                                        _isRecruiter
                                            ? Colors.white
                                            : Pallete.greyColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Recruiter',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          _isRecruiter
                                              ? Colors.white
                                              : Pallete.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Login Form
              CustomField(hintText: 'Email', controller: emailController),
              const SizedBox(height: 15),
              CustomField(
                hintText: 'Password',
                controller: passwordController,
                isObscure: true,
              ),
              const SizedBox(height: 20),

              // Login Button with user type context
              AuthButton(
                text: 'Sign in as ${_isRecruiter ? 'Recruiter' : 'Candidate'}',
                onTap: () async {
                  // Handle login logic based on _isRecruiter value
                  if (formKey.currentState!.validate()) {
                    final email = emailController.text;
                    final password = passwordController.text;
                  }
                },
              ),
              const SizedBox(height: 20),

              // Sign up link
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
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
