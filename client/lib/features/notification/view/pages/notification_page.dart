import 'package:flutter/material.dart';
import 'package:jobnexus/features/notification/view/pages/candidate_notf.dart';
import 'package:jobnexus/features/notification/view/pages/recruiter_notf.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});
  final isRecruiter = false;
  @override
  Widget build(BuildContext context) {
    if (isRecruiter) {
      return RecruiterNotf();
    } else {
      return CandidateNotf();
    }
  }
}
