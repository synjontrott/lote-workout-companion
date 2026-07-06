"""Tests for update_quest_board_routines_combined.py.

Importing the module proves it has no import-time side effects (it must not
touch lib/views/quest_board_view.dart when imported).
"""

import update_quest_board_routines_combined as m

SIG = "  Widget _buildSuggestedWorkoutsSection(UserProfileManager profile) {"


def test_module_is_import_safe():
    assert callable(m.transform)


def test_transform_injects_routines_section_and_dialogs():
    src = (
        "                  _buildSuggestedWorkoutsSection(profile),\n"
        + SIG
        + "\n    return Container();\n  }\n"
    )
    out = m.transform(src)
    # Custom routines section injected before the suggested-workouts section.
    assert "_buildCustomRoutinesSection" in out
    assert "_buildCustomRoutinesSection(profile)," in out
    # Dialog widgets appended at the end of the file.
    assert "_SuggestedWorkoutLogDialog" in out
    assert "class _AddToRoutineDialog extends StatefulWidget" in out


def test_transform_appends_dialogs_but_no_section_without_anchor():
    out = m.transform("int x = 0;\n")
    # Nothing to inject the routines section into.
    assert "_buildCustomRoutinesSection" not in out
    # Dialog widgets are always appended.
    assert "_SuggestedWorkoutLogDialog" in out
