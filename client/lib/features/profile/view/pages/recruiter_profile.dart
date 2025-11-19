import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/core/failure/failure.dart';
import 'package:jobnexus/core/theme/app_pallete.dart';
import 'package:jobnexus/features/profile/view/widgets/recruiter_profile_header.dart';
import 'package:jobnexus/features/profile/view/widgets/recruiter_section.dart';
import 'package:jobnexus/features/profile/viewmodal/profile_view_model.dart';

class RecruiterProfile extends ConsumerStatefulWidget {
  const RecruiterProfile({super.key});

  @override
  ConsumerState<RecruiterProfile> createState() => _RecruiterProfileState();
}

class _RecruiterProfileState extends ConsumerState<RecruiterProfile> {
  final CompanyProfile companyProfile = CompanyProfile(
    companyName: 'TechCorp Inc.',
    industry: 'Technology & Software Development',
    companySize: '500-1000 employees',
    location: 'San Francisco, CA',
    website: 'www.techcorp.com',
    founded: '2015',
    email: 'careers@techcorp.com',
    phone: '+1 (555) 123-4567',
    about:
        'TechCorp is a leading technology company focused on building innovative solutions that transform industries. We believe in creating products that make a difference in people\'s lives and foster a culture of innovation and collaboration.',
    specialties: [
      'Mobile Development',
      'Web Applications',
      'AI/ML',
      'Cloud Solutions',
    ],
    companyLogo:
        'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=400&h=300&fit=crop',
    coverImage:
        'https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=800&h=300&fit=crop',
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                        SliverAppBar(
                          expandedHeight: 200,
                          floating: false,
                          pinned: true,
                          backgroundColor: Pallete.purpleColor,
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                              'Company Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            background: Image.network(
                              companyProfile.coverImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Pallete.purpleColor,
                                        Colors.blue[600]!,
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          actions: [
                            IconButton(
                              icon: Icon(Iconsax.edit, color: Colors.white),
                              onPressed: () => _editProfile(context),
                            ),
                          ],
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              RecruiterProfileHeader(
                                companyName: profile.name,
                                location: profile.location,
                                industry: profile.industry,
                              ),
                              _buildCompanyStats(),
                              RecruiterSection(
                                title: 'About Company',
                                icon: Iconsax.info_circle,
                                child: Text(
                                  profile.bio ?? "No Bio Set",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              RecruiterSection(
                                title: 'Company Details',
                                icon: Iconsax.building,
                                child: Column(
                                  children: [
                                    _buildDetailRow(
                                      Iconsax.people,
                                      'Company Size',
                                      profile.companySize ?? "Not Set",
                                    ),
                                    _buildDetailRow(
                                      Iconsax.calendar,
                                      'Founded',
                                      profile.foundedYear.toString(),
                                    ),
                                    _buildDetailRow(
                                      Iconsax.global,
                                      'Website',
                                      profile.website ?? "Not Set",
                                    ),
                                  ],
                                ),
                              ),

                              //Specialites
                              RecruiterSection(
                                title: 'Specialties',
                                icon: Iconsax.cpu,
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                      profile.specialities?.map((specialty) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[50],
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: Colors.blue[100]!,
                                            ),
                                          ),
                                          child: Text(
                                            specialty,
                                            style: TextStyle(
                                              color: Pallete.purpleColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }).toList() ??
                                      [],
                                ),
                              ),

                              //Contact Informations
                              RecruiterSection(
                                title: 'Contact Information',
                                icon: Iconsax.sms,
                                child: Column(
                                  children: [
                                    _buildContactRow(
                                      Iconsax.sms,
                                      'Email',
                                      profile.email,
                                    ),
                                    _buildContactRow(
                                      Iconsax.call,
                                      'Phone',
                                      profile.phone,
                                    ),
                                    _buildContactRow(
                                      Iconsax.location,
                                      'Address',
                                      profile.location,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
              ),
    );
  }

  Widget _buildCompanyStats() {
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
          _buildStatItem('12', 'Active Jobs'),
          _buildStatItem('245', 'Applications'),
          _buildStatItem('18', 'Interviews'),
          _buildStatItem('5', 'Hires'),
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
            color: Pallete.purpleColor,
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
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
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
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
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Pallete.purpleColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Icon(Iconsax.copy, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }

  void _editProfile(BuildContext context) {
    // Navigate to edit company profile page
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Company Profile'),
            content: Text('This would navigate to edit company profile screen'),
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

class CompanyProfile {
  final String companyName;
  final String industry;
  final String companySize;
  final String location;
  final String website;
  final String founded;
  final String email;
  final String phone;
  final String about;
  final List<String> specialties;
  final String companyLogo;
  final String coverImage;

  CompanyProfile({
    required this.companyName,
    required this.industry,
    required this.companySize,
    required this.location,
    required this.website,
    required this.founded,
    required this.email,
    required this.phone,
    required this.about,
    required this.specialties,
    required this.companyLogo,
    required this.coverImage,
  });
}
