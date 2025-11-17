import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/features/profile/view/pages/recruiter_profile.dart';

class AddRecruiterProfileScreen extends StatefulWidget {
  const AddRecruiterProfileScreen({super.key});

  @override
  State<AddRecruiterProfileScreen> createState() =>
      _AddRecruiterProfileScreenState();
}

class _AddRecruiterProfileScreenState extends State<AddRecruiterProfileScreen> {
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
                      _buildHeader(),
                      const SizedBox(height: 24),

                      // Company Basic Info
                      _buildSection(
                        title: 'Company Information',
                        icon: Iconsax.building,
                        children: [
                          _buildTextField(
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
                          _buildTextField(
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
                          _buildTextField(
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
                      _buildSection(
                        title: 'Company Details',
                        icon: Iconsax.info_circle,
                        children: [
                          _buildTextField(
                            controller: _foundedController,
                            label: 'Founded Year',
                            hintText: 'e.g., 2015',
                            icon: Iconsax.calendar,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
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
                      _buildSection(
                        title: 'Contact Information',
                        icon: Iconsax.sms,
                        children: [
                          _buildTextField(
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
                          _buildTextField(
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
                      _buildSection(
                        title: 'About Company',
                        icon: Iconsax.document_text,
                        children: [
                          _buildTextArea(
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
                      _buildSection(
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[800]!.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.profile_add,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Your Company Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Add your company details to start posting jobs and finding talent',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.grey[600]),
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

  Widget _buildTextArea({
    required TextEditingController controller,
    required String label,
    required String hintText,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: 5,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
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
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create company profile object
      final companyProfile = CompanyProfile(
        companyName: _companyNameController.text,
        industry: _industryController.text,
        companySize: _companySizeController.text,
        location: _locationController.text,
        website: _websiteController.text,
        founded: _foundedController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        about: _aboutController.text,
        specialties: specialties,
        companyLogo:
            'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=400&h=300&fit=crop',
        coverImage:
            'https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=800&h=300&fit=crop',
      );

      // TODO: Save to database/local storage

      setState(() {
        _isLoading = false;
      });

      // Navigate to main profile page
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RecruiterProfile()),
        );
      }
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
