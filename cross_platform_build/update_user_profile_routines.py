# Add list of routines
property_injection = """  List<WorkoutRoutine> _customRoutines = [];
  List<WorkoutRoutine> get customRoutines => _customRoutines;

  void saveCustomRoutine(WorkoutRoutine routine) {
    final idx = _customRoutines.indexWhere((r) => r.id == routine.id);
    if (idx != -1) {
      _customRoutines[idx] = routine;
    } else {
      _customRoutines.add(routine);
    }
    _saveProgress();
    notifyListeners();
  }

  void deleteCustomRoutine(String id) {
    _customRoutines.removeWhere((r) => r.id == id);
    _saveProgress();
    notifyListeners();
  }
"""

# Save progress
save_progress = """    await prefs.setString(
        'lote_custom_routines',
        jsonEncode(_customRoutines.map((r) => r.toJson()).toList()),
      );"""

# Load progress
load_progress = """      final routinesJson = prefs.getString('lote_custom_routines');
      if (routinesJson != null) {
        final List<dynamic> raw = jsonDecode(routinesJson);
        _customRoutines = raw.map((r) => WorkoutRoutine.fromJson(r)).toList();
      } else {
        _customRoutines = [];
      }"""


def transform(content: str) -> str:
    content = content.replace("  List<LotEQuest> get yearlyQuests => _yearlyQuests;", "  List<LotEQuest> get yearlyQuests => _yearlyQuests;\n\n" + property_injection)
    content = content.replace(
        "await prefs.setString('lote_active_workout_goal', _activeWorkoutGoal.name);",
        "await prefs.setString('lote_active_workout_goal', _activeWorkoutGoal.name);\n      " + save_progress
    )
    content = content.replace(
        "final goalStr = prefs.getString('lote_active_workout_goal');",
        load_progress + "\n\n      final goalStr = prefs.getString('lote_active_workout_goal');"
    )
    return content


def main() -> None:
    with open('lib/managers/user_profile_manager.dart', 'r') as f:
        content = f.read()
    content = transform(content)
    with open('lib/managers/user_profile_manager.dart', 'w') as f:
        f.write(content)


if __name__ == "__main__":
    main()
