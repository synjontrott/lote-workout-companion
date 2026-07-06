def transform(content: str) -> str:
    # Add to properties
    content = content.replace(
        "  String _homePlanet = 'Warrion';",
        "  String _homePlanet = 'Warrion';\n  AdvancedWorkoutGoal _activeWorkoutGoal = AdvancedWorkoutGoal.none;",
        1
    )

    # Add getter and setter
    content = content.replace(
        "  String get homePlanet => _homePlanet;",
        "  String get homePlanet => _homePlanet;\n  AdvancedWorkoutGoal get activeWorkoutGoal => _activeWorkoutGoal;\n\n  set activeWorkoutGoal(AdvancedWorkoutGoal val) {\n    _activeWorkoutGoal = val;\n    _save();\n    notifyListeners();\n  }",
        1
    )

    # Add to load
    content = content.replace(
        "      _homePlanet = prefs.getString('lote_home_planet') ?? 'Warrion';",
        "      _homePlanet = prefs.getString('lote_home_planet') ?? 'Warrion';\n      final goalStr = prefs.getString('lote_workout_goal');\n      if (goalStr != null) {\n        _activeWorkoutGoal = AdvancedWorkoutGoal.values.firstWhere(\n          (e) => e.toString() == goalStr,\n          orElse: () => AdvancedWorkoutGoal.none,\n        );\n      }",
        1
    )

    # Add to save
    content = content.replace(
        "      await prefs.setString('lote_home_planet', _homePlanet);",
        "      await prefs.setString('lote_home_planet', _homePlanet);\n      await prefs.setString('lote_workout_goal', _activeWorkoutGoal.toString());",
        1
    )

    return content


def main() -> None:
    path = 'lib/managers/user_profile_manager.dart'
    with open(path, 'r') as f:
        content = f.read()
    content = transform(content)
    with open(path, 'w') as f:
        f.write(content)


if __name__ == "__main__":
    main()
