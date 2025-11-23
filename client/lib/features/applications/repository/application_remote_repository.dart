import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:jobnexus/core/constants/server_constants.dart';
import 'package:jobnexus/core/failure/failure.dart';
import 'package:jobnexus/features/applications/models/application_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'application_remote_repository.g.dart';

@riverpod
ApplicationRemoteRepository applicationRemoteRepository(Ref ref) {
  return ApplicationRemoteRepository();
}

class ApplicationRemoteRepository {
  // ---------------------------------------------------------
  // CREATE APPLICATION
  // ---------------------------------------------------------
  Future<Either<AppFailure, ApplicationModel>> createApplication({
    required String token,
    required String jobId,
    required String resumeUrl,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverUrl}/application/create"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
        body: jsonEncode({"job_id": jobId, "resume_url": resumeUrl}),
      );

      final resBody = jsonDecode(response.body);

      if (response.statusCode != 201) {
        return Left(AppFailure(resBody['detail'] ?? 'Failed to apply for job'));
      }

      return Right(ApplicationModel.fromMap(resBody));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ---------------------------------------------------------
  // GET APPLICATIONS FOR RECRUITER
  // ---------------------------------------------------------
  Future<Either<AppFailure, List<ApplicationModel>>> getRecruiterApplications({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstants.serverUrl}/application/recruiter/"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (response.statusCode != 200) {
        return Left(AppFailure("Failed to fetch applications"));
      }

      final List data = jsonDecode(response.body);

      final apps = data.map((e) => ApplicationModel.fromMap(e)).toList();

      return Right(apps);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ---------------------------------------------------------
  // OPTIONAL: GET APPLICATIONS OF CURRENT USER
  // ---------------------------------------------------------
  Future<Either<AppFailure, List<ApplicationModel>>> getMyApplications({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstants.serverUrl}/application/candidate"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (response.statusCode != 200) {
        return Left(AppFailure("Failed to fetch my applications"));
      }

      final List data = jsonDecode(response.body);

      final apps = data.map((e) => ApplicationModel.fromMap(e)).toList();

      return Right(apps);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
