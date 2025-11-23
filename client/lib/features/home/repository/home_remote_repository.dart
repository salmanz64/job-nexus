import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:jobnexus/core/constants/server_constants.dart';
import 'package:jobnexus/core/failure/failure.dart';
import 'package:jobnexus/features/home/models/job_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_remote_repository.g.dart';

@riverpod
HomeRemoteRepository homeRemoteRepository(Ref ref) {
  return HomeRemoteRepository();
}

class HomeRemoteRepository {
  Future<Either<AppFailure, Map<String, dynamic>>> createJob({
    required String token,
    required String title,
    required String description,
    required String requirements,
    required String responsibilities,
    required String location,
    required String salaryRange,
    required String jobType,
    required String experienceLevel,
    required String category,
    required String skills,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverUrl}/job/create"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
        body: jsonEncode({
          "title": title,
          "description": description,
          "requirements": requirements,
          "responsibilities": responsibilities,
          "location": location,
          "salary_range": salaryRange,
          "job_type": jobType,
          "experience_level": experienceLevel,
          "category": category,
          "skills": skills,
        }),
      );

      final resBody = jsonDecode(response.body);

      if (response.statusCode != 201) {
        return Left(AppFailure(resBody['detail'] ?? 'Failed to create job'));
      }

      return Right(resBody); // Return created job model if you have one
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<JobModel>>> getRecruiterJobs({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstants.serverUrl}/job/"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (response.statusCode != 200) {
        return Left(AppFailure("Failed to fetch jobs"));
      }

      final List data = jsonDecode(response.body);

      final jobs = data.map((e) => JobModel.fromMap(e)).toList();
      print(jobs);

      return Right(jobs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  //all Jobs
  Future<Either<AppFailure, List<JobModel>>> fetchAllJobs({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstants.serverUrl}/job/all"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (response.statusCode != 200) {
        return Left(AppFailure("Failed to fetch jobs"));
      }

      final List data = jsonDecode(response.body);

      final jobs = data.map((e) => JobModel.fromMap(e)).toList();

      return Right(jobs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
