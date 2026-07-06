import add_goals_ui


def test_import_has_no_side_effects():
    assert hasattr(add_goals_ui, "transform")


def test_transform_inserts_workout_goal_dropdown():
    src = (
        "              const SizedBox(height: 20),\n"
        "              Text(\n"
        '                "TRAINING FOCUSES",\n'
    )
    out = add_goals_ui.transform(src)
    assert '"ADVANCED WORKOUT GOAL"' in out
    assert "DropdownButton<AdvancedWorkoutGoal>" in out
    # The block is inserted before the anchor, which is preserved.
    assert '"TRAINING FOCUSES",' in out


def test_transform_noop_without_pattern():
    src = "class Foo {}\n"
    assert add_goals_ui.transform(src) == src
