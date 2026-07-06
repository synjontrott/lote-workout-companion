import update_models_scheduling as mod  # import must have no side effects


def test_appends_schedule_class():
    out = mod.transform("// dart source\n")
    assert "class WorkoutSchedule {" in out


def test_idempotent_when_present():
    once = mod.transform("// dart source\n")
    assert mod.transform(once) == once


def test_noop_when_already_present():
    src = "class WorkoutSchedule already exists\n"
    assert mod.transform(src) == src
