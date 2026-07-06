import update_quest_board_routines as mod  # import must have no side effects

P1 = "_buildSuggestedWorkoutsSection(profile),"
P2 = "  Widget _buildSuggestedWorkoutsSection(UserProfileManager profile) {"
BEFORE = P1 + "\n" + P2 + "\n"


def test_custom_routines_section_injected():
    out = mod.transform(BEFORE)
    # step 1: the custom-routines section is called before suggested workouts
    assert "_buildCustomRoutinesSection(profile)," in out
    # step 2: the builder method + its heading are defined
    assert "Widget _buildCustomRoutinesSection(UserProfileManager profile) {" in out
    assert "CUSTOM ROUTINES" in out


def test_noop_without_patterns():
    src = "// unrelated\n"
    assert mod.transform(src) == src
