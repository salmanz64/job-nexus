import 'package:jobnexus/features/applications/view/pages/recruiter_application.dart';
import 'package:jobnexus/features/auth/models/user_model.dart';
import 'package:jobnexus/features/home/models/job_model.dart';
import 'package:jobnexus/features/profile/models/profile_model.dart';

import 'package:jobnexus/features/profile/view/pages/candidate_profile.dart';

class ApplicationModel {
  final String id;
  final String jobId;
  final String candidateId;
  final String resumeUrl;
  final String status;
  final DateTime appliedAt;
  final DateTime updatedAt;
  final JobModel job;
  final ProfileModel? profile;

  ApplicationModel({
    required this.id,
    required this.jobId,
    required this.candidateId,
    required this.resumeUrl,
    required this.status,
    required this.appliedAt,
    required this.updatedAt,
    required this.job,
    required this.profile,
  });

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      id: map['id'] ?? '',
      jobId: map['job_id'] ?? '',
      candidateId: map['candidate_id'] ?? '',
      resumeUrl: map['resume_url'] ?? '',
      status: map['status'] ?? 'applied',
      appliedAt: DateTime.parse(map['applied_at']),
      updatedAt: DateTime.parse(map['updated_at']),

      /// Nested parsing
      job: JobModel.fromMap(map['job']),
      profile:
          map['profile'] != null
              ? ProfileModel.fromMap(map['profile']) // recruiter sees candidate
              : (map['job'] != null && map['job']['recruiter'] != null
                  ? ProfileModel.fromMap(
                    map['job']['recruiter'],
                  ) // candidate sees recruiter
                  : null),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'job_id': jobId,
      'candidate_id': candidateId,
      'resume_url': resumeUrl,
      'status': status,
      'applied_at': appliedAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),

      /// Nested conversion
      'job': job.toMap(),
      'profile': profile!.toMap(),
    };
  }

  ApplicationModel copyWith({
    String? id,
    String? jobId,
    String? candidateId,
    String? resumeUrl,
    String? status,
    DateTime? appliedAt,
    DateTime? updatedAt,
    JobModel? job,
    ProfileModel? profile,
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      candidateId: candidateId ?? this.candidateId,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      job: job ?? this.job,
      profile: profile ?? this.profile,
    );
  }
}
