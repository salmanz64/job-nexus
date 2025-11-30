import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/features/applications/view/widgets/application_card_with_dropdown.dart';
import 'package:jobnexus/features/applications/viewmodal/application_view_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecruiterApplications extends ConsumerStatefulWidget {
  const RecruiterApplications({super.key});

  @override
  ConsumerState<RecruiterApplications> createState() =>
      _RecruiterApplicationsState();
}

class _RecruiterApplicationsState extends ConsumerState<RecruiterApplications> {
  String _selectedStatusFilter = 'All';
  String? _selectedJobFilter;
  bool _showJobFilter = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(applicationViewModelProvider.notifier)
          .fetchRecruiterApplications();
    });
  }

  // ------------------- CONNECT UI TO BACKEND FILTERS --------------------
  void _applySearch(String text) {
    ref.read(applicationViewModelProvider.notifier).search(text);
  }

  void _applyStatus(String status) {
    setState(() => _selectedStatusFilter = status);
    ref
        .read(applicationViewModelProvider.notifier)
        .filterByStatus(status == "All" ? "" : status);
  }

  void _applyJob(String? jobId) {
    setState(() => _selectedJobFilter = jobId);
    ref.read(applicationViewModelProvider.notifier).filterByJob(jobId ?? "");
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedJobFilter = null;
      _selectedStatusFilter = 'All';
      _showJobFilter = false;
    });
    ref.read(applicationViewModelProvider.notifier).resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    final applicationsData = ref.watch(applicationViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text(
                        "Candidate\nApplications",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF110e48),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ------ SEARCH + FILTER UI ------
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(0, 5),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _applySearch,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search Jobs',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14,
                              ), // 👈 centers vertically
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() => _showJobFilter = !_showJobFilter);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                _selectedJobFilter != null
                                    ? Color(0xFF6E75FF)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Iconsax.briefcase,
                            color:
                                _selectedJobFilter != null
                                    ? Colors.white
                                    : Color(0xFF6E75FF),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ------ STATUS FILTER & LIST ------
                  applicationsData.when(
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(child: Text(err.toString())),
                    data: (applications) {
                      final fullList =
                          ref
                              .read(applicationViewModelProvider.notifier)
                              .fullList;

                      return Column(
                        children: [
                          SizedBox(
                            height: 50,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildStatusFilter(
                                  "All",
                                  fullList.length,
                                  "All",
                                ),
                                _buildStatusFilter(
                                  "Applied",
                                  fullList
                                      .where((a) => a.status == "applied")
                                      .length,
                                  "applied",
                                ),
                                _buildStatusFilter(
                                  "Reviewed",
                                  fullList
                                      .where((a) => a.status == "reviewed")
                                      .length,
                                  "reviewed",
                                ),
                                _buildStatusFilter(
                                  "Shortlisted",
                                  fullList
                                      .where((a) => a.status == "shortlisted")
                                      .length,
                                  "shortlisted",
                                ),
                                _buildStatusFilter(
                                  "Accepted",
                                  fullList
                                      .where((a) => a.status == "accepted")
                                      .length,
                                  "accepted",
                                ),
                                _buildStatusFilter(
                                  "Rejected",
                                  fullList
                                      .where((a) => a.status == "rejected")
                                      .length,
                                  "rejected",
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          applications.isEmpty
                              ? _buildEmptyState()
                              : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: applications.length,
                                itemBuilder: (_, index) {
                                  final app = applications[index];
                                  return ApplicationCardWithDropdown(
                                    candidateId: app.candidateId,
                                    applicationId: app.id,
                                    candidate: app.profile!,
                                    appliedDate: timeago.format(app.appliedAt),
                                    status: app.status,
                                    candidateEmail: app.profile!.email,
                                    candidateLocation: app.profile!.location,
                                    candidateName: app.profile!.name,
                                    candidatePosition:
                                        app.profile!.jobTitle ?? "",
                                    experience:
                                        app.profile!.experienceYears ?? 0,
                                    jobTitle: app.job.title,
                                  );
                                },
                                separatorBuilder:
                                    (_, __) => const SizedBox(height: 16),
                              ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- HELPER WIDGETS ----
  Widget _buildStatusFilter(String status, int count, String value) {
    final bool isActive = _selectedStatusFilter == value;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedStatusFilter = value);

        if (value == "All") {
          ref.read(applicationViewModelProvider.notifier).resetFilters();
        } else {
          ref.read(applicationViewModelProvider.notifier).filterByStatus(value);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF6E75FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFF6E75FF) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Text(
              status,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : const Color(0xFF6E75FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isActive ? const Color(0xFF6E75FF) : Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobChip(String title, String? jobId) {
    final active = _selectedJobFilter == jobId;
    return GestureDetector(
      onTap: () => _applyJob(jobId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF6E75FF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? const Color(0xFF6E75FF) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 60),
        Icon(Iconsax.profile_2user, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 10),
        const Text("No applications found"),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _clearFilters,
          child: const Text(
            "Clear Filters",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
