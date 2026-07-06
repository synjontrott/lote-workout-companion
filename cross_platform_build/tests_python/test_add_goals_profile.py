import add_goals_profile


def test_import_has_no_side_effects():
    assert hasattr(add_goals_profile, "transform")


def test_transform_adds_active_workout_goal():
    src = (
        "  String _homePlanet = 'Warrion';\n"
        "  String get homePlanet => _homePlanet;\n"
        "      _homePlanet = prefs.getString('lote_home_planet') ?? 'Warrion';\n"
        "      await prefs.setString('lote_home_planet', _homePlanet);\n"
    )
    out = add_goals_profile.transform(src)
    assert "AdvancedWorkoutGoal _activeWorkoutGoal = AdvancedWorkoutGoal.none;" in out
    assert "AdvancedWorkoutGoal get activeWorkoutGoal => _activeWorkoutGoal;" in out
    assert "set activeWorkoutGoal(AdvancedWorkoutGoal val) {" in out
    assert "prefs.getString('lote_workout_goal')" in out
    assert "await prefs.setString('lote_workout_goal', _activeWorkoutGoal.toString());" in out


def test_transform_noop_without_pattern():
    src = "class Foo {}\n"
    assert add_goals_profile.transform(src) == src
