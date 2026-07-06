# 1. Update the buttons under the workout instructions.
# Look for the ElevatedButton that completes the workout.
# Wait, it's inside `_buildSuggestedWorkoutCard` which doesn't exist, it's just mapped in `filtered.map`.
# Let's search for "COMPLETE WORKOUT?" and its containing ElevatedButton.
# I'll replace the single ElevatedButton with a Row of two ElevatedButtons.

old_button = """                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return _SuggestedWorkoutLogDialog("""

new_buttons = """                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return _SuggestedWorkoutLogDialog("""

old_button_end = """                                child: Text(
                                  "COMPLETE WORKOUT",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),"""

new_buttons_end = """                                  child: Text(
                                    "LOG",
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showAddToRoutineDialog(context, profile, workout);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),
                                  child: Text(
                                    "ADD TO ROUTINE",
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),"""

# 2. Add the dialog function
add_to_routine_func = """
  void _showAddToRoutineDialog(BuildContext context, UserProfileManager profile, SuggestedWorkout workout) {
    showDialog(
      context: context,
      builder: (context) {
        return _AddToRoutineDialog(profile: profile, workout: workout);
      },
    );
  }
"""

# 3. Define the dialog widget
dialog_widget = """
class _AddToRoutineDialog extends StatefulWidget {
  final UserProfileManager profile;
  final SuggestedWorkout workout;

  const _AddToRoutineDialog({
    Key? key,
    required this.profile,
    required this.workout,
  }) : super(key: key);

  @override
  State<_AddToRoutineDialog> createState() => _AddToRoutineDialogState();
}

class _AddToRoutineDialogState extends State<_AddToRoutineDialog> {
  String _newRoutineName = "";

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.profile.currentElement.primaryColor;

    return AlertDialog(
      backgroundColor: const Color(0xFF0F0F0F),
      title: Text(
        "ADD TO ROUTINE",
        style: GoogleFonts.orbitron(
          color: themeColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add '${widget.workout.name}' to a routine:",
              style: GoogleFonts.exo2(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ...widget.profile.customRoutines.map((routine) {
              return ListTile(
                title: Text(routine.name, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  final newEx = RoutineExercise(
                    workoutId: widget.workout.id,
                    sets: widget.workout.sets,
                    reps: widget.workout.reps,
                  );
                  routine.exercises.add(newEx);
                  widget.profile.saveCustomRoutine(routine);
                  Navigator.of(context).pop();
                },
                tileColor: Colors.white.withValues(alpha: 0.05),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              );
            }).toList(),
            if (widget.profile.customRoutines.isNotEmpty) const SizedBox(height: 16),
            const Text("Or create new routine:", style: TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 8),
            TextField(
              onChanged: (val) => _newRoutineName = val,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: "Routine Name (e.g., Morning Push)",
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            if (_newRoutineName.trim().isEmpty) return;
            final routine = WorkoutRoutine(
              id: UniqueKey().toString(),
              name: _newRoutineName.trim(),
              exercises: [
                RoutineExercise(
                  workoutId: widget.workout.id,
                  sets: widget.workout.sets,
                  reps: widget.workout.reps,
                ),
              ],
            );
            widget.profile.saveCustomRoutine(routine);
            Navigator.of(context).pop();
          },
          child: Text(
            "CREATE & ADD",
            style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
"""


def transform(content: str) -> str:
    content = content.replace(old_button, new_buttons)
    content = content.replace(old_button_end, new_buttons_end)
    content = content.replace(
        '  Widget _buildSuggestedWorkoutsSection(UserProfileManager profile) {',
        add_to_routine_func + '\n  Widget _buildSuggestedWorkoutsSection(UserProfileManager profile) {',
    )
    content = content + "\n" + dialog_widget
    return content


def main() -> None:
    path = "lib/views/quest_board_view.dart"
    with open(path) as f:
        content = f.read()
    content = transform(content)
    with open(path, "w") as f:
        f.write(content)


if __name__ == "__main__":
    main()
