import 'package:fpdart/fpdart.dart';
import 'package:jobnexus/features/auth/repository/auth_local_repository.dart';
import 'package:jobnexus/features/home/models/job_model.dart';
import 'package:jobnexus/features/home/repository/home_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRemoteRepository _homeRemoteRepository;
  late AuthLocalRepository _authLocalRepository;

  // Hired Count State
  AsyncValue<int> hiredCount = const AsyncValue.loading();

  @override
  AsyncValue<List<JobModel>> build() {
    _homeRemoteRepository = ref.watch(homeRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);

    // Auto fetch hired count on init
    fetchHiredCount();

    return const AsyncValue.loading();
  }

  // ---------------------------------------------------------
  // 🔵 Fetch Recruiter's Jobs
  // ---------------------------------------------------------
  Future<void> fetchRecruiterJobs() async {
    state = const AsyncValue.loading();

    final token = _authLocalRepository.getToken();

    final res = await _homeRemoteRepository.getRecruiterJobs(token: token!);

    res.match(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (jobs) => state = AsyncValue.data(jobs),
    );
  }

  // ---------------------------------------------------------
  // 🔵 Fetch All Jobs (for general listing)
  // ---------------------------------------------------------
  Future<void> fetchAllJobs() async {
    state = const AsyncValue.loading();

    final token = _authLocalRepository.getToken();

    final res = await _homeRemoteRepository.fetchAllJobs(token: token!);

    res.match(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (jobs) => state = AsyncValue.data(jobs),
    );
  }

  // ---------------------------------------------------------
  // 🟢 Fetch Active Jobs Only (Filtered UI)
  // ---------------------------------------------------------
  Future<void> fetchActiveJobs() async {
    state = const AsyncValue.loading();

    final token = _authLocalRepository.getToken();

    final res = await _homeRemoteRepository.getActiveJobs(token: token!);

    res.match(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (jobs) => state = AsyncValue.data(jobs),
    );
  }

  // ---------------------------------------------------------
  // 🟣 Create Job + Refresh Recruiter List
  // ---------------------------------------------------------
  Future<void> createJob({
    required String title,
    required String description,
    required String requirements,
    required String responsibilities,
    required String location,
    required String salaryRange,
    required String jobType,
    required String experienceLevel,
    required String category,
    required String skills,
  }) async {
    state = const AsyncValue.loading();

    final token = _authLocalRepository.getToken();

    final res = await _homeRemoteRepository.createJob(
      token: token!,
      title: title,
      description: description,
      requirements: requirements,
      responsibilities: responsibilities,
      location: location,
      salaryRange: salaryRange,
      jobType: jobType,
      experienceLevel: experienceLevel,
      category: category,
      skills: skills,
    );

    res.match(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) async {
        // Refresh job list after creation
        await fetchRecruiterJobs();
      },
    );
  }

  // ---------------------------------------------------------
  // 🔴 Delete Job + Instant UI Update + Refresh
  // ---------------------------------------------------------
  Future<void> deleteJob(String jobId) async {
    final token = _authLocalRepository.getToken();

    final res = await _homeRemoteRepository.deleteJob(
      token: token!,
      jobId: jobId,
    );

    res.match(
      (failure) {
        // Optionally show UI error
      },
      (_) {
        // Instantly remove job from UI (Better UX)
        removeJobInstantly(jobId);

        // Sync fresh data from backend
        fetchRecruiterJobs();
      },
    );
  }

  // Local only UI instant removal
  Future<void> removeJobInstantly(String jobId) async {
    state = state.whenData(
      (jobs) => jobs.where((job) => job.jobId != jobId).toList(),
    );
  }

  // ---------------------------------------------------------
  // 🟡 Fetch Hired Count
  // ---------------------------------------------------------
  Future<void> fetchHiredCount() async {
    hiredCount = const AsyncValue.loading();
    ref.notifyListeners();

    final token = _authLocalRepository.getToken();

    final res = await _homeRemoteRepository.getHiredCount(token: token!);

    res.match(
      (failure) {
        hiredCount = AsyncValue.error(failure.message, StackTrace.current);
        ref.notifyListeners();
      },
      (count) {
        hiredCount = AsyncValue.data(count);
        ref.notifyListeners();
      },
    );
  }
}
