import 'package:flutter/material.dart';
import 'package:jobnexus/features/applications/view/pages/candidate_application.dart';
import 'package:jobnexus/features/applications/view/pages/recruiter_application.dart';

class ApplicationPage extends StatelessWidget {
  const ApplicationPage({super.key});
  final bool isRecruiter = true;

  @override
  Widget build(BuildContext context) {
    if (isRecruiter) {
      return CandidateApplication();
    } else {
      return RecruiterApplications();
    }
  }
}
