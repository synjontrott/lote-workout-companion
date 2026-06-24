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
  }

  @override
  void dispose() {
    _bobController.dispose();
    _sprintTimer?.cancel();
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

    return Scaffold(
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
                                      pixelSize: 4.0,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                )
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
                          target: 10000.0,
                          unit: "steps",
                          icon: Icons.directions_walk,
                          themeColor: profile.currentElement.primaryColor,
                        ),
                        const SizedBox(height: 12),
                        _buildMetricGauge(
                          title: "Active Energy",
                          current: health.todayCalories,
                          target: 500.0,
                          unit: "kcal",
                          icon: Icons.local_fire_department,
                          themeColor: profile.currentElement.primaryColor,
                        ),
                        const SizedBox(height: 12),
                        _buildMetricGauge(
                          title: "Training Time",
                          current: health.activeMinutes,
                          target: 30.0,
                          unit: "mins",
                          icon: Icons.timer,
                          themeColor: profile.currentElement.primaryColor,
                        ),
                      ],
                    ),
                  ),
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
          )
        ],
      ),
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
    final stepsDone = health.todaySteps >= 10000.0;
    final calDone = health.todayCalories >= 500.0;
    final minsDone = health.activeMinutes >= 30.0;
    final mealDone = profile.healthyMealsLoggedToday > 0;

    double completionPct = 0.0;
    int itemsCompleted = 0;
    if (stepsDone) itemsCompleted++;
    if (calDone) itemsCompleted++;
    if (minsDone) itemsCompleted++;
    if (mealDone) itemsCompleted++;
    completionPct = (itemsCompleted / 4) * 100;

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
                _buildChecklistRow("Steps Quota (10k steps)", stepsDone),
                const SizedBox(height: 8),
                _buildChecklistRow("Active Calories Burned (500 kcal)", calDone),
                const SizedBox(height: 8),
                _buildChecklistRow("Completed Today's Active Minutes (30m)", minsDone),
                const SizedBox(height: 8),
                _buildChecklistRow("Nourishing Healthy Rations Logged", mealDone),
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
                          "Calisthenics: ",
                          style: GoogleFonts.exo2(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            profile.calisthenicsGoal,
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
                          "Lifting: ",
                          style: GoogleFonts.exo2(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            profile.liftingGoal,
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
                          "Custom: ",
                          style: GoogleFonts.exo2(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            profile.customGoal,
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
}
