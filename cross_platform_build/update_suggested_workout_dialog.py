import re

with open('lib/views/quest_board_view.dart', 'r') as f:
    content = f.read()

# 1. Define the StatefulWidget for the dialog
dialog_class = """
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
"""

content = content + "\n" + dialog_class

# 2. Replace the showDialog call in _buildSuggestedWorkoutsSection
old_dialog = """                                  showDialog(
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
                                  );"""

new_dialog = """                                  showDialog(
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
                                  );"""

content = content.replace(old_dialog, new_dialog)

with open('lib/views/quest_board_view.dart', 'w') as f:
    f.write(content)
