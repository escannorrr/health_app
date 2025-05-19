import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import 'exercise_event.dart';
import 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExerciseRepository repository;
  Timer? _timer;

  ExerciseBloc({required this.repository}) : super(ExerciseInitial()) {
    on<FetchExercisesEvent>(_onFetchExercises);
    on<StartExerciseEvent>(_onStartExercise);
    on<UpdateTimerEvent>(_onUpdateTimer);
    on<CompleteExerciseEvent>(_onCompleteExercise);
    on<GetStreakEvent>(_onGetStreak);
    on<PauseExerciseEvent>(_onPauseExercise);
    on<ResumeExerciseEvent>(_onResumeExercise);
    on<StopExerciseEvent>(_onStopExercise);
  }

  Future<void> _onFetchExercises(
    FetchExercisesEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    try {
      final exercises = await repository.getExercises();
      emit(ExerciseLoaded(List.from(exercises))); // Emit fresh list
    } catch (e) {
      emit(ExerciseError('Failed to load exercises: ${e.toString()}'));
    }
  }

  Future<void> _onStartExercise(
    StartExerciseEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    final exercise = event.exercise;
    int remainingSeconds = exercise.duration;

    emit(ExerciseInProgress(exercise, remainingSeconds));
    _startTimer(exercise, remainingSeconds);
  }

  void _startTimer(Exercise exercise, int remainingSeconds) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds--;

      if (remainingSeconds <= 0) {
        timer.cancel();
        add(CompleteExerciseEvent(exercise));
      } else {
        add(UpdateTimerEvent(exercise, remainingSeconds));
      }
    });
  }

  Future<void> _onPauseExercise(
    PauseExerciseEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    _timer?.cancel();
    emit(ExercisePaused(event.exercise, event.remainingSeconds));
  }

  Future<void> _onResumeExercise(
    ResumeExerciseEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseInProgress(event.exercise, event.remainingSeconds));
    _startTimer(event.exercise, event.remainingSeconds);
  }

  Future<void> _onStopExercise(
    StopExerciseEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    _timer?.cancel();
    emit(ExerciseInitial());
  }

  void _onUpdateTimer(
    UpdateTimerEvent event,
    Emitter<ExerciseState> emit,
  ) {
    emit(ExerciseInProgress(event.exercise, event.remainingSeconds));
  }

  Future<void> _onCompleteExercise(
    CompleteExerciseEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    final updatedExercise = event.exercise.copyWith(isCompleted: true);

    try {
      await repository.markExerciseAsCompleted(updatedExercise.id);
      await repository.saveCompletedDate();

      emit(ExerciseCompleted(updatedExercise));
      add(FetchExercisesEvent()); // Refresh list
      add(GetStreakEvent()); // Update streak
    } catch (e) {
      emit(ExerciseError(
          'Failed to mark exercise as completed: ${e.toString()}'));
    }
  }

  Future<void> _onGetStreak(
    GetStreakEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      final streak = await repository.getCurrentStreak();
      emit(StreakUpdated(streak));
    } catch (e) {
      emit(ExerciseError('Failed to calculate streak: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
