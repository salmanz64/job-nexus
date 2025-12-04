import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobnexus/features/home/view/widgets/job_card.dart';
import 'package:jobnexus/features/home/viewmodal/home_view_model.dart';

class ClientHome extends ConsumerStatefulWidget {
  const ClientHome({super.key});

  @override
  ConsumerState<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends ConsumerState<ClientHome> {
  String searchQuery = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
      ref.read(homeViewModelProvider.notifier).fetchAllJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobsData = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Find Your\nDream Job",
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
                    child: Image(
                      image: AssetImage('assets/icon.jpg'),
                      width: 180,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
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
                            color: Colors.black.withOpacity(
                              0.2,
                            ), // darker bottom shadow
                            offset: const Offset(0, 5), // move shadow downward
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
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search Job',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
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
              Row(
                children: [
                  Text(
                    "Recent Jobs",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0XFF110e48),
                    ),
                  ),
                  SizedBox(width: 30),
                  Text(
                    "Best Matches",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              jobsData.when(
                error: (error, stackTrace) {
                  throw Exception(error.toString());
                },
                loading: () {
                  return Center(child: CircularProgressIndicator());
                },
                data: (jobs) {
                  final filteredJobs =
                      jobs.where((job) {
                        return job.title.toLowerCase().contains(
                          searchQuery.toLowerCase(),
                        );
                      }).toList();

                  return ListView.separated(
                    itemCount: filteredJobs.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final job = filteredJobs[index];
                      return JobCard(
                        jobId: job.jobId,
                        companyUrl:
                            job.profile!.profileImageUrl ??
                            'https://static.vecteezy.com/system/resources/previews/023/731/733/non_2x/head-hunting-related-icon-hr-illustration-sign-candidate-symbol-vector.jpg',
                        applicationCount: job.applicationCount.toString(),
                        companyName: job.profile!.name,
                        createAt: job.createAt,
                        jobTitle: job.title,
                        jobType: job.jobType,
                        salary: job.salaryRange,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 20);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
