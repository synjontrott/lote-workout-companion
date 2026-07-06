def transform(content: str) -> str:
    schedule_class = """
class WorkoutSchedule {
  final Map<int, String> routinesByDay; // 1=Mon, 7=Sun, maps to Routine ID
  final Map<int, bool> restDays;
  final String flowTime; // For ADHD/AuDHD: "Morning", "Afternoon", "Night"
  final String? consistentTime; // For Autistic/Neurotypical: e.g. "08:00"

  WorkoutSchedule({
    this.routinesByDay = const {},
    this.restDays = const {},
    this.flowTime = "Morning",
    this.consistentTime,
  });

  factory WorkoutSchedule.fromJson(Map<String, dynamic> json) {
    return WorkoutSchedule(
      routinesByDay: (json['routinesByDay'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(int.parse(k), v as String),
          ) ?? {},
      restDays: (json['restDays'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(int.parse(k), v as bool),
          ) ?? {},
      flowTime: json['flowTime'] as String? ?? "Morning",
      consistentTime: json['consistentTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routinesByDay': routinesByDay.map((k, v) => MapEntry(k.toString(), v)),
      'restDays': restDays.map((k, v) => MapEntry(k.toString(), v)),
      'flowTime': flowTime,
      'consistentTime': consistentTime,
    };
  }

  WorkoutSchedule copyWith({
    Map<int, String>? routinesByDay,
    Map<int, bool>? restDays,
    String? flowTime,
    String? consistentTime,
  }) {
    return WorkoutSchedule(
      routinesByDay: routinesByDay ?? this.routinesByDay,
      restDays: restDays ?? this.restDays,
      flowTime: flowTime ?? this.flowTime,
      consistentTime: consistentTime ?? this.consistentTime,
    );
  }
}
"""

    if "class WorkoutSchedule" not in content:
        content = content + "\n" + schedule_class
    return content


def main() -> None:
    with open('lib/models/lote_models.dart', 'r') as f:
        content = f.read()
    content = transform(content)
    with open('lib/models/lote_models.dart', 'w') as f:
        f.write(content)


if __name__ == "__main__":
    main()
