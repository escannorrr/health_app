import '../entity/exercise.dart';

abstract class ExerciseRepository {
  Future<List<Exercise>> getExercises();
  Future<void> markExerciseAsCompleted(String id);
  Future<bool> saveCompletedDate();
  Future<List<DateTime>> getCompletedDates();
  Future<int> getCurrentStreak();
}