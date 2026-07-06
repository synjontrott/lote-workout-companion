"""Tests for update_suggested_workouts.

Importing the module at top level must have no side effects: the real code-mod
only runs under the ``if __name__ == "__main__"`` guard.
"""

import update_suggested_workouts as mod

# The replace target is the first line of the injected block by design.
ANCHOR = mod.injection.splitlines()[0]


def test_import_is_side_effect_free():
    assert callable(mod.transform)
    assert callable(mod.main)


def test_injects_progression_block():
    out = mod.transform("a\n" + ANCHOR + "\nb")
    assert "if (profile.activeWorkoutGoal != AdvancedWorkoutGoal.none" in out
    assert "prerequisiteWorkouts" in out


def test_only_first_occurrence_replaced():
    out = mod.transform(ANCHOR + "\n" + ANCHOR)
    # count=1: the progression block is injected exactly once.
    assert out.count("AdvancedWorkoutGoal.none") == 1


def test_noop_without_anchor():
    src = "nothing to see here\n"
    assert mod.transform(src) == src
