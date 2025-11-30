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
    String? resumeUrl,
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
  // UPDATE APPLICATION STATUS (PATCH)
  // ---------------------------------------------------------
  Future<Either<AppFailure, Map<String, dynamic>>> updateApplicationStatus({
    required String token,
    required String applicationId,
    required String status,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse("${ServerConstants.serverUrl}/application/update-status"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
        body: jsonEncode({"application_id": applicationId, "status": status}),
      );

      final resBody = jsonDecode(response.body);

      if (response.statusCode != 200) {
        return Left(
          AppFailure(resBody['message'] ?? "Failed to update status"),
        );
      }

      // Response example: { message, id, status }
      return Right(resBody);
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

  // ---------------------------------------------------------
  // GET Filtered by STATUS
  // ---------------------------------------------------------
  Future<Either<AppFailure, List<ApplicationModel>>> getApplicationsByStatus({
    required String token,
    required String status,
  }) async {
    try {
      final uri = Uri.parse(
        "${ServerConstants.serverUrl}/application/recruiter",
      ).replace(queryParameters: {"status": status});

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (response.statusCode != 200) {
        return Left(AppFailure("Failed to filter applications"));
      }

      final List data = jsonDecode(response.body);
      return Right(data.map((e) => ApplicationModel.fromMap(e)).toList());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ---------------------------------------------------------
  // SEARCH applications by job name
  // ---------------------------------------------------------
  Future<Either<AppFailure, List<ApplicationModel>>> searchApplications({
    required String token,
    required String query,
  }) async {
    try {
      final uri = Uri.parse(
        "${ServerConstants.serverUrl}/application/recruiter",
      ).replace(queryParameters: {"search": query});

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (response.statusCode != 200) {
        return Left(AppFailure("Search failed"));
      }

      final List data = jsonDecode(response.body);
      return Right(data.map((e) => ApplicationModel.fromMap(e)).toList());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ---------------------------------------------------------
  // FILTER applications by JOB ID
  // ---------------------------------------------------------
  Future<Either<AppFailure, List<ApplicationModel>>> getApplicationsByJob({
    required String token,
    required String jobId,
  }) async {
    try {
      final uri = Uri.parse(
        "${ServerConstants.serverUrl}/application/recruiter",
      ).replace(queryParameters: {"job_id": jobId});

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (response.statusCode != 200) {
        return Left(AppFailure("Failed to fetch applications for job"));
      }

      final List data = jsonDecode(response.body);
      return Right(data.map((e) => ApplicationModel.fromMap(e)).toList());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ---------------------------------------------------------
  // COMBINED FILTER (status + search + job)
  // ---------------------------------------------------------
  Future<Either<AppFailure, List<ApplicationModel>>> filterApplications({
    required String token,
    String? status,
    String? search,
    String? jobId,
  }) async {
    try {
      final queryParams = {
        if (status != null && status.isNotEmpty) "status": status,
        if (search != null && search.isNotEmpty) "search": search,
        if (jobId != null && jobId.isNotEmpty) "job_id": jobId,
      };

      final uri = Uri.parse(
        "${ServerConstants.serverUrl}/application/recruiter",
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (response.statusCode != 200) {
        return Left(AppFailure("Filter request failed"));
      }

      final List data = jsonDecode(response.body);
      return Right(data.map((e) => ApplicationModel.fromMap(e)).toList());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
