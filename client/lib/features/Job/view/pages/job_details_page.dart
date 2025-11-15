import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/features/Job/view/pages/apply_job_page.dart';

class JobDetailsPage extends StatefulWidget {
  final Job job;

  const JobDetailsPage({Key? key, required this.job}) : super(key: key);

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.job.isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Header with Company Image
          SliverAppBar(
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Iconsax.arrow_left, color: Colors.blue),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isBookmarked ? Iconsax.bookmark_25 : Iconsax.bookmark_2,
                  color: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                },
              ),
            ],
          ),

          // Job Details Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Name & Title Section
                  _buildCompanyHeader(),
                  SizedBox(height: 24),

                  // Quick Stats (Salary, Applications, Deadline)
                  _buildQuickStats(),
                  SizedBox(height: 24),

                  // Job Description
                  _buildDescriptionSection(),
                  SizedBox(height: 24),

                  // Required Skills
                  _buildSkillsSection(),
                  SizedBox(height: 24),

                  // Responsibilities
                  _buildResponsibilitiesSection(),
                  SizedBox(height: 24),

                  // Qualifications
                  _buildQualificationsSection(),
                  SizedBox(height: 24),

                  // Company Info
                  _buildCompanyInfoSection(),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),

      // Apply Button
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ApplyJobPage(job: mockJob),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Apply Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Iconsax.share, color: Colors.grey[700]),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Name
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.job.companyName,
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(height: 12),

        // Job Title
        Text(
          widget.job.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),

        // Location & Type
        Row(
          children: [
            Icon(Iconsax.location, size: 16, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(
              widget.job.location,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(width: 16),
            Icon(Iconsax.briefcase, size: 16, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(widget.job.jobType, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Iconsax.dollar_circle,
            'Salary',
            widget.job.salary,
            Colors.green,
          ),
          _buildStatItem(
            Iconsax.profile_2user,
            'Applications',
            widget.job.applicationsReceived,
            Colors.blue,
          ),
          _buildStatItem(
            Iconsax.calendar,
            'Deadline',
            widget.job.deadline,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return _buildSection(
      title: 'Job Description',
      icon: Iconsax.note_text,
      child: Text(
        widget.job.description,
        style: TextStyle(color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return _buildSection(
      title: 'Required Skills',
      icon: Iconsax.cpu,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            widget.job.requiredSkills.map((skill) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildResponsibilitiesSection() {
    return _buildSection(
      title: 'What You Will Do',
      icon: Iconsax.task_square,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            widget.job.responsibilities.map((responsibility) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Iconsax.arrow_right,
                      size: 16,
                      color: Colors.blue[700],
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        responsibility,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildQualificationsSection() {
    return _buildSection(
      title: 'Qualifications',
      icon: Iconsax.verify,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            widget.job.qualifications.map((qualification) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Iconsax.tick_circle, size: 16, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        qualification,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildCompanyInfoSection() {
    return _buildSection(
      title: 'About Company',
      icon: Iconsax.building,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(widget.job.companyImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.job.companyName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${widget.job.companySize} employees • ${widget.job.industry}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            widget.job.companyDescription,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue[700], size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// Job Model Class
class Job {
  final String id;
  final String title;
  final String companyName;
  final String companyImage;
  final String location;
  final String jobType;
  final String salary;
  final String applicationsReceived;
  final String deadline;
  final String description;
  final List<String> requiredSkills;
  final List<String> responsibilities;
  final List<String> qualifications;
  final String companySize;
  final String industry;
  final String companyDescription;
  bool isBookmarked;

  Job({
    required this.id,
    required this.title,
    required this.companyName,
    required this.companyImage,
    required this.location,
    required this.jobType,
    required this.salary,
    required this.applicationsReceived,
    required this.deadline,
    required this.description,
    required this.requiredSkills,
    required this.responsibilities,
    required this.qualifications,
    required this.companySize,
    required this.industry,
    required this.companyDescription,
    this.isBookmarked = false,
  });
}

// Mock Data
final Job mockJob = Job(
  id: '1',
  title: 'Senior Flutter Developer',
  companyName: 'TechCorp Inc.',
  companyImage:
      'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=400&h=300&fit=crop',
  location: 'San Francisco, CA',
  jobType: 'Full-time',
  salary: '\$120K - \$150K',
  applicationsReceived: '245',
  deadline: 'Dec 15, 2024',
  description:
      'We are looking for a skilled Flutter Developer to join our mobile team. You will be responsible for building cross-platform mobile applications for both iOS and Android using Flutter framework.',
  requiredSkills: [
    'Flutter',
    'Dart',
    'Firebase',
    'REST API',
    'Bloc Pattern',
    'UI/UX Design',
    'Git',
    'CI/CD',
  ],
  responsibilities: [
    'Develop and maintain high-quality mobile applications using Flutter',
    'Collaborate with designers and product managers to implement new features',
    'Write clean, maintainable, and testable code',
    'Participate in code reviews and technical discussions',
    'Optimize application performance and ensure smooth user experience',
    'Integrate with third-party APIs and services',
  ],
  qualifications: [
    '5+ years of experience in mobile development',
    '3+ years of experience with Flutter and Dart',
    'Strong understanding of state management solutions (Bloc, Provider)',
    'Experience with Firebase services and RESTful APIs',
    'Knowledge of CI/CD pipelines for mobile apps',
    'Bachelor\'s degree in Computer Science or related field',
  ],
  companySize: '500-1000',
  industry: 'Technology',
  companyDescription:
      'TechCorp is a leading technology company focused on building innovative solutions that transform industries. We believe in creating products that make a difference in people\'s lives.',
  isBookmarked: false,
);
