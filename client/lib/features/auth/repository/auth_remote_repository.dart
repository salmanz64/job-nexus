import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jobnexus/core/constants/server_constants.dart';
import 'package:jobnexus/core/failure/failure.dart';
import 'package:jobnexus/features/auth/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  //Sign Up
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverUrl}/auth/signup"),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      final resBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201) {
        return Left(AppFailure(resBody['detail']));
      }
      return Right(
        UserModel.fromMap(resBody['user']).copyWith(token: resBody['token']),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  //Sign In
  Future<Either<AppFailure, UserModel>> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverUrl}/auth/login"),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final resBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBody['detail']));
      }

      print(resBody);
      return Right(
        UserModel.fromMap(resBody['user']).copyWith(token: resBody['token']),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  //Add this inside AuthRemoteRepository class

  Future<String> getUserIdFromProfile(String profileId) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstants.serverUrl}/auth/user/$profileId"),
        headers: {'Content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch user ID");
      }

      final resBody = jsonDecode(response.body);

      if (resBody == null || !resBody.containsKey("user_id")) {
        throw Exception("Invalid response format");
      }

      return resBody["user_id"];
    } catch (e) {
      throw Exception("Error getting user ID: $e");
    }
  }

  Future<String> getProfileIdFromUser(String userId) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstants.serverUrl}/auth/profile/$userId"),
        headers: {'Content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch profile ID");
      }

      final resBody = jsonDecode(response.body);

      if (resBody == null || !resBody.containsKey("profile_id")) {
        throw Exception("Invalid response format");
      }

      return resBody["profile_id"];
    } catch (e) {
      throw Exception("Error getting profile ID: $e");
    }
  }
}
