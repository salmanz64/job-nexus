import 'package:flutter/material.dart';
import 'package:jobnexus/features/profile/view/pages/candidate_profile.dart';
import 'package:jobnexus/features/profile/view/pages/recruiter_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  final isRecruiter = true;

  @override
  Widget build(BuildContext context) {
    if (isRecruiter) {
      return RecruiterProfile();
    } else {
      return CandidateProfile();
    }
  }
}
