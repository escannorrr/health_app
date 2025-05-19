import '../../domain/entity/exercise.dart';

class ExerciseModel extends Exercise {
  ExerciseModel({
    required String id,
    required String name,
    required String description,
    required int duration,
    required String difficulty,
    bool isCompleted = false,
  }) : super(
    id: id,
    name: name,
    description: description,
    duration: duration,
    difficulty: difficulty,
    isCompleted: isCompleted,
  );

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      duration: json['duration'],
      difficulty: json['difficulty'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'difficulty': difficulty,
      'isCompleted': isCompleted,
    };
  }
}