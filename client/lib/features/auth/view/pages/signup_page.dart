import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobnexus/core/enums/roles.dart';
import 'package:jobnexus/core/utils.dart';
import 'package:jobnexus/core/widgets/loader.dart';
import 'package:jobnexus/features/auth/view/pages/login_page.dart';
import 'package:jobnexus/features/auth/view/widgets/auth_button.dart';
import 'package:jobnexus/core/widgets/custom_field.dart';
import 'package:jobnexus/core/theme/app_pallete.dart';
import 'package:jobnexus/features/auth/viewmodal/auth_view_model.dart';
import 'package:jobnexus/features/home/view/pages/home_page.dart';
import 'package:jobnexus/features/profile/view/pages/recruiter_profile_setup.dart';
import 'package:jobnexus/main_page.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isRecruiter = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
              builder: (context) => AddRecruiterProfileScreen(),
            ),
            (_) => false,
          );
        },
        error: (error, stackTrace) {
          return showSnackbar(error.toString(), context);
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
                        "Sign Up.",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                        ),
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
                          border: Border.all(
                            color: Pallete.greyColor.withOpacity(0.3),
                          ),
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

                      // Common form fields
                      CustomField(
                        hintText: _isRecruiter ? "Company Name" : "Full Name",
                        controller: nameController,
                      ),
                      const SizedBox(height: 15),
                      CustomField(
                        hintText: "Email",
                        controller: emailController,
                      ),
                      const SizedBox(height: 15),
                      CustomField(
                        hintText: "Password",
                        isObscure: true,
                        controller: passwordController,
                      ),
                      const SizedBox(height: 15),

                      // Sign Up Button
                      AuthButton(
                        text:
                            'Sign Up as ${_isRecruiter ? 'Recruiter' : 'Candidate'}',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            ref
                                .read(authViewModelProvider.notifier)
                                .signUpUser(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  role:
                                      _isRecruiter ? "recruiter" : "candidate",
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Sign In link
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: const [
                              TextSpan(
                                text: "Sign In",
                                style: TextStyle(
                                  color: Pallete.gradient2,
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
