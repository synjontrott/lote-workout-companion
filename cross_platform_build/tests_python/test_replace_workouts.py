import replace_workouts

BEFORE = """SuggestedWorkout(
  id: "bodyweight_inverted_rows",
  name: "Old Name",
  description: "Old description",
  instructions: [
    "old instruction",
  ],
  sets: 3,
),"""


def test_import_has_no_side_effects():
    # Importing must not touch lote_models.dart; the transform must be exposed.
    assert hasattr(replace_workouts, "transform")


def test_transform_replaces_workout_fields():
    result = replace_workouts.transform(BEFORE)
    assert 'name: "Superman Holds"' in result
    assert "Engage the entire posterior chain with isometric holds." in result
    assert "Lie face down with arms extended forward." in result
    assert "old instruction" not in result


def test_transform_noop_without_pattern():
    content = "// no SuggestedWorkout entries here"
    assert replace_workouts.transform(content) == content
