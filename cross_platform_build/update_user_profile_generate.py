import re


def transform(content: str) -> str:
    # find all occurrences of 'QuestCadence.daily,' etc inside generateQuests
    content = re.sub(
        r'(QuestCadence\.(?:daily|monthly|yearly),\s*)(prs: _personalRecords,\s*waterGoal: _waterIntakeGoal,\s*)?\);',
        r'\1\2activeGoal: _activeWorkoutGoal,\n          );',
        content
    )

    # the first one in the above regex might have trailing commas but the regex checks for `);`
    # Wait, let's see how it's formatted:
    # _dailyQuests = generateQuests(
    #   elementName,
    #   _selectedFocuses,
    #   QuestCadence.daily,
    # );
    # OR
    # _dailyQuests = generateQuests(
    #   elementName,
    #   _selectedFocuses,
    #   QuestCadence.daily,
    #   prs: _personalRecords,
    #   waterGoal: _waterIntakeGoal,
    # );

    # we can just match `generateQuests(...)` using a simpler replacement:
    content = content.replace(
        'QuestCadence.daily,\n          );',
        'QuestCadence.daily,\n            activeGoal: _activeWorkoutGoal,\n          );'
    )
    content = content.replace(
        'QuestCadence.monthly,\n          );',
        'QuestCadence.monthly,\n            activeGoal: _activeWorkoutGoal,\n          );'
    )
    content = content.replace(
        'QuestCadence.yearly,\n          );',
        'QuestCadence.yearly,\n            activeGoal: _activeWorkoutGoal,\n          );'
    )

    content = content.replace(
        'waterGoal: _waterIntakeGoal,\n        );',
        'waterGoal: _waterIntakeGoal,\n          activeGoal: _activeWorkoutGoal,\n        );'
    )
    content = content.replace(
        'waterGoal: _waterIntakeGoal,\n    );',
        'waterGoal: _waterIntakeGoal,\n      activeGoal: _activeWorkoutGoal,\n    );'
    )
    return content


def main() -> None:
    with open('lib/managers/user_profile_manager.dart', 'r') as f:
        content = f.read()
    content = transform(content)
    with open('lib/managers/user_profile_manager.dart', 'w') as f:
        f.write(content)


if __name__ == "__main__":
    main()
