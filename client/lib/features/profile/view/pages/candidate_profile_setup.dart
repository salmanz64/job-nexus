import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/core/enums/roles.dart';
import 'package:jobnexus/core/theme/app_pallete.dart';
import 'package:jobnexus/core/utils.dart';
import 'package:jobnexus/features/profile/view/pages/candidate_profile.dart';
import 'package:jobnexus/features/profile/view/widgets/profile_field.dart';
import 'package:jobnexus/features/profile/view/widgets/profile_header.dart';
import 'package:jobnexus/features/profile/view/widgets/profile_section.dart';
import 'package:jobnexus/features/profile/view/widgets/profile_text_area.dart';
import 'package:jobnexus/features/profile/viewmodal/profile_view_model.dart';
import 'package:jobnexus/main_page.dart';

class AddCandidateProfileScreen extends ConsumerStatefulWidget {
  final UserRole role;
  const AddCandidateProfileScreen({super.key, required this.role});

  @override
  ConsumerState<AddCandidateProfileScreen> createState() =>
      _AddCandidateProfileScreenState();
}

class _AddCandidateProfileScreenState
    extends ConsumerState<AddCandidateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // PROFILE IMAGE
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  List<String> skills = [];
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(profileViewModelProvider, (previous, next) {
      next?.when(
        data: (data) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder:
                  (context) => MainPage(
                    isRecruiter:
                        widget.role == UserRole.recruiter ? true : false,
                  ),
            ),
            (_) => false,
          );
        },
        error: (error, stackTrace) {
          return showSnackbar(error.toString(), context);
        },
        loading: () {},
      );
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Pallete.purpleColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PROFILE IMAGE PICKER
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage:
                                _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : null,
                            child:
                                _profileImage == null
                                    ? const Icon(
                                      Iconsax.camera,
                                      size: 40,
                                      color: Colors.white,
                                    )
                                    : null,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const ProfileHeader(),
                      const SizedBox(height: 24),

                      ProfileSection(
                        title: 'Personal Information',
                        icon: Iconsax.user,
                        children: [
                          ProfileTextField(
                            controller: _nameController,
                            label: 'Full Name *',
                            hintText: 'Enter your full name',
                            icon: Iconsax.user,
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? 'Please enter your name'
                                        : null,
                          ),
                          const SizedBox(height: 16),
                          ProfileTextField(
                            controller: _locationController,
                            label: 'Location *',
                            hintText: 'e.g., New York, NY',
                            icon: Iconsax.location,
                            validator:
                                (v) =>
                                    v!.isEmpty ? 'Please enter location' : null,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      ProfileSection(
                        title: 'Professional Details',
                        icon: Iconsax.briefcase,
                        children: [
                          ProfileTextField(
                            controller: _jobTitleController,
                            label: 'Job Title *',
                            hintText: 'e.g., Software Engineer, UX Designer',
                            icon: Iconsax.briefcase,
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? 'Please enter job title'
                                        : null,
                          ),
                          const SizedBox(height: 16),
                          ProfileTextField(
                            controller: _experienceController,
                            label: 'Years of Experience *',
                            hintText: 'e.g., 3',
                            icon: Iconsax.clock,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter experience';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Enter valid number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ProfileTextField(
                            controller: _educationController,
                            label: 'Education',
                            hintText: 'e.g., Bachelor of Computer Science',
                            icon: Iconsax.book,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      ProfileSection(
                        title: 'Contact Information',
                        icon: Iconsax.sms,
                        children: [
                          ProfileTextField(
                            controller: _emailController,
                            label: 'Email *',
                            hintText: 'your.email@example.com',
                            keyboardType: TextInputType.emailAddress,
                            icon: Iconsax.sms,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Invalid email format';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ProfileTextField(
                            controller: _phoneController,
                            label: 'Phone Number *',
                            hintText: '+1 (555) 123-4567',
                            icon: Iconsax.call,
                            keyboardType: TextInputType.phone,
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? 'Please enter phone number'
                                        : null,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      ProfileSection(
                        title: 'About You',
                        icon: Iconsax.document_text,
                        children: [
                          ProfileTextArea(
                            controller: _bioController,
                            label: 'Professional Bio *',
                            hintText:
                                'Tell us about your professional background, achievements, and career goals...',
                            validator:
                                (value) =>
                                    value!.length < 30
                                        ? 'Minimum 30 characters required'
                                        : null,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      ProfileSection(
                        title: 'Skills',
                        icon: Iconsax.cpu,
                        children: [
                          _buildSkillsInput(),
                          const SizedBox(height: 8),
                          _buildSkillsList(),
                        ],
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Pallete.purpleColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Save Profile & Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildSkillsInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _skillsController,
            decoration: InputDecoration(
              hintText: 'Add skill (e.g., Flutter, UI/UX, Project Management)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Pallete.purpleColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: _addSkill,
            icon: const Icon(Iconsax.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsList() {
    if (skills.isEmpty) return Container();

    return Wrap(
      spacing: 8,
      children:
          skills.map((skill) {
            return Chip(
              label: Text(skill),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () => _removeSkill(skill),
            );
          }).toList(),
    );
  }

  void _addSkill() {
    if (_skillsController.text.trim().isNotEmpty) {
      setState(() {
        skills.add(_skillsController.text.trim());
        _skillsController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() => skills.remove(skill));
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    if (_profileImage == null) {
      showSnackbar("Please upload a profile image", context);
      return;
    }

    ref
        .read(profileViewModelProvider.notifier)
        .setupProfile(
          name: _nameController.text,
          location: _locationController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          bio: _bioController.text,
          jobTitle: _jobTitleController.text,
          experienceYears: int.tryParse(_experienceController.text) ?? 0,
          education: _educationController.text,
          skills: skills,
          role: widget.role,
          profileImage: _profileImage,
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _jobTitleController.dispose();
    _experienceController.dispose();
    _educationController.dispose();
    _skillsController.dispose();
    super.dispose();
  }
}
