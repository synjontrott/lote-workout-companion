import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../managers/user_profile_manager.dart';
import '../managers/health_manager.dart';
import '../models/lote_models.dart';

class QuestBoardView extends StatefulWidget {
  const QuestBoardView({super.key});

  @override
  State<QuestBoardView> createState() => _QuestBoardViewState();
}

class _QuestBoardViewState extends State<QuestBoardView> with TickerProviderStateMixin {
  LotEQuest? _selectedQuest;
  QuestCadence _selectedCadence = QuestCadence.daily;

  // Dopamine Item detail selection
  Map<String, dynamic>? _selectedDopamineItem;

  // Detailed meal log states
  bool _showingMealLog = false;
  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _mealCaloriesController = TextEditingController();
  final TextEditingController _mealProteinController = TextEditingController();
  final TextEditingController _mealCarbsController = TextEditingController();
  final TextEditingController _mealFatsController = TextEditingController();
  final TextEditingController _mealSugarController = TextEditingController();

  // Suggested Workout Tailoring states
  String _tailGender = "Male";
  String _tailAge = "30";
  String _tailWeight = "170";
  String _tailEquipment = "Bodyweight Only";
  String _tailDifficulty = "Medium";
  MuscleGroup _tailMuscleGroup = MuscleGroup.chest;

