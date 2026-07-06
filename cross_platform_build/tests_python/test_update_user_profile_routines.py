"""Tests for update_user_profile_routines.

Importing the module at top level must have no side effects: the real code-mod
only runs under the ``if __name__ == "__main__"`` guard.
"""

import update_user_profile_routines as mod

YEARLY_GETTER = "  List<LotEQuest> get yearlyQuests => _yearlyQuests;"
SAVE_GOAL = "await prefs.setString('lote_active_workout_goal', _activeWorkoutGoal.name);"
LOAD_GOAL = "final goalStr = prefs.getString('lote_active_workout_goal');"


def test_import_is_side_effect_free():
    assert callable(mod.transform)
    assert callable(mod.main)


def test_injects_routines_property():
    out = mod.transform(YEARLY_GETTER)
    assert out.startswith(YEARLY_GETTER)
    assert "void saveCustomRoutine(WorkoutRoutine routine)" in out
    assert "List<WorkoutRoutine> _customRoutines = [];" in out


def test_injects_save_progress():
    out = mod.transform(SAVE_GOAL)
    assert "jsonEncode(_customRoutines.map((r) => r.toJson()).toList())" in out


def test_injects_load_progress():
    out = mod.transform(LOAD_GOAL)
    assert "WorkoutRoutine.fromJson(r)" in out


def test_noop_unrelated_content():
    src = "class Foo {}"
    assert mod.transform(src) == src
