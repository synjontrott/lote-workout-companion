import re

with open('lib/models/lote_models.dart', 'r') as f:
    content = f.read()

models = """
class RoutineExercise {
  final String workoutId;
  final int sets;
  final String reps;

  RoutineExercise({
    required this.workoutId,
    required this.sets,
    required this.reps,
  });

  Map<String, dynamic> toJson() => {
        'workoutId': workoutId,
        'sets': sets,
        'reps': reps,
      };

  factory RoutineExercise.fromJson(Map<String, dynamic> json) {
    return RoutineExercise(
      workoutId: json['workoutId'] ?? '',
      sets: json['sets'] ?? 1,
      reps: json['reps'] ?? '10',
    );
  }
}

class WorkoutRoutine {
  final String id;
  final String name;
  final List<RoutineExercise> exercises;

  WorkoutRoutine({
    required this.id,
    required this.name,
    required this.exercises,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  factory WorkoutRoutine.fromJson(Map<String, dynamic> json) {
    return WorkoutRoutine(
      id: json['id'] ?? UniqueKey().toString(),
      name: json['name'] ?? 'Custom Routine',
      exercises: (json['exercises'] as List?)
              ?.map((e) => RoutineExercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SuggestedWorkout {"""

content = content.replace("class SuggestedWorkout {", models)

with open('lib/models/lote_models.dart', 'w') as f:
    f.write(content)
