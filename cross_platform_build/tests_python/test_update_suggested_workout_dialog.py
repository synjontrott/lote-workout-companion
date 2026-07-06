"""Tests for update_suggested_workout_dialog.

Importing the module at top level must have no side effects: the real code-mod
only runs under the ``if __name__ == "__main__"`` guard, so import never touches
lib/views/quest_board_view.dart.
"""

import update_suggested_workout_dialog as mod


def test_import_is_side_effect_free():
    assert callable(mod.transform)
    assert callable(mod.main)


def test_replaces_old_dialog_and_appends_class():
    src = "// before\n" + mod.old_dialog + "\n// after"
    out = mod.transform(src)
    # The old inline AlertDialog is swapped for the new stateful dialog.
    assert mod.new_dialog in out
    assert "_SuggestedWorkoutLogDialog(" in out
    # The old confirmation dialog text is gone after the replacement.
    assert "COMPLETE WORKOUT?" not in out
    # The StatefulWidget definition is appended to the file.
    assert mod.dialog_class in out
    assert "class _SuggestedWorkoutLogDialog extends StatefulWidget" in out


def test_append_only_when_pattern_absent():
    src = "class Foo {}\n"
    out = mod.transform(src)
    # No old_dialog present, so only the class is appended (no other edits).
    assert out == src + "\n" + mod.dialog_class
