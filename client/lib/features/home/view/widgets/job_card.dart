import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobnexus/features/Job/view/pages/job_details_page.dart';
import 'package:jobnexus/features/applications/viewmodal/application_view_model.dart';
import 'package:jobnexus/features/home/view/widgets/job_small_info.dart';
import 'package:jobnexus/features/home/view/widgets/job_tag.dart';
import 'package:jobnexus/features/home/viewmodal/home_view_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobCard extends ConsumerWidget {
  final String jobId;
  final String jobType;
  final String salary;
  final String jobTitle;
  final String companyName;
  final DateTime createAt;
  final String applicationCount;
  final String companyUrl;
  const JobCard({
    super.key,
    required this.jobId,
    required this.jobType,
    required this.salary,
    required this.jobTitle,
    required this.companyName,
    required this.createAt,
    required this.applicationCount,
    required this.companyUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => JobDetailsPage(job: mockJob)),
        );
      },
      child: Container(
        width: 300,
        height: 230,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 80, 80, 124), // bright purple-blue tone
              Color(0xFF3F3DFF), // deeper blue
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                JobTag(text: jobType),
                JobTag(text: 'Remote'),
                JobTag(text: salary),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),

                  child: Center(child: Icon(Icons.bookmark_border, size: 18)),
                ),
                SizedBox(width: 10),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(companyUrl, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        softWrap: true,
                        maxLines: null,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        companyName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                JobSmallInfo(icon: Icons.alarm, text: timeago.format(createAt)),
                JobSmallInfo(
                  icon: Icons.people,
                  text: '$applicationCount Applied',
                ),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(applicationViewModelProvider.notifier)
                        .createApplication(jobId: jobId);

                    // Optionally re-sync list from backend later
                    ref.read(homeViewModelProvider.notifier).fetchAllJobs();
                  },
                  child: Container(
                    width: 100,
                    height: 50,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          color: Color(0xFF6E75FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
