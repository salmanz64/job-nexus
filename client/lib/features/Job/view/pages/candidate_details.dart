import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/features/profile/models/profile_model.dart';
import 'package:jobnexus/features/profile/view/pages/candidate_profile.dart';

class CandidateDetailsPage extends StatelessWidget {
  final ProfileModel candidateDetails;

  const CandidateDetailsPage({super.key, required this.candidateDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Candidate Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0XFF110e48),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: Colors.grey[700]),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Iconsax.share, color: Colors.grey[700]),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: Icon(Iconsax.more, color: Colors.grey[700]),
            onSelected: (value) {
              // Handle menu item selection
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem(
                    value: 'download',
                    child: Text('Download Resume'),
                  ),
                  PopupMenuItem(value: 'contact', child: Text('Contact Info')),
                  PopupMenuItem(value: 'notes', child: Text('Add Notes')),
                ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),
            SizedBox(height: 24),

            // About Section
            _buildSection(
              title: 'About',
              icon: Iconsax.user,
              child: Text(
                candidateDetails.bio ?? "No Bio Provided",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            SizedBox(height: 24),

            // Experience Section
            _buildSection(
              title: 'Work Experience',
              icon: Iconsax.briefcase,
              child: Column(
                children:
                    _getExperienceList().map<Widget>((exp) {
                      return _buildExperienceItem(exp);
                    }).toList(),
              ),
            ),
            SizedBox(height: 24),

            // Education Section
            _buildSection(
              title: 'Education',
              icon: Iconsax.book,
              child: Column(
                children:
                    _getEducationList().map<Widget>((edu) {
                      return _buildEducationItem(edu);
                    }).toList(),
              ),
            ),
            SizedBox(height: 24),

            // Skills Section
            _buildSection(
              title: 'Skills',
              icon: Iconsax.cpu,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _getSkillsList().map<Widget>((skill) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF6E75FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xFF6E75FF).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          skill.toString(),
                          style: TextStyle(
                            color: Color(0xFF6E75FF),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            SizedBox(height: 24),

            // Contact Information
            _buildSection(
              title: 'Contact Information',
              icon: Iconsax.profile_2user,
              child: Column(
                children: [
                  _buildContactItem(
                    Iconsax.sms,
                    'Email',
                    candidateDetails.email,
                  ),
                  _buildContactItem(
                    Iconsax.call,
                    'Phone',
                    candidateDetails.phone,
                  ),
                  _buildContactItem(
                    Iconsax.location,
                    'Location',
                    candidateDetails.location,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Resume Section
            _buildSection(
              title: 'Resume',
              icon: Iconsax.document,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.document_text,
                          size: 24,
                          color: Color(0xFF6E75FF),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${candidateDetails.name.toString()}_Resume.pdf',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0XFF110e48),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '2.4 MB • Updated 2 days ago',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Iconsax.document_download,
                            color: Color(0xFF6E75FF),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
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
              child: OutlinedButton(
                onPressed: () {
                  // Message candidate
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: Color(0xFF6E75FF)),
                ),
                child: Text(
                  'Message',
                  style: TextStyle(
                    color: Color(0xFF6E75FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Schedule interview
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6E75FF),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Schedule Interview',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods to safely extract data
  List<Map<String, dynamic>> _getExperienceList() {
    final experience = candidateDetails.education ?? [];
    if (experience is List) {
      return experience.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  List<Map<String, dynamic>> _getEducationList() {
    final education = candidateDetails.education ?? [];
    if (education is List) {
      return education.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  List<dynamic> _getSkillsList() {
    final skills = candidateDetails.skills ?? [];
    return skills;
  }

  String _getExperienceText() {
    final experience = candidateDetails.experienceYears ?? 0;
    if (experience > 0) {
      return '${experience.toString()} years';
    }
    return 'No experience';
  }

  Widget _buildProfileHeader() {
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
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFF6E75FF), width: 3),
            ),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face',
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
                  candidateDetails.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF110e48),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  candidateDetails.jobTitle ?? 'No position specified',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6E75FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Iconsax.location, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      candidateDetails.location,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(width: 16),
                    Icon(Iconsax.briefcase, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      _getExperienceText(),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.arrow_up_3, size: 12, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        '${'0'}% Match',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF6E75FF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: Color(0xFF6E75FF)),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
              Icon(icon, color: Color(0xFF6E75FF), size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF110e48),
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

  Widget _buildExperienceItem(Map<String, dynamic> experience) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF6E75FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Iconsax.briefcase, size: 20, color: Color(0xFF6E75FF)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  experience['position']?.toString() ?? 'Unknown Position',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0XFF110e48),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  experience['company']?.toString() ?? 'Unknown Company',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Text(
                  '${experience['startDate']?.toString() ?? ''} - ${experience['endDate']?.toString() ?? ''} • ${experience['duration']?.toString() ?? ''}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                SizedBox(height: 8),
                Text(
                  experience['description']?.toString() ??
                      'No description provided',
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationItem(Map<String, dynamic> education) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF6E75FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Iconsax.book, size: 20, color: Color(0xFF6E75FF)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  education['degree']?.toString() ?? 'Unknown Degree',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0XFF110e48),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  education['institution']?.toString() ?? 'Unknown Institution',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Text(
                  '${education['year']?.toString() ?? ''} • ${education['grade']?.toString() ?? ''}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
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
                Text(value, style: TextStyle(color: Colors.grey[800])),
              ],
            ),
          ),
          if (label == 'Email' || label == 'Phone')
            IconButton(
              icon: Icon(Iconsax.copy, size: 16, color: Color(0xFF6E75FF)),
              onPressed: () {},
            ),
        ],
      ),
    );
  }
}

// Updated mock candidate data with proper types
final Map<String, dynamic> mockCandidate = {
  'name': 'Alex Morgan',
  'email': 'alex.morgan@email.com',
  'phone': '+1 (555) 123-4567',
  'location': 'San Francisco, CA',
  'position': 'Senior Flutter Developer',
  'experience': '5 years', // This should be a string, not a list
  'profileImage':
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face',
  'matchScore': 85,
  'about':
      'Passionate mobile developer with 5+ years of experience building cross-platform applications.',
  'skills': [
    'Flutter',
    'Dart',
    'Firebase',
    'REST API',
    'Bloc Pattern',
    'UI/UX',
    'Git',
    'CI/CD',
  ],
  'workExperience': [
    // Renamed to avoid conflict with 'experience' string
    {
      'position': 'Senior Flutter Developer',
      'company': 'TechCorp Inc.',
      'startDate': 'Jan 2020',
      'endDate': 'Present',
      'duration': '2 years 8 months',
      'description':
          'Lead development of cross-platform mobile applications using Flutter.',
    },
  ],
  'education': [
    {
      'degree': 'Bachelor of Science in Computer Science',
      'institution': 'Stanford University',
      'year': '2014 - 2018',
      'grade': 'GPA: 3.8/4.0',
    },
  ],
};
