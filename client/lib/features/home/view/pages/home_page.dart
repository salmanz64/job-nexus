import 'package:flutter/material.dart';
import 'package:jobnexus/features/home/view/pages/client_home.dart';
import 'package:jobnexus/features/home/view/pages/recruiter_home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final isRecruiter = true;

  @override
  Widget build(BuildContext context) {
    if (isRecruiter == false) {
      return ClientHome();
    } else {
      return RecruiterHome();
    }
  }
}
