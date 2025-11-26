// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class JobModel {
  final String jobId;
  final String title;
  final String description;
  final String requirements;
  final String responsibilities;
  final String location;
  final String salaryRange;
  final String jobType;
  final String experienceLevel;
  final String category;
  final String skills;
  final int applicationCount;
  final String status;
  final DateTime createAt;

  JobModel({
    required this.jobId,
    required this.title,
    required this.description,
    required this.requirements,
    required this.responsibilities,
    required this.location,
    required this.salaryRange,
    required this.jobType,
    required this.experienceLevel,
    required this.category,
    required this.skills,
    required this.applicationCount,
    required this.status,
    required this.createAt,
  });

  JobModel copyWith({
    String? title,
    String? description,
    String? requirements,
    String? responsibilities,
    String? location,
    String? salaryRange,
    String? jobType,
    String? experienceLevel,
    String? category,
    String? skills,
    int? applicationCount,
    String? status,
  }) {
    return JobModel(
      jobId: jobId ?? this.jobId,
      title: title ?? this.title,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      responsibilities: responsibilities ?? this.responsibilities,
      location: location ?? this.location,
      salaryRange: salaryRange ?? this.salaryRange,
      jobType: jobType ?? this.jobType,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      category: category ?? this.category,
      skills: skills ?? this.skills,
      applicationCount: applicationCount ?? this.applicationCount,
      status: status ?? this.status,
      createAt: createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'location': location,
      'salaryRange': salaryRange,
      'jobType': jobType,
      'experienceLevel': experienceLevel,
      'category': category,
      'skills': skills,
      'applicationCount': applicationCount,
      'status': status,
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      jobId: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      requirements: map['requirements'] as String,
      responsibilities: map['responsibilities'] as String,
      location: map['location'] as String,
      salaryRange: map['salary_range'] as String,
      jobType: map['job_type'] as String,
      experienceLevel: map['experience_level'] as String,
      category: map['category'] as String,
      skills: map['skills'] as String,
      applicationCount: map['application_count'] as int,
      status: map['status'] as String,
      createAt: DateTime.parse(map['created_at']),
    );
  }
}
