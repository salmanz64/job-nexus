import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:jobnexus/core/constants/server_constants.dart';
import 'package:jobnexus/core/enums/roles.dart';
import 'package:jobnexus/core/failure/failure.dart';
import 'package:jobnexus/features/auth/models/user_model.dart';
import 'package:jobnexus/features/profile/models/recruiter_profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_remote_repository.g.dart';

@riverpod
ProfileRemoteRepository profileRemoteRepository(Ref ref) {
  return ProfileRemoteRepository();
}

class ProfileRemoteRepository {
  Future<Either<AppFailure, RecruiterProfileModel>> setupProfile({
    required String name,
    required String industry,
    required String companySize,
    required String location,
    required String email,
    required String phone,
    required String token,
    List<String>? specialities,
    String? bio,
    required int foundedYear,
    String? website,
    required UserRole role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverUrl}/auth/setup-profile"),
        headers: {'Content-type': 'application/json', 'x-auth-token': token},
        body: jsonEncode({
          'name': name,
          'industry': industry,
          'companySize': companySize,
          'location': location,
          'email': email,
          'phone': phone,
          'specialities': specialities,
          'bio': bio,
          'foundedYear': foundedYear,
          'website': website,
        }),
      );

      final resBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201) {
        return Left(AppFailure(resBody['detail']));
      }
      return Right(RecruiterProfileModel.fromMap(resBody));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  //Get User Profile
  Future<Either<AppFailure, RecruiterProfileModel>> getCurrentProfile({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          "${ServerConstants.serverUrl}/auth/",
        ), // Your profile endpoint
        headers: {'Content-type': 'application/json', 'x-auth-token': token},
      );

      final resBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBody['detail'] ?? 'Failed to load profile'));
      }
      return Right(RecruiterProfileModel.fromMap(resBody));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
