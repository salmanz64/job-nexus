import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/core/theme/app_pallete.dart';
import 'package:jobnexus/features/profile/view/pages/edit_profile_page.dart';

class CandidateProfile extends StatefulWidget {
  const CandidateProfile({Key? key}) : super(key: key);

  @override
  State<CandidateProfile> createState() => _CandidateProfileState();
}

class _CandidateProfileState extends State<CandidateProfile> {
  final UserProfile userProfile = UserProfile(
    name: 'Alex Morgan',
    email: 'alex.morgan@email.com',
    phone: '+1 (555) 123-4567',
    location: 'San Francisco, CA',
    jobTitle: 'Senior Flutter Developer',
    experience: '5 years',
    education: 'BS Computer Science, Stanford University',
    skills: ['Flutter', 'Dart', 'Firebase', 'REST API', 'UI/UX', 'Bloc'],
    bio:
        'Passionate mobile developer with 5+ years of experience building cross-platform applications. Strong focus on clean architecture and user experience.',
    profileImage:
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face',
    resumeUrl: 'https://example.com/resume.pdf',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(),
                _buildQuickStats(),
                _buildPersonalInfo(),
                _buildSkillsSection(),
                _buildExperienceSection(),
                _buildEducationSection(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: EdgeInsets.all(16),
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
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 3),
            ),
            child: ClipOval(
              child: Image.network(
                userProfile.profileImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(Iconsax.user, color: Colors.grey[400]),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProfile.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  userProfile.jobTitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Iconsax.location, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      userProfile.location,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
            icon: Icon(Icons.edit, color: Pallete.purpleColor),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
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
          _buildStatItem('25', 'Applied'),
          _buildStatItem('12', 'Interviews'),
          _buildStatItem('3', 'Offers'),
          _buildStatItem('85%', 'Match Rate'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return _buildSection(
      title: 'Personal Information',
      icon: Iconsax.user,
      child: Column(
        children: [
          _buildInfoRow(Iconsax.sms, 'Email', userProfile.email),
          _buildInfoRow(Iconsax.call, 'Phone', userProfile.phone),
          _buildInfoRow(
            Iconsax.briefcase,
            'Experience',
            userProfile.experience,
          ),
          _buildInfoRow(
            Iconsax.note_text,
            'Bio',
            userProfile.bio,
            isMultiLine: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return _buildSection(
      title: 'Skills',
      icon: Iconsax.cpu,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            userProfile.skills.map((skill) {
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

  Widget _buildExperienceSection() {
    return _buildSection(
      title: 'Experience',
      icon: Iconsax.briefcase,
      child: Column(
        children: [
          _buildExperienceItem(
            'Senior Flutter Developer',
            'TechCorp Inc.',
            '2020 - Present',
            'San Francisco, CA',
          ),
          _buildExperienceItem(
            'Mobile Developer',
            'StartUp XYZ',
            '2018 - 2020',
            'New York, NY',
          ),
        ],
      ),
    );
  }

  Widget _buildEducationSection() {
    return _buildSection(
      title: 'Education',
      icon: Iconsax.book,
      child: _buildEducationItem(
        userProfile.education,
        '2014 - 2018',
        'GPA: 3.8/4.0',
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.all(16),
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

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isMultiLine = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        crossAxisAlignment:
            isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: isMultiLine ? 3 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(
    String title,
    String company,
    String period,
    String location,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 4),
          Text(
            company,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Iconsax.calendar, size: 14, color: Colors.grey[500]),
              SizedBox(width: 4),
              Text(
                period,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              SizedBox(width: 16),
              Icon(Iconsax.location, size: 14, color: Colors.grey[500]),
              SizedBox(width: 4),
              Text(
                location,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEducationItem(String degree, String period, String details) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            degree,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 4),
          Text(period, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          SizedBox(height: 4),
          Text(
            details,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _editProfile(BuildContext context) {
    // Navigate to edit profile page
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Profile'),
            content: Text('This would navigate to edit profile screen'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }
}

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String location;
  final String jobTitle;
  final String experience;
  final String education;
  final List<String> skills;
  final String bio;
  final String profileImage;
  final String resumeUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.jobTitle,
    required this.experience,
    required this.education,
    required this.skills,
    required this.bio,
    required this.profileImage,
    required this.resumeUrl,
  });
}
