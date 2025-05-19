import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/exercise_bloc.dart';
import '../bloc/exercise_event.dart';
import '../bloc/exercise_state.dart';
import '../widgets/exercise_card.dart';
import 'exercise_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int streak = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  void _refreshData() {
    context.read<ExerciseBloc>().add(FetchExercisesEvent());
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercise App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff106AC4),
      ),
      body: BlocConsumer<ExerciseBloc, ExerciseState>(
        listener: (context, state) {
          if (state is ExerciseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is StreakUpdated) {
            setState(() {
              streak = state.streak;
            });
          } else if (state is ExerciseCompleted) {
            _refreshData();
          }
        },
        buildWhen: (prev, curr) => curr is ExerciseLoaded,
        builder: (context, state) {
          print("Current BLoC State: $state");
          if (state is ExerciseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExerciseLoaded) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffE0EFFE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Current Streak: $streak days',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: state.exercises.isEmpty
                      ? const Center(child: Text('No exercises available'))
                      : RefreshIndicator(
                          onRefresh: () async => _refreshData(),
                          child: ListView.builder(
                            itemCount: state.exercises.length,
                            itemBuilder: (context, index) {
                              final exercise = state.exercises[index];
                              return ExerciseCard(
                                key: ValueKey(
                                    '${exercise.id}_${exercise.isCompleted}'),
                                exercise: exercise,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExerciseDetailPage(
                                          exercise: exercise),
                                    ),
                                  );
                                  if (mounted) _refreshData();
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Something went wrong.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshData,
                    child: const Text('Refresh Data'),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
