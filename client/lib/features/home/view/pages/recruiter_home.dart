import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/features/Job/view/pages/create_job_page.dart';

class RecruiterHome extends StatelessWidget {
  const RecruiterHome({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
                    value: '24',
                    icon: Iconsax.document_text,
                    color: Colors.blue,
                  ),
                  _buildStatCard(
                    title: 'Active Jobs',
                    value: '12',
                    icon: Iconsax.briefcase,
                    color: Colors.green,
                  ),
                  _buildStatCard(
                    title: 'Total Applications',
                    value: '245',
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
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '12 new',
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
                itemCount: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildApplicationItem(index);
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
                itemCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildJobItem(index);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 15);
                },
              ),
            ],
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

  Widget _buildApplicationItem(int index) {
    List<Map<String, dynamic>> applications = [
      {
        'name': 'Alex Morgan',
        'position': 'Senior Flutter Developer',
        'time': '2 hours ago',
        'status': 'New',
        'statusColor': Colors.blue,
      },
      {
        'name': 'Sarah Wilson',
        'position': 'UI/UX Designer',
        'time': '5 hours ago',
        'status': 'Reviewed',
        'statusColor': Colors.orange,
      },
      {
        'name': 'Mike Chen',
        'position': 'Backend Developer',
        'time': '1 day ago',
        'status': 'Shortlisted',
        'statusColor': Colors.green,
      },
    ];

    final application = applications[index];

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
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF6E75FF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Iconsax.profile_circle,
                color: Color(0xFF6E75FF),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    application['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0XFF110e48),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    application['position'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    application['time'],
                    style: TextStyle(color: Colors.grey[500], fontSize: 10),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: application['statusColor'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                application['status'],
                style: TextStyle(
                  color: application['statusColor'],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobItem(int index) {
    List<Map<String, dynamic>> jobs = [
      {
        'title': 'Senior Flutter Developer',
        'applications': '45 applications',
        'status': 'Active',
        'statusColor': Colors.green,
      },
      {
        'title': 'Product Manager',
        'applications': '23 applications',
        'status': 'Closing Soon',
        'statusColor': Colors.orange,
      },
    ];

    final job = jobs[index];

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
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF6E75FF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Iconsax.briefcase,
                color: Color(0xFF6E75FF),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0XFF110e48),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    job['applications'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: job['statusColor'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                job['status'],
                style: TextStyle(
                  color: job['statusColor'],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
