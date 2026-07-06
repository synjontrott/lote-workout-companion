"""Tests for update_user_profile_scheduling.

Importing the module at top level must have no side effects: the real code-mod
only runs under the ``if __name__ == "__main__"`` guard.
"""

import update_user_profile_scheduling as mod

ROUTINES_FIELD = "  final List<WorkoutRoutine> _customRoutines = [];"


def test_import_is_side_effect_free():
    assert callable(mod.transform)
    assert callable(mod.main)


def test_injects_schedule_state():
    out = mod.transform(ROUTINES_FIELD)
    assert "WorkoutSchedule _schedule = WorkoutSchedule();" in out
    assert "void updateSchedule(WorkoutSchedule newSchedule)" in out


def test_idempotent_once_schedule_present():
    once = mod.transform(ROUTINES_FIELD)
    twice = mod.transform(once)
    # The guard (`if "WorkoutSchedule _schedule" not in content`) blocks a
    # second injection, so the transform is idempotent.
    assert once == twice


def test_guard_skips_when_marker_present():
    src = "WorkoutSchedule _schedule marker already present"
    assert mod.transform(src) == src
