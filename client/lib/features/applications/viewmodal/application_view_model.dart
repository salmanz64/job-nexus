import 'package:jobnexus/features/applications/models/application_model.dart';
import 'package:jobnexus/features/applications/repository/application_remote_repository.dart';
import 'package:jobnexus/features/auth/repository/auth_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'application_view_model.g.dart';

@riverpod
class ApplicationViewModel extends _$ApplicationViewModel {
  late ApplicationRemoteRepository _repo;
  late AuthLocalRepository _auth;

  // Store full unfiltered list
  List<ApplicationModel> _allApplications = [];

  // Filters (UI state memory)
  String? _selectedStatus;
  String? _searchQuery;
  String? _selectedJobId;

  @override
  AsyncValue<List<ApplicationModel>> build() {
    _repo = ref.watch(applicationRemoteRepositoryProvider);
    _auth = ref.watch(authLocalRepositoryProvider);
    return const AsyncValue.loading();
  }

  String? get selectedStatus => _selectedStatus;
  String? get searchQuery => _searchQuery;
  String? get selectedJobId => _selectedJobId;

  List<ApplicationModel> get fullList => _allApplications; // For counters

  // ---------------------------------------------------------
  // 🔹 Base: Fetch All Applications for Recruiter
  // ---------------------------------------------------------
  Future<void> fetchRecruiterApplications() async {
    state = const AsyncValue.loading();
    final token = _auth.getToken();

    final res = await _repo.getRecruiterApplications(token: token!);

    res.match(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (applications) {
        _allApplications = applications; // store original list
        state = AsyncValue.data(applications);
      },
    );
  }

  // ---------------------------------------------------------
  // 🔹 Fetch Candidate Applications
  // ---------------------------------------------------------
  Future<void> fetchCandidateApplications() async {
    state = const AsyncValue.loading();
    final token = _auth.getToken();

    final res = await _repo.getMyApplications(token: token!);

    res.match(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (applications) {
        _allApplications = applications; // store original
        state = AsyncValue.data(applications);
      },
    );
  }

  // ---------------------------------------------------------
  // 🟢 Create Application + Auto-refresh
  // ---------------------------------------------------------
  Future<void> createApplication({
    required String jobId,
    String? resumeUrl,
  }) async {
    state = const AsyncValue.loading();
    final token = _auth.getToken();

    final res = await _repo.createApplication(
      token: token!,
      jobId: jobId,
      resumeUrl: resumeUrl,
    );

    res.match(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) async => await fetchRecruiterApplications(),
    );
  }

  // ---------------------------------------------------------
  // 🔍 FILTER BY STATUS (LOCAL FILTERING)
  // ---------------------------------------------------------
  Future<void> filterByStatus(String status) async {
    _selectedStatus = status;

    final filtered =
        _allApplications
            .where((a) => a.status.toLowerCase() == status.toLowerCase())
            .toList();

    state = AsyncValue.data(filtered);
  }

  // ---------------------------------------------------------
  // 🔍 SEARCH Job (LOCAL SEARCH)
  // ---------------------------------------------------------
  Future<void> search(String query) async {
    _searchQuery = query;

    final filtered =
        _allApplications
            .where(
              (a) => a.job.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    state = AsyncValue.data(filtered);
  }

  // ---------------------------------------------------------
  // 🔍 FILTER BY JOB (LOCAL FILTERING)
  // ---------------------------------------------------------
  Future<void> filterByJob(String jobId) async {
    _selectedJobId = jobId;

    final filtered =
        _allApplications.where((a) => a.job.jobId == jobId).toList();

    state = AsyncValue.data(filtered);
  }

  // ---------------------------------------------------------
  // 🔥 APPLY COMBINED FILTERS (LOCAL LOGIC)
  // ---------------------------------------------------------
  Future<void> applyFilters() async {
    var filtered = _allApplications;

    if (_selectedStatus != null && _selectedStatus!.isNotEmpty) {
      filtered =
          filtered
              .where(
                (a) => a.status.toLowerCase() == _selectedStatus!.toLowerCase(),
              )
              .toList();
    }

    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      filtered =
          filtered
              .where(
                (a) => a.profile!.name.toLowerCase().contains(
                  _searchQuery!.toLowerCase(),
                ),
              )
              .toList();
    }

    if (_selectedJobId != null && _selectedJobId!.isNotEmpty) {
      filtered = filtered.where((a) => a.job.jobId == _selectedJobId).toList();
    }

    state = AsyncValue.data(filtered);
  }

  // ---------------------------------------------------------
  // RESET FILTERS
  // ---------------------------------------------------------
  Future<void> resetFilters() async {
    _selectedJobId = null;
    _searchQuery = null;
    _selectedStatus = null;
    state = AsyncValue.data(_allApplications); // restore original
  }

  // ---------------------------------------------------------
  // 🟦 UPDATE STATUS (LOCAL + REMOTE SYNC)
  // ---------------------------------------------------------
  Future<void> updateApplicationStatus({
    required String applicationId,
    required String status,
  }) async {
    final token = _auth.getToken();

    // 1. Call API
    final result = await _repo.updateApplicationStatus(
      token: token!,
      applicationId: applicationId,
      status: status,
    );

    result.match(
      // Error: Show error but keep state unchanged
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (_) {
        // 2. Update local list
        _allApplications =
            _allApplications.map((app) {
              if (app.id == applicationId) {
                return app.copyWith(status: status);
              }
              return app;
            }).toList();

        // 3. Reapply filters if any active
        applyFilters();
      },
    );
  }
}
