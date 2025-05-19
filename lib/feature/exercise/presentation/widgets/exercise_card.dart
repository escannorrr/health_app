import 'package:flutter/material.dart';
import '../../domain/entity/exercise.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final Function onTap;

  const ExerciseCard({
    Key? key,
    required this.exercise,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: exercise.isCompleted ? Colors.green : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${exercise.duration} seconds',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              if (exercise.isCompleted)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24,
                ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}