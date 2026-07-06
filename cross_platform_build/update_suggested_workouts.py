import re

with open('lib/views/quest_board_view.dart', 'r') as f:
    content = f.read()

injection = """          }).toList();

    if (profile.activeWorkoutGoal != AdvancedWorkoutGoal.none && _workoutSearchQuery.isEmpty) {
      final progression = WorkoutProgression.all.firstWhere(
        (p) => p.goal == profile.activeWorkoutGoal,
        orElse: () => WorkoutProgression.all.first,
      );
      if (progression.goal == profile.activeWorkoutGoal) {
        // Prepend prerequisite workouts
        final prerequisiteWorkouts = SuggestedWorkout.allWorkouts.where(
          (w) => progression.prerequisiteWorkoutIds.contains(w.id) && !isWorkoutCompletedToday(w)
        ).toList();
        
        // Remove them from filtered if they are already there so we don't duplicate
        filtered.removeWhere((w) => progression.prerequisiteWorkoutIds.contains(w.id));
        
        // Add them to the top
        filtered.insertAll(0, prerequisiteWorkouts);
      }
    }
"""

content = content.replace(
    '          }).toList();',
    injection,
    1 # only the first one which is inside _buildSuggestedWorkoutsSection
)

with open('lib/views/quest_board_view.dart', 'w') as f:
    f.write(content)
