import 'package:flutter/material.dart';
import 'package:jobnexus/features/applications/view/pages/candidate_application.dart';
import 'package:jobnexus/features/applications/view/pages/recruiter_application.dart';

class ApplicationPage extends StatelessWidget {
  final bool isRecruiter;
  const ApplicationPage({super.key, required this.isRecruiter});

  @override
  Widget build(BuildContext context) {
    if (isRecruiter) {
      return RecruiterApplications();
    } else {
      return CandidateApplication();
    }
  }
}
