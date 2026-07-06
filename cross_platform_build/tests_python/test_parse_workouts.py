import parse_workouts


def test_import_has_no_side_effects():
    # Importing must not read files or print; the helper should be exposed.
    assert hasattr(parse_workouts, "find_bodyweight_back_workouts")


def test_finds_bodyweight_back_workout():
    content = """
    SuggestedWorkout(
      name: "Superman Holds",
      muscleGroup: MuscleGroup.back,
      equipment: "Bodyweight Only",
    ),
    """
    assert parse_workouts.find_bodyweight_back_workouts(content) == ["Superman Holds"]


def test_ignores_non_bodyweight_back_workout():
    content = """
    SuggestedWorkout(
      name: "Barbell Row",
      muscleGroup: MuscleGroup.back,
      equipment: "Barbell",
    ),
    """
    assert parse_workouts.find_bodyweight_back_workouts(content) == []
