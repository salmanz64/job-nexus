import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:jobnexus/core/constants/server_constants.dart';
import 'package:jobnexus/core/enums/roles.dart';
import 'package:jobnexus/core/failure/failure.dart';
import 'package:jobnexus/features/auth/models/user_model.dart';
import 'package:jobnexus/features/profile/models/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_remote_repository.g.dart';

@riverpod
ProfileRemoteRepository profileRemoteRepository(Ref ref) {
  return ProfileRemoteRepository();
}

class ProfileRemoteRepository {
  Future<Either<AppFailure, ProfileModel>> setupProfile({
    required Map<String, dynamic> profileData,
    required String token,
    required UserRole role,
    File? profileImage,
  }) async {
    try {
      final uri = Uri.parse("${ServerConstants.serverUrl}/profile/setup-new");

      final request =
          http.MultipartRequest("POST", uri)
            ..headers['x-auth-token'] = token
            ..fields['profile_data'] = jsonEncode({
              ...profileData,
              "role": role.name, // ensure backend receives role
            });

      if (profileImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath("profile_image", profileImage.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final resBody = jsonDecode(response.body);

      if (response.statusCode != 201) {
        return Left(AppFailure(resBody['detail'] ?? "Unknown Error"));
      }

      return Right(ProfileModel.fromMap(resBody));
    } catch (e) {
      return Left(AppFailure("Request Failed: $e"));
    }
  }

  //Get User Profile
  Future<Either<AppFailure, ProfileModel>> getCurrentProfile({
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
      return Right(ProfileModel.fromMap(resBody));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
