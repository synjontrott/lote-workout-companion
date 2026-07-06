"""Tests for update_quest_board_routines_create.py.

Importing the module proves it has no import-time side effects (it must not
touch lib/views/quest_board_view.dart when imported).
"""

import update_quest_board_routines_create as m

SIG = "  Widget _buildSuggestedWorkoutsSection(UserProfileManager profile) {"


def test_module_is_import_safe():
    assert callable(m.transform)


def test_transform_rewrites_buttons_and_adds_dialog():
    # Build a minimal input that contains every 'before' pattern by reusing the
    # module's own literal constants.
    src = m.old_button + "\n" + m.old_button_end + "\n" + SIG + "\n"
    out = m.transform(src)
    # Single "COMPLETE WORKOUT" button becomes a LOG + ADD TO ROUTINE row.
    assert '"COMPLETE WORKOUT"' not in out
    assert '"LOG"' in out
    assert "ADD TO ROUTINE" in out
    # Helper method + dialog widget added.
    assert "_showAddToRoutineDialog" in out
    assert "class _AddToRoutineDialog extends StatefulWidget" in out


def test_transform_appends_dialog_but_no_helper_without_anchor():
    out = m.transform("int x = 0;\n")
    # Dialog widget is always appended.
    assert "class _AddToRoutineDialog extends StatefulWidget" in out
    # Helper method is only added when the section signature is present.
    assert "_showAddToRoutineDialog" not in out
