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

  @override
  AsyncValue<List<JobModel>> build() {
    _homeRemoteRepository = ref.watch(homeRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    return AsyncValue.loading(); // initial state
  }

  // ---------------------------------------------------------
  // 🔵 Fetch Recruiter Jobs
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
  // 🔵 Fetch All Jobs
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
  // 🟢 Create Job + Auto Refresh Job List
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
        // After job creation → refresh job list
        await fetchRecruiterJobs();
      },
    );
  }
}
