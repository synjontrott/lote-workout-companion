def transform(content: str) -> str:
    # 1. Update signature
    content = content.replace(
        '  double waterGoal = 3.0,\n}) {',
        '  double waterGoal = 3.0,\n  AdvancedWorkoutGoal activeGoal = AdvancedWorkoutGoal.none,\n}) {'
    )

    # 2. Inject goal logic
    goal_injection = """      );
    }
\x20\x20\x20\x20
    if (activeGoal != AdvancedWorkoutGoal.none && quests.isNotEmpty) {
      final progression = WorkoutProgression.all.firstWhere(
        (p) => p.goal == activeGoal,
        orElse: () => WorkoutProgression.all.first,
      );
      if (progression.goal == activeGoal) {
        final workoutId = progression.prerequisiteWorkoutIds.first;\x20
        final workout = SuggestedWorkout.allWorkouts.firstWhere((w) => w.id == workoutId, orElse: () => SuggestedWorkout.allWorkouts.first);
\x20\x20\x20\x20\x20\x20\x20\x20
        quests[0] = LotEQuest(
          id: UniqueKey().toString(),
          title: "Goal Training: ${workout.name}",
          questDescription: "Path to ${progression.title}: Complete ${workout.name} (${workout.sets} sets x ${workout.reps}).",
          workoutType: WorkoutCategory.strength,
          difficultyRoll: 15,
          rewardXP: 100,
          rewardCrystals: 50,
          statReward: StatType.strength,
          statValue: 2,
          cadence: QuestCadence.daily,
          progressCount: 0,
          targetCount: workout.sets,
          requiredMinutes: 0.0,
        );
      }
    }
  } else if (cadence == QuestCadence.monthly) {"""

    content = content.replace('      );\n    }\n  } else if (cadence == QuestCadence.monthly) {', goal_injection)
    return content


def main() -> None:
    with open('lib/models/lote_models.dart', 'r') as f:
        content = f.read()
    content = transform(content)
    with open('lib/models/lote_models.dart', 'w') as f:
        f.write(content)


if __name__ == "__main__":
    main()
