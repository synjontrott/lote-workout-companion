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

  late final TextEditingController _targetCaloriesController;
  late final TextEditingController _targetProteinController;
  late final TextEditingController _targetCarbsController;
  late final TextEditingController _targetFatsController;
  late final TextEditingController _targetSugarController;

  late final TextEditingController _prPullupsController;
  late final TextEditingController _prPushupsController;
  late final TextEditingController _prSquatsController;
  late final TextEditingController _prDipsController;
  late final TextEditingController _prRunController;
  late final TextEditingController _prHandstandController;
  late final TextEditingController _prBenchPressController;
  late final TextEditingController _prDeadliftController;
  late final TextEditingController _prBarbellSquatController;
  late final TextEditingController _prOverheadPressController;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<UserProfileManager>(context, listen: false);
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _startWeightController = TextEditingController();
    _goalWeightController = TextEditingController();
    _chestController = TextEditingController();
    _armsController = TextEditingController();
    _waistController = TextEditingController();
    _hipsController = TextEditingController();
    _legsController = TextEditingController();
    _distanceGoalController = TextEditingController();

    _updateControllerTexts(profile);

    _stepsGoalController = TextEditingController(
      text: profile.stepsGoal.toString(),
    );
    _caloriesGoalController = TextEditingController(
      text: profile.caloriesGoal.toString(),
    );
    _activeMinutesGoalController = TextEditingController(
      text: profile.activeMinutesGoal.toString(),
    );
    _standHoursGoalController = TextEditingController(
      text: profile.standHoursGoal.toString(),
    );

    _targetCaloriesController = TextEditingController(
      text: profile.targetCalories.toStringAsFixed(0),
    );
    _targetProteinController = TextEditingController(
      text: profile.targetProtein.toStringAsFixed(0),
    );
    _targetCarbsController = TextEditingController(
      text: profile.targetCarbs.toStringAsFixed(0),
    );
    _targetFatsController = TextEditingController(
      text: profile.targetFats.toStringAsFixed(0),
    );
    _targetSugarController = TextEditingController(
      text: profile.targetSugar.toStringAsFixed(0),
    );

    _prPullupsController = TextEditingController();
    _prPushupsController = TextEditingController();
    _prSquatsController = TextEditingController();
    _prDipsController = TextEditingController();
    _prRunController = TextEditingController();
    _prHandstandController = TextEditingController();
    _prBenchPressController = TextEditingController();
    _prDeadliftController = TextEditingController();
    _prBarbellSquatController = TextEditingController();
    _prOverheadPressController = TextEditingController();

    _updatePRControllerTexts(profile);
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

    _targetCaloriesController.dispose();
    _targetProteinController.dispose();
    _targetCarbsController.dispose();
    _targetFatsController.dispose();
    _targetSugarController.dispose();

    _prPullupsController.dispose();
    _prPushupsController.dispose();
    _prSquatsController.dispose();
    _prDipsController.dispose();
    _prRunController.dispose();
    _prHandstandController.dispose();
    _prBenchPressController.dispose();
    _prDeadliftController.dispose();
    _prBarbellSquatController.dispose();
    _prOverheadPressController.dispose();
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
                          color: Colors.white.withValues(alpha: 0.02),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: themeColor.withValues(alpha: 0.15),
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
                            _buildConfigField(
                              label: "AGE",
                              hint: "Enter Age",
                              initialValue: profile.age.toString(),
                              onChanged: (val) {
                                final a = int.tryParse(val);
                                if (a != null) profile.age = a;
                              },
                            ),
                            const SizedBox(height: 12),

                            // Home Planet Input
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "HOME PLANET",
                                  style: GoogleFonts.exo2(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: const Color(0xFF0F0F0F),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    initialValue:
                                        [
                                          "Ninjonia",
                                          "Techno",
                                          "Warrion",
                                          "Battacaria",
                                        ].contains(profile.homePlanet)
                                        ? profile.homePlanet
                                        : "Ninjonia",
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    items:
                                        [
                                              "Ninjonia",
                                              "Techno",
                                              "Warrion",
                                              "Battacaria",
                                            ]
                                            .map(
                                              (p) => DropdownMenuItem(
                                                value: p,
                                                child: Text(p),
                                              ),
                                            )
                                            .toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        profile.homePlanet = val;
                                      }
                                    },
                                  ),
                                ),
                              ],
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
                          color: Colors.white.withValues(alpha: 0.02),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: themeColor.withValues(alpha: 0.15),
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
                                final isSelected = profile.selectedFocuses
                                    .contains(focus);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      final newList = List<TrainingFocus>.from(
                                        profile.selectedFocuses,
                                      );
                                      if (isSelected) {
                                        newList.remove(focus);
                                      } else {
                                        newList.add(focus);
                                      }
                                      profile.selectedFocuses = newList;
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
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
                                            isSelected
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            color: isSelected
                                                ? themeColor
                                                : Colors.grey,
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
                          color: Colors.white.withValues(alpha: 0.02),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: themeColor.withValues(alpha: 0.15),
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
                                    label: profile.useImperialUnits
                                        ? "HEIGHT (IN)"
                                        : "HEIGHT (CM)",
                                    controller: _heightController,
                                    onChanged: (val) => _saveDoubleField(
                                      val,
                                      false,
                                      (v) => profile.height = v,
                                      profile,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: profile.useImperialUnits
                                        ? "WEIGHT (LBS)"
                                        : "WEIGHT (KG)",
                                    controller: _weightController,
                                    onChanged: (val) => _saveDoubleField(
                                      val,
                                      true,
                                      (v) => profile.weight = v,
                                      profile,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: profile.useImperialUnits
                                        ? "START WEIGHT (LBS)"
                                        : "START WEIGHT (KG)",
                                    controller: _startWeightController,
                                    onChanged: (val) => _saveDoubleField(
                                      val,
                                      true,
                                      (v) => profile.startWeight = v,
                                      profile,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: profile.useImperialUnits
                                        ? "GOAL WEIGHT (LBS)"
                                        : "GOAL WEIGHT (KG)",
                                    controller: _goalWeightController,
                                    onChanged: (val) => _saveDoubleField(
                                      val,
                                      true,
                                      (v) => profile.goalWeight = v,
                                      profile,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: profile.useImperialUnits
                                        ? "CHEST (IN)"
                                        : "CHEST (CM)",
                                    controller: _chestController,
                                    onChanged: (val) => _saveDoubleField(
                                      val,
                                      false,
                                      (v) => profile.chest = v,
                                      profile,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: profile.useImperialUnits
                                        ? "ARMS (IN)"
                                        : "ARMS (CM)",
                                    controller: _armsController,
                                    onChanged: (val) => _saveDoubleField(
                                      val,
                                      false,
                                      (v) => profile.arms = v,
                                      profile,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: profile.useImperialUnits
                                        ? "WAIST (IN)"
                                        : "WAIST (CM)",
                                    controller: _waistController,
                                    onChanged: (val) => _saveDoubleField(
                                      val,
                                      false,
                                      (v) => profile.waist = v,
                                      profile,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: profile.useImperialUnits
                                        ? "HIPS (IN)"
                                        : "HIPS (CM)",
                                    controller: _hipsController,
                                    onChanged: (val) => _saveDoubleField(
                                      val,
                                      false,
                                      (v) => profile.hips = v,
                                      profile,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: profile.useImperialUnits
                                        ? "LEGS (IN)"
                                        : "LEGS (CM)",
                                    controller: _legsController,
                                    onChanged: (val) => _saveDoubleField(
                                      val,
                                      false,
                                      (v) => profile.legs = v,
                                      profile,
                                    ),
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
                          color: Colors.white.withValues(alpha: 0.02),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: themeColor.withValues(alpha: 0.15),
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
                                      if (d != null)
                                        profile.activeMinutesGoal = d;
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
                                    label: profile.useImperialUnits
                                        ? "DAILY CARDIO GOAL (MILES)"
                                        : "DAILY CARDIO GOAL (KM)",
                                    controller: _distanceGoalController,
                                    onChanged: (val) {
                                      final d = double.tryParse(val);
                                      if (d != null) {
                                        double finalVal = d;
                                        if (!profile.useImperialUnits) {
                                          finalVal = d / 1.609344;
                                        }
                                        profile.distanceGoal = finalVal;
                                      }
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

                    // FEAST & BIO-FUEL TELEMETRY GOALS Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.02),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: themeColor.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "FEAST & BIO-FUEL TELEMETRY GOALS",
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
                                    label: "CALORIE INTAKE (KCAL)",
                                    controller: _targetCaloriesController,
                                    onChanged: (val) {
                                      final d = double.tryParse(val);
                                      if (d != null) profile.targetCalories = d;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: "PROTEIN TARGET (G)",
                                    controller: _targetProteinController,
                                    onChanged: (val) {
                                      final d = double.tryParse(val);
                                      if (d != null) profile.targetProtein = d;
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
                                    label: "CARBS TARGET (G)",
                                    controller: _targetCarbsController,
                                    onChanged: (val) {
                                      final d = double.tryParse(val);
                                      if (d != null) profile.targetCarbs = d;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: "FATS TARGET (G)",
                                    controller: _targetFatsController,
                                    onChanged: (val) {
                                      final d = double.tryParse(val);
                                      if (d != null) profile.targetFats = d;
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
                                    label: "SUGAR LIMIT (G)",
                                    controller: _targetSugarController,
                                    onChanged: (val) {
                                      final d = double.tryParse(val);
                                      if (d != null) profile.targetSugar = d;
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

                    // WARRIOR PERSONAL RECORDS (PRs) Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.02),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: themeColor.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "WARRIOR PERSONAL RECORDS (PRs)",
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
                                    label: "PULLUPS PR (REPS)",
                                    controller: _prPullupsController,
                                    onChanged: (val) => _savePRField(
                                      val,
                                      "Pullups",
                                      "rep",
                                      profile,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: "PUSHUPS PR (REPS)",
                                    controller: _prPushupsController,
                                    onChanged: (val) => _savePRField(
                                      val,
                                      "Pushups",
                                      "rep",
                                      profile,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: "SQUATS PR (REPS)",
                                    controller: _prSquatsController,
                                    onChanged: (val) => _savePRField(
                                      val,
                                      "Squats",
                                      "rep",
                                      profile,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: "DIPS PR (REPS)",
                                    controller: _prDipsController,
                                    onChanged: (val) => _savePRField(
                                      val,
                                      "Dips",
                                      "rep",
                                      profile,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: profile.useImperialUnits
                                        ? "RUN PR (MILES)"
                                        : "RUN PR (KM)",
                                    controller: _prRunController,
                                    onChanged: (val) => _savePRField(
                                      val,
                                      "Run (Miles)",
                                      "cardio",
                                      profile,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: "HANDSTAND HOLD (SEC)",
                                    controller: _prHandstandController,
                                    onChanged: (val) => _savePRField(
                                      val,
                                      "Handstand Hold (Sec)",
                                      "rep",
                                      profile,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: profile.useImperialUnits
                                        ? "BENCH PRESS (LBS)"
                                        : "BENCH PRESS (KG)",
                                    controller: _prBenchPressController,
                                    onChanged: (val) => _savePRField(
                                      val,
                                      "Bench Press",
                                      "weight",
                                      profile,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: profile.useImperialUnits
                                        ? "DEADLIFT (LBS)"
                                        : "DEADLIFT (KG)",
                                    controller: _prDeadliftController,
                                    onChanged: (val) => _savePRField(
                                      val,
                                      "Deadlift",
                                      "weight",
                                      profile,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: profile.useImperialUnits
                                        ? "BARBELL SQUAT (LBS)"
                                        : "BARBELL SQUAT (KG)",
                                    controller: _prBarbellSquatController,
                                    onChanged: (val) => _savePRField(
                                      val,
                                      "Barbell Squat",
                                      "weight",
                                      profile,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildMetricConfigField(
                                    label: profile.useImperialUnits
                                        ? "OVERHEAD PRESS (LBS)"
                                        : "OVERHEAD PRESS (KG)",
                                    controller: _prOverheadPressController,
                                    onChanged: (val) => _savePRField(
                                      val,
                                      "Overhead Press",
                                      "weight",
                                      profile,
                                    ),
                                  ),
                                ),
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

                          // Unit System Selector
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "SYSTEM MEASUREMENT UNITS",
                                style: GoogleFonts.exo2(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.02),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          profile.useImperialUnits = false;
                                          _updateControllerTexts(profile);
                                          _updatePRControllerTexts(profile);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              !profile.useImperialUnits
                                              ? themeColor
                                              : Colors.transparent,
                                          foregroundColor:
                                              !profile.useImperialUnits
                                              ? Colors.black
                                              : Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Metric (L, KG, CM)",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          profile.useImperialUnits = true;
                                          _updateControllerTexts(profile);
                                          _updatePRControllerTexts(profile);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              profile.useImperialUnits
                                              ? themeColor
                                              : Colors.transparent,
                                          foregroundColor:
                                              profile.useImperialUnits
                                              ? Colors.black
                                              : Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Imperial (oz, LBS, IN)",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.02),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Row(
                                  children:
                                      [
                                        CognitiveProfile.neurotypical,
                                        CognitiveProfile.adhd,
                                        CognitiveProfile.autistic,
                                        CognitiveProfile.audhd,
                                      ].map((cp) {
                                        final isSelected =
                                            profile.cognitiveProfile == cp;
                                        final text =
                                            cp == CognitiveProfile.neurotypical
                                            ? "Vanguard"
                                            : (cp == CognitiveProfile.adhd
                                                  ? "Hunter"
                                                  : (cp ==
                                                            CognitiveProfile
                                                                .autistic
                                                        ? "Revenant"
                                                        : "Warrior"));
                                        return Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 2,
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                profile.cognitiveProfile = cp;
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isSelected
                                                    ? themeColor
                                                    : Colors.transparent,
                                                foregroundColor: isSelected
                                                    ? Colors.black
                                                    : Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.02),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Row(
                                  children: ["Off", "Low", "Medium", "High"]
                                      .map((freq) {
                                        final isSelected =
                                            profile.notificationFrequency ==
                                            freq;
                                        return Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 2,
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                profile.notificationFrequency =
                                                    freq;
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isSelected
                                                    ? themeColor
                                                    : Colors.transparent,
                                                foregroundColor: isSelected
                                                    ? Colors.black
                                                    : Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
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
                                      })
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          const SizedBox(height: 16),
                          // Flow/Time Scheduling
                          if (profile.cognitiveProfile ==
                                  CognitiveProfile.adhd ||
                              profile.cognitiveProfile ==
                                  CognitiveProfile.audhd)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ROUTINE FLOW TIME (ADHD/AuDHD)",
                                  style: GoogleFonts.exo2(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.02),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: Row(
                                    children:
                                        [
                                          "Morning",
                                          "Afternoon",
                                          "Evening",
                                        ].map((time) {
                                          final isSelected =
                                              profile.schedule.flowTime == time;
                                          return Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 2,
                                                  ),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  final newSchedule = profile
                                                      .schedule
                                                      .copyWith(flowTime: time);
                                                  profile.updateSchedule(
                                                    newSchedule,
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: isSelected
                                                      ? themeColor
                                                      : Colors.transparent,
                                                  foregroundColor: isSelected
                                                      ? Colors.black
                                                      : Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                      ),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                ),
                                                child: Text(
                                                  time,
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
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CONSISTENT WORKOUT TIME",
                                  style: GoogleFonts.exo2(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                _buildAdjustButton(
                                  icon: Icons.access_time,
                                  label:
                                      profile.schedule.consistentTime ??
                                      "Set Workout Time",
                                  color: themeColor,
                                  onTap: () async {
                                    final initialTime = TimeOfDay.now();
                                    final TimeOfDay? newTime =
                                        await showTimePicker(
                                          context: context,
                                          initialTime: initialTime,
                                        );
                                    if (newTime != null) {
                                      final timeStr = newTime.format(context);
                                      final newSchedule = profile.schedule
                                          .copyWith(consistentTime: timeStr);
                                      profile.updateSchedule(newSchedule);
                                    }
                                  },
                                ),
                              ],
                            ),

                          const SizedBox(height: 16),
                          // Week Tracker
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "WEEK TRACKER (REST DAYS)",
                                style: GoogleFonts.exo2(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.02),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [1, 2, 3, 4, 5, 6, 7].map((day) {
                                    final dayName = [
                                      "M",
                                      "T",
                                      "W",
                                      "T",
                                      "F",
                                      "S",
                                      "S",
                                    ][day - 1];
                                    final isRest =
                                        profile.schedule.restDays[day] ?? false;
                                    return GestureDetector(
                                      onTap: () {
                                        final newRestDays = Map<int, bool>.from(
                                          profile.schedule.restDays,
                                        );
                                        newRestDays[day] = !isRest;
                                        final newSchedule = profile.schedule
                                            .copyWith(restDays: newRestDays);
                                        profile.updateSchedule(newSchedule);
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: isRest
                                              ? Colors.transparent
                                              : themeColor.withValues(
                                                  alpha: 0.2,
                                                ),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isRest
                                                ? Colors.white24
                                                : themeColor,
                                          ),
                                        ),
                                        child: Text(
                                          dayName,
                                          style: GoogleFonts.orbitron(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: isRest
                                                ? Colors.grey
                                                : themeColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),

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
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: const Color(0xFF0F0F0F),
                                    title: Text(
                                      "RESET ALL PROGRESS?",
                                      style: GoogleFonts.orbitron(
                                        color: Colors.redAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text(
                                      "This will permanently erase all your stats, character customizations, logged workouts, and level progress. This action cannot be undone.",
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
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          profile.resetProgress();
                                        },
                                        child: const Text(
                                          "RESET EVERYTHING",
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
        ),
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
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
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
        Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              onChanged(controller.text);
            }
          },
          child: TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.black, fontSize: 14),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.blueAccent,
                  size: 18,
                ),
                onPressed: () {
                  onChanged(controller.text);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
            onFieldSubmitted: onChanged,
          ),
        ),
      ],
    );
  }

  void _updateControllerTexts(UserProfileManager profile) {
    final useImperial = profile.useImperialUnits;

    String formatVal(double val, bool isWeight) {
      double converted = val;
      if (!useImperial) {
        if (isWeight) {
          converted = val * 0.45359237;
        } else {
          converted = val * 2.54;
        }
      }
      return converted == 0.0 ? "" : converted.toStringAsFixed(1);
    }

    _heightController.text = formatVal(profile.height, false);
    _weightController.text = formatVal(profile.weight, true);
    _startWeightController.text = formatVal(profile.startWeight, true);
    _goalWeightController.text = formatVal(profile.goalWeight, true);
    _chestController.text = formatVal(profile.chest, false);
    _armsController.text = formatVal(profile.arms, false);
    _waistController.text = formatVal(profile.waist, false);
    _hipsController.text = formatVal(profile.hips, false);
    _legsController.text = formatVal(profile.legs, false);

    double dist = profile.distanceGoal;
    if (!useImperial) {
      dist = dist * 1.609344;
    }
    _distanceGoalController.text = dist == 0.0 ? "" : dist.toStringAsFixed(1);
  }

  void _saveDoubleField(
    String val,
    bool isWeight,
    void Function(double) setter,
    UserProfileManager profile,
  ) {
    final d = double.tryParse(val);
    if (d != null) {
      double finalVal = d;
      if (!profile.useImperialUnits) {
        if (isWeight) {
          finalVal = d / 0.45359237;
        } else {
          finalVal = d / 2.54;
        }
      }
      setter(finalVal);
    }
  }

  void _updatePRControllerTexts(UserProfileManager profile) {
    final useImperial = profile.useImperialUnits;

    String formatRep(double val) => val.toStringAsFixed(0);
    String formatWeight(double val) {
      double converted = val;
      if (!useImperial) {
        converted = val * 0.45359237;
      }
      return converted.toStringAsFixed(0);
    }

    String formatRun(double val) {
      double converted = val;
      if (!useImperial) {
        converted = val * 1.609344;
      }
      return converted.toStringAsFixed(1);
    }

    _prPullupsController.text = formatRep(
      profile.personalRecords["Pullups"] ?? 5.0,
    );
    _prPushupsController.text = formatRep(
      profile.personalRecords["Pushups"] ?? 20.0,
    );
    _prSquatsController.text = formatRep(
      profile.personalRecords["Squats"] ?? 30.0,
    );
    _prDipsController.text = formatRep(profile.personalRecords["Dips"] ?? 8.0);
    _prRunController.text = formatRun(
      profile.personalRecords["Run (Miles)"] ?? 1.0,
    );
    _prHandstandController.text = formatRep(
      profile.personalRecords["Handstand Hold (Sec)"] ?? 15.0,
    );
    _prBenchPressController.text = formatWeight(
      profile.personalRecords["Bench Press"] ?? 135.0,
    );
    _prDeadliftController.text = formatWeight(
      profile.personalRecords["Deadlift"] ?? 185.0,
    );
    _prBarbellSquatController.text = formatWeight(
      profile.personalRecords["Barbell Squat"] ?? 155.0,
    );
    _prOverheadPressController.text = formatWeight(
      profile.personalRecords["Overhead Press"] ?? 95.0,
    );
  }

  void _savePRField(
    String val,
    String key,
    String type,
    UserProfileManager profile,
  ) {
    final d = double.tryParse(val);
    if (d != null) {
      double finalVal = d;
      if (!profile.useImperialUnits) {
        if (type == "weight") {
          finalVal = d / 0.45359237;
        } else if (type == "cardio") {
          finalVal = d / 1.609344;
        }
      }
      profile.logPR(key, finalVal);
    }
  }
}
