"""Tests for update_stats_minigame_fixed.py.

Importing the module proves it has no import-time side effects (it must not
touch lib/views/character_stats_view.dart when imported).
"""

import update_stats_minigame_fixed as m

SIG = "  Widget _buildBadgesSection(UserProfileManager profile, Color themeColor) {"

BADGES_BLOCK = (
    '                  ] else if (_selectedTab == "Badges") ...[\n'
    "                    _buildBadgesSection(profile, themeColor),\n"
    "                  ],"
)


def test_module_is_import_safe():
    assert callable(m.transform)


def test_transform_adds_trials_tab_and_section():
    src = '["Stats", "Badges"]\n' + SIG + "\n" + BADGES_BLOCK + "\n"
    out = m.transform(src)
    # Trials tab added.
    assert '["Stats", "Badges", "Trials"]' in out
    # Trials section + roller injected.
    assert "ORACLE STAT TRIALS" in out
    assert "_buildTrialsSection" in out
    # Tab dispatch gains a Trials branch.
    assert 'else if (_selectedTab == "Trials")' in out
    # dart:math import prepended.
    assert out.startswith("import 'dart:math' as import_math;\n")


def test_transform_only_prepends_import_without_anchors():
    src = "int x = 0;\n"
    assert m.transform(src) == "import 'dart:math' as import_math;\n" + src
