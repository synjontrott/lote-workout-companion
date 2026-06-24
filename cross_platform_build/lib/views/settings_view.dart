import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../managers/user_profile_manager.dart';
import '../managers/health_manager.dart';
import 'character_creator_view.dart';
import 'element_selection_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // Mock Simulator inputs
  final TextEditingController _stepsController = TextEditingController(text: "1000");
  final TextEditingController _caloriesController = TextEditingController(text: "150");
  final TextEditingController _minutesController = TextEditingController(text: "15");

  @override
  void dispose() {
    _stepsController.dispose();
    _caloriesController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  void _runActivitySimulation(UserProfileManager profile, HealthManager health) {
    final steps = double.tryParse(_stepsController.text) ?? 1000.0;
    final calories = double.tryParse(_caloriesController.text) ?? 150.0;
    final minutes = double.tryParse(_minutesController.text) ?? 15.0;

    health.simulateActivity(steps: steps, calories: calories, minutes: minutes);
    profile.addXP(100);
    profile.earnCrystals(30);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0C0C0C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: profile.currentElement.primaryColor.withOpacity(0.4)),
          ),
          title: Text(
            "Oracle Sync Complete",
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          content: Text(
            "Successfully injected physical energy: ${steps.toInt()} steps, ${calories.toInt()} kcal, ${minutes.toInt()} mins of exercise time. Recalculated level gains (+100 XP, +30 Crystals).",
            style: GoogleFonts.exo2(color: Colors.grey, fontSize: 12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Acknowledge",
                style: TextStyle(color: profile.currentElement.primaryColor),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfileManager>(context);
    final health = Provider.of<HealthManager>(context);
    final themeColor = profile.currentElement.primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "ORACLE SYSTEMS HUD",
                          style: GoogleFonts.orbitron(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Configure interface parameters and objectives",
                          style: GoogleFonts.exo2(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // IDENTITY CONFIGURATION Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: themeColor.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "IDENTITY CONFIGURATION",
                            style: GoogleFonts.orbitron(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Warrior Name Input
                          _buildConfigField(
                            label: "WARRIOR NAME",
                            hint: "Enter Name",
                            initialValue: profile.characterName,
                            onChanged: (val) => profile.characterName = val,
                          ),
                          const SizedBox(height: 12),

                          // Short Term Goal Input
                          _buildConfigField(
                            label: "SHORT TERM TRAINING GOAL",
                            hint: "e.g., 5,000 steps daily",
                            initialValue: profile.shortTermGoal,
                            onChanged: (val) => profile.shortTermGoal = val,
                          ),
                          const SizedBox(height: 12),

                          // Long Term Goal Input
                          _buildConfigField(
                            label: "LONG TERM TRAINING GOAL",
                            hint: "e.g., Run 5k in under 25 mins",
                            initialValue: profile.longTermGoal,
                            onChanged: (val) => profile.longTermGoal = val,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // SOVEREIGN ADJUSTMENTS Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "SOVEREIGN ADJUSTMENTS",
                      style: GoogleFonts.orbitron(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Tune Element Channels Button
                        _buildAdjustButton(
                          icon: Icons.local_fire_department,
                          label: "Tune Element Channels",
                          color: themeColor,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ElementSelectionView(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),

                        // Re-Forge Character Sprite Button
                        _buildAdjustButton(
                          icon: Icons.portrait,
                          label: "Re-Forge Character Sprite",
                          color: themeColor,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CharacterCreatorView(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),

                        // Recalibrate Psychological Profile Button
                        _buildAdjustButton(
                          icon: Icons.psychology,
                          label: "Recalibrate Psychological Profile",
                          color: Colors.orange,
                          onTap: () {
                            profile.hasCompletedInitialQuiz = false;
                            profile.cognitiveProfile = null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Simulated Energy Core Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SIMULATED ENERGY CORE",
                            style: GoogleFonts.orbitron(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Inject mock workouts/activity loops to test character XP level gains:",
                            style: GoogleFonts.exo2(fontSize: 11, color: Colors.grey),
                          ),
                          const SizedBox(height: 15),

                          // Textfields
                          Row(
                            children: [
                              Expanded(
                                child: _buildMockInputField(
                                  label: "Steps",
                                  controller: _stepsController,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildMockInputField(
                                  label: "Calories",
                                  controller: _caloriesController,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildMockInputField(
                                  label: "Minutes",
                                  controller: _minutesController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Trigger Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _runActivitySimulation(profile, health),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "INJECT PHYSICAL ACTIVITY",
                                style: GoogleFonts.orbitron(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildConfigField({
    required String label,
    required String hint,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.exo2(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: initialValue,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
        )
      ],
    );
  }

  Widget _buildMockInputField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.exo2(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildAdjustButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.exo2(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}
