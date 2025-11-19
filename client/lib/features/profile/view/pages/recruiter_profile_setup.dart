import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/core/enums/roles.dart';
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
        backgroundColor: Colors.blue[700],
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
                      // Header
                      ProfileHeader(),
                      const SizedBox(height: 24),

                      // Company Basic Info
                      ProfileSection(
                        title: 'Company Information',
                        icon: Iconsax.building,
                        children: [
                          ProfileTextField(
                            controller: _companyNameController,
                            label: 'Company Name *',
                            hintText: 'Enter your company name',
                            icon: Iconsax.building,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter company name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ProfileTextField(
                            controller: _industryController,
                            label: 'Industry *',
                            hintText: 'e.g., Technology, Healthcare, Finance',
                            icon: Iconsax.category,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter industry';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildDropdownField(),
                          const SizedBox(height: 16),
                          ProfileTextField(
                            controller: _locationController,
                            label: 'Location *',
                            hintText: 'e.g., San Francisco, CA',
                            icon: Iconsax.location,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter location';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Company Details
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

                      // Contact Information
                      ProfileSection(
                        title: 'Contact Information',
                        icon: Iconsax.sms,
                        children: [
                          ProfileTextField(
                            controller: _emailController,
                            label: 'Email *',
                            hintText: 'careers@company.com',
                            icon: Iconsax.sms,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email';
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

                      // About Company
                      ProfileSection(
                        title: 'About Company',
                        icon: Iconsax.document_text,
                        children: [
                          ProfileTextArea(
                            controller: _aboutController,
                            label: 'Company Description *',
                            hintText:
                                'Tell us about your company culture, mission, and values...',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter company description';
                              }
                              if (value.length < 50) {
                                return 'Description should be at least 50 characters';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Specialties
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

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Company Size *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value:
              _companySizeController.text.isEmpty
                  ? null
                  : _companySizeController.text,
          items:
              companySizes.map((String size) {
                return DropdownMenuItem<String>(value: size, child: Text(size));
              }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _companySizeController.text = newValue!;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select company size';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Select company size',
            prefixIcon: Icon(Iconsax.people, color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
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
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue[700],
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
    if (specialties.isEmpty) {
      return Container();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          specialties.map((specialty) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    specialty,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => _removeSpecialty(specialty),
                    child: Icon(Icons.close, size: 16, color: Colors.blue[700]),
                  ),
                ],
              ),
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
    setState(() {
      specialties.remove(specialty);
    });
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      ref
          .read(profileViewModelProvider.notifier)
          .setupProfile(
            name: _companyNameController.text,
            industry: _industryController.text,
            foundedYear: int.parse(_foundedController.text),
            companySize: _companySizeController.text,
            location: _locationController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            role: widget.role,
          );
    }
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
