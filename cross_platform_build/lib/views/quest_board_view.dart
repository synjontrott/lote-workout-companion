import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../managers/user_profile_manager.dart';
import '../models/lote_models.dart';

class QuestBoardView extends StatefulWidget {
  const QuestBoardView({super.key});

  @override
  State<QuestBoardView> createState() => _QuestBoardViewState();
}

class _QuestBoardViewState extends State<QuestBoardView> with TickerProviderStateMixin {
  LotEQuest? _selectedQuest;

  // Dice rolling state variables
  bool _isRolling = false;
  int _diceResult = 1;
  late AnimationController _spinController;

  // Dopamine Menu items
  final List<Map<String, dynamic>> _dopamineMenu = const [
    {"name": "Flame Dash (20 Jumping Jacks)", "icon": Icons.bolt, "xp": 15, "crystals": 5},
    {"name": "Terra Stomp (15 Body squats)", "icon": Icons.eco, "xp": 15, "crystals": 5},
    {"name": "Aether Breath (10 Deep inhalations)", "icon": Icons.air, "xp": 10, "crystals": 3},
    {"name": "Zephyr Spin (2 Min shadow boxing or dancing)", "icon": Icons.music_note, "xp": 20, "crystals": 8},
    {"name": "Iron Guard (30 Sec forearm plank)", "icon": Icons.shield, "xp": 15, "crystals": 5},
  ];

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  IconData _iconForWorkoutCategory(WorkoutCategory cat) {
    switch (cat) {
      case WorkoutCategory.cardio:
        return Icons.directions_run;
      case WorkoutCategory.strength:
        return Icons.fitness_center;
      case WorkoutCategory.flexibility:
        return Icons.accessibility_new;
      case WorkoutCategory.nutrition:
        return Icons.restaurant_menu;
      case WorkoutCategory.meditation:
        return Icons.self_improvement;
    }
  }

  void _completeDopamineTask(UserProfileManager profile, String name, int xp, int crystals) {
    profile.addXP(xp);
    profile.earnCrystals(crystals);

    _showOutcomeDialog(
      title: "BURST SENSORY COMPLETE! 🎉",
      message: "Completed: $name! You earned $xp XP and $crystals Crystals instantly. Keep that momentum rolling!",
      themeColor: profile.currentElement.primaryColor,
    );
  }

  void _logHealthyMeal(UserProfileManager profile) {
    profile.logHealthyMeal();

    _showOutcomeDialog(
      title: "MEAL LOGGED! 🍏",
      message: "Logged healthy rations! You consume high-nutrition energy cubes, earning +15 XP, +10 Crystals, and +1 Constitution.",
      themeColor: profile.currentElement.primaryColor,
    );
  }

