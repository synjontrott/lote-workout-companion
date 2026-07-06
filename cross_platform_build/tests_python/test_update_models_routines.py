import update_models_routines as mod  # import must have no side effects


def test_injects_routine_models():
    out = mod.transform("class SuggestedWorkout {\n}\n")
    assert "class RoutineExercise {" in out
    assert "class WorkoutRoutine {" in out
    # the anchor class is preserved
    assert "class SuggestedWorkout {" in out


def test_noop_without_marker():
    src = "// no anchor class here\n"
    assert mod.transform(src) == src
