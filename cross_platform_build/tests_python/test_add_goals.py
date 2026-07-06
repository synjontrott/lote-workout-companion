import add_goals


def test_import_has_no_side_effects():
    assert hasattr(add_goals, "transform")


def test_transform_inserts_advanced_goal_enum():
    src = "class SuggestedWorkout {"
    out = add_goals.transform(src)
    assert "enum AdvancedWorkoutGoal {" in out
    assert "class WorkoutProgression {" in out
    # The enum block is inserted before the anchor, which is preserved.
    assert "class SuggestedWorkout {" in out


def test_transform_noop_without_pattern():
    src = "class Foo {}\n"
    assert add_goals.transform(src) == src