  void _rollDiceAndResolve(UserProfileManager profile, LotEQuest quest) {
    setState(() {
      _isRolling = true;
    });
    _spinController.repeat();

    int tickCount = 0;
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      setState(() {
        _diceResult = Random().nextInt(20) + 1;
      });
      tickCount++;
      if (tickCount > 10) {
        timer.cancel();
        _spinController.stop();
        _resolveQuest(profile, quest);
      }
    });
  }

  void _resolveQuest(UserProfileManager profile, LotEQuest quest) {
    setState(() {
      _isRolling = false;
    });

    final statBonus = profile.stats.getModifier(quest.statReward);
    final totalVal = _diceResult + statBonus;
    final success = totalVal >= quest.difficultyRoll;

    if (success) {
      profile.completeQuest(quest, _diceResult);
      _showOutcomeDialog(
        title: "QUEST SUCCESS! 🎉",
        message: "You rolled a $_diceResult + $statBonus modifier = $totalVal! You cleared the DC ${quest.difficultyRoll} check! Earning ${quest.rewardXP} XP, ${quest.rewardCrystals} Crystals, and +1 to ${quest.statReward.displayName}!",
        themeColor: Colors.green,
        onDismiss: () {
          setState(() {
            _selectedQuest = null;
          });
        },
      );
    } else {
      profile.addXP((quest.rewardXP / 3).floor());
      _showOutcomeDialog(
        title: "QUEST FAILED! ⚔️",
        message: "You rolled a $_diceResult + $statBonus modifier = $totalVal. Unfortunately, you failed to clear the DC ${quest.difficultyRoll} check. You receive ${(quest.rewardXP / 3).floor()} XP in training lessons. Try again tomorrow or build up your modifiers!",
        themeColor: Colors.red,
        onDismiss: () {
          setState(() {
            _selectedQuest = null;
          });
        },
      );
    }
  }

  void _showOutcomeDialog({
    required String title,
    required String message,
    required Color themeColor,
    VoidCallback? onDismiss,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0C0C0C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: themeColor.withOpacity(0.4), width: 1.5),
          ),
          title: Text(
            title,
            style: GoogleFonts.orbitron(
              color: themeColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            style: GoogleFonts.exo2(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onDismiss != null) onDismiss();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Acknowledge",
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfileManager>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Stack(
        children: [
          // Scrollable board contents
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title
                Center(
                  child: Column(
                    children: [
                      Text(
                        "GUILD QUEST BOARD",
                        style: GoogleFonts.orbitron(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Complete quests to forge stats and levels",
                        style: GoogleFonts.exo2(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // ADHD / AuDHD Dopamine Menu Section
                if (profile.cognitiveProfile == CognitiveProfile.adhd ||
                    profile.cognitiveProfile == CognitiveProfile.audhd) ...[
                  _buildDopamineQuickMenu(profile),
                  const SizedBox(height: 25),
                ],

                // Daily Warrior Challenges
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "DAILY WARRIOR CHALLENGES",
                    style: GoogleFonts.orbitron(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: profile.dailyQuests.map((quest) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedQuest = quest;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.02),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: quest.isCompleted
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.white.withOpacity(0.08),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Icon
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: quest.isCompleted
                                        ? Colors.green.withOpacity(0.2)
                                        : profile.currentElement.primaryColor.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    _iconForWorkoutCategory(quest.workoutType),
                                    color: quest.isCompleted
                                        ? Colors.green
                                        : profile.currentElement.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Title / Desc
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        quest.title,
                                        style: GoogleFonts.exo2(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          decoration: quest.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          decorationColor: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        quest.questDescription,
                                        style: GoogleFonts.exo2(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Reward / Status
                                if (quest.isCompleted)
                                  const Icon(Icons.check_circle, color: Colors.green)
                                else
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          "DC ${quest.difficultyRoll}",
                                          style: GoogleFonts.orbitron(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "+${quest.rewardXP} XP",
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 25),

                // Healthy Food Inventory Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "HEALTHY FOOD INVENTORY",
                    style: GoogleFonts.orbitron(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nourish your Elsaither energy",
                                style: GoogleFonts.exo2(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Log a healthy meal to build CON and crystals.",
                                style: GoogleFonts.exo2(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => _logHealthyMeal(profile),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: profile.currentElement.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "LOG MEAL",
                            style: GoogleFonts.orbitron(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          // Dice Roll Modal Overlay
          if (_selectedQuest != null)
            _buildDiceRollOverlay(profile, _selectedQuest!),
        ],
      ),
    );
  }

  Widget _buildDopamineQuickMenu(UserProfileManager profile) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.15)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.flash_on, color: Colors.orange, size: 18),
                const SizedBox(width: 8),
                Text(
                  "DOPAMINE QUICK MENU",
                  style: GoogleFonts.orbitron(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Short on executive energy? Tap a quick burst to build momentum:",
              style: GoogleFonts.exo2(fontSize: 11, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _dopamineMenu.length,
              itemBuilder: (context, idx) {
                final item = _dopamineMenu[idx];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () => _completeDopamineTask(
                      profile,
                      item["name"],
                      item["xp"],
                      item["crystals"],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 130,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: profile.currentElement.primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item["icon"],
                            color: profile.currentElement.primaryColor,
                            size: 24,
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: Text(
                              item["name"],
                              style: GoogleFonts.exo2(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "+${item["xp"]} XP / +${item["crystals"]} 💎",
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDiceRollOverlay(UserProfileManager profile, LotEQuest quest) {
    final statBonus = profile.stats.getModifier(quest.statReward);
    final isCompleted = quest.isCompleted;

    return Positioned.fill(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Dim
          GestureDetector(
            onTap: () {
              if (!_isRolling) {
                setState(() {
                  _selectedQuest = null;
                });
              }
            },
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          // Dialog Box
          Container(
            width: 310,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFF0C0C0C),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: profile.currentElement.primaryColor.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  quest.title.toUpperCase(),
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  quest.questDescription,
                  style: GoogleFonts.exo2(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // D20 Graphic
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow background
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: profile.currentElement.primaryColor.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    // Hexagon Spin
                    RotationTransition(
                      turns: _spinController,
                      child: Icon(
                        Icons.hexagon,
                        size: 110,
                        color: _isRolling ? Colors.orange : profile.currentElement.primaryColor,
                      ),
                    ),
                    // Result text
                    Text(
                      "$_diceResult",
                      style: GoogleFonts.orbitron(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  "Your Modifier: +$statBonus (${quest.statReward.displayName})",
                  style: GoogleFonts.exo2(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                if (isCompleted)
                  Text(
                    "Quest Completed!",
                    style: GoogleFonts.exo2(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: _isRolling ? null : () => _rollDiceAndResolve(profile, quest),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: profile.currentElement.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _isRolling ? "ROLLING..." : "ROLL D20 (DC ${quest.difficultyRoll})",
                      style: GoogleFonts.orbitron(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
