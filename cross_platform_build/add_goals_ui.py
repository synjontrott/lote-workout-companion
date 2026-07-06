def transform(content: str) -> str:
    ui_to_add = """
              const SizedBox(height: 20),
              Text(
                "ADVANCED WORKOUT GOAL",
                style: GoogleFonts.orbitron(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AdvancedWorkoutGoal>(
                    value: profile.activeWorkoutGoal,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1A1A1A),
                    style: GoogleFonts.exo2(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    items: AdvancedWorkoutGoal.values.map((goal) {
                      String label = goal.name.toUpperCase();
                      if (goal == AdvancedWorkoutGoal.none) label = "NO SPECIFIC GOAL";
                      if (goal == AdvancedWorkoutGoal.dragonFlag) label = "DRAGON FLAG";
                      if (goal == AdvancedWorkoutGoal.frontLever) label = "FRONT LEVER";
                      if (goal == AdvancedWorkoutGoal.pistolSquat) label = "PISTOL SQUAT";
                      if (goal == AdvancedWorkoutGoal.muscleUp) label = "MUSCLE UP";

                      return DropdownMenuItem(
                        value: goal,
                        child: Text(label),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        profile.activeWorkoutGoal = val;
                      }
                    },
                  ),
                ),
              ),
"""

    content = content.replace(
        '              const SizedBox(height: 20),\n              Text(\n                \"TRAINING FOCUSES\",',
        ui_to_add + '              const SizedBox(height: 20),\n              Text(\n                \"TRAINING FOCUSES\",',
        1
    )

    return content


def main() -> None:
    path = 'lib/views/settings_view.dart'
    with open(path, 'r') as f:
        content = f.read()
    content = transform(content)
    with open(path, 'w') as f:
        f.write(content)


if __name__ == "__main__":
    main()
