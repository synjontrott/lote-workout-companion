import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../managers/user_profile_manager.dart';
import '../models/lote_models.dart';
import 'character_creator_view.dart';
import 'element_selection_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _startWeightController;
  late final TextEditingController _goalWeightController;
  late final TextEditingController _distanceGoalController;
  late final TextEditingController _chestController;
  late final TextEditingController _armsController;
  late final TextEditingController _waistController;
  late final TextEditingController _hipsController;
  late final TextEditingController _legsController;
  late final TextEditingController _stepsGoalController;
  late final TextEditingController _caloriesGoalController;
  late final TextEditingController _activeMinutesGoalController;
  late final TextEditingController _standHoursGoalController;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<UserProfileManager>(context, listen: false);
    _heightController = TextEditingController(text: profile.height.toString());
    _weightController = TextEditingController(text: profile.weight.toString());
    _startWeightController = TextEditingController(text: profile.startWeight.toString());
    _goalWeightController = TextEditingController(text: profile.goalWeight.toString());
    _distanceGoalController = TextEditingController(text: profile.distanceGoal.toString());
    _chestController = TextEditingController(text: profile.chest.toString());
    _armsController = TextEditingController(text: profile.arms.toString());
    _waistController = TextEditingController(text: profile.waist.toString());
    _hipsController = TextEditingController(text: profile.hips.toString());
    _legsController = TextEditingController(text: profile.legs.toString());
    _stepsGoalController = TextEditingController(text: profile.stepsGoal.toString());
    _caloriesGoalController = TextEditingController(text: profile.caloriesGoal.toString());
    _activeMinutesGoalController = TextEditingController(text: profile.activeMinutesGoal.toString());
    _standHoursGoalController = TextEditingController(text: profile.standHoursGoal.toString());
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _startWeightController.dispose();
    _goalWeightController.dispose();
    _distanceGoalController.dispose();
    _chestController.dispose();
    _armsController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _legsController.dispose();
    _stepsGoalController.dispose();
    _caloriesGoalController.dispose();
    _activeMinutesGoalController.dispose();
    _standHoursGoalController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfileManager>(context);
    final themeColor = profile.currentElement.primaryColor;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                                  label: "START WEIGHT (LBS)",
                                  controller: _startWeightController,
                                  onChanged: (val) {
                                    final d = double.tryParse(val);
                                    if (d != null) profile.startWeight = d;
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildMetricConfigField(
                                  label: "GOAL WEIGHT (LBS)",
                                  controller: _goalWeightController,
                                  onChanged: (val) {
                                    final d = double.tryParse(val);
                                    if (d != null) profile.goalWeight = d;
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
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricConfigField(
                                  label: "LEGS (INCHES)",
                                  controller: _legsController,
                                  onChanged: (val) {
                                    final d = double.tryParse(val);
                                    if (d != null) profile.legs = d;
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // DAILY TARGET GOALS Card
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
                            "DAILY TARGET GOALS",
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
                                  label: "STEPS GOAL",
                                  controller: _stepsGoalController,
                                  onChanged: (val) {
                                    final d = double.tryParse(val);
                                    if (d != null) profile.stepsGoal = d;
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildMetricConfigField(
                                  label: "CALORIE GOAL (KCAL)",
                                  controller: _caloriesGoalController,
                                  onChanged: (val) {
                                    final d = double.tryParse(val);
                                    if (d != null) profile.caloriesGoal = d;
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
                                  label: "ACTIVE TIME GOAL (MINS)",
                                  controller: _activeMinutesGoalController,
                                  onChanged: (val) {
                                    final d = double.tryParse(val);
                                    if (d != null) profile.activeMinutesGoal = d;
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildMetricConfigField(
                                  label: "STAND TIME GOAL (HOURS)",
                                  controller: _standHoursGoalController,
                                  onChanged: (val) {
                                    final d = double.tryParse(val);
                                    if (d != null) profile.standHoursGoal = d;
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
                                  label: "DAILY CARDIO GOAL (MILES)",
                                  controller: _distanceGoalController,
                                  onChanged: (val) {
                                    final d = double.tryParse(val);
                                    if (d != null) profile.distanceGoal = d;
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Spacer(),
                            ],
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
                        // Choose Element Theme Button
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
                        const SizedBox(height: 16),

                        // Cognitive Profile Selector
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "MOTIVATIONAL MINDSET PROFILE",
                              style: GoogleFonts.exo2(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.02),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Row(
                                children: [
                                  CognitiveProfile.neurotypical,
                                  CognitiveProfile.adhd,
                                  CognitiveProfile.autistic,
                                  CognitiveProfile.audhd
                                ].map((cp) {
                                  final isSelected = profile.cognitiveProfile == cp;
                                  final text = cp == CognitiveProfile.neurotypical
                                      ? "NT"
                                      : (cp == CognitiveProfile.adhd ? "ADHD" : (cp == CognitiveProfile.autistic ? "Autism" : "AuDHD"));
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          profile.cognitiveProfile = cp;
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isSelected ? themeColor : Colors.transparent,
                                          foregroundColor: isSelected ? Colors.black : Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                        child: Text(
                                          text,
                                          style: GoogleFonts.orbitron(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Notification Frequency Selector
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "NOTIFICATION FREQUENCY",
                              style: GoogleFonts.exo2(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.02),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Row(
                                children: ["Off", "Low", "Medium", "High"].map((freq) {
                                  final isSelected = profile.notificationFrequency == freq;
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          profile.notificationFrequency = freq;
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isSelected ? themeColor : Colors.transparent,
                                          foregroundColor: isSelected ? Colors.black : Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                        child: Text(
                                          freq,
                                          style: GoogleFonts.orbitron(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

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

                        // Reset All Progress Button
                        _buildAdjustButton(
                          icon: Icons.delete_forever,
                          label: "Reset All Progress (Clean Slate)",
                          color: Colors.red,
                          onTap: () {
                            profile.resetProgress();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
            suffixIcon: IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.blueAccent, size: 18),
              onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          onChanged: onChanged,
        )
      ],
    );
  }
}
