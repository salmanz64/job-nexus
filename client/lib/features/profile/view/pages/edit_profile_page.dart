import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _jobTitleController;
  late TextEditingController _experienceController;
  late TextEditingController _educationController;
  late TextEditingController _bioController;
  late List<String> _skills;
  final _formKey = GlobalKey<FormState>();
  String _newSkill = '';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _skills = [];
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    _jobTitleController = TextEditingController();
    _experienceController = TextEditingController();
    _educationController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _jobTitleController.dispose();
    _experienceController.dispose();
    _educationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: Colors.grey[700]),
          onPressed: () => _showExitConfirmation(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildProfileImageSection(),
              SizedBox(height: 24),
              _buildPersonalInfoSection(),
              SizedBox(height: 16),
              _buildProfessionalInfoSection(),
              SizedBox(height: 16),
              _buildSkillsSection(),
              SizedBox(height: 16),
              _buildBioSection(),
              SizedBox(height: 32),
              _buildActionButtons(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 3),
              ),
              child: ClipOval(
                child: Image.network(
                  '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Iconsax.user,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: IconButton(
                  icon: Icon(Iconsax.camera, size: 16, color: Colors.white),
                  onPressed: _changeProfileImage,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          'Tap camera icon to change photo',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSection(
      title: 'Personal Information',
      icon: Iconsax.user,
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Full Name',
          icon: Iconsax.user,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          icon: Iconsax.sms,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          icon: Iconsax.call,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _locationController,
          label: 'Location',
          icon: Iconsax.location,
        ),
      ],
    );
  }

  Widget _buildProfessionalInfoSection() {
    return _buildSection(
      title: 'Professional Information',
      icon: Iconsax.briefcase,
      children: [
        _buildTextField(
          controller: _jobTitleController,
          label: 'Job Title',
          icon: Iconsax.briefcase,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _experienceController,
          label: 'Experience',
          icon: Iconsax.calendar,
          hintText: 'e.g., 5 years',
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _educationController,
          label: 'Education',
          icon: Iconsax.book,
          hintText: 'e.g., BS Computer Science, University Name',
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return _buildSection(
      title: 'Skills',
      icon: Iconsax.cpu,
      children: [
        // Add new skill input
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Add Skill',
                  prefixIcon: Icon(Iconsax.add, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                onChanged: (value) => _newSkill = value,
                onFieldSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _addSkill(value.trim());
                  }
                },
              ),
            ),
            SizedBox(width: 12),
            Container(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (_newSkill.trim().isNotEmpty) {
                    _addSkill(_newSkill.trim());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Text('Add'),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Skills list
        if (_skills.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _skills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    deleteIcon: Icon(Iconsax.close_circle, size: 16),
                    onDeleted: () => _removeSkill(skill),
                    backgroundColor: Colors.blue[50],
                    labelStyle: TextStyle(color: Colors.blue[700]),
                  );
                }).toList(),
          ),
          SizedBox(height: 8),
          Text(
            'Tap × to remove skills',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ] else ...[
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(Iconsax.info_circle, color: Colors.grey[500], size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Add skills to increase your job match rate',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBioSection() {
    return _buildSection(
      title: 'Professional Bio',
      icon: Iconsax.note_text,
      children: [
        TextFormField(
          controller: _bioController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'Tell us about yourself',
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            hintText: 'Describe your experience, skills, and career goals...',
          ),
          maxLength: 500,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${_bioController.text.length}/500',
              style: TextStyle(
                color:
                    _bioController.text.length > 500
                        ? Colors.red
                        : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _showExitConfirmation(context),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Divider(),
        SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: _uploadResume,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.document_upload,
                  size: 20,
                  color: Colors.blue[700],
                ),
                SizedBox(width: 8),
                Text(
                  'Upload Updated Resume',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      validator: validator,
    );
  }

  void _addSkill(String skill) {
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _newSkill = '';
        // Clear the text field
        FocusScope.of(context).unfocus();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  void _changeProfileImage() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Iconsax.camera),
                  title: Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    // Implement camera functionality
                  },
                ),
                ListTile(
                  leading: Icon(Iconsax.gallery),
                  title: Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    // Implement gallery picker
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _uploadResume() {
    // Implement resume upload functionality
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Upload Resume'),
            content: Text('This would open file picker to select PDF/document'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  void _saveProfile() {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

void _showExitConfirmation(BuildContext context) {
  if (true) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Unsaved Changes'),
            content: Text(
              'You have unsaved changes. Are you sure you want to discard them?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Discard', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  } else {
    Navigator.pop(context);
  }
}
