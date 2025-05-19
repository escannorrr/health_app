import '../../domain/entity/exercise.dart';

abstract class ExerciseEvent {}

class FetchExercisesEvent extends ExerciseEvent {}

class StartExerciseEvent extends ExerciseEvent {
  final Exercise exercise;

  StartExerciseEvent(this.exercise);
}

class UpdateTimerEvent extends ExerciseEvent {
  final Exercise exercise;
  final int remainingSeconds;

  UpdateTimerEvent(this.exercise, this.remainingSeconds);
}

class CompleteExerciseEvent extends ExerciseEvent {
  final Exercise exercise;

  CompleteExerciseEvent(this.exercise);
}

class GetStreakEvent extends ExerciseEvent {}

class PauseExerciseEvent extends ExerciseEvent {
  final Exercise exercise;
  final int remainingSeconds;

  PauseExerciseEvent(this.exercise, this.remainingSeconds);
}

class ResumeExerciseEvent extends ExerciseEvent {
  final Exercise exercise;
  final int remainingSeconds;

  ResumeExerciseEvent(this.exercise, this.remainingSeconds);
}

class StopExerciseEvent extends ExerciseEvent {
  final Exercise exercise;

  StopExerciseEvent(this.exercise);
}