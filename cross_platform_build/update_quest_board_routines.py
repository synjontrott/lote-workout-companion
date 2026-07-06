def transform(content: str) -> str:
    # 1. Call _buildCustomRoutinesSection before _buildSuggestedWorkoutsSection
    content = content.replace(
        '_buildSuggestedWorkoutsSection(profile),',
        '_buildCustomRoutinesSection(profile),\n                  const SizedBox(height: 16),\n                  _buildSuggestedWorkoutsSection(profile),'
    )

    # 2. Add _buildCustomRoutinesSection
    routine_ui = """  Widget _buildCustomRoutinesSection(UserProfileManager profile) {
    if (profile.customRoutines.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CUSTOM ROUTINES",
            style: GoogleFonts.orbitron(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          ...profile.customRoutines.map((routine) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        routine.name,
                        style: GoogleFonts.exo2(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                        onPressed: () {
                          profile.deleteCustomRoutine(routine.id);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...routine.exercises.map((e) {
                    final workout = SuggestedWorkout.allWorkouts.firstWhere(
                      (w) => w.id == e.workoutId,
                      orElse: () => SuggestedWorkout.allWorkouts.first,
                    );
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 4, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${e.sets} x ${e.reps} - ${workout.name}",
                              style: GoogleFonts.exo2(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Log all exercises
                        for (final e in routine.exercises) {
                          final workout = SuggestedWorkout.allWorkouts.firstWhere(
                            (w) => w.id == e.workoutId,
                            orElse: () => SuggestedWorkout.allWorkouts.first,
                          );
                          profile.logCustomWorkout(
                            name: workout.name,
                            category: workout.category,
                            sets: e.sets,
                            reps: e.reps,
                            difficulty: workout.difficulty,
                            durationMinutes: 10.0,
                          );
                        }
                        _showOutcomeDialog(
                          title: "ROUTINE CONQUERED! 💪",
                          message: "You completed '${routine.name}' and logged ${routine.exercises.length} exercises!",
                          themeColor: profile.currentElement.primaryColor,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: profile.currentElement.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        "COMPLETE ROUTINE",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

"""

    content = content.replace(
        '  Widget _buildSuggestedWorkoutsSection(UserProfileManager profile) {',
        routine_ui + '  Widget _buildSuggestedWorkoutsSection(UserProfileManager profile) {'
    )
    return content


def main() -> None:
    with open('lib/views/quest_board_view.dart', 'r') as f:
        content = f.read()
    content = transform(content)
    with open('lib/views/quest_board_view.dart', 'w') as f:
        f.write(content)


if __name__ == "__main__":
    main()
