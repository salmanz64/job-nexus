// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class RecruiterProfileModel {
  final String name;
  final String location;
  final String phone;
  final String email;

  final String? bio;
  final String industry;
  final String? companySize;
  final int foundedYear;
  final String? website;
  final List<String>? specialities;

  RecruiterProfileModel({
    required this.name,
    required this.location,
    required this.phone,
    required this.email,
    required this.bio,
    required this.industry,
    required this.companySize,
    required this.foundedYear,
    required this.website,
    required this.specialities,
  });

  RecruiterProfileModel copyWith({
    String? name,
    String? location,
    String? phone,
    String? email,
    String? bio,
    String? industry,
    String? companySize,
    int? foundedYear,
    String? website,
    List<String>? specialities,
  }) {
    return RecruiterProfileModel(
      name: name ?? this.name,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      industry: industry ?? this.industry,
      companySize: companySize ?? this.companySize,
      foundedYear: foundedYear ?? this.foundedYear,
      website: website ?? this.website,
      specialities: specialities ?? this.specialities,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'location': location,
      'phone': phone,
      'email': email,
      'bio': bio,
      'industry': industry,
      'companySize': companySize,
      'foundedYear': foundedYear,
      'website': website,
      'specialities': specialities,
    };
  }

  factory RecruiterProfileModel.fromMap(Map<String, dynamic> map) {
    return RecruiterProfileModel(
      name: map['name'] as String,
      location: map['location'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      bio: map['bio'] != null ? map['bio'] as String : null,
      industry: map['industry'] as String,
      companySize:
          map['company_size'] != null ? map['company_size'] as String : null,
      foundedYear: map['founded_year'] as int,
      website: map['website'] != null ? map['website'] as String : null,
      specialities:
          map['specialities'] != null
              ? List<String>.from((map['specialities'] as List<String>))
              : null,
    );
  }
}
