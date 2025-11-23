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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref
          .read(applicationViewModelProvider.notifier)
          .fetchRecruiterApplications();
    });
  }

  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> myJobs = [
    {'id': '1', 'title': 'Senior Flutter Developer', 'applications': 12},
    {'id': '2', 'title': 'UI/UX Designer', 'applications': 8},
    {'id': '3', 'title': 'Product Manager', 'applications': 5},
    {'id': '4', 'title': 'Backend Developer', 'applications': 7},
  ];

  List<Map<String, dynamic>> applications = [
    {
      'name': 'Alex Morgan',
      'email': 'alex.morgan@email.com',
      'position': 'Senior Flutter Developer',
      'jobId': '1',
      'jobTitle': 'Senior Flutter Developer',
      'appliedDate': 'Applied 2 days ago',
      'status': 'New',
      'experience': '5 years',
      'location': 'San Francisco, CA',
      'matchScore': 85,
    },
    {
      'name': 'Sarah Wilson',
      'email': 'sarah.wilson@email.com',
      'position': 'UI/UX Designer',
      'jobId': '2',
      'jobTitle': 'UI/UX Designer',
      'appliedDate': 'Applied 1 day ago',
      'status': 'Reviewed',
      'experience': '3 years',
      'location': 'New York, NY',
      'matchScore': 92,
    },
    {
      'name': 'Mike Chen',
      'email': 'mike.chen@email.com',
      'position': 'Backend Developer',
      'jobId': '4',
      'jobTitle': 'Backend Developer',
      'appliedDate': 'Applied 3 days ago',
      'status': 'Shortlisted',
      'experience': '4 years',
      'location': 'Austin, TX',
      'matchScore': 78,
    },
    {
      'name': 'Emily Davis',
      'email': 'emily.davis@email.com',
      'position': 'Product Manager',
      'jobId': '3',
      'jobTitle': 'Product Manager',
      'appliedDate': 'Applied 5 days ago',
      'status': 'Rejected',
      'experience': '6 years',
      'location': 'Chicago, IL',
      'matchScore': 65,
    },
    {
      'name': 'David Kim',
      'email': 'david.kim@email.com',
      'position': 'Frontend Developer',
      'jobId': '1',
      'jobTitle': 'Senior Flutter Developer',
      'appliedDate': 'Applied 1 week ago',
      'status': 'Hired',
      'experience': '2 years',
      'location': 'Seattle, WA',
      'matchScore': 88,
    },
  ];

  List<Map<String, dynamic>> get filteredApplications {
    String searchQuery = _searchController.text.toLowerCase();

    return applications.where((app) {
      // Search filter
      bool searchMatch =
          searchQuery.isEmpty ||
          app['name'].toLowerCase().contains(searchQuery) ||
          app['email'].toLowerCase().contains(searchQuery) ||
          app['position'].toLowerCase().contains(searchQuery);

      // Status filter
      bool statusMatch =
          _selectedStatusFilter == 'All' ||
          app['status'] == _selectedStatusFilter;

      // Job filter
      bool jobMatch =
          _selectedJobFilter == null || app['jobId'] == _selectedJobFilter;

      return searchMatch && statusMatch && jobMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final applicationsData = ref.watch(applicationViewModelProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: applicationsData.when(
        error: (error, stackTrace) {
          throw Exception(error.toString());
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
        data:
            (applicationss) => SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Candidate\nApplications",
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'sans-serif',
                                color: Color(0XFF110e48),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Search and Filter Row
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
                                  onChanged: (value) => setState(() {}),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    hintText: 'Search Candidates',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Job Filter Button
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    _selectedJobFilter != null
                                        ? Color(0xFF6E75FF)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 3),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(8),
                              child: IconButton(
                                icon: Icon(
                                  Iconsax.briefcase,
                                  color:
                                      _selectedJobFilter != null
                                          ? Colors.white
                                          : Color(0xFF6E75FF),
                                  size: 24,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showJobFilter = !_showJobFilter;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            // Status Filter Button
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF6E75FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.filter_list,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),

                        // Job Filter Dropdown
                        if (_showJobFilter) ...[
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Iconsax.briefcase,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Filter by Job',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _buildJobChip('All Jobs', null),
                                    ...myJobs.map(
                                      (job) => _buildJobChip(
                                        job['title'],
                                        job['id'],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],

                        SizedBox(height: 20),

                        // Status Filter Tabs
                        Container(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildStatusFilter(
                                'All',
                                applications.length,
                                'All',
                              ),
                              _buildStatusFilter(
                                'New',
                                applications
                                    .where((app) => app['status'] == 'New')
                                    .length,
                                'New',
                              ),
                              _buildStatusFilter(
                                'Reviewed',
                                applications
                                    .where((app) => app['status'] == 'Reviewed')
                                    .length,
                                'Reviewed',
                              ),
                              _buildStatusFilter(
                                'Shortlisted',
                                applications
                                    .where(
                                      (app) => app['status'] == 'Shortlisted',
                                    )
                                    .length,
                                'Shortlisted',
                              ),
                              _buildStatusFilter(
                                'Rejected',
                                applications
                                    .where((app) => app['status'] == 'Rejected')
                                    .length,
                                'Rejected',
                              ),
                              _buildStatusFilter(
                                'Hired',
                                applications
                                    .where((app) => app['status'] == 'Hired')
                                    .length,
                                'Hired',
                              ),
                            ],
                          ),
                        ),

                        // Active Filters Info
                        if (_selectedJobFilter != null ||
                            _selectedStatusFilter != 'All' ||
                            _searchController.text.isNotEmpty) ...[
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.filter,
                                  size: 16,
                                  color: Colors.blue[700],
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _buildFilterText(),
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _clearFilters,
                                  child: Text(
                                    'Clear',
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        SizedBox(height: 20),

                        // Applications List
                        if (filteredApplications.isEmpty)
                          _buildEmptyState()
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final application = applicationss[index];
                              return ApplicationCardWithDropdown(
                                candidate: application.profile!,
                                appliedDate: timeago.format(
                                  application.appliedAt,
                                ),
                                status: application.status,
                                candidateEmail: application.profile!.email,
                                candidateLocation:
                                    application.profile!.location,
                                candidateName: application.profile!.name,
                                candidatePosition:
                                    application.profile!.jobTitle ?? "",
                                experience:
                                    application.profile!.experienceYears ?? 0,
                                jobTitle: application.job.title,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 16);
                            },
                            itemCount: applicationss.length,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildJobChip(String title, String? jobId) {
    bool isSelected = _selectedJobFilter == jobId;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedJobFilter = isSelected ? null : jobId;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF6E75FF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Color(0xFF6E75FF) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusFilter(String status, int count, String statusValue) {
    bool isActive = _selectedStatusFilter == statusValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatusFilter = statusValue;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Color(0xFF6E75FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Color(0xFF6E75FF) : Colors.grey[300]!,
          ),
          boxShadow:
              isActive
                  ? []
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Color(0xFF6E75FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isActive ? Color(0xFF6E75FF) : Colors.white,
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

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Iconsax.profile_2user, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No applications found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try changing your filters or check back later',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _clearFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6E75FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Clear All Filters'),
          ),
        ],
      ),
    );
  }

  String _buildFilterText() {
    List<String> filters = [];
    if (_selectedStatusFilter != 'All') {
      filters.add('Status: $_selectedStatusFilter');
    }
    if (_selectedJobFilter != null) {
      String jobTitle =
          myJobs.firstWhere(
            (job) => job['id'] == _selectedJobFilter,
            orElse: () => {'title': 'Unknown Job'},
          )['title'];
      filters.add('Job: $jobTitle');
    }
    if (_searchController.text.isNotEmpty) {
      filters.add('Search: "${_searchController.text}"');
    }
    return filters.join(' • ');
  }

  void _clearFilters() {
    setState(() {
      _selectedStatusFilter = 'All';
      _selectedJobFilter = null;
      _searchController.clear();
      _showJobFilter = false;
    });
  }
}
