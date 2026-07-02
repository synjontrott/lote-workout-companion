import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../managers/user_profile_manager.dart';

class NutritionView extends StatefulWidget {
  const NutritionView({Key? key}) : super(key: key);

  @override
  State<NutritionView> createState() => _NutritionViewState();
}

class _NutritionViewState extends State<NutritionView> {
  final _formKey = GlobalKey<FormState>();
  
  // Dialog logging fields
  String _mealName = "";
  String _mealCalories = "";
  String _mealProtein = "";
  String _mealCarbs = "";
  String _mealFats = "";
  String _mealSugar = "";

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfileManager>(context);
    final themeColor = profile.currentElement.primaryColor;
    
    final double calorieTarget = profile.targetCalories;
    final double proteinTarget = profile.targetProtein;
    final double carbsTarget = profile.targetCarbs;
    final double fatsTarget = profile.targetFats;
    final double sugarLimit = profile.targetSugar;
    
    // Filter meals for today
    final now = DateTime.now();
    final todayMeals = profile.loggedMeals.where((m) {
      return m.date.year == now.year &&
             m.date.month == now.month &&
             m.date.day == now.day;
    }).toList();

    // Sums
    final totalCalories = todayMeals.fold<double>(0, (sum, m) => sum + m.calories);
    final totalProtein = todayMeals.fold<double>(0, (sum, m) => sum + m.protein);
    final totalCarbs = todayMeals.fold<double>(0, (sum, m) => sum + m.carbs);
    final totalFats = todayMeals.fold<double>(0, (sum, m) => sum + m.fats);
    final totalSugar = todayMeals.fold<double>(0, (sum, m) => sum + m.sugar);

