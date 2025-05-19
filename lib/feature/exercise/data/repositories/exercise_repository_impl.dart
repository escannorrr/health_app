import 'dart:convert';

import '../../domain/entity/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_remote_data_source.dart';
import '../../../../utils/shared_prefs_manager.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseRemoteDataSource remoteDataSource;

  ExerciseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Exercise>> getExercises() async {
    try {
      final remoteExercises = await remoteDataSource.getExercises();
      final completedExerciseIds = await SharedPrefsManager.getCompletedExercises();

      final updatedExercises = remoteExercises.map((exercise) {
        if (completedExerciseIds.contains(exercise.id)) {
          return exercise.copyWith(isCompleted: true);
        }
        return exercise;
      }).toList();

      return updatedExercises;

    } catch (e) {
      throw Exception('Failed to fetch exercises: ${e.toString()}');
    }
  }

  @override
  Future<void> markExerciseAsCompleted(String id) async {
    await SharedPrefsManager.saveCompletedExercise(id);
  }

  @override
  Future<bool> saveCompletedDate() async {
    return await SharedPrefsManager.saveCompletedDate();
  }

  @override
  Future<List<DateTime>> getCompletedDates() async {
    return await SharedPrefsManager.getCompletedDates();
  }

  @override
  Future<int> getCurrentStreak() async {
    final List<DateTime> completedDates = await getCompletedDates();
    if (completedDates.isEmpty) return 0;

    // Sort dates in ascending order
    completedDates.sort((a, b) => a.compareTo(b));

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Check if today or yesterday is the last completed date
    final lastCompletedDate = completedDates.last;
    final lastCompletedDateOnly = DateTime(
        lastCompletedDate.year,
        lastCompletedDate.month,
        lastCompletedDate.day
    );

    // If the last completed date is before yesterday, streak is broken
    if (todayDate.difference(lastCompletedDateOnly).inDays > 1) {
      return 0;
    }

    // Calculate streak
    int streak = 1;
    DateTime currentDate = lastCompletedDateOnly;

    // Calculate consecutive days
    for (int i = completedDates.length - 2; i >= 0; i--) {
      final previousDate = completedDates[i];
      final previousDateOnly = DateTime(
          previousDate.year,
          previousDate.month,
          previousDate.day
      );

      final difference = currentDate.difference(previousDateOnly).inDays;

      if (difference == 1) {
        streak++;
        currentDate = previousDateOnly;
      } else if (difference == 0) {
        // Same day, continue checking
        continue;
      } else {
        // Streak broken
        break;
      }
    }

    return streak;
  }
}
