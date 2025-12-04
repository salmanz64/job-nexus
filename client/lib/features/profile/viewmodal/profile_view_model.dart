import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:jobnexus/core/enums/roles.dart';
import 'package:jobnexus/features/auth/repository/auth_local_repository.dart';
import 'package:jobnexus/features/profile/models/profile_model.dart';
import 'package:jobnexus/features/profile/repository/profile_remote_repository.dart';
import 'package:jobnexus/features/profile/view/pages/recruiter_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  late ProfileRemoteRepository _profileRemoteRepository;
  late AuthLocalRepository _authLocalRepository;

  @override
  AsyncValue<ProfileModel>? build() {
    _profileRemoteRepository = ref.watch(profileRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    return null;
  }

  // Sign Up - Updated for both roles
  Future<void> setupProfile({
    required String name,
    required UserRole role,
    required String location,
    required String email,
    required String phone,
    String? bio,
    File? profileImage,

    // Candidate specific
    String? jobTitle,
    int? experienceYears,
    List<String>? skills,
    String? education,

    // Recruiter specific
    String? industry,
    String? companySize,
    int? foundedYear,
    String? website,
    List<String>? specialities,
  }) async {
    state = AsyncValue.loading();
    final token = _authLocalRepository.getToken();

    if (token == null) return;

    // ---- Build JSON Body based on role ----
    Map<String, dynamic> profileData = {
      "name": name,
      "location": location,
      "email": email,
      "phone": phone,
      "bio": bio,
      "role": role.name, // Add role to request
    };

    // Add role-specific fields
    if (role == UserRole.candidate) {
      profileData.addAll({
        "job_title": jobTitle,
        "experience_years": experienceYears,
        "skills": skills,
        "education": education,
        "resume_url": null, // Will be handled separately
        // Set recruiter fields to null
        "industry": null,
        "company_size": null,
        "founded_year": null,
        "website": null,
        "specialities": null,
      });
    } else if (role == UserRole.recruiter) {
      profileData.addAll({
        "industry": industry,
        "company_size": companySize,
        "founded_year": foundedYear,
        "website": website,
        "specialities": specialities,
        // Set candidate fields to null
        "job_title": null,
        "experience_years": null,
        "skills": null,
        "education": null,
        "resume_url": null,
      });
    }

    // ---- Build Multipart Request ----
    final response = await _profileRemoteRepository.setupProfile(
      profileData: profileData,
      token: token,
      role: role,
      profileImage: profileImage,
    );

    response.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (data) => state = AsyncValue.data(data),
    );
  }

  // Get Current Profile
  Future<void> getCurrentProfile() async {
    state = AsyncValue.loading();
    final token = _authLocalRepository.getToken();

    if (token != null) {
      final res = await _profileRemoteRepository.getCurrentProfile(
        token: token,
      );

      final val = switch (res) {
        Left(value: final l) =>
          state = AsyncValue.error(l.message, StackTrace.current),
        Right(value: final r) => state = AsyncValue.data(r),
      };
    } else {
      state = AsyncValue.error('No token found', StackTrace.current);
    }
  }
}
