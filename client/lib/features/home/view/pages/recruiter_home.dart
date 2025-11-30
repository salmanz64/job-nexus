import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/core/constants/application_status_color.dart';
import 'package:jobnexus/core/constants/job_status_color.dart';
import 'package:jobnexus/features/Job/view/pages/create_job_page.dart';
import 'package:jobnexus/features/applications/viewmodal/application_view_model.dart';
import 'package:jobnexus/features/home/view/widgets/application_list.dart';
import 'package:jobnexus/features/home/view/widgets/job_list.dart';
import 'package:jobnexus/features/home/viewmodal/home_view_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecruiterHome extends ConsumerStatefulWidget {
  const RecruiterHome({super.key});

  @override
  ConsumerState<RecruiterHome> createState() => _RecruiterHomeState();
}

class _RecruiterHomeState extends ConsumerState<RecruiterHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref.read(homeViewModelProvider.notifier).fetchRecruiterJobs();
      ref
          .read(applicationViewModelProvider.notifier)
          .fetchRecruiterApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobsData = ref.watch(homeViewModelProvider);
    final applicationsData = ref.watch(applicationViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to post job page
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => CreateJobPage()));
        },
        backgroundColor: Color(0xFF6E75FF),
        child: Icon(Iconsax.add, color: Colors.white, size: 24),
      ),
      body: jobsData.when(
        error: (error, stackTrace) {
          throw Exception(error.toString());
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
        data:
            (jobs) => applicationsData.when(
              error: (error, stackTrace) {
                throw Exception(error.toString());
              },
              loading: () {
                return Center(child: CircularProgressIndicator());
              },
              data:
                  (applications) => SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Header
                          Row(
                            children: [
                              Text(
                                "Recruiter\nDashboard",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'sans-serif',
                                  color: Color(0XFF110e48),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF6E75FF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Iconsax.briefcase,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          // Quick Stats Grid
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.3,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            children: [
                              _buildStatCard(
                                title: 'Total Jobs Posted',
                                value: jobs.length.toString(),
                                icon: Iconsax.document_text,
                                color: Colors.blue,
                              ),
                              _buildStatCard(
                                title: 'Active Jobs',
                                value: jobs.length.toString(),
                                icon: Iconsax.briefcase,
                                color: Colors.green,
                              ),
                              _buildStatCard(
                                title: 'Total Applications',
                                value: applications.length.toString(),
                                icon: Iconsax.profile_2user,
                                color: Colors.orange,
                              ),
                              _buildStatCard(
                                title: 'Total Hired',
                                value: '18',
                                icon: Iconsax.award,
                                color: Colors.purple,
                              ),
                            ],
                          ),
                          SizedBox(height: 30),

                          // Recent Applications
                          Row(
                            children: [
                              Text(
                                "Recent Applications",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0XFF110e48),
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${applications.length} new',
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Applications List
                          ListView.separated(
                            itemCount: applications.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final application = applications[index];
                              return ApplicationList(
                                name: application.profile!.name,
                                position: application.job.title,
                                timeAgo: timeago.format(application.appliedAt),
                                status: application.status,
                                color:
                                    ApplicationStatusColors.colors[application
                                        .status]!,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 15);
                            },
                          ),

                          SizedBox(height: 20),

                          // Active Jobs
                          Row(
                            children: [
                              Text(
                                "Active Jobs",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0XFF110e48),
                                ),
                              ),
                              Spacer(),
                              Text(
                                "See All",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6E75FF),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Jobs List
                          ListView.separated(
                            itemCount: jobs.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final job = jobs[index];
                              return JobList(
                                onDismissed: () {},
                                dismissibleKey: ValueKey(job.jobId),
                                title: job.title,
                                applications: job.applicationCount.toString(),
                                status: job.status,
                                color: JobStatusColors.colors[job.status]!,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 15);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0XFF110e48),
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
