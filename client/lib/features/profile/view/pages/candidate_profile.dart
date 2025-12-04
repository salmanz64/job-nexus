import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/core/theme/app_pallete.dart';
import 'package:jobnexus/features/profile/view/pages/edit_profile_page.dart';
import 'package:jobnexus/features/profile/view/widgets/candidate_profile_header.dart';
import 'package:jobnexus/features/profile/view/widgets/info_row.dart';
import 'package:jobnexus/features/profile/view/widgets/main_profile_section.dart';
import 'package:jobnexus/features/profile/viewmodal/profile_view_model.dart';

class CandidateProfile extends ConsumerStatefulWidget {
  const CandidateProfile({Key? key}) : super(key: key);

  @override
  ConsumerState<CandidateProfile> createState() => _CandidateProfileState();
}

class _CandidateProfileState extends ConsumerState<CandidateProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref.read(profileViewModelProvider.notifier).getCurrentProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileData = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body:
          profileData == null
              ? Center(child: Text("No Profile Data"))
              : profileData.when(
                loading: () {
                  return Center(child: CircularProgressIndicator());
                },
                error: (error, stackTrace) {
                  return throw (error.toString());
                },

                data:
                    (profile) => CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              CandidateProfileHeader(
                                location: profile.location,
                                name: profile.name,
                                imageUrl:
                                    profile.profileImageUrl ??
                                    'https://static.vecteezy.com/system/resources/previews/023/731/733/non_2x/head-hunting-related-icon-hr-illustration-sign-candidate-symbol-vector.jpg',
                                position: profile.jobTitle!,
                              ),
                              _buildQuickStats(),
                              MainProfileSection(
                                title: 'Personal Information',
                                icon: Iconsax.user,
                                child: Column(
                                  children: [
                                    InfoRow(
                                      icon: Iconsax.sms,
                                      isMultiLine: true,
                                      label: 'Email',
                                      value: profile.email,
                                    ),
                                    InfoRow(
                                      icon: Iconsax.call,
                                      label: 'Phone',
                                      isMultiLine: true,
                                      value: profile.phone,
                                    ),
                                    InfoRow(
                                      icon: Iconsax.briefcase,
                                      label: 'Experience',
                                      isMultiLine: true,
                                      value: profile.experienceYears.toString(),
                                    ),
                                    InfoRow(
                                      isMultiLine: true,
                                      icon: Iconsax.note_text,
                                      label: 'Bio',
                                      value: profile.bio!,
                                    ),
                                  ],
                                ),
                              ),
                              _buildExperienceSection(),
                              _buildEducationSection(),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
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
          _buildStatItem('2', 'Applied'),
          _buildStatItem('1', 'Shortlisted'),
          _buildStatItem('1', 'Hired'),
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
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 4),
            Text("", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            SizedBox(height: 4),
            Text("", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
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
