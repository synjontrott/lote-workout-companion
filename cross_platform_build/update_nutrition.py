def transform(content: str) -> str:
    # 1. Add `bool saveAsTemplate = false;` to `_showMealLogDialog`
    content = content.replace(
        'void _showMealLogDialog(BuildContext context, UserProfileManager profile) {',
        'void _showMealLogDialog(BuildContext context, UserProfileManager profile) {\n    bool saveAsTemplate = false;'
    )

    # 2. Add quick log chip wrap before LOG HEALTHY RATIONS
    quick_log_ui = """
              if (profile.savedMeals.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "QUICK LOG MEALS",
                        style: GoogleFonts.orbitron(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: profile.savedMeals.map((meal) {
                          return ActionChip(
                            label: Text(meal.name, style: const TextStyle(fontSize: 11, color: Colors.white)),
                            backgroundColor: Colors.white.withValues(alpha: 0.05),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                            onPressed: () {
                              profile.logDetailedMeal(
                                name: meal.name,
                                calories: meal.calories,
                                protein: meal.protein,
                                carbs: meal.carbs,
                                fats: meal.fats,
                                sugar: meal.sugar,
                              );
                              setState(() {});
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
"""
    content = content.replace(
        '              // Action button to log food',
        quick_log_ui + '              // Action button to log food'
    )

    # 3. Add checkbox inside form before actions
    # We replace the end of the `Column` inside `SingleChildScrollView` -> `Form` -> `Column`
    # Looking at the code:
    #   1012                      ],
    #   1013                    ),
    #   1014                  ),
    #   1015                ),
    #   1016                actions: [
    # wait, my `checkbox_ui` needs to replace:
    #   1012                      ],
    #   1013                    ),
    #   1014                  ),
    #   1015                ),
    target_end_form = """                      ],
                    ),
                  ),
                ),
              actions: ["""
    replacement_end_form = """                      ],
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      title: const Text("Save as Quick Meal template", style: TextStyle(color: Colors.white, fontSize: 11)),
                      value: saveAsTemplate,
                      activeColor: profile.currentElement.primaryColor,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => saveAsTemplate = val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: ["""
    content = content.replace(target_end_form, replacement_end_form)

    # 4. Add save logic in the dialog submit
    submit_logic = """
                          if (saveAsTemplate) {
                            profile.saveMealTemplate(
                              MealEntry(
                                id: UniqueKey().toString(),
                                name: _mealName.isEmpty ? "Healthy Rations" : _mealName,
                                calories: cal,
                                protein: prot,
                                carbs: carb,
                                fats: fat,
                                sugar: sug,
                                date: DateTime.now(),
                              )
                            );
                          }
\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
                          profile.logDetailedMeal("""

    content = content.replace(
        '                          profile.logDetailedMeal(',
        submit_logic
    )
    return content


def main() -> None:
    with open('lib/views/nutrition_view.dart', 'r') as f:
        content = f.read()
    content = transform(content)
    with open('lib/views/nutrition_view.dart', 'w') as f:
        f.write(content)


if __name__ == "__main__":
    main()
