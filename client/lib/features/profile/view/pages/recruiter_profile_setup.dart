import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/core/enums/roles.dart';
import 'package:jobnexus/core/theme/app_pallete.dart';
import 'package:jobnexus/core/utils.dart';
import 'package:jobnexus/features/profile/view/pages/recruiter_profile.dart';
import 'package:jobnexus/features/profile/view/widgets/profile_field.dart';
import 'package:jobnexus/features/profile/view/widgets/profile_header.dart';
import 'package:jobnexus/features/profile/view/widgets/profile_section.dart';
import 'package:jobnexus/features/profile/view/widgets/profile_text_area.dart';
import 'package:jobnexus/features/profile/viewmodal/profile_view_model.dart';
import 'package:jobnexus/main_page.dart';

class AddRecruiterProfileScreen extends ConsumerStatefulWidget {
  final UserRole role;
  const AddRecruiterProfileScreen({super.key, required this.role});

  @override
  ConsumerState<AddRecruiterProfileScreen> createState() =>
      _AddRecruiterProfileScreenState();
}

class _AddRecruiterProfileScreenState
    extends ConsumerState<AddRecruiterProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // PROFILE IMAGE
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Form controllers
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _companySizeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _foundedController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _specialtiesController = TextEditingController();

  List<String> specialties = [];
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
                      // NEW PROFILE IMAGE PICKER (MINIMAL UI)
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

                      ProfileHeader(),
                      const SizedBox(height: 24),

                      ProfileSection(
                        title: 'Company Information',
                        icon: Iconsax.building,
                        children: [
                          ProfileTextField(
                            controller: _companyNameController,
                            label: 'Company Name *',
                            hintText: 'Enter your company name',
                            icon: Iconsax.building,
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? 'Please enter company name'
                                        : null,
                          ),
                          const SizedBox(height: 16),
                          ProfileTextField(
                            controller: _industryController,
                            label: 'Industry *',
                            hintText: 'e.g., Technology, Healthcare, Finance',
                            icon: Iconsax.category,
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? 'Please enter industry'
                                        : null,
                          ),
                          const SizedBox(height: 16),
                          _buildDropdownField(),
                          const SizedBox(height: 16),
                          ProfileTextField(
                            controller: _locationController,
                            label: 'Location *',
                            hintText: 'e.g., San Francisco, CA',
                            icon: Iconsax.location,
                            validator:
                                (v) => v!.isEmpty ? 'Enter location' : null,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      ProfileSection(
                        title: 'Company Details',
                        icon: Iconsax.info_circle,
                        children: [
                          ProfileTextField(
                            controller: _foundedController,
                            label: 'Founded Year',
                            hintText: 'e.g., 2015',
                            icon: Iconsax.calendar,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          ProfileTextField(
                            controller: _websiteController,
                            label: 'Website',
                            hintText: 'www.example.com',
                            icon: Iconsax.global,
                            keyboardType: TextInputType.url,
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
                            hintText: 'careers@company.com',
                            keyboardType: TextInputType.emailAddress,
                            icon: Iconsax.sms,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Invalid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ProfileTextField(
                            controller: _phoneController,
                            label: 'Phone Number',
                            hintText: '+1 (555) 123-4567',
                            icon: Iconsax.call,
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      ProfileSection(
                        title: 'About Company',
                        icon: Iconsax.document_text,
                        children: [
                          ProfileTextArea(
                            controller: _aboutController,
                            label: 'Company Description *',
                            hintText: 'Tell us about your company culture...',
                            validator:
                                (value) =>
                                    value!.length < 50
                                        ? 'Min 50 characters required'
                                        : null,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      ProfileSection(
                        title: 'Specialties',
                        icon: Iconsax.cpu,
                        children: [
                          _buildSpecialtiesInput(),
                          const SizedBox(height: 8),
                          _buildSpecialtiesList(),
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

  Widget _buildDropdownField() {
    const List<String> companySizes = [
      '1-10 employees',
      '11-50 employees',
      '51-200 employees',
      '201-500 employees',
      '501-1000 employees',
      '1000+ employees',
    ];

    return DropdownButtonFormField<String>(
      value:
          _companySizeController.text.isEmpty
              ? null
              : _companySizeController.text,
      items:
          companySizes
              .map(
                (String size) =>
                    DropdownMenuItem(value: size, child: Text(size)),
              )
              .toList(),
      onChanged: (value) {
        setState(() => _companySizeController.text = value!);
      },
      validator: (value) => value == null ? "Please select company size" : null,
      decoration: InputDecoration(
        hintText: "Select company size",
        prefixIcon: Icon(Iconsax.people, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
      ),
    );
  }

  Widget _buildSpecialtiesInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _specialtiesController,
            decoration: InputDecoration(
              hintText: 'Add specialty (e.g., Mobile Development)',
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
            onPressed: _addSpecialty,
            icon: const Icon(Iconsax.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtiesList() {
    if (specialties.isEmpty) return Container();

    return Wrap(
      spacing: 8,
      children:
          specialties.map((e) {
            return Chip(
              label: Text(e),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () => _removeSpecialty(e),
            );
          }).toList(),
    );
  }

  void _addSpecialty() {
    if (_specialtiesController.text.trim().isNotEmpty) {
      setState(() {
        specialties.add(_specialtiesController.text.trim());
        _specialtiesController.clear();
      });
    }
  }

  void _removeSpecialty(String specialty) {
    setState(() => specialties.remove(specialty));
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    if (_profileImage == null) {
      showSnackbar("Please upload a profile/company image", context);
      return;
    }

    ref
        .read(profileViewModelProvider.notifier)
        .setupProfile(
          name: _companyNameController.text,
          industry: _industryController.text,
          foundedYear: int.tryParse(_foundedController.text) ?? 0,
          companySize: _companySizeController.text,
          location: _locationController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          role: widget.role,
          profileImage: _profileImage, // <-- Added to backend payload
          bio: _aboutController.text,
          specialities: specialties,
          website: _websiteController.text,
        );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _industryController.dispose();
    _companySizeController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _foundedController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    _specialtiesController.dispose();
    super.dispose();
  }
}
