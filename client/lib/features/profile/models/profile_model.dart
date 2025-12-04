class ProfileModel {
  final String id;
  final String name;
  final String location;
  final String phone;
  final String email;
  final String? bio;

  // NEW 📌 Profile image
  final String? profileImageUrl;

  // Candidate fields
  final String? jobTitle;
  final int? experienceYears;
  final List<String>? skills;
  final String? education;
  final String? resumeUrl;

  // Recruiter fields
  final String? industry;
  final String? companySize;
  final int? foundedYear;
  final String? website;
  final List<String>? specialities;

  // Auto-detected role
  bool get isRecruiter => industry != null;

  ProfileModel({
    required this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.email,
    this.bio,

    // NEW
    this.profileImageUrl,

    // Candidate
    this.jobTitle,
    this.experienceYears,
    this.skills,
    this.education,
    this.resumeUrl,

    // Recruiter
    this.industry,
    this.companySize,
    this.foundedYear,
    this.website,
    this.specialities,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'],

      // NEW
      profileImageUrl: map['profile_image_url'] ?? map['profileImageUrl'],

      // Candidate
      jobTitle: map['job_title'],
      experienceYears: map['experience_years'],
      education: map['education'],
      resumeUrl: map['resume_url'],
      skills: map['skills'] != null ? List<String>.from(map['skills']) : null,

      // Recruiter
      industry: map['industry'],
      companySize: map['company_size'],
      foundedYear: map['founded_year'],
      website: map['website'],
      specialities:
          map['specialities'] != null
              ? List<String>.from(map['specialities'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'phone': phone,
      'email': email,
      'bio': bio,

      // NEW
      'profile_image_url': profileImageUrl,

      // candidate
      'job_title': jobTitle,
      'experience_years': experienceYears,
      'skills': skills,
      'education': education,
      'resume_url': resumeUrl,

      // recruiter
      'industry': industry,
      'company_size': companySize,
      'founded_year': foundedYear,
      'website': website,
      'specialities': specialities,
    };
  }
}
