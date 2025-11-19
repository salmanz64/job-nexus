import 'package:fpdart/fpdart.dart';
import 'package:jobnexus/core/enums/roles.dart';
import 'package:jobnexus/features/auth/repository/auth_local_repository.dart';
import 'package:jobnexus/features/profile/models/recruiter_profile_model.dart';
import 'package:jobnexus/features/profile/repository/profile_remote_repository.dart';
import 'package:jobnexus/features/profile/view/pages/recruiter_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  late ProfileRemoteRepository _profileRemoteRepository;
  late AuthLocalRepository _authLocalRepository;

  @override
  AsyncValue<RecruiterProfileModel>? build() {
    _profileRemoteRepository = ref.watch(profileRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    return null;
  }

  //Sign Up
  Future<void> setupProfile({
    required String name,
    required String industry,
    required String companySize,
    required String location,
    required String email,
    required String phone,
    List<String>? specialities,
    String? bio,
    required int foundedYear,
    String? website,
    required UserRole role,
  }) async {
    state = AsyncValue.loading();
    final token = _authLocalRepository.getToken();

    if (token != null) {
      final res = await _profileRemoteRepository.setupProfile(
        name: name,
        industry: industry,
        companySize: companySize,
        location: location,
        foundedYear: foundedYear,
        email: email,
        phone: phone,
        token: token,
        role: role,
      );

      final val = switch (res) {
        Left(value: final l) =>
          state = AsyncValue.error(l.message, StackTrace.current),
        Right(value: final r) => state = AsyncValue.data(r),
      };
    }
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
