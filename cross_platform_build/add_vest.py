import re

with open('lib/views/quest_board_view.dart', 'r') as f:
    content = f.read()

# Add Controller
content = content.replace(
    '  final TextEditingController _customWorkoutDurationController =\n      TextEditingController();',
    '  final TextEditingController _customWorkoutDurationController =\n      TextEditingController();\n  final TextEditingController _customWorkoutWeightVestController =\n      TextEditingController();'
)

# Add UI block right after Duration block
# Search for the end of the duration block:
# focusedBorder: OutlineInputBorder(
#   borderRadius: BorderRadius.circular(8),
#   borderSide: BorderSide(color: themeColor),
# ),
# ),
# ),
# ],
# const SizedBox(height: 20),

ui_to_add = """
                  const SizedBox(height: 12),
                  Text(
                    "WEIGHT VEST / BELT (LBS)",
                    style: GoogleFonts.exo2(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _customWorkoutWeightVestController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "e.g. 20 (Leave blank if none)",
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.04),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.check_circle_outline, color: Colors.blueAccent, size: 18),
                        onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: themeColor),
                      ),
                    ),
                  ),
"""

content = content.replace(
    '                  const SizedBox(height: 20),\n\n                  Row(\n                    children: [\n                      Expanded(\n                        child: OutlinedButton(',
    ui_to_add + '                  const SizedBox(height: 20),\n\n                  Row(\n                    children: [\n                      Expanded(\n                        child: OutlinedButton('
)

# Add passing the vest weight to profile.logCustomWorkout
content = content.replace(
    '                              durationMinutes: dur,\n                            );',
    '                              durationMinutes: dur,\n                              vestWeightLbs: double.tryParse(_customWorkoutWeightVestController.text) ?? 0.0,\n                            );'
)

# Update UI string calculation for xp/crystals
xp_calc = """
                            int xp = 25;
                            int crystals = 10;
                            switch (_customWorkoutDifficulty.toLowerCase()) {
                              case 'easy':
                                xp = 15;
                                crystals = 5;
                                break;
                              case 'medium':
                                xp = 25;
                                crystals = 10;
                                break;
                              case 'hard':
                                xp = 40;
                                crystals = 15;
                                break;
                              case 'legend':
                                xp = 60;
                                crystals = 25;
                                break;
                              case 'master':
                                xp = 80;
                                crystals = 35;
                                break;
                            }
                            
                            final vestWeightLbs = double.tryParse(_customWorkoutWeightVestController.text) ?? 0.0;
                            if (vestWeightLbs > 0) {
                              double multiplier = 1.0 + (vestWeightLbs / 50.0);
                              xp = (xp * multiplier).round();
                              crystals = (crystals * multiplier).round();
                            }
"""

content = re.sub(
    r'                            int xp = 25;[\s\S]*?                                break;\n                            }',
    xp_calc,
    content
)

# Clear controller
content = content.replace(
    '                            _customWorkoutDurationController.clear();',
    '                            _customWorkoutDurationController.clear();\n                            _customWorkoutWeightVestController.clear();'
)

with open('lib/views/quest_board_view.dart', 'w') as f:
    f.write(content)