  // Dice/animation controller (stub, unused now but kept for compatibility)
  late AnimationController _spinController;

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
    _mealNameController.dispose();
    _mealCaloriesController.dispose();
    _mealProteinController.dispose();
    _mealCarbsController.dispose();
    _mealFatsController.dispose();
    _mealSugarController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _tailoredDopamineMenu(UserProfileManager profile) {
    List<Map<String, dynamic>> menu = [];
    final element = profile.currentElement.name;
    
    String adj;
    switch (element) {
      case "Fire": adj = "Flame"; break;
      case "Water": adj = "Tidal"; break;
      case "Earth": adj = "Terra"; break;
      case "Air": adj = "Zephyr"; break;
      case "Lightning": adj = "Volt"; break;
      case "Metal": adj = "Iron"; break;
      case "Ice": adj = "Frost"; break;
      case "Bone": adj = "Marrow"; break;
      case "Gas": adj = "Vapor"; break;
      case "Laser": adj = "Photon"; break;
      case "Zero Space": adj = "Void"; break;
      case "Darki": adj = "Umbral"; break;
      case "Death": adj = "Decay"; break;
      case "Knife": adj = "Razor"; break;
      case "Poison": adj = "Toxic"; break;
      case "Shadow": adj = "Phantom"; break;
      default: adj = "Astral";
    }
    
    final focuses = profile.selectedFocuses.isEmpty
        ? [TrainingFocus.calisthenics, TrainingFocus.cardio]
        : profile.selectedFocuses;
        
    for (var focus in focuses) {
      switch (focus) {
        case TrainingFocus.calisthenics:
          menu.add({"name": "$adj Defiance (10 Pushups)", "icon": Icons.directions_run, "xp": 15, "crystals": 5});
          menu.add({"name": "$adj Lever (15s hollow hold)", "icon": Icons.shield, "xp": 15, "crystals": 5});
          break;
        case TrainingFocus.lifting:
          menu.add({"name": "$adj Load (15 body squats)", "icon": Icons.fitness_center, "xp": 15, "crystals": 5});
          menu.add({"name": "$adj Press (10 overhead raises)", "icon": Icons.fitness_center, "xp": 15, "crystals": 5});
          break;
        case TrainingFocus.cardio:
          menu.add({"name": "$adj Dash (30 High knees)", "icon": Icons.flash_on, "xp": 15, "crystals": 5});
          menu.add({"name": "$adj Jog (1 Min walk in place)", "icon": Icons.directions_run, "xp": 20, "crystals": 6});
          break;
        case TrainingFocus.flexibility:
          menu.add({"name": "$adj Alignment (30s toe stretch)", "icon": Icons.accessibility_new, "xp": 15, "crystals": 5});
          menu.add({"name": "$adj Flow (1 Min ankle mobility)", "icon": Icons.accessibility_new, "xp": 10, "crystals": 3});
          break;
        case TrainingFocus.cutting:
          menu.add({"name": "$adj Cleanse (Drink cold water)", "icon": Icons.opacity, "xp": 10, "crystals": 3});
          break;
        case TrainingFocus.bulking:
          menu.add({"name": "$adj Nourish (Protein snack log)", "icon": Icons.restaurant_menu, "xp": 10, "crystals": 3});
          break;
      }
    }
    
    if (menu.isEmpty) {
      menu.add({"name": "$adj Focus (30s deep breathing)", "icon": Icons.self_improvement, "xp": 10, "crystals": 3});
    }
    
    return menu.take(5).toList();
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

  int _getQuestIndex(UserProfileManager profile, String id, QuestCadence cadence) {
    if (cadence == QuestCadence.daily) {
      return profile.dailyQuests.indexWhere((q) => q.id == id);
    } else if (cadence == QuestCadence.monthly) {
      return profile.monthlyQuests.indexWhere((q) => q.id == id);
    } else {
      return profile.yearlyQuests.indexWhere((q) => q.id == id);
    }
  }

  LotEQuest _getQuestAt(UserProfileManager profile, int index, QuestCadence cadence) {
    if (cadence == QuestCadence.daily) {
      return profile.dailyQuests[index];
    } else if (cadence == QuestCadence.monthly) {
      return profile.monthlyQuests[index];
    } else {
      return profile.yearlyQuests[index];
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfileManager>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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

                // Segmented picker for Quest Cadence
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: QuestCadence.values.map((cadence) {
                      final isSelected = _selectedCadence == cadence;
                      final cadenceName = cadence.name[0].toUpperCase() + cadence.name.substring(1);
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Container(
                              alignment: Alignment.center,
                              child: Text(
                                cadenceName,
                                style: GoogleFonts.orbitron(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.grey,
                                ),
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: profile.currentElement.primaryColor,
                            backgroundColor: Colors.white.withOpacity(0.04),
                            onSelected: (val) {
                              if (val) {
                                setState(() {
                                  _selectedCadence = cadence;
                                });
                              }
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 25),

                // ADHD / AuDHD Dopamine Menu Section
                if (profile.cognitiveProfile == CognitiveProfile.adhd ||
                    profile.cognitiveProfile == CognitiveProfile.audhd) ...[
                  _buildDopamineQuickMenu(profile),
                  const SizedBox(height: 25),
                ],

                // Campaigns Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${_selectedCadence.name.toUpperCase()} WARRIOR CAMPAIGNS",
                        style: GoogleFonts.orbitron(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 2,
                        ),
                      ),
                      if (_selectedCadence == QuestCadence.daily)
                        ElevatedButton.icon(
                          onPressed: () {
                            profile.logRestDay();
                            _showOutcomeDialog(
                              title: "REST DAY LOGGED",
                              message: "Rest Day logged successfully! Your consecutive workout streak has been preserved and your muscles recovered.",
                              themeColor: Colors.cyan,
                            );
                          },
                          icon: const Icon(Icons.king_bed, size: 14, color: Colors.cyan),
                          label: Text(
                            "REST DAY",
                            style: GoogleFonts.orbitron(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan.withOpacity(0.15),
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Builder(
                    builder: (context) {
                      final currentQuests = _selectedCadence == QuestCadence.daily
                          ? profile.dailyQuests
                          : (_selectedCadence == QuestCadence.monthly
                              ? profile.monthlyQuests
                              : profile.yearlyQuests);

                      return Column(
                        children: currentQuests.map((quest) {
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
                                    // Progress status
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
                                              "${quest.progressCount}/${quest.targetCount}",
                                              style: GoogleFonts.orbitron(
                                                fontSize: 10,
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
                      );
                    }
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
                          onPressed: () {
                            setState(() {
                              _showingMealLog = true;
                            });
                          },
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
                ),
                const SizedBox(height: 25),
                _buildSuggestedWorkoutsSection(profile),
              ],
            ),
          ),

          // Quest detail overlay
          if (_selectedQuest != null)
            _buildQuestDetailOverlay(profile, _selectedQuest!),

          // Dopamine confirmation overlay
          if (_selectedDopamineItem != null)
            _buildDopamineConfirmationOverlay(profile, _selectedDopamineItem!),

          // Meal Log Overlay
          if (_showingMealLog)
            _buildMealLogOverlay(profile),
        ],
      ),
    ),);
  }

  Widget _buildDopamineQuickMenu(UserProfileManager profile) {
    final menuItems = _tailoredDopamineMenu(profile);
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
              itemCount: menuItems.length,
              itemBuilder: (context, idx) {
                final item = menuItems[idx];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedDopamineItem = item;
                      });
                    },
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

  Widget _buildQuestDetailOverlay(UserProfileManager profile, LotEQuest quest) {
    final isCompleted = quest.isCompleted;
    final themeColor = profile.currentElement.primaryColor;

    return Positioned.fill(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dismiss on tap outside
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedQuest = null;
              });
            },
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          // Dialog card
          Container(
            width: 310,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFF0C0C0C),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: themeColor.withOpacity(0.4),
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

                // Progress Bar Visualizer
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Progress:",
                          style: GoogleFonts.exo2(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          "${quest.progressCount} / ${quest.targetCount}",
                          style: GoogleFonts.orbitron(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: quest.targetCount > 0 ? (quest.progressCount / quest.targetCount) : 0,
                        backgroundColor: Colors.white.withOpacity(0.08),
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Rewards
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text("XP", style: TextStyle(fontSize: 10, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            "+${quest.rewardXP}",
                            style: GoogleFonts.orbitron(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Crystals", style: TextStyle(fontSize: 10, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            "+${quest.rewardCrystals}",
                            style: GoogleFonts.orbitron(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Attribute", style: TextStyle(fontSize: 10, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            "+${quest.statValue} ${quest.statReward.name.toUpperCase().substring(0, min(3, quest.statReward.name.length))}",
                            style: GoogleFonts.orbitron(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (isCompleted)
                  Text(
                    "Campaign Achieved",
                    style: GoogleFonts.exo2(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  )
                else if (quest.progressCount >= quest.targetCount)
                  ElevatedButton(
                    onPressed: () {
                      final success = profile.completeQuest(quest);
                      if (success) {
                        _showOutcomeDialog(
                          title: "QUEST SUCCESS! 🎉",
                          message: "You successfully cleared ${quest.title}! Earning ${quest.rewardXP} XP, ${quest.rewardCrystals} Crystals, and +${quest.statValue} to ${quest.statReward.displayName}!",
                          themeColor: Colors.green,
                          onDismiss: () {
                            setState(() {
                              _selectedQuest = null;
                            });
                          },
                        );
                      } else {
                        setState(() {
                          _selectedQuest = null;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "CLAIM QUEST REWARDS",
                      style: GoogleFonts.orbitron(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            profile.logWorkout(quest.workoutType);
                            // Refresh our local quest reference
                            setState(() {
                              final idx = _getQuestIndex(profile, quest.id, quest.cadence);
                              if (idx != -1) {
                                _selectedQuest = _getQuestAt(profile, idx, quest.cadence);
                              }
                            });
                          },
                          icon: const Icon(Icons.edit, size: 16),
                          label: Text(
                            "Log Session Manually",
                            style: GoogleFonts.orbitron(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final health = Provider.of<HealthManager>(context, listen: false);
                            health.requestAuthorization().then((_) {
                              if (health.isAuthorized) {
                                health.fetchTodayData().then((_) {
                                  profile.syncQuestsWithHealthData(
                                    todaySteps: health.todaySteps,
                                    activeMinutes: health.activeMinutes,
                                  );
                                  setState(() {
                                    final idx = _getQuestIndex(profile, quest.id, quest.cadence);
                                    if (idx != -1) {
                                      _selectedQuest = _getQuestAt(profile, idx, quest.cadence);
                                    }
                                  });
                                });
                              }
                            });
                          },
                          icon: const Icon(Icons.sync, size: 16),
                          label: Text(
                            "Sync from HealthKit",
                            style: GoogleFonts.orbitron(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: themeColor, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDopamineConfirmationOverlay(UserProfileManager profile, Map<String, dynamic> item) {
    final themeColor = profile.currentElement.primaryColor;

    return Positioned.fill(
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedDopamineItem = null;
              });
            },
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          Container(
            width: 310,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFF0C0C0C),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.orange.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.flash_on, color: Colors.orange, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "DOPAMINE CONFIRMATION",
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  "Perform the following action:",
                  style: GoogleFonts.exo2(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item["name"],
                    style: GoogleFonts.exo2(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "REWARDS",
                  style: GoogleFonts.exo2(fontSize: 11, color: Colors.grey),
                ),
                Text(
                  "+${item["xp"]} XP  /  +${item["crystals"]} Crystals 💎",
                  style: GoogleFonts.orbitron(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedDopamineItem = null;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.orbitron(color: Colors.grey, fontSize: 11),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final xp = item["xp"] as int;
                          final crystals = item["crystals"] as int;
                          profile.addXP(xp);
                          profile.earnCrystals(crystals);
                          setState(() {
                            _selectedDopamineItem = null;
                          });
                          _showOutcomeDialog(
                            title: "MOMENTUM GAINED! ⚡",
                            message: "You earned $xp XP and $crystals Crystals instantly. Keep it up!",
                            themeColor: Colors.orange,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "I DID IT!",
                          style: GoogleFonts.orbitron(color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealLogOverlay(UserProfileManager profile) {
    final themeColor = profile.currentElement.primaryColor;

    return Positioned.fill(
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _showingMealLog = false;
              });
            },
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          Container(
            width: 310,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFF0C0C0C),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: themeColor.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "LOG HEALTHY RATIONS",
                    style: GoogleFonts.orbitron(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                Text(
                  "RATION NAME",
                  style: GoogleFonts.exo2(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _mealNameController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "e.g. Chicken breast & broccoli",
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.04),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: themeColor),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CALORIES",
                            style: GoogleFonts.exo2(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _mealCaloriesController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "kcal",
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.04),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: themeColor),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.check_circle_outline, color: Colors.grey, size: 16),
                                onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "PROTEIN",
                            style: GoogleFonts.exo2(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _mealProteinController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "grams",
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.04),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: themeColor),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.check_circle_outline, color: Colors.grey, size: 16),
                                onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CARBS",
                            style: GoogleFonts.exo2(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _mealCarbsController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "grams",
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.04),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: themeColor),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.check_circle_outline, color: Colors.grey, size: 16),
                                onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "FATS",
                            style: GoogleFonts.exo2(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _mealFatsController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "grams",
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.04),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: themeColor),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.check_circle_outline, color: Colors.grey, size: 16),
                                onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SUGAR",
                            style: GoogleFonts.exo2(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _mealSugarController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "grams",
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.04),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: themeColor),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.check_circle_outline, color: Colors.grey, size: 16),
                                onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(child: SizedBox()),
                  ],
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _showingMealLog = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.orbitron(color: Colors.grey, fontSize: 11),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final cal = double.tryParse(_mealCaloriesController.text) ?? 0.0;
                          final prot = double.tryParse(_mealProteinController.text) ?? 0.0;
                          final carb = double.tryParse(_mealCarbsController.text) ?? 0.0;
                          final fat = double.tryParse(_mealFatsController.text) ?? 0.0;
                          final sug = double.tryParse(_mealSugarController.text) ?? 0.0;

                          profile.logDetailedMeal(
                            name: _mealNameController.text.isEmpty
                                ? "Healthy Rations"
                                : _mealNameController.text,
                            calories: cal,
                            protein: prot,
                            carbs: carb,
                            fats: fat,
                            sugar: sug,
                          );

                          setState(() {
                            _showingMealLog = false;
                          });

                          _mealNameController.clear();
                          _mealCaloriesController.clear();
                          _mealProteinController.clear();
                          _mealCarbsController.clear();
                          _mealFatsController.clear();
                          _mealSugarController.clear();

                          _showOutcomeDialog(
                            title: "RATIONS LOGGED! 🍏",
                            message: "Logged healthy rations! +15 XP, +10 Crystals, and +1 Constitution gained from nutrition sync.",
                            themeColor: themeColor,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "LOG RATION",
                          style: GoogleFonts.orbitron(color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedWorkoutsSection(UserProfileManager profile) {
    final filtered = SuggestedWorkout.allWorkouts.where((w) {
      final isMuscleGroupMatch = w.muscleGroup == _tailMuscleGroup;
      final isDifficultyMatch = w.difficulty.toLowerCase() == _tailDifficulty.toLowerCase();
      final isEquipmentMatch = _tailEquipment == "Full Gym" || 
          w.equipment.toLowerCase().replaceAll('-', '').contains(_tailEquipment.toLowerCase().replaceAll('-', ''));
      return isMuscleGroupMatch && isDifficultyMatch && isEquipmentMatch;
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "TAILORED SUGGESTED WORKOUTS",
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
              children: [
                // Tailoring inputs card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TAILORING PARAMETERS",
                        style: GoogleFonts.orbitron(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: profile.currentElement.primaryColor,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("GENDER", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Theme(
                                  data: Theme.of(context).copyWith(canvasColor: const Color(0xFF0F0F0F)),
                                  child: DropdownButtonFormField<String>(
                                    value: _tailGender,
                                    isDense: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.04),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                    ),
                                    style: const TextStyle(color: Colors.white, fontSize: 11),
                                    items: ["Male", "Female", "Other"].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() { _tailGender = val; });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("AGE", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 4),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white, fontSize: 11),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.04),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                  ),
                                  onChanged: (val) {
                                    setState(() { _tailAge = val; });
                                  },
                                  controller: TextEditingController(text: _tailAge)..selection = TextSelection.fromPosition(TextPosition(offset: _tailAge.length)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("WEIGHT (LBS)", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 4),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white, fontSize: 11),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.04),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                  ),
                                  onChanged: (val) {
                                    setState(() { _tailWeight = val; });
                                  },
                                  controller: TextEditingController(text: _tailWeight)..selection = TextSelection.fromPosition(TextPosition(offset: _tailWeight.length)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("EQUIPMENT", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Theme(
                                  data: Theme.of(context).copyWith(canvasColor: const Color(0xFF0F0F0F)),
                                  child: DropdownButtonFormField<String>(
                                    value: _tailEquipment,
                                    isDense: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.04),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                    ),
                                    style: const TextStyle(color: Colors.white, fontSize: 11),
                                    items: ["Bodyweight Only", "Dumbbells", "Pull-up Bar", "Full Gym"]
                                        .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() { _tailEquipment = val; });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("DIFFICULTY", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Theme(
                                  data: Theme.of(context).copyWith(canvasColor: const Color(0xFF0F0F0F)),
                                  child: DropdownButtonFormField<String>(
                                    value: _tailDifficulty,
                                    isDense: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.04),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                    ),
                                    style: const TextStyle(color: Colors.white, fontSize: 11),
                                    items: ["Easy", "Medium", "Hard", "Legend", "Master"]
                                        .map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() { _tailDifficulty = val; });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("MUSCLE GROUP", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Theme(
                                  data: Theme.of(context).copyWith(canvasColor: const Color(0xFF0F0F0F)),
                                  child: DropdownButtonFormField<MuscleGroup>(
                                    value: _tailMuscleGroup,
                                    isDense: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.04),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                    ),
                                    style: const TextStyle(color: Colors.white, fontSize: 11),
                                    items: MuscleGroup.values
                                        .map((mg) => DropdownMenuItem(value: mg, child: Text(mg.displayName))).toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() { _tailMuscleGroup = val; });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Workouts list
                ...(filtered.isEmpty
                        ? [_generateDynamicSuggestedWorkout(_tailMuscleGroup, _tailDifficulty, _tailEquipment)]
                        : filtered)
                    .map((workout) {
                    final tailored = _tailorWorkout(workout);
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                workout.name,
                                style: GoogleFonts.exo2(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: profile.currentElement.primaryColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  workout.difficulty.toUpperCase(),
                                  style: GoogleFonts.orbitron(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: profile.currentElement.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            workout.description,
                            style: GoogleFonts.exo2(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.75),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.repeat, size: 12, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text(
                                "${tailored.sets} Sets",
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange),
                              ),
                              const SizedBox(width: 16),
                              const Icon(Icons.directions_run, size: 12, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text(
                                tailored.reps,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "INSTRUCTIONS:",
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          ...workout.instructions.map((inst) {
                            if (inst.startsWith("TARGET MUSCLES:")) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.fitness_center, size: 10, color: Colors.orange),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        inst,
                                        style: GoogleFonts.exo2(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (inst.startsWith("SETUP & WIDTH:")) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.straighten, size: 10, color: Colors.cyan),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        inst,
                                        style: GoogleFonts.exo2(fontSize: 10, color: Colors.cyan, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (inst.startsWith("DIFFICULTY KEY:")) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.speed, size: 10, color: Colors.yellow),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        inst,
                                        style: GoogleFonts.exo2(fontSize: 10, color: Colors.yellow, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("• ", style: TextStyle(color: profile.currentElement.primaryColor)),
                                    Expanded(
                                      child: Text(
                                        inst,
                                        style: GoogleFonts.exo2(fontSize: 10, color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: const Color(0xFF0F0F0F),
                                      title: Text(
                                        "COMPLETE WORKOUT?",
                                        style: GoogleFonts.orbitron(
                                          color: profile.currentElement.primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        "Are you sure you have completed '${workout.name}'? This will reward you with +20 XP, +10 Crystals, and advance your goals.",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontFamily: "Exo2",
                                          fontSize: 13,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            profile.addXP(20);
                                            profile.earnCrystals(10);
                                            profile.logWorkout(workout.category);
                                            _showOutcomeDialog(
                                              title: "WORKOUT CONQUERED! 💪",
                                              message: "Workout complete! You conquered ${workout.name} and gained +20 XP, +10 Crystals, and forged your character attributes.",
                                              themeColor: profile.currentElement.primaryColor,
                                            );
                                          },
                                          child: Text(
                                            "YES, LOG IT",
                                            style: TextStyle(
                                              color: profile.currentElement.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: profile.currentElement.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: Text(
                                "COMPLETE WORKOUT",
                                style: GoogleFonts.orbitron(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ({int sets, String reps}) _tailorWorkout(SuggestedWorkout workout) {
    final ageVal = int.tryParse(_tailAge) ?? 30;
    final weightVal = double.tryParse(_tailWeight) ?? 170.0;

    double setsMultiplier = 1.0;
    double repsMultiplier = 1.0;

    if (ageVal > 50) {
      setsMultiplier = 0.8;
      repsMultiplier = 0.8;
    } else if (ageVal < 22) {
      setsMultiplier = 1.2;
      repsMultiplier = 1.1;
    }

    if (weightVal > 220.0 && workout.equipment == "Bodyweight Only") {
      repsMultiplier *= 0.85;
    }

    if (_tailGender == "Female") {
      repsMultiplier *= 0.95;
    }

    final finalSets = (workout.sets * setsMultiplier).round().clamp(1, 99);

    final repStr = workout.reps;
    String finalReps = repStr;
    final regExp = RegExp(r'\d+');
    final match = regExp.firstMatch(repStr);
    if (match != null) {
      final firstNumStr = match.group(0)!;
      final num = double.tryParse(firstNumStr);
      if (num != null) {
        final adjustedNum = (num * repsMultiplier).round().clamp(1, 999);
        finalReps = repStr.replaceFirst(firstNumStr, adjustedNum.toString());
      }
    }

    return (sets: finalSets, reps: finalReps);
  }

  SuggestedWorkout _generateDynamicSuggestedWorkout(MuscleGroup muscleGroup, String difficulty, String equipment) {
    String name = "$difficulty Custom ${muscleGroup.displayName} Builder";
    String description = "Target the ${muscleGroup.displayName} using $equipment.";
    List<String> instructions = [
      "Perform dynamic warm up.",
      "Perform compound sets targeting ${muscleGroup.displayName}.",
      "Adjust weight or resistance based on $equipment.",
      "Rest 60-90 seconds between sets."
    ];
    String reps = difficulty == "Easy" ? "8-10 reps" : difficulty == "Medium" ? "10-12 reps" : "12-15 reps";
    int sets = difficulty == "Easy" ? 3 : difficulty == "Medium" ? 4 : 5;

    return SuggestedWorkout(
      id: "dynamic_${muscleGroup.name}_${difficulty.toLowerCase()}",
      name: name,
      muscleGroup: muscleGroup,
      difficulty: difficulty,
      equipment: equipment,
      description: description,
      instructions: instructions,
      sets: sets,
      reps: reps,
    );
  }
}
