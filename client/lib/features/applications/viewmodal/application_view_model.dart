import 'package:jobnexus/features/applications/models/application_model.dart';
import 'package:jobnexus/features/applications/repository/application_remote_repository.dart';
import 'package:jobnexus/features/auth/repository/auth_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'application_view_model.g.dart';

@riverpod
class ApplicationViewModel extends _$ApplicationViewModel {
  late ApplicationRemoteRepository _applicationRemoteRepository;
  late AuthLocalRepository _authLocalRepository;

  @override
  AsyncValue<List<ApplicationModel>> build() {
    _applicationRemoteRepository = ref.watch(
      applicationRemoteRepositoryProvider,
    );
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    return const AsyncValue.loading();
  }

  // ---------------------------------------------------------
  // 🔵 Fetch All Applications for Recruiter
  // ---------------------------------------------------------
  Future<void> fetchRecruiterApplications() async {
    state = const AsyncValue.loading();

    final token = _authLocalRepository.getToken();

    final res = await _applicationRemoteRepository.getRecruiterApplications(
      token: token!,
    );

    res.match(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (applications) => state = AsyncValue.data(applications),
    );
  }

  // ---------------------------------------------------------
  // 🔵 Fetch My Applications for Recruiter
  // ---------------------------------------------------------
  Future<void> fetchCandidateApplications() async {
    state = const AsyncValue.loading();

    final token = _authLocalRepository.getToken();

    final res = await _applicationRemoteRepository.getMyApplications(
      token: token!,
    );

    res.match(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (applications) => state = AsyncValue.data(applications),
    );
  }

  // ---------------------------------------------------------
  // 🟢 Create Application + Refresh List
  // ---------------------------------------------------------
  Future<void> createApplication({
    required String jobId,
    required String resumeUrl,
  }) async {
    state = const AsyncValue.loading();

    final token = _authLocalRepository.getToken();

    final res = await _applicationRemoteRepository.createApplication(
      token: token!,
      jobId: jobId,
      resumeUrl: resumeUrl,
    );

    res.match(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) async {
        // Refresh after applying
        await fetchRecruiterApplications();
      },
    );
  }
}