    final progressPct = (totalCalories / calorieTarget).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFF020408),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Title
              Center(
                child: Column(
                  children: [
                    Text(
                      "BIO-FUEL TELEMETRY",
                      style: GoogleFonts.orbitron(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Monitor caloric input and metabolic fuel ratios",
                      style: TextStyle(
                        fontFamily: "Exo2",
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Main Caloric Telemetry Ring / Progress Arc
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeColor.withOpacity(0.04),
                      ),
                    ),
                    // Ring Progress Indicator
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: progressPct,
                        strokeWidth: 10,
                        backgroundColor: Colors.white.withOpacity(0.03),
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                    ),
                    // Value readouts
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          totalCalories.toInt().toString(),
                          style: GoogleFonts.orbitron(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "/ ${calorieTarget.toInt()} KCAL",
                          style: GoogleFonts.orbitron(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${(progressPct * 100).toInt()}% FUELED",
                          style: GoogleFonts.exo2(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Macro-Nutrient Split Progress Bars Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ELEMENTAL FUEL SPLIT",
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Protein (Orange)
                    _buildMacroProgressBar(
                      label: "PROTEIN CORE",
                      current: totalProtein,
                      target: proteinTarget,
                      unit: "g",
                      color: Colors.orange,
                      icon: Icons.fitness_center,
                    ),
                    const SizedBox(height: 14),
                    // Carbs (Cyan)
                    _buildMacroProgressBar(
                      label: "CARBON INTAKE",
                      current: totalCarbs,
                      target: carbsTarget,
                      unit: "g",
                      color: Colors.cyan,
                      icon: Icons.grass,
                    ),
                    const SizedBox(height: 14),
                    // Fats (Yellow)
                    _buildMacroProgressBar(
                      label: "LIPID SHIELD",
                      current: totalFats,
                      target: fatsTarget,
                      unit: "g",
                      color: Colors.yellow,
                      icon: Icons.shield,
                    ),
                    const SizedBox(height: 14),
                    // Sugar (Red)
                    _buildMacroProgressBar(
                      label: "GLUCOSE LIMIT",
                      current: totalSugar,
                      target: sugarLimit,
                      unit: "g",
                      color: Colors.red,
                      icon: Icons.warning_amber_rounded,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // HYDRATION TELEMETRY Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "HYDRATION TELEMETRY",
                          style: GoogleFonts.orbitron(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          "💧 ACTIVE",
                          style: GoogleFonts.orbitron(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.useImperialUnits
                                  ? "${profile.todayWaterIntakeOz.toStringAsFixed(0)} / ${profile.waterIntakeGoalOz.toStringAsFixed(0)} oz"
                                  : "${profile.todayWaterIntake.toStringAsFixed(2)} / ${profile.waterIntakeGoal.toStringAsFixed(2)} L",
                              style: GoogleFonts.orbitron(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              "Daily Intake Target",
                              style: TextStyle(
                                fontFamily: "Exo2",
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        // Goal Adjuster stepper
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (profile.useImperialUnits) {
                                  final currentGoal = profile.waterIntakeGoalOz;
                                  if (currentGoal > 8.0) {
                                    profile.waterIntakeGoalOz = currentGoal - 8.0;
                                  }
                                } else {
                                  final currentGoal = profile.waterIntakeGoal;
                                  if (currentGoal > 0.5) {
                                    profile.waterIntakeGoal = currentGoal - 0.5;
                                  }
                                }
                              },
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.grey, size: 18),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Goal",
                              style: GoogleFonts.orbitron(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                if (profile.useImperialUnits) {
                                  profile.waterIntakeGoalOz = profile.waterIntakeGoalOz + 8.0;
                                } else {
                                  profile.waterIntakeGoal = profile.waterIntakeGoal + 0.5;
                                }
                              },
                              icon: const Icon(Icons.add_circle_outline, color: Colors.grey, size: 18),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Hydration Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: profile.waterIntakeGoal > 0 ? (profile.todayWaterIntake / profile.waterIntakeGoal).clamp(0.0, 1.0) : 0.0,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.04),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Increment buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (profile.useImperialUnits) ...[
                          ElevatedButton(
                            onPressed: () {
                              if (profile.todayWaterIntakeOz >= 8.0) {
                                profile.todayWaterIntakeOz -= 8.0;
                                profile.evaluateQuestsCompletion();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.12),
                              foregroundColor: Colors.redAccent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            child: const Text("-8 oz", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              profile.todayWaterIntakeOz += 8.0;
                              profile.evaluateQuestsCompletion();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent.withOpacity(0.12),
                              foregroundColor: Colors.blueAccent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            child: const Text("+8 oz", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              profile.todayWaterIntakeOz += 16.0;
                              profile.evaluateQuestsCompletion();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent.withOpacity(0.12),
                              foregroundColor: Colors.blueAccent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            child: const Text("+16 oz", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ] else ...[
                          ElevatedButton(
                            onPressed: () {
                              if (profile.todayWaterIntake >= 0.25) {
                                profile.todayWaterIntake -= 0.25;
                                profile.evaluateQuestsCompletion();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.12),
                              foregroundColor: Colors.redAccent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            child: const Text("-0.25 L", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              profile.todayWaterIntake += 0.25;
                              profile.evaluateQuestsCompletion();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent.withOpacity(0.12),
                              foregroundColor: Colors.blueAccent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            child: const Text("+0.25 L", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              profile.todayWaterIntake += 0.5;
                              profile.evaluateQuestsCompletion();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent.withOpacity(0.12),
                              foregroundColor: Colors.blueAccent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            child: const Text("+0.50 L", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action button to log food
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () => _showMealLogDialog(context, profile),
                  icon: const Icon(Icons.add_circle, color: Colors.black, size: 18),
                  label: Text(
                    "LOG HEALTHY RATIONS",
                    style: GoogleFonts.orbitron(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Rations list registry
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "TODAY'S RATIONS LOG",
                  style: GoogleFonts.orbitron(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (todayMeals.isEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.01),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        "No bio-fuel logged today.",
                        style: TextStyle(
                          fontFamily: "Exo2",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Sync your healthy eating to boost constitution attributes.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Exo2",
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...todayMeals.map((meal) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.04)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal.name.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: "Exo2",
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  "${meal.calories.toInt()} kcal",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: themeColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "P: ${meal.protein.toInt()}g  C: ${meal.carbs.toInt()}g  F: ${meal.fats.toInt()}g",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          profile.deleteDetailedMeal(meal.id);
                        },
                        icon: const Icon(Icons.cancel, color: Colors.redAccent, size: 18),
                      ),
                    ],
                  ),
                )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroProgressBar({
    required String label,
    required double current,
    required double target,
    required String unit,
    required Color color,
    required IconData icon,
  }) {
    final progress = (current / target).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.orbitron(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              "${current.toInt()} / ${target.toInt()} $unit",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.03),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  void _showMealLogDialog(BuildContext context, UserProfileManager profile) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF0C0C0C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: profile.currentElement.primaryColor.withOpacity(0.4), width: 1.5),
              ),
              title: Center(
                child: Text(
                  "LOG HEALTHY RATIONS",
                  style: GoogleFonts.orbitron(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "RATION NAME",
                          labelStyle: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
                          hintText: "e.g. Chicken breast and broccoli",
                          hintStyle: TextStyle(fontSize: 11, color: Colors.white24),
                        ),
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (val) => _mealName = val,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "CALORIES",
                                labelStyle: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
                                hintText: "kcal",
                              ),
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              onChanged: (val) => _mealCalories = val,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "PROTEIN (g)",
                                labelStyle: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
                                hintText: "grams",
                              ),
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              onChanged: (val) => _mealProtein = val,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "CARBS (g)",
                                labelStyle: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
                                hintText: "grams",
                              ),
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              onChanged: (val) => _mealCarbs = val,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "FATS (g)",
                                labelStyle: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
                                hintText: "grams",
                              ),
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              onChanged: (val) => _mealFats = val,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "SUGAR (g)",
                          labelStyle: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
                          hintText: "grams",
                        ),
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (val) => _mealSugar = val,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 11)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final cal = double.tryParse(_mealCalories) ?? 0;
                          final prot = double.tryParse(_mealProtein) ?? 0;
                          final carb = double.tryParse(_mealCarbs) ?? 0;
                          final fat = double.tryParse(_mealFats) ?? 0;
                          final sug = double.tryParse(_mealSugar) ?? 0;

                          profile.logDetailedMeal(
                            name: _mealName.isEmpty ? "Healthy Rations" : _mealName,
                            calories: cal,
                            protein: prot,
                            carbs: carb,
                            fats: fat,
                            sugar: sug,
                          );

                          // Reset dialog state
                          _mealName = "";
                          _mealCalories = "";
                          _mealProtein = "";
                          _mealCarbs = "";
                          _mealFats = "";
                          _mealSugar = "";

                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: profile.currentElement.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "LOG RATION",
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
