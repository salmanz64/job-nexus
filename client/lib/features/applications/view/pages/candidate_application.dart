import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobnexus/core/constants/application_status_color.dart';
import 'package:jobnexus/features/applications/view/widgets/application_card.dart';
import 'package:jobnexus/features/applications/viewmodal/application_view_model.dart';
import 'package:jobnexus/features/auth/viewmodal/auth_view_model.dart';

class CandidateApplication extends ConsumerStatefulWidget {
  const CandidateApplication({super.key});

  @override
  ConsumerState<CandidateApplication> createState() =>
      _CandidateApplicationState();
}

class _CandidateApplicationState extends ConsumerState<CandidateApplication> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(applicationViewModelProvider.notifier)
          .fetchCandidateApplications();
    });
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
        loading: () => Center(child: CircularProgressIndicator()),
        data: (applications) {
          ///  Filter logic
          final filteredApps =
              applications.where((app) {
                return app.job.title.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    app.profile!.name.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    );
              }).toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Your \nApplications",
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

                  /// 🔍 Search Input
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
                                offset: Offset(0, 5),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search Applications',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF6E75FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  /// 📄 Show filtered results
                  filteredApps.isEmpty
                      ? Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          "No applications found",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                      : ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final application = filteredApps[index];
                          return ApplicationCard(
                            companyUrl: application.profile?.profileImageUrl,
                            companyName: application.profile!.name,
                            jobTitle: application.job.title,
                            status: application.status,
                            color:
                                ApplicationStatusColors.colors[application
                                    .status]!,
                          );
                        },
                        separatorBuilder:
                            (context, index) => Divider(thickness: 0.4),
                        itemCount: filteredApps.length,
                      ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
