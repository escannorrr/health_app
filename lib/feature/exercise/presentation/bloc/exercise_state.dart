import '../../domain/entity/exercise.dart';

abstract class ExerciseState {}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  final List<Exercise> exercises;

  ExerciseLoaded(this.exercises);
}

class ExerciseError extends ExerciseState {
  final String message;

  ExerciseError(this.message);
}

class ExerciseCompleted extends ExerciseState {
  final Exercise exercise;

  ExerciseCompleted(this.exercise);
}

class ExerciseInProgress extends ExerciseState {
  final Exercise exercise;
  final int remainingSeconds;

  ExerciseInProgress(this.exercise, this.remainingSeconds);
}

class StreakUpdated extends ExerciseState {
  final int streak;

  StreakUpdated(this.streak);
}

class ExercisePaused extends ExerciseState {
  final Exercise exercise;
  final int remainingSeconds;

  ExercisePaused(this.exercise, this.remainingSeconds);
}