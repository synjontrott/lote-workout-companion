import update_nutrition as mod  # import must have no side effects

P1 = "void _showMealLogDialog(BuildContext context, UserProfileManager profile) {"
P2 = "              // Action button to log food"
P3 = "                      ],\n                    ),\n                  ),\n                ),\n              actions: ["
P4 = "                          profile.logDetailedMeal("
BEFORE = P1 + "\n" + P2 + "\n" + P3 + "\n" + P4 + "\n"


def test_meal_template_features_injected():
    out = mod.transform(BEFORE)
    assert "bool saveAsTemplate = false;" in out          # step 1
    assert "QUICK LOG MEALS" in out                        # step 2
    assert "Save as Quick Meal template" in out            # step 3
    assert "profile.saveMealTemplate(" in out              # step 4


def test_noop_without_patterns():
    src = "// unrelated dart\n"
    assert mod.transform(src) == src
