import update_generate_quests as mod  # import must have no side effects

P1 = "  double waterGoal = 3.0,\n}) {"
P2 = "      );\n    }\n  } else if (cadence == QuestCadence.monthly) {"
BEFORE = P1 + "\n" + P2 + "\n"


def test_signature_and_goal_injection():
    out = mod.transform(BEFORE)
    # step 1: new activeGoal parameter appended to the signature
    assert "AdvancedWorkoutGoal activeGoal = AdvancedWorkoutGoal.none," in out
    # step 2: goal-training quest logic injected before the monthly branch
    assert "if (activeGoal != AdvancedWorkoutGoal.none && quests.isNotEmpty) {" in out


def test_idempotent():
    once = mod.transform(BEFORE)
    assert mod.transform(once) == once
