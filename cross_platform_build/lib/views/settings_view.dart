import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../managers/user_profile_manager.dart';
import '../managers/health_manager.dart';
import '../models/lote_models.dart';
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

  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _chestController;
  late final TextEditingController _armsController;
  late final TextEditingController _waistController;
  late final TextEditingController _hipsController;
  late final TextEditingController _legsController;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<UserProfileManager>(context, listen: false);
    _heightController = TextEditingController(text: profile.height.toString());
    _weightController = TextEditingController(text: profile.weight.toString());
    _chestController = TextEditingController(text: profile.chest.toString());
    _armsController = TextEditingController(text: profile.arms.toString());
    _waistController = TextEditingController(text: profile.waist.toString());
    _hipsController = TextEditingController(text: profile.hips.toString());
    _legsController = TextEditingController(text: profile.legs.toString());
  }

  @override
  void dispose() {
    _stepsController.dispose();
    _caloriesController.dispose();
    _minutesController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _chestController.dispose();
    _armsController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _legsController.dispose();
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

                          // Home Planet Input
                          _buildConfigField(
                            label: "HOME PLANET",
                            hint: "Enter Home Planet",
                            initialValue: profile.homePlanet,
                            onChanged: (val) => profile.homePlanet = val,
                          ),
                          const SizedBox(height: 12),

                          // Calisthenics Goal Input
                          _buildConfigField(
                            label: "CALISTHENICS GOAL",
                            hint: "e.g., 10 pull-ups, handstands",
                            initialValue: profile.calisthenicsGoal,
                            onChanged: (val) => profile.calisthenicsGoal = val,
                          ),
                          const SizedBox(height: 12),

                          // Lifting Goal Input
                          _buildConfigField(
                            label: "LIFTING GOAL",
                            hint: "e.g., Deadlift 300 lbs",
                            initialValue: profile.liftingGoal,
                            onChanged: (val) => profile.liftingGoal = val,
                          ),
                          const SizedBox(height: 12),

                          // Custom Goal Input
                          _buildConfigField(
                            label: "CUSTOM GOAL",
                            hint: "e.g., Run 3 miles, stretch daily",
                            initialValue: profile.customGoal,
                            onChanged: (val) => profile.customGoal = val,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // TRAINING GOALS & FOCUSES Card
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
                            "TRAINING GOALS & FOCUSES",
                            style: GoogleFonts.orbitron(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Column(
                            children: TrainingFocus.values.map((focus) {
                              final isSelected = profile.selectedFocuses.contains(focus);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: InkWell(
                                  onTap: () {
                                    final newList = List<TrainingFocus>.from(profile.selectedFocuses);
                                    if (isSelected) {
                                      newList.remove(focus);
                                    } else {
                                      newList.add(focus);
                                    }
                                    profile.selectedFocuses = newList;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            focus.displayName,
                                            style: GoogleFonts.exo2(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                          color: isSelected ? themeColor : Colors.grey,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // BODY METRICS Card
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
                            "BODY METRICS TRACKING",
                            style: GoogleFonts.orbitron(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricConfigField(
                                  label: "HEIGHT (INCHES)",
                                  controller: _heightController,
                                  onChanged: (val) {
                                    final d = double.tryParse(val);
                                    if (d != null) profile.height = d;
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildMetricConfigField(
                                  label: "WEIGHT (LBS)",
                                  controller: _weightController,
                                  onChanged: (val) {
                                    final d = double.tryParse(val);
                                    if (d != null) profile.weight = d;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricConfigField(
                                  label: "CHEST (INCHES)",
                                  controller: _chestController,
                                  onChanged: (val) {
                                    final d = double.tryParse(val);
                                    if (d != null) profile.chest = d;
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildMetricConfigField(
                                  label: "ARMS (INCHES)",
                                  controller: _armsController,
                                  onChanged: (val) {
                                    final d = double.tryParse(val);
                                    if (d != null) profile.arms = d;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricConfigField(
                                  label: "WAIST (INCHES)",
                                  controller: _waistController,
                                  onChanged: (val) {
                                    final d = double.tryParse(val);
                                    if (d != null) profile.waist = d;
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildMetricConfigField(
                                  label: "HIPS (INCHES)",
                                  controller: _hipsController,
                                  onChanged: (val) {
                                    final d = double.tryParse(val);
                                    if (d != null) profile.hips = d;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildMetricConfigField(
                            label: "LEGS (INCHES)",
                            controller: _legsController,
                            onChanged: (val) {
                              final d = double.tryParse(val);
                              if (d != null) profile.legs = d;
                            },
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
                          label: "Choose Element Theme",
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

  Widget _buildMetricConfigField({
    required String label,
    required TextEditingController controller,
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
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
          onChanged: onChanged,
        )
      ],
    );
  }
}
