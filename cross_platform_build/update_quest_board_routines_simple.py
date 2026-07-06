# 1. Inject _buildCustomRoutinesSection into quest_board_view.dart
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

# 2. Add the dialog widgets at the bottom of the file
dialog_widgets = """
class _SuggestedWorkoutLogDialog extends StatefulWidget {
  final UserProfileManager profile;
  final SuggestedWorkout workout;
  final Function(int, String, double) onLog;

  const _SuggestedWorkoutLogDialog({
    Key? key,
    required this.profile,
    required this.workout,
    required this.onLog,
  }) : super(key: key);

  @override
  State<_SuggestedWorkoutLogDialog> createState() =>
      _SuggestedWorkoutLogDialogState();
}

class _SuggestedWorkoutLogDialogState
    extends State<_SuggestedWorkoutLogDialog> {
  late TextEditingController _setsController;
  late TextEditingController _repsController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _setsController = TextEditingController(text: widget.workout.sets.toString());
    _repsController = TextEditingController(text: widget.workout.reps.replaceAll(RegExp(r'[^0-9]'), ''));

    // Auto-populate weight with bodyweight if it's a bodyweight exercise, otherwise 0 or empty.
    final bool isBodyweight = widget.workout.equipment.toLowerCase().contains("bodyweight");
    _weightController = TextEditingController(
      text: isBodyweight ? widget.profile.weight.toString() : "",
    );
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0F0F0F),
      title: Text(
        "LOG WORKOUT",
        style: GoogleFonts.orbitron(
          color: widget.profile.currentElement.primaryColor,
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
              widget.workout.name,
              style: GoogleFonts.exo2(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildField("Sets", _setsController),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildField("Reps/Time", _repsController),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildField(
              "Weight (lbs) [From HealthKit]",
              _weightController,
              hint: "e.g. 150",
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
            final sets = int.tryParse(_setsController.text) ?? widget.workout.sets;
            String reps = _repsController.text.isNotEmpty ? _repsController.text : widget.workout.reps;
            final weightStr = _weightController.text;
            if (weightStr.isNotEmpty && double.tryParse(weightStr) != null) {
              reps += " @ ${weightStr}lbs";
            }
            widget.onLog(sets, reps, 15.0);
          },
          child: Text(
            "YES, LOG IT",
            style: TextStyle(
              color: widget.profile.currentElement.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.blueAccent, size: 16),
              onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      ],
    );
  }
}

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


# 3. Replace the EXACT string in _buildSuggestedWorkoutsSection
old_button_block = """                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: const Color(
                                          0xFF0F0F0F,
                                        ),
                                        title: Text(
                                          "COMPLETE WORKOUT?",
                                          style: GoogleFonts.orbitron(
                                            color: profile
                                                .currentElement
                                                .primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Text(
                                          "Are you sure you have completed '${workout.name}'? You will earn XP and Crystals based on difficulty.",
                                          style: GoogleFonts.exo2(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text(
                                              "CANCEL",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              profile.logCustomWorkout(
                                                name: workout.name,
                                                category: workout.category,
                                                sets: workout.sets,
                                                reps: workout.reps,
                                                difficulty: workout.difficulty,
                                                durationMinutes: 15.0,
                                              );
                                              _showOutcomeDialog(
                                                title: "WORKOUT CONQUERED! 💪",
                                                message:
                                                    "Workout complete! You conquered ${workout.name} and gained XP, Crystals, and forged your character attributes.",
                                                themeColor: profile
                                                    .currentElement
                                                    .primaryColor,
                                              );
                                            },
                                            child: Text(
                                              "YES, LOG IT",
                                              style: TextStyle(
                                                color: profile
                                                    .currentElement
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      profile.currentElement.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                                child: Text(
                                  "COMPLETE WORKOUT",
                                  style: GoogleFonts.orbitron(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),"""

new_buttons_block = """                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return _SuggestedWorkoutLogDialog(
                                            profile: profile,
                                            workout: workout,
                                            onLog: (sets, reps, durationMinutes) {
                                              Navigator.of(context).pop();
                                              profile.logCustomWorkout(
                                                name: workout.name,
                                                category: workout.category,
                                                sets: sets,
                                                reps: reps,
                                                difficulty: workout.difficulty,
                                                durationMinutes: durationMinutes,
                                              );
                                              _showOutcomeDialog(
                                                title: "WORKOUT CONQUERED! 💪",
                                                message:
                                                    "Workout complete! You conquered ${workout.name} and gained XP, Crystals, and forged your character attributes.",
                                                themeColor: profile.currentElement.primaryColor,
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: profile.currentElement.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                    ),
                                    child: Text(
                                      "LOG",
                                      style: GoogleFonts.orbitron(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => _AddToRoutineDialog(profile: profile, workout: workout),
                                      );
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
                                      style: GoogleFonts.orbitron(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),"""


def transform(content: str) -> str:
    content = content.replace(
        '  Widget _buildSuggestedWorkoutsSection(UserProfileManager profile) {',
        routine_ui + '\n  Widget _buildSuggestedWorkoutsSection(UserProfileManager profile) {',
    )
    content = content.replace(
        '_buildSuggestedWorkoutsSection(profile),',
        '_buildCustomRoutinesSection(profile),\n                  const SizedBox(height: 16),\n                  _buildSuggestedWorkoutsSection(profile),',
    )
    content = content + "\n" + dialog_widgets
    content = content.replace(old_button_block, new_buttons_block)
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
