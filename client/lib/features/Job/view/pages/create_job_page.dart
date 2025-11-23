import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/features/home/viewmodal/home_view_model.dart';

class CreateJobPage extends ConsumerStatefulWidget {
  const CreateJobPage({super.key});

  @override
  ConsumerState<CreateJobPage> createState() => _CreateJobPageState();
}

class _CreateJobPageState extends ConsumerState<CreateJobPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jobTitleController = TextEditingController();

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final TextEditingController _responsibilitiesController =
      TextEditingController();

  String _selectedJobType = 'Full-time';
  String _selectedExperience = 'Mid-level';
  String _selectedCategory = 'Technology';
  List<String> _selectedSkills = [];
  final TextEditingController _skillController = TextEditingController();

  final List<String> _jobTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
    'Remote',
  ];
  final List<String> _experienceLevels = [
    'Entry-level',
    'Mid-level',
    'Senior',
    'Executive',
  ];
  final List<String> _categories = [
    'Technology',
    'Design',
    'Marketing',
    'Sales',
    'Finance',
    'HR',
    'Operations',
  ];
  final List<String> _popularSkills = [
    'Flutter',
    'Dart',
    'Firebase',
    'REST API',
    'UI/UX',
    'Figma',
    'JavaScript',
    'Python',
    'React',
    'Node.js',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Create New Job',
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
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Section
              _buildSection(
                title: 'Basic Information',
                icon: Iconsax.info_circle,
                children: [
                  _buildTextField(
                    controller: _jobTitleController,
                    label: 'Job Title',
                    hintText: 'e.g., Senior Flutter Developer',
                    icon: Iconsax.briefcase,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter job title';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _locationController,
                    label: 'Location',
                    hintText: 'e.g., San Francisco, CA or Remote',
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
              SizedBox(height: 24),

              // Job Details Section
              _buildSection(
                title: 'Job Details',
                icon: Iconsax.setting,
                children: [
                  _buildDropdown(
                    label: 'Job Type',
                    value: _selectedJobType,
                    items: _jobTypes,
                    onChanged: (value) {
                      setState(() {
                        _selectedJobType = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Experience Level',
                    value: _selectedExperience,
                    items: _experienceLevels,
                    onChanged: (value) {
                      setState(() {
                        _selectedExperience = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Category',
                    value: _selectedCategory,
                    items: _categories,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _salaryController,
                    label: 'Salary Range',
                    hintText: 'e.g., \$80,000 - \$120,000',
                    icon: Iconsax.dollar_circle,
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Skills Section
              _buildSection(
                title: 'Required Skills',
                icon: Iconsax.cpu,
                children: [
                  // Add Skill Input
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _skillController,
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
                            if (_skillController.text.trim().isNotEmpty) {
                              _addSkill(_skillController.text.trim());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6E75FF),
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
                  SizedBox(height: 12),

                  // Popular Skills
                  Text(
                    'Popular Skills:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _popularSkills.map((skill) {
                          return GestureDetector(
                            onTap: () {
                              if (!_selectedSkills.contains(skill)) {
                                _addSkill(skill);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                skill,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 12),

                  // Selected Skills
                  if (_selectedSkills.isNotEmpty) ...[
                    Text(
                      'Selected Skills:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          _selectedSkills.map((skill) {
                            return Chip(
                              label: Text(skill),
                              deleteIcon: Icon(Iconsax.close_circle, size: 16),
                              onDeleted: () => _removeSkill(skill),
                              backgroundColor: Color(
                                0xFF6E75FF,
                              ).withOpacity(0.1),
                              labelStyle: TextStyle(color: Color(0xFF6E75FF)),
                            );
                          }).toList(),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 24),

              // Job Description Section
              _buildSection(
                title: 'Job Description',
                icon: Iconsax.note_text,
                children: [
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Job Description',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      hintText:
                          'Describe the role, responsibilities, and what makes your company great...',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter job description';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Requirements Section
              _buildSection(
                title: 'Requirements',
                icon: Iconsax.task_square,
                children: [
                  TextFormField(
                    controller: _requirementsController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Requirements & Qualifications',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      hintText:
                          'List the required qualifications, education, and experience...',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Responsibilities Section
              _buildSection(
                title: 'Responsibilities',
                icon: Iconsax.location_minus1,
                children: [
                  TextFormField(
                    controller: _responsibilitiesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Key Responsibilities',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      hintText:
                          'Describe the day-to-day responsibilities of this role...',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
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
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _createJob,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6E75FF),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Create Job',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
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

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
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
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Iconsax.arrow_down_1, size: 16),
              style: TextStyle(color: Colors.grey[800], fontSize: 14),
              onChanged: onChanged,
              items:
                  items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _addSkill(String skill) {
    if (skill.isNotEmpty && !_selectedSkills.contains(skill)) {
      setState(() {
        _selectedSkills.add(skill);
        _skillController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _selectedSkills.remove(skill);
    });
  }

  void _createJob() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(homeViewModelProvider.notifier)
          .createJob(
            title: _jobTitleController.text,
            location: _locationController.text,
            jobType: _jobTitleController.text,
            experienceLevel: _selectedExperience,
            category: _selectedCategory,
            salaryRange: _salaryController.text,
            skills: _selectedSkills.join(', '),
            description: _descriptionController.text,
            requirements: _requirementsController.text,
            responsibilities: _responsibilitiesController.text,
          );

      // Show success dialog
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.tick_circle,
                      size: 40,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Job Created Successfully!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF110e48),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your job posting has been created and is now live.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Close create job page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6E75FF),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Back to Dashboard'),
                  ),
                ],
              ),
            ),
      );
    }
  }
}
