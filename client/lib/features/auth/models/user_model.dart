import 'dart:convert';
import 'package:jobnexus/core/enums/roles.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? token;
  final UserRole role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.role,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    UserRole? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'role': role.name,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      token: map['token'],
      role: UserRole.values.firstWhere((e) => e.name == map['role']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
