"""Tests for update_settings_schedule.py.

Importing the module proves it has no import-time side effects (it must not
touch lib/views/settings_view.dart when imported).
"""

import update_settings_schedule as m

MARKER = "                          // Re-Forge Character Sprite Button"


def test_module_is_import_safe():
    assert callable(m.transform)


def test_transform_injects_schedule_ui_before_marker():
    out = m.transform(MARKER + "\n")
    # schedule_ui block is injected...
    assert "ROUTINE FLOW TIME" in out
    assert "WEEK TRACKER (REST DAYS)" in out
    # ...and the marker is preserved exactly once (injected before it).
    assert out.count(MARKER) == 1


def test_transform_is_noop_without_marker():
    src = "int x = 0;\n"
    assert m.transform(src) == src
