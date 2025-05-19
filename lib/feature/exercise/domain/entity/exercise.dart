import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final String id;
  final String name;
  final String description;
  final int duration;
  final String difficulty;
  final bool isCompleted;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.difficulty,
    this.isCompleted = false,
  });

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    int? duration,
    String? difficulty,
    bool? isCompleted,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, name, description, duration, difficulty, isCompleted];
}
