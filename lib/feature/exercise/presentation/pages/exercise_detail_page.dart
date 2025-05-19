import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/exercise.dart';
import '../bloc/exercise_bloc.dart';
import '../bloc/exercise_event.dart';
import '../bloc/exercise_state.dart';
import '../widgets/timer_widget.dart';

class ExerciseDetailPage extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailPage({
    super.key,
    required this.exercise,
  });

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.exercise.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, isCompleted);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.exercise.name,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          elevation: 0,
          backgroundColor: const Color(0xff106AC4),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: BlocConsumer<ExerciseBloc, ExerciseState>(
          listener: (context, state) {
            if (state is ExerciseCompleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exercise completed!'),
                  backgroundColor: Colors.green,
                ),
              );

              context.read<ExerciseBloc>().add(FetchExercisesEvent());
              context.read<ExerciseBloc>().add(GetStreakEvent());

              setState(() {
                isCompleted = true;
              });

              // Navigate back to home after completion
              Future.delayed(const Duration(seconds: 2), () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context, true);
                }
              });
            } else if (state is ExerciseError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final bool isInProgress = state is ExerciseInProgress &&
                state.exercise.id == widget.exercise.id;
            final bool isPaused = state is ExercisePaused &&
                state.exercise.id == widget.exercise.id;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.exercise.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.exercise.description,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Chip(
                            label: Text('${widget.exercise.duration} seconds'),
                            backgroundColor: Colors.blue.shade100,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(widget.exercise.difficulty),
                            backgroundColor: Colors.red[300],
                          ),
                        ],
                      ),
                      if (widget.exercise.isCompleted && !isInProgress)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),
                      if (isInProgress || isPaused) ...[
                        TimerWidget(
                          remainingSeconds: isInProgress
                              ? (state).remainingSeconds
                              : (state as ExercisePaused).remainingSeconds,
                        ),
                        const SizedBox(height: 24),

                        // Control buttons - only show when exercise is in progress or paused
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Pause/Resume button
                            ElevatedButton.icon(
                              onPressed: () {
                                if (isInProgress) {
                                  context.read<ExerciseBloc>().add(
                                      PauseExerciseEvent((state).exercise,
                                          (state).remainingSeconds));
                                } else if (isPaused) {
                                  context.read<ExerciseBloc>().add(
                                      ResumeExerciseEvent((state).exercise,
                                          (state).remainingSeconds));
                                }
                              },
                              icon: Icon(
                                isPaused ? Icons.play_arrow : Icons.pause,
                                color: Colors.white,
                              ),
                              label: Text(
                                isPaused ? 'Resume' : 'Pause',
                                style: const TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Stop button
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<ExerciseBloc>().add(
                                    StopExerciseEvent(isInProgress
                                        ? (state).exercise
                                        : (state as ExercisePaused).exercise));
                              },
                              icon: const Icon(
                                Icons.stop,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Stop',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (!isInProgress && !isPaused)
                        Center(
                          child: ElevatedButton(
                            onPressed: widget.exercise.isCompleted
                                ? null
                                : () {
                                    context.read<ExerciseBloc>().add(
                                        StartExerciseEvent(widget.exercise));
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              backgroundColor: Colors.blue,
                              disabledBackgroundColor: Colors.grey,
                            ),
                            child: Text(
                              widget.exercise.isCompleted
                                  ? 'Completed'
                                  : 'Start Exercise',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
