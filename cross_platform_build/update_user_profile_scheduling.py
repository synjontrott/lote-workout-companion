schedule_var = """
  WorkoutSchedule _schedule = WorkoutSchedule();
  WorkoutSchedule get schedule => _schedule;

  void updateSchedule(WorkoutSchedule newSchedule) {
    _schedule = newSchedule;
    _save();
    notifyListeners();
  }
"""


def transform(content: str) -> str:
    if "WorkoutSchedule _schedule" not in content:
        content = content.replace("  final List<WorkoutRoutine> _customRoutines = [];", schedule_var + "\n  final List<WorkoutRoutine> _customRoutines = [];")

    # Add saving/loading logic
    if "prefs.getString('lote_schedule')" not in content:
        load_code = """
      final scheduleStr = prefs.getString('lote_schedule');
      if (scheduleStr != null) {
        _schedule = WorkoutSchedule.fromJson(import_convert.jsonDecode(scheduleStr));
      }
"""
        content = content.replace("      final routinesStr = prefs.getString('lote_custom_routines');", load_code + "\n      final routinesStr = prefs.getString('lote_custom_routines');")

    if "prefs.setString('lote_schedule'" not in content:
        save_code = """
      await prefs.setString('lote_schedule', import_convert.jsonEncode(_schedule.toJson()));
"""
        content = content.replace("      await prefs.setString('lote_custom_routines', import_convert.jsonEncode(routinesList));", save_code + "\n      await prefs.setString('lote_custom_routines', import_convert.jsonEncode(routinesList));")
    return content


def main() -> None:
    with open('lib/managers/user_profile_manager.dart', 'r') as f:
        content = f.read()
    content = transform(content)
    with open('lib/managers/user_profile_manager.dart', 'w') as f:
        f.write(content)


if __name__ == "__main__":
    main()
