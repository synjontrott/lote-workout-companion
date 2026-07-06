"""Tests for update_user_profile_generate.

Importing the module at top level must have no side effects: the real code-mod
only runs under the ``if __name__ == "__main__"`` guard.
"""

import update_user_profile_generate as mod


def test_import_is_side_effect_free():
    assert callable(mod.transform)
    assert callable(mod.main)


def test_adds_active_goal_to_quest_cadence():
    src = "generateQuests(\n            QuestCadence.daily,\n          );"
    out = mod.transform(src)
    assert "activeGoal: _activeWorkoutGoal," in out


def test_adds_active_goal_after_water_goal():
    src = "      waterGoal: _waterIntakeGoal,\n        );"
    out = mod.transform(src)
    assert "activeGoal: _activeWorkoutGoal," in out
    assert out != src


def test_noop_unrelated_content():
    src = "int x = 0;\n"
    assert mod.transform(src) == src
