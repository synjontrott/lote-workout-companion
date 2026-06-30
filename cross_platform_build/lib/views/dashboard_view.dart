import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../managers/user_profile_manager.dart';
import '../managers/health_manager.dart';
import '../models/lote_models.dart';
import 'widgets/pixel_sprite_widget.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> with SingleTickerProviderStateMixin {
  // Bobbing animation for the pixel character
  late AnimationController _bobController;
  late Animation<double> _bobAnimation;

  // 5-Minute Focus Timer (300 seconds)
  Timer? _sprintTimer;
  int _sprintTimeRemaining = 300;
  bool _sprintTimerActive = false;

  // Body Measurement Logging State
  bool _showingMeasurementLog = false;
  late TextEditingController _measureWeightController;
  late TextEditingController _measureChestController;
  late TextEditingController _measureArmsController;
  late TextEditingController _measureWaistController;
  late TextEditingController _measureHipsController;
  late TextEditingController _measureLegsController;

  @override
  void initState() {
    super.initState();
    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    
    _bobAnimation = Tween<double>(begin: 0.0, end: -6.0).animate(
      CurvedAnimation(parent: _bobController, curve: Curves.easeInOut),
    );

    _measureWeightController = TextEditingController();
    _measureChestController = TextEditingController();
    _measureArmsController = TextEditingController();
    _measureWaistController = TextEditingController();
    _measureHipsController = TextEditingController();
    _measureLegsController = TextEditingController();
  }

  @override
  void dispose() {
    _bobController.dispose();
    _sprintTimer?.cancel();
    _measureWeightController.dispose();
    _measureChestController.dispose();
    _measureArmsController.dispose();
    _measureWaistController.dispose();
    _measureHipsController.dispose();
    _measureLegsController.dispose();
    super.dispose();
  }

  // Timer format helper
  String get _timerString {
    final mins = _sprintTimeRemaining ~/ 60;
    final secs = _sprintTimeRemaining % 60;
    final minStr = mins.toString().padLeft(2, '0');
    final secStr = secs.toString().padLeft(2, '0');
    return "$minStr:$secStr";
  }

  void _toggleSprintTimer(UserProfileManager profile) {
    if (_sprintTimerActive) {
      _sprintTimer?.cancel();
      setState(() {
        _sprintTimerActive = false;
      });
    } else {
      setState(() {
        _sprintTimerActive = true;
      });
      _sprintTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_sprintTimeRemaining > 0) {
          setState(() {
            _sprintTimeRemaining--;
          });
        } else {
          timer.cancel();
          setState(() {
            _sprintTimerActive = false;
            _sprintTimeRemaining = 300;
          });
          // Award XP and Crystals
          profile.earnCrystals(10);
          profile.addXP(20);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: profile.currentElement.primaryColor,
              content: Text(
                "Focus burst complete! +20 XP / +10 Crystals awarded.",
                style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
      });
    }
  }

  void _resetSprintTimer() {
    _sprintTimer?.cancel();
    setState(() {
      _sprintTimerActive = false;
      _sprintTimeRemaining = 300;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfileManager>(context);
    final health = Provider.of<HealthManager>(context);

    // Sync values daily on load
    profile.checkNewDayRefresh();

    // Map retro character custom pixel colors
    final skin = hexToColor(profile.sprite.skinColorHex);
    final hair = hexToColor(profile.sprite.hairColorHex);
    final outfit = hexToColor(profile.sprite.outfitColorHex);
    final eye = profile.currentElement.primaryColor;
    final aura = profile.currentElement.accentColor;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF050505),
      body: Stack(
        children: [
          // Background elemental theme glow
          Positioned(
            left: 20,
            top: 40,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: profile.currentElement.primaryColor.withOpacity(0.08),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MARK: - Character Cockpit
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: profile.currentElement.primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                        gradient: profile.equippedBackground != "None" ? LinearGradient(
                          colors: [
                            profile.equippedBackground == "Neon Cyber Space" ? Colors.blue.withOpacity(0.1) :
                            profile.equippedBackground == "Nebula Starfield" ? Colors.purple.withOpacity(0.1) :
                            profile.equippedBackground == "Volcanic Core" ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ) : null,
                      ),
                      child: Row(
                        children: [
                          // Animated Pixel Sprite
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: profile.currentElement.primaryColor.withOpacity(0.12),
                                ),
                              ),
                              if (profile.equippedAura != "None")
                                Builder(
                                  builder: (context) {
                                    final Color auraColor = () {
                                      switch (profile.equippedAura) {
                                        case "Glitch Aura": return const Color(0xFF00F0FF);
                                        case "Phoenix Flare": return Colors.orange;
                                        case "Abyssal Mist": return const Color(0xFF880E4F);
                                        case "Lightning Spark": return Colors.yellow;
                                        default: return profile.currentElement.accentColor;
                                      }
                                    }();
                                    return Container(
                                      width: 85,
                                      height: 85,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: auraColor.withOpacity(0.15),
                                      ),
                                    );
                                  }
                                ),
                              AnimatedBuilder(
                                animation: _bobAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _bobAnimation.value),
                                    child: PixelSpriteWidget(
                                      grid: profile.sprite.pixelGrid,
                                      skinColor: skin,
                                      hairColor: hair,
                                      eyeColor: eye,
                                      outfitColor: outfit,
                                      auraColor: aura,
                                      pixelSize: 1.6,
                                    ),
                                  );
                                },
                              ),
                              // Floating Element Flavor Sprite
                              AnimatedBuilder(
                                animation: _bobAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(32, -32 - _bobAnimation.value * 0.7),
                                    child: child,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: profile.currentElement.primaryColor.withOpacity(0.2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: profile.currentElement.primaryColor.withOpacity(0.6),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    () {
                                      switch (profile.currentElement.name) {
                                        case "Fire": return "🔥";
                                        case "Water": return "💧";
                                        case "Earth": return "🪨";
                                        case "Air": return "💨";
                                        case "Lightning": return "⚡";
                                        case "Metal": return "⚙️";
                                        case "Ice": return "🧊";
                                        case "Bone": return "🦴";
                                        case "Gas": return "🌫️";
                                        case "Laser": return "🔴";
                                        case "Zero Space": return "🌀";
                                        case "Knife": return "🗡️";
                                        case "Poison": return "🧪";
                                        case "Darki": return "🔮";
                                        case "Shadow": return "👻";
                                        case "Death": return "💀";
                                        default: return "✨";
                                      }
                                    }(),
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                              ),
                              if (profile.equippedFrame != "None")
                                Builder(
                                  builder: (context) {
                                    final Color frameColor = () {
                                      switch (profile.equippedFrame) {
                                        case "Ignis Frame": return Colors.red;
                                        case "Crystalline Frame": return const Color(0xFF26C6DA);
                                        case "Umbral Border": return const Color(0xFF311B92);
                                        case "Cyber Grid Frame": return Colors.blue;
                                        default: return profile.currentElement.primaryColor;
                                      }
                                    }();
                                    return Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: frameColor, width: 2.5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: frameColor.withOpacity(0.4),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          )
                                        ]
                                      ),
                                    );
                                  }
                                ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: _buildElementFlavorSprite(profile),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: [
                                    Text(
                                      profile.characterName.toUpperCase(),
                                      style: GoogleFonts.orbitron(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    if (profile.equippedTitle != "None")
                                      Text(
                                        "[${profile.equippedTitle}]",
                                        style: GoogleFonts.orbitron(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profile.currentTier.dynamicDisplayName(profile.currentElement.name).toUpperCase(),
                                  style: GoogleFonts.orbitron(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: profile.currentElement.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.local_fire_department,
                                      size: 14,
                                      color: profile.streak > 0 ? Colors.orange : Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${profile.streak} DAYS",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Text(
                                      "💎",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${profile.crystals} CRYSTALS",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                 if (profile.previousStreak > 0 && profile.streak == 0) ...[
                                   const SizedBox(height: 6),
                                   InkWell(
                                     onTap: () {
                                       profile.recoverStreak();
                                     },
                                     borderRadius: BorderRadius.circular(6),
                                     child: Container(
                                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                       decoration: BoxDecoration(
                                         color: Colors.orange.withOpacity(0.12),
                                         borderRadius: BorderRadius.circular(6),
                                       ),
                                       child: Row(
                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                           const Icon(Icons.refresh, color: Colors.orange, size: 10),
                                           const SizedBox(width: 4),
                                           Text(
                                             "Recover ${profile.previousStreak} Day Streak (100 💎)",
                                             style: GoogleFonts.orbitron(
                                               fontSize: 8,
                                               fontWeight: FontWeight.bold,
                                               color: Colors.orange,
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ),
                                 ],
                                if (profile.equippedAccessory != "None") ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    "Equipped: ${profile.equippedAccessory}",
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // MARK: - HealthKit Status / Connect
                  if (!health.isAuthorized)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: InkWell(
                        onTap: () => health.requestAuthorization(),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.health_and_safety, color: Colors.red),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "CONNECT PLATFORM HEALTH SYSTEM",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Icon(Icons.link, color: Colors.grey, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (!health.isAuthorized) const SizedBox(height: 20),

                  // MARK: - Energy Activity Gauges
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "ELSAITHER ENERGY CORE",
                      style: GoogleFonts.orbitron(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildMetricGauge(
                          title: "Steps Taken",
                          current: health.todaySteps,
                          target: profile.stepsGoal,
                          unit: "steps",
                          icon: Icons.directions_walk,
                          themeColor: profile.currentElement.primaryColor,
                        ),
                        const SizedBox(height: 12),
                        _buildMetricGauge(
                          title: "Active Energy",
                          current: health.todayCalories,
                          target: profile.caloriesGoal,
                          unit: "kcal",
                          icon: Icons.local_fire_department,
                          themeColor: profile.currentElement.primaryColor,
                        ),
                        const SizedBox(height: 12),
                        _buildMetricGauge(
                          title: "Training Time",
                          current: health.activeMinutes,
                          target: profile.activeMinutesGoal,
                          unit: "mins",
                          icon: Icons.timer,
                          themeColor: profile.currentElement.primaryColor,
                        ),
                        const SizedBox(height: 12),
                        _buildMetricGauge(
                          title: "Stand Hours",
                          current: health.todayStandHours,
                          target: profile.standHoursGoal,
                          unit: "hours",
                          icon: Icons.accessibility_new,
                          themeColor: profile.currentElement.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sugar Tracker Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "SUGAR INTAKE TRACKER",
                      style: GoogleFonts.orbitron(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Builder(
                      builder: (context) {
                        final loggedSugar = profile.todaySugar;
                        final sugarPercent = (loggedSugar / 30.0).clamp(0.0, 1.0);
                        final exceeded = loggedSugar > 30.0;

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: exceeded ? Colors.red.withOpacity(0.3) : Colors.white.withOpacity(0.06),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.bubble_chart, color: Colors.white, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Today's Sugar",
                                    style: GoogleFonts.exo2(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${loggedSugar.toStringAsFixed(1)} / 30.0 g",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: exceeded ? Colors.red : profile.currentElement.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: sugarPercent,
                                  minHeight: 6,
                                  backgroundColor: Colors.white.withOpacity(0.1),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    exceeded ? Colors.red : profile.currentElement.primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      exceeded
                                          ? "⚠️ Sugar threshold exceeded!"
                                          : "Keep sugar under 30g daily to maintain clean energy flow.",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: exceeded ? Colors.red : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                  const SizedBox(height: 24),

                  // MARK: - Target Goal Progress (Weight & Distance)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "TARGET GOAL PROGRESS",
                      style: GoogleFonts.orbitron(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.06),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(
                            builder: (context) {
                              final isCutting = profile.startWeight > profile.goalWeight;
                              final totalDelta = (profile.startWeight - profile.goalWeight).abs();
                              final currentDelta = isCutting
                                  ? (profile.startWeight - profile.weight)
                                  : (profile.weight - profile.startWeight);
                              final progressPercent = totalDelta > 0
                                  ? (currentDelta / totalDelta).clamp(0.0, 1.0)
                                  : 1.0;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.scale, color: Colors.white, size: 16),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Weight Target Progress",
                                        style: GoogleFonts.exo2(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "${profile.startWeight.toStringAsFixed(1)} -> ${profile.weight.toStringAsFixed(1)} lbs (Goal: ${profile.goalWeight.toStringAsFixed(1)})",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: profile.currentElement.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progressPercent,
                                      minHeight: 6,
                                      backgroundColor: Colors.white.withOpacity(0.1),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        profile.currentElement.primaryColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        "${(progressPercent * 100).toStringAsFixed(0)}% Achieved",
                                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                                      ),
                                      const Spacer(),
                                      if (profile.hasClaimedWeightGoalReward)
                                        const Text(
                                          "🏆 Reward Claimed!",
                                          style: TextStyle(fontSize: 10, color: Colors.green),
                                        )
                                      else if (progressPercent >= 1.0)
                                        const Text(
                                          "🎉 Goal Hit! Reward Pending...",
                                          style: TextStyle(fontSize: 10, color: Colors.orange),
                                        )
                                      else
                                        Text(
                                          "${(profile.weight - profile.goalWeight).abs().toStringAsFixed(1)} lbs to go",
                                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                                        ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          const Divider(color: Colors.white10),
                          const SizedBox(height: 15),
                          // Distance Goal progress bar
                          Builder(
                            builder: (context) {
                              final currentDistance = health.todaySteps / 2000.0;
                              final distancePercent = profile.distanceGoal > 0
                                  ? (currentDistance / profile.distanceGoal).clamp(0.0, 1.0)
                                  : 1.0;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.directions_run, color: Colors.white, size: 16),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Daily Cardio Goal",
                                        style: GoogleFonts.exo2(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "${currentDistance.toStringAsFixed(1)} / ${profile.distanceGoal.toStringAsFixed(1)} miles",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: profile.currentElement.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: distancePercent,
                                      minHeight: 6,
                                      backgroundColor: Colors.white.withOpacity(0.1),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        profile.currentElement.primaryColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        "${(distancePercent * 100).toStringAsFixed(0)}% Completed",
                                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                                      ),
                                      const Spacer(),
                                      if (profile.hasClaimedDistanceGoalReward)
                                        const Text(
                                          "🏆 Daily Reward Claimed! (+30 💎)",
                                          style: TextStyle(fontSize: 10, color: Colors.green),
                                        )
                                      else if (distancePercent >= 1.0)
                                        Builder(
                                          builder: (context) {
                                            // Trigger check automatically on load
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              profile.checkDistanceGoalProgress(health.todaySteps);
                                            });
                                            return const Text(
                                              "🎉 Goal Achieved! Reward Claimed",
                                              style: TextStyle(fontSize: 10, color: Colors.green),
                                            );
                                          },
                                        )
                                      else
                                        Text(
                                          "${(profile.distanceGoal - currentDistance).clamp(0.0, 999.0).toStringAsFixed(1)} miles to go",
                                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                                        ),
                                    ],
                                  ),
                                  if (profile.streak >= 3) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.flash_on, color: Colors.orange, size: 14),
                                              const SizedBox(width: 6),
                                              Text(
                                                "CHALLENGE RECOMMENDATION",
                                                style: GoogleFonts.orbitron(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "You have a ${profile.streak}-day activity streak! Push your limits and increase your daily cardio target to ${(profile.distanceGoal + 1.0).toStringAsFixed(1)} miles.",
                                            style: const TextStyle(fontSize: 10, color: Colors.white70),
                                          ),
                                          const SizedBox(height: 8),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 28,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                profile.distanceGoal = profile.distanceGoal + 1.0;
                                                profile.hasClaimedDistanceGoalReward = false;
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                padding: EdgeInsets.zero,
                                              ),
                                              child: Text(
                                                "UP CARDIO GOAL TO ${(profile.distanceGoal + 1.0).toStringAsFixed(1)} MILES",
                                                style: GoogleFonts.orbitron(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ]
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Weight History Log",
                                style: GoogleFonts.exo2(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 70,
                                child: _WeightHistoryChart(
                                  history: profile.weightHistory,
                                  startWeight: profile.startWeight,
                                  goalWeight: profile.goalWeight,
                                  primaryColor: profile.currentElement.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Divider(color: Colors.white10),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Body Measurements Log",
                                    style: GoogleFonts.exo2(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton.icon(
                                    onPressed: () {
                                      _measureWeightController.text = profile.weight.toStringAsFixed(1);
                                      _measureChestController.text = profile.chest.toStringAsFixed(1);
                                      _measureArmsController.text = profile.arms.toStringAsFixed(1);
                                      _measureWaistController.text = profile.waist.toStringAsFixed(1);
                                      _measureHipsController.text = profile.hips.toStringAsFixed(1);
                                      _measureLegsController.text = profile.legs.toStringAsFixed(1);
                                      setState(() {
                                        _showingMeasurementLog = true;
                                      });
                                    },
                                    icon: Icon(Icons.edit, size: 12, color: profile.currentElement.primaryColor),
                                    label: Text(
                                      "Log Metric",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: profile.currentElement.primaryColor,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (profile.measurementHistory.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    "No measurements logged yet. Start measuring year-over-year!",
                                    style: TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                )
                              else
                                SizedBox(
                                  height: 125,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: profile.measurementHistory.length,
                                    itemBuilder: (context, index) {
                                      final entry = profile.measurementHistory.reversed.toList()[index];
                                      final dateStr = "${entry.date.month}/${entry.date.day}/${entry.date.year}";
                                      return Container(
                                        width: 140,
                                        margin: const EdgeInsets.only(right: 12),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.04),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.08),
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dateStr,
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: profile.currentElement.primaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "Weight: ${entry.weight.toStringAsFixed(1)} lbs",
                                              style: const TextStyle(fontSize: 9, color: Colors.white),
                                            ),
                                            Text(
                                              "Chest: ${entry.chest.toStringAsFixed(1)} in",
                                              style: const TextStyle(fontSize: 9, color: Colors.white70),
                                            ),
                                            Text(
                                              "Arms: ${entry.arms.toStringAsFixed(1)} in",
                                              style: const TextStyle(fontSize: 9, color: Colors.white70),
                                            ),
                                            Text(
                                              "Waist: ${entry.waist.toStringAsFixed(1)} in",
                                              style: const TextStyle(fontSize: 9, color: Colors.white70),
                                            ),
                                            Text(
                                              "Hips: ${entry.hips.toStringAsFixed(1)} in",
                                              style: const TextStyle(fontSize: 9, color: Colors.white70),
                                            ),
                                            Text(
                                              "Legs: ${entry.legs.toStringAsFixed(1)} in",
                                              style: const TextStyle(fontSize: 9, color: Colors.white70),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildMonthlyChallengeCard(profile),
                  const SizedBox(height: 24),

                  // MARK: - Psych-Adaptive Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "ORACLE TACTICAL HUD",
                      style: GoogleFonts.orbitron(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPsychSection(profile, health),
                ],
              ),
            ),
          ),
          if (_showingMeasurementLog)
            _buildMeasurementLogModal(profile),
        ],
      ),
    ),);
  }

  Widget _buildMeasurementLogModal(UserProfileManager profile) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.85),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF151515),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: profile.currentElement.primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "LOG BODY METRICS",
                      style: GoogleFonts.orbitron(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildModalTextField(
                          label: "WEIGHT (LBS)",
                          controller: _measureWeightController,
                          hint: "lbs",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildModalTextField(
                          label: "CHEST (INCHES)",
                          controller: _measureChestController,
                          hint: "inches",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildModalTextField(
                          label: "ARMS (INCHES)",
                          controller: _measureArmsController,
                          hint: "inches",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildModalTextField(
                          label: "WAIST (INCHES)",
                          controller: _measureWaistController,
                          hint: "inches",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildModalTextField(
                          label: "HIPS (INCHES)",
                          controller: _measureHipsController,
                          hint: "inches",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildModalTextField(
                          label: "LEGS (INCHES)",
                          controller: _measureLegsController,
                          hint: "inches",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _showingMeasurementLog = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            "CANCEL",
                            style: GoogleFonts.orbitron(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final w = double.tryParse(_measureWeightController.text) ?? 0.0;
                            final c = double.tryParse(_measureChestController.text) ?? 0.0;
                            final a = double.tryParse(_measureArmsController.text) ?? 0.0;
                            final wa = double.tryParse(_measureWaistController.text) ?? 0.0;
                            final h = double.tryParse(_measureHipsController.text) ?? 0.0;
                            final l = double.tryParse(_measureLegsController.text) ?? 0.0;
                            
                            profile.logBodyMeasurements(
                              weight: w,
                              chest: c,
                              arms: a,
                              waist: wa,
                              hips: h,
                              legs: l,
                            );
                            setState(() {
                              _showingMeasurementLog = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: profile.currentElement.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            "LOG METRICS",
                            style: GoogleFonts.orbitron(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
            filled: true,
            fillColor: Colors.white.withOpacity(0.04),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            suffixIcon: IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.blueAccent, size: 18),
              onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricGauge({
    required String title,
    required double current,
    required double target,
    required String unit,
    required IconData icon,
    required Color themeColor,
  }) {
    final pct = (current / target).clamp(0.0, 1.0);
    final pctStr = "${(pct * 100).toStringAsFixed(1)}%";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.exo2(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                "${current.toInt()} / ${target.toInt()} $unit ($pctStr)",
                style: TextStyle(
                  fontSize: 11,
                  color: themeColor,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(themeColor),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPsychSection(UserProfileManager profile, HealthManager health) {
    final cognitive = profile.cognitiveProfile ?? CognitiveProfile.neurotypical;
    switch (cognitive) {
      case CognitiveProfile.adhd:
        return _buildAdhdHud(profile);
      case CognitiveProfile.autistic:
        return _buildAutisticHud(profile, health);
      case CognitiveProfile.audhd:
        return _buildAudhdHud(profile, health);
      case CognitiveProfile.neurotypical:
        return _buildNeurotypicalHud(profile);
    }
  }

  Widget _buildAdhdHud(UserProfileManager profile) {
    return Column(
      children: [
        // 5-Min focus timer card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.av_timer, color: Colors.orange, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "5-MIN FOCUS BURST TIMER",
                      style: GoogleFonts.orbitron(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _timerString,
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _toggleSprintTimer(profile),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          _sprintTimerActive ? "PAUSE" : "START FOCUS BURST",
                          style: GoogleFonts.orbitron(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: _resetSprintTimer,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      ),
                      child: Text(
                        "RESET",
                        style: GoogleFonts.orbitron(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Novelty Beast Active Alert Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "⚔️ NOVELTY BEAST ACTIVE",
                  style: GoogleFonts.orbitron(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Today's workout multiplier is active. If training feels heavy, switch workouts immediately or check the Dopamine Menu in the Quest Board. Low-friction starts only!",
                  style: GoogleFonts.exo2(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.75),
                    height: 1.4,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildAutisticHud(UserProfileManager profile, HealthManager health) {
    final stepsDone = health.todaySteps >= profile.stepsGoal;
    final calDone = health.todayCalories >= profile.caloriesGoal;
    final minsDone = health.activeMinutes >= profile.activeMinutesGoal;
    final standDone = health.todayStandHours >= profile.standHoursGoal;
    final sugarDone = profile.todaySugar <= 30.0;

    double completionPct = 0.0;
    double totalProgress = 0.0;
    totalProgress += profile.stepsGoal > 0 ? (health.todaySteps / profile.stepsGoal).clamp(0.0, 1.0) : 1.0;
    totalProgress += profile.caloriesGoal > 0 ? (health.todayCalories / profile.caloriesGoal).clamp(0.0, 1.0) : 1.0;
    totalProgress += profile.activeMinutesGoal > 0 ? (health.activeMinutes / profile.activeMinutesGoal).clamp(0.0, 1.0) : 1.0;
    totalProgress += profile.standHoursGoal > 0 ? (health.todayStandHours / profile.standHoursGoal).clamp(0.0, 1.0) : 1.0;
    totalProgress += profile.todaySugar <= 30.0 ? 1.0 : 0.0;
    completionPct = (totalProgress / 5.0) * 100;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Checklist
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DAILY FITNESS PERFORMANCE CHECKLIST",
                  style: GoogleFonts.orbitron(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                _buildChecklistRow("Steps Taken (${health.todaySteps.toInt()}/${profile.stepsGoal.toInt()} steps)", stepsDone),
                const SizedBox(height: 8),
                _buildChecklistRow("Active Energy (${health.todayCalories.toInt()}/${profile.caloriesGoal.toInt()} kcal)", calDone),
                const SizedBox(height: 8),
                _buildChecklistRow("Training Time (${health.activeMinutes.toInt()}/${profile.activeMinutesGoal.toInt()} mins)", minsDone),
                const SizedBox(height: 8),
                _buildChecklistRow("Stand Hours (${health.todayStandHours.toInt()}/${profile.standHoursGoal.toInt()} hours)", standDone),
                const SizedBox(height: 8),
                _buildChecklistRow("Sugar Intake (${profile.todaySugar.toStringAsFixed(1)}g/30.0g max)", sugarDone),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // System Metric logs
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "📊 SYSTEM METRIC LOGS",
                  style: GoogleFonts.orbitron(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: profile.currentElement.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Calculated Daily Completion: ${completionPct.toStringAsFixed(2)}%",
                  style: GoogleFonts.exo2(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Training frequency matches physical parameters exactly. Consistent execution keeps performance high.",
                  style: GoogleFonts.exo2(
                    fontSize: 10,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChecklistRow(String label, bool completed) {
    return Row(
      children: [
        Icon(
          completed ? Icons.check_box : Icons.check_box_outline_blank,
          color: completed ? Colors.green : Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.exo2(
              fontSize: 12,
              color: completed ? Colors.white : Colors.grey,
              fontWeight: completed ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildAudhdHud(UserProfileManager profile, HealthManager health) {
    return Column(
      children: [
        // Wildcard card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.sync_alt, color: Colors.purple, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      "DAILY WILDCARD CHALLENGE",
                      style: GoogleFonts.orbitron(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Need flexibility today? Swap your workout type. If the default Quest is too demanding, you are fully authorized to substitute a quick 10-minute walk or a Dopamine Menu burst.",
                  style: GoogleFonts.exo2(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.4,
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Checklist overview
        _buildAutisticHud(profile, health),
      ],
    );
  }

  Widget _buildNeurotypicalHud(UserProfileManager profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Habit Stacking
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "HABIT STACKING REINFORCEMENT",
                  style: GoogleFonts.orbitron(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "• Immediately after my morning routine, I will check the Quest Board.",
                  style: GoogleFonts.exo2(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "• When I arrive home, I will log my healthy meal checklist.",
                  style: GoogleFonts.exo2(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.4,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          // objectives
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "🎯 CURRENT CAMPAIGN OBJECTIVES",
                  style: GoogleFonts.orbitron(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: profile.currentElement.primaryColor,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Active Focuses: ",
                          style: GoogleFonts.exo2(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            profile.selectedFocuses.map((f) => f.displayName).join(', '),
                            style: GoogleFonts.exo2(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Weight Goal: ",
                          style: GoogleFonts.exo2(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${profile.goalWeight.toInt()} lbs (Starting from ${profile.startWeight.toInt()} lbs)",
                            style: GoogleFonts.exo2(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daily Cardio: ",
                          style: GoogleFonts.exo2(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${profile.distanceGoal.toStringAsFixed(1)} miles",
                            style: GoogleFonts.exo2(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildElementFlavorSprite(UserProfileManager profile) {
    final name = profile.currentElement.name;
    final primary = profile.currentElement.primaryColor;
    final accent = profile.currentElement.accentColor;

    IconData icon;
    switch (name) {
      case "Fire":
        icon = Icons.whatshot;
        break;
      case "Water":
        icon = Icons.water_drop;
        break;
      case "Earth":
        icon = Icons.eco;
        break;
      case "Air":
        icon = Icons.air;
        break;
      case "Lightning":
        icon = Icons.bolt;
        break;
      case "Metal":
        icon = Icons.shield;
        break;
      case "Ice":
        icon = Icons.ac_unit;
        break;
      case "Bone":
        icon = Icons.animation;
        break;
      case "Gas":
        icon = Icons.cloud;
        break;
      case "Laser":
        icon = Icons.center_focus_strong;
        break;
      case "Zero Space":
        icon = Icons.public;
        break;
      case "Darki":
        icon = Icons.workspace_premium;
        break;
      case "Death":
        icon = Icons.error_outline;
        break;
      case "Knife":
        icon = Icons.colorize;
        break;
      case "Poison":
        icon = Icons.science;
        break;
      case "Shadow":
        icon = Icons.nights_stay;
        break;
      default:
        icon = Icons.stars;
    }

    return AnimatedBuilder(
      animation: _bobAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_bobAnimation.value * 0.5),
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(color: primary, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.4),
                  blurRadius: 3,
                  spreadRadius: 1,
                )
              ]
            ),
            child: Icon(
              icon,
              size: 10,
              color: accent,
            ),
          ),
        );
      }
    );
  }
  Widget _buildMonthlyChallengeCard(UserProfileManager profile) {
    final challenge = profile.activeMonthlyChallenge;
    final themeColor = profile.currentElement.primaryColor;
    final progressPercent = challenge.targetAmount > 0
        ? (challenge.currentAmount / challenge.targetAmount).clamp(0.0, 1.0)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: themeColor.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "MONTHLY CHALLENGE: ${challenge.monthName.toUpperCase()}",
                  style: GoogleFonts.orbitron(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                    letterSpacing: 2,
                  ),
                ),
                const Text(
                  "🏆 Badge Reward",
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Text(
              challenge.targetDescription,
              style: GoogleFonts.exo2(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${challenge.currentAmount.toInt()} / ${challenge.targetAmount.toInt()} ${challenge.targetMetric}",
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  "${(progressPercent * 100).toInt()}%",
                  style: GoogleFonts.orbitron(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressPercent,
                minHeight: 6,
                backgroundColor: Colors.white.withOpacity(0.06),
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Auto-advances via quests, or manually log reps/miles:",
                    style: TextStyle(fontSize: 8, color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    profile.advanceMonthlyChallenge(
                      challenge.targetMetric == "reps" ? 50.0 : (challenge.targetMetric == "Liters" ? 3.0 : 1.0),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor.withOpacity(0.12),
                    foregroundColor: themeColor,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "+ Log Progress",
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeightHistoryChart extends StatelessWidget {
  final List<WeightEntry> history;
  final double startWeight;
  final double goalWeight;
  final Color primaryColor;

  const _WeightHistoryChart({
    required this.history,
    required this.startWeight,
    required this.goalWeight,
    required this.primaryColor,
  });

  String _formatDate(DateTime date) {
    return "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "No weight records yet.",
            style: GoogleFonts.exo2(fontSize: 11, color: Colors.grey),
          ),
        ),
      );
    }

    final recentHistory = history.length > 7 ? history.sublist(history.length - 7) : history;
    final weights = history.map((w) => w.weight).toList();
    
    double minW = weights.isEmpty ? 0.0 : weights.reduce((a, b) => a < b ? a : b);
    double maxW = weights.isEmpty ? 0.0 : weights.reduce((a, b) => a > b ? a : b);
    
    if (startWeight < minW) minW = startWeight;
    if (goalWeight < minW) minW = goalWeight;
    if (startWeight > maxW) maxW = startWeight;
    if (goalWeight > maxW) maxW = goalWeight;

    minW -= 5.0;
    maxW += 5.0;
    final diff = maxW - minW;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: recentHistory.map((entry) {
        final heightPercent = diff > 0 ? (entry.weight - minW) / diff : 0.5;
        final barHeight = (heightPercent * 40).clamp(0.0, 40.0) + 4.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              entry.weight.toStringAsFixed(0),
              style: const TextStyle(fontSize: 8, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Container(
              width: 16,
              height: barHeight,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(entry.date),
              style: const TextStyle(fontSize: 8, color: Colors.grey),
            ),
          ],
        );
      }).toList(),
    );
  }
}
