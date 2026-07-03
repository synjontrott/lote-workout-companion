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
  String _selectedHistoryType = 'Weight';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profile.checkBadges(health);
    });

    final themeColor = profile.currentElement.primaryColor;
    final accentColor = profile.currentElement.accentColor;

    // Map retro character custom pixel colors
    final skin = hexToColor(profile.sprite.skinColorHex);
    final hair = hexToColor(profile.sprite.hairColorHex);
    final outfit = hexToColor(profile.sprite.outfitColorHex);
    final eye = profile.currentElement.primaryColor;
    final aura = () {
      if (profile.equippedAura != "None") {
        switch (profile.equippedAura) {
          case "Glitch Aura": return const Color(0xFF00F0FF);
          case "Phoenix Flare": return Colors.orange;
          case "Abyssal Mist": return const Color(0xFF880E4F);
          case "Lightning Spark": return Colors.yellow;
          default: return profile.currentElement.accentColor;
        }
      } else {
        return profile.currentElement.accentColor;
      }
    }();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: () {
            if (profile.equippedBackground == "Neon Cyber Space") {
              return const LinearGradient(
                colors: [Color(0xFF050B14), Color(0xFF0A192F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              );
            } else if (profile.equippedBackground == "Nebula Starfield") {
              return const LinearGradient(
                colors: [Color(0xFF0B071E), Color(0xFF1F1235)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              );
            } else if (profile.equippedBackground == "Volcanic Core") {
              return const LinearGradient(
                colors: [Color(0xFF140505), Color(0xFF2D0A0A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              );
            } else {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  themeColor.withValues(alpha: 0.15),
                  const Color(0xFF090D16),
                  const Color(0xFF020408),
                ],
              );
            }
          }(),
        ),
        child: Stack(
          children: [
            // Background elemental theme glow
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 40,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColor.withValues(alpha: 0.08),
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
                    child: GestureDetector(
                      onTap: () => showActivityHistory(context, profile),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.02),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: profile.currentElement.primaryColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        gradient: profile.equippedBackground != "None" ? LinearGradient(
                          colors: (() {
                            switch (profile.equippedBackground) {
                              case "Neon Cyber Space":
                                return [const Color(0xFF0A192F).withValues(alpha: 0.45), const Color(0xFF172A45).withValues(alpha: 0.2)];
                              case "Nebula Starfield":
                                return [const Color(0xFF1F1235).withValues(alpha: 0.45), const Color(0xFF362259).withValues(alpha: 0.2)];
                              case "Volcanic Core":
                                return [const Color(0xFF2D0A0A).withValues(alpha: 0.45), const Color(0xFF501B1B).withValues(alpha: 0.2)];
                              default:
                                return [profile.currentElement.primaryColor.withValues(alpha: 0.35), Colors.transparent];
                            }
                          })(),
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
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: profile.currentElement.primaryColor.withValues(alpha: 0.12),
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
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: auraColor.withValues(alpha: 0.15),
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
                                      pixelSize: 0.3,
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
                                    color: profile.currentElement.primaryColor.withValues(alpha: 0.2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: profile.currentElement.primaryColor.withValues(alpha: 0.6),
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
                                            color: frameColor.withValues(alpha: 0.4),
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
                                         color: Colors.orange.withValues(alpha: 0.12),
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
                            color: Colors.red.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.3),
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
                          element: profile.currentElement,
                        ),
                        const SizedBox(height: 12),
                        _buildMetricGauge(
                          title: "Active Energy",
                          current: health.todayCalories,
                          target: profile.caloriesGoal,
                          unit: "kcal",
                          icon: Icons.local_fire_department,
                          element: profile.currentElement,
                        ),
                        const SizedBox(height: 12),
                        _buildMetricGauge(
                          title: "Training Time",
                          current: health.activeMinutes,
                          target: profile.activeMinutesGoal,
                          unit: "mins",
                          icon: Icons.timer,
                          element: profile.currentElement,
                        ),
                        const SizedBox(height: 12),
                        _buildMetricGauge(
                          title: "Stand Hours",
                          current: health.todayStandHours,
                          target: profile.standHoursGoal,
                          unit: "hours",
                          icon: Icons.accessibility_new,
                          element: profile.currentElement,
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
                        final sugarPercent = (loggedSugar / profile.targetSugar).clamp(0.0, 1.0);
                        final exceeded = loggedSugar > profile.targetSugar;

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.02),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: exceeded ? Colors.red.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.06),
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
                                    "${loggedSugar.toStringAsFixed(1)} / ${profile.targetSugar.toStringAsFixed(1)} g",
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
                                  backgroundColor: Colors.white.withValues(alpha: 0.1),
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
                                          : "Keep sugar under ${profile.targetSugar.toStringAsFixed(0)}g daily to maintain clean energy flow.",
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
                        color: Colors.white.withValues(alpha: 0.02),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
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
                                      backgroundColor: Colors.white.withValues(alpha: 0.1),
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
                                      backgroundColor: Colors.white.withValues(alpha: 0.1),
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
                                        color: Colors.orange.withValues(alpha: 0.08),
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
                              Row(
                                children: [
                                  Text(
                                    _selectedHistoryType == "Weight" ? "Weight History Log" : "$_selectedHistoryType PR History",
                                    style: GoogleFonts.exo2(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  PopupMenuButton<String>(
                                    onSelected: (String val) {
                                      setState(() {
                                        _selectedHistoryType = val;
                                      });
                                    },
                                    color: const Color(0xFF0F0F0F),
                                    icon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _selectedHistoryType == "Weight"
                                              ? "Weight"
                                              : (_selectedHistoryType == "Run (Miles)"
                                                  ? (profile.useImperialUnits ? "Run (Miles)" : "Run (KM)")
                                                  : (["Bench Press", "Deadlift", "Barbell Squat", "Overhead Press"].contains(_selectedHistoryType)
                                                      ? (profile.useImperialUnits ? "$_selectedHistoryType (LBS)" : "$_selectedHistoryType (KG)")
                                                      : _selectedHistoryType)),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: themeColor,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(Icons.arrow_drop_down, color: themeColor, size: 14),
                                      ],
                                    ),
                                    itemBuilder: (BuildContext context) {
                                      final items = ["Weight", "Pullups", "Pushups", "Squats", "Dips", "Bench Press", "Deadlift", "Barbell Squat", "Overhead Press", "Run (Miles)", "Handstand Hold (Sec)"];
                                      return items.map((key) {
                                        final label = key == "Weight"
                                            ? "Weight"
                                            : (key == "Run (Miles)"
                                                ? (profile.useImperialUnits ? "Run PR (Miles)" : "Run PR (KM)")
                                                : (["Bench Press", "Deadlift", "Barbell Squat", "Overhead Press"].contains(key)
                                                    ? (profile.useImperialUnits ? "$key PR (LBS)" : "$key PR (KG)")
                                                    : "$key PR"));
                                        return PopupMenuItem<String>(
                                          value: key,
                                          child: Text(
                                            label,
                                            style: const TextStyle(color: Colors.white, fontSize: 11),
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 70,
                                child: _selectedHistoryType == "Weight"
                                    ? _WeightHistoryChart(
                                        history: profile.weightHistory,
                                        startWeight: profile.startWeight,
                                        goalWeight: profile.goalWeight,
                                        primaryColor: profile.currentElement.primaryColor,
                                      )
                                    : Builder(builder: (context) {
                                        final historyList = profile.prHistory[_selectedHistoryType] ?? [];
                                        final convertedPoints = historyList.map((entry) {
                                          double val = entry.value;
                                          if (!profile.useImperialUnits) {
                                            if (["Bench Press", "Deadlift", "Barbell Squat", "Overhead Press"].contains(_selectedHistoryType)) {
                                              val = val * 0.45359237;
                                            } else if (_selectedHistoryType == "Run (Miles)") {
                                              val = val * 1.609344;
                                            }
                                          }
                                          return (date: entry.date, value: val);
                                        }).toList();
                                        return _ProgressHistoryChart(
                                          points: convertedPoints,
                                          primaryColor: profile.currentElement.primaryColor,
                                        );
                                      }),
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
                                      color: Colors.white.withValues(alpha: 0.8),
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
                                  child: Builder(
                                    builder: (context) {
                                      final reversedHistory = profile.measurementHistory.reversed.toList();
                                      return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: reversedHistory.length,
                                    itemBuilder: (context, index) {
                                      final entry = reversedHistory[index];
                                      final dateStr = "${entry.date.month}/${entry.date.day}/${entry.date.year}";
                                      return Container(
                                        width: 140,
                                        margin: const EdgeInsets.only(right: 12),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.04),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.white.withValues(alpha: 0.08),
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
    ),
  ),
);
  }

  Widget _buildMeasurementLogModal(UserProfileManager profile) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.85),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF151515),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: profile.currentElement.primaryColor.withValues(alpha: 0.3),
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
                          label: profile.useImperialUnits ? "WEIGHT (LBS)" : "WEIGHT (KG)",
                          controller: _measureWeightController,
                          hint: profile.useImperialUnits ? "lbs" : "kg",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildModalTextField(
                          label: profile.useImperialUnits ? "CHEST (INCHES)" : "CHEST (CM)",
                          controller: _measureChestController,
                          hint: profile.useImperialUnits ? "inches" : "cm",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildModalTextField(
                          label: profile.useImperialUnits ? "ARMS (INCHES)" : "ARMS (CM)",
                          controller: _measureArmsController,
                          hint: profile.useImperialUnits ? "inches" : "cm",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildModalTextField(
                          label: profile.useImperialUnits ? "WAIST (INCHES)" : "WAIST (CM)",
                          controller: _measureWaistController,
                          hint: profile.useImperialUnits ? "inches" : "cm",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildModalTextField(
                          label: profile.useImperialUnits ? "HIPS (INCHES)" : "HIPS (CM)",
                          controller: _measureHipsController,
                          hint: profile.useImperialUnits ? "inches" : "cm",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildModalTextField(
                          label: profile.useImperialUnits ? "LEGS (INCHES)" : "LEGS (CM)",
                          controller: _measureLegsController,
                          hint: profile.useImperialUnits ? "inches" : "cm",
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
            fillColor: Colors.white.withValues(alpha: 0.04),
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
    required LotEElement element,
  }) {
    final pct = (current / target).clamp(0.0, 1.0);
    final pctStr = "${(pct * 100).toStringAsFixed(1)}%";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: element.primaryColor.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: element.primaryColor.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: element.accentColor, size: 16),
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
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${current.toInt()} / ${target.toInt()} $unit ",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                    TextSpan(
                      text: "($pctStr)",
                      style: GoogleFonts.orbitron(
                        fontSize: 10,
                        color: element.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 8,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: constraints.maxWidth * pct,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          element.primaryColor,
                          element.accentColor,
                          element.secondaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: element.primaryColor.withValues(alpha: 0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
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
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
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
              color: Colors.orange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
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
                    color: Colors.white.withValues(alpha: 0.75),
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
    final sugarDone = profile.todaySugar <= profile.targetSugar;

    double completionPct = 0.0;
    double totalProgress = 0.0;
    totalProgress += profile.stepsGoal > 0 ? (health.todaySteps / profile.stepsGoal).clamp(0.0, 1.0) : 1.0;
    totalProgress += profile.caloriesGoal > 0 ? (health.todayCalories / profile.caloriesGoal).clamp(0.0, 1.0) : 1.0;
    totalProgress += profile.activeMinutesGoal > 0 ? (health.activeMinutes / profile.activeMinutesGoal).clamp(0.0, 1.0) : 1.0;
    totalProgress += profile.standHoursGoal > 0 ? (health.todayStandHours / profile.standHoursGoal).clamp(0.0, 1.0) : 1.0;
    totalProgress += profile.todaySugar <= profile.targetSugar ? 1.0 : 0.0;
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
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
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
                _buildChecklistRow("Sugar Intake (${profile.todaySugar.toStringAsFixed(1)}g/${profile.targetSugar.toStringAsFixed(1)}g max)", sugarDone),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // System Metric logs
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
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
              color: Colors.purple.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
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
                    color: Colors.white.withValues(alpha: 0.85),
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
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
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
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "• When I arrive home, I will log my healthy meal checklist.",
                  style: GoogleFonts.exo2(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.8),
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
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
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
                  color: primary.withValues(alpha: 0.4),
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
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: themeColor.withValues(alpha: 0.15),
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
                backgroundColor: Colors.white.withValues(alpha: 0.06),
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
                    final double amount = challenge.targetMetric == "reps" ? 50.0 : (challenge.targetMetric == "Liters" ? 3.0 : 1.0);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFF0C0C0C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: themeColor.withValues(alpha: 0.4), width: 1.5),
                          ),
                          title: Text(
                            "LOG PROGRESS?",
                            style: GoogleFonts.orbitron(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                              letterSpacing: 2,
                            ),
                          ),
                          content: Text(
                            "Confirm adding +${amount.toInt()} ${challenge.targetMetric} toward your ${challenge.monthName} monthly challenge: \"${challenge.targetDescription}\"?",
                            style: GoogleFonts.exo2(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(
                                "CANCEL",
                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                profile.advanceMonthlyChallenge(amount);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "LOG PROGRESS",
                                style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor.withValues(alpha: 0.12),
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

void showActivityHistory(BuildContext context, UserProfileManager profile) {
  showDialog(
    context: context,
    builder: (ctx) {
      final sessions = profile.loggedWorkoutSessions.reversed.toList();
      final meals = profile.loggedMeals.reversed.toList();
      
      final List<dynamic> combined = [...sessions, ...meals];
      combined.sort((a, b) => (b.date as DateTime).compareTo(a.date as DateTime));

      return Dialog(
        backgroundColor: const Color(0xFF0C0C0C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: profile.currentElement.primaryColor.withValues(alpha: 0.3)),
        ),
        child: Container(
          width: double.maxFinite,
          height: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "ACTIVITY LOG",
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: combined.isEmpty
                    ? const Center(child: Text("No activity logged yet.", style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        itemCount: combined.length,
                        itemBuilder: (ctx, idx) {
                          final item = combined[idx];
                          if (item.runtimeType.toString() == 'WorkoutSession') {
                            return ListTile(
                              leading: Icon(Icons.fitness_center, color: profile.currentElement.primaryColor),
                              title: Text("${item.type} Workout", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: Text("${item.durationMinutes.toStringAsFixed(1)} min • ${item.date.month}/${item.date.day}", style: const TextStyle(color: Colors.grey)),
                            );
                          } else {
                            return ListTile(
                              leading: const Icon(Icons.restaurant, color: Colors.green),
                              title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: Text("${item.calories.toStringAsFixed(0)} kcal • ${item.date.month}/${item.date.day}", style: const TextStyle(color: Colors.grey)),
                            );
                          }
                        },
                      ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text("CLOSE", style: TextStyle(color: profile.currentElement.primaryColor)),
              )
            ],
          ),
        ),
      );
    },
  );
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

class _ProgressHistoryChart extends StatelessWidget {
  final List<({DateTime date, double value})> points;
  final Color primaryColor;

  const _ProgressHistoryChart({
    required this.points,
    required this.primaryColor,
  });

  String _formatDate(DateTime date) {
    return "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "No log entries yet.",
            style: GoogleFonts.exo2(fontSize: 11, color: Colors.grey),
          ),
        ),
      );
    }

    final recentPoints = points.length > 7 ? points.sublist(points.length - 7) : points;
    final values = points.map((p) => p.value).toList();
    
    double minVal = values.isEmpty ? 0.0 : values.reduce((a, b) => a < b ? a : b);
    double maxVal = values.isEmpty ? 0.0 : values.reduce((a, b) => a > b ? a : b);
    
    minVal *= 0.9;
    maxVal *= 1.1;
    final diff = maxVal - minVal;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: recentPoints.map((entry) {
        final heightPercent = diff > 0 ? (entry.value - minVal) / diff : 0.5;
        final barHeight = (heightPercent * 40).clamp(0.0, 40.0) + 4.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              entry.value.toStringAsFixed(1),
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
