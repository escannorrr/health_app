import 'package:flutter/foundation.dart';
import 'package:health_app/core/app/constants.dart';
import '../../../../core/network/network_client.dart';
import '../models/exercise_model.dart';

abstract class ExerciseRemoteDataSource {
  Future<List<ExerciseModel>> getExercises();
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final NetworkClient client;

  ExerciseRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ExerciseModel>> getExercises() async {
    try {
      final response = await client.get(AppConstants.workouts);
      final List<ExerciseModel> exercises = [];

      if (response is List) {
        for (var item in response) {
          exercises.add(ExerciseModel.fromJson(item));
        }
        return exercises;
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      debugPrint('Error fetching exercises: ${e.toString()}');
      throw Exception('Failed to fetch exercises: ${e.toString()}');
    }
  }
}