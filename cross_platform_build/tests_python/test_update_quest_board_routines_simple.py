"""Tests for update_quest_board_routines_simple.py.

Importing the module proves it has no import-time side effects (it must not
touch lib/views/quest_board_view.dart when imported).
"""

import update_quest_board_routines_simple as m

SIG = "  Widget _buildSuggestedWorkoutsSection(UserProfileManager profile) {"


def test_module_is_import_safe():
    assert callable(m.transform)


def test_transform_injects_section_and_rewrites_buttons():
    src = (
        "                  _buildSuggestedWorkoutsSection(profile),\n"
        + SIG
        + "\n"
        + m.old_button_block
        + "\n"
    )
    out = m.transform(src)
    # Custom routines section injected.
    assert "_buildCustomRoutinesSection" in out
    assert "_buildCustomRoutinesSection(profile)," in out
    # Dialog widgets appended.
    assert "_SuggestedWorkoutLogDialog" in out
    # The old confirm-dialog button block is replaced with LOG + ADD TO ROUTINE.
    assert '"COMPLETE WORKOUT?"' not in out
    assert "ADD TO ROUTINE" in out


def test_transform_appends_dialogs_but_no_section_without_anchor():
    out = m.transform("int x = 0;\n")
    assert "_buildCustomRoutinesSection" not in out
    assert "_SuggestedWorkoutLogDialog" in out
