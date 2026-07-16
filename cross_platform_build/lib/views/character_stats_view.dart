import 'dart:math' as import_math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../managers/user_profile_manager.dart';
import '../models/lote_models.dart';

class CharacterStatsView extends StatefulWidget {
  const CharacterStatsView({super.key});

  @override
  State<CharacterStatsView> createState() => _CharacterStatsViewState();
}

class _CharacterStatsViewState extends State<CharacterStatsView> {
  String _selectedTab = "Stats";

  // Decides race based on planet and expression stance
  String _getRaceName(UserProfileManager profile) {
    if (profile.currentElement.inherentDark ||
        profile.expressionStyle == ExpressionStyle.corrupt) {
      return "Tenebrie (Corrupt Genes)";
    }
    switch (profile.homePlanet) {
      case "Warrion":
        return "Warrion (Primal Force)";
      case "Techno":
        return "Krenpowen (Techno Cyber)";
      case "Ninjonia":
        return "Krenpowen (Ninjonian Disciplined)";
      default:
        return "Calthrian Spatialist";
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfileManager>(context);
    final themeColor = profile.currentElement.primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  // Title / Header
                  Column(
                    children: [
                      Text(
                        "WARRIOR PROFILE SHEET",
                        style: GoogleFonts.orbitron(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Status logs from the Elsaither Oracle",
                        style: GoogleFonts.exo2(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Level & Tier Summary Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.02),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: themeColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            profile.currentTier
                                .dynamicDisplayName(profile.currentElement.name)
                                .toUpperCase(),
                            style: GoogleFonts.orbitron(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                              letterSpacing: 2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "LEVEL ${profile.currentLevel}",
                            style: GoogleFonts.orbitron(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),

                          // XP Progress Indicator
                          Builder(
                            builder: (context) {
                              final needed = profile.requiredXPForLevel(
                                profile.currentLevel,
                              );
                              final pct = (profile.currentXP / needed).clamp(
                                0.0,
                                1.0,
                              );
                              return Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: pct,
                                      minHeight: 6,
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        themeColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${profile.currentXP} XP",
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "$needed XP Required",
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          Text(
                            profile.currentTier.description,
                            style: GoogleFonts.exo2(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.8),
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Profile Subsections Segmented Picker
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: ["Stats", "Badges", "Trials"].map((tab) {
                        final isSelected = _selectedTab == tab;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  tab,
                                  style: GoogleFonts.orbitron(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: themeColor,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.04,
                              ),
                              onSelected: (val) {
                                if (val) {
                                  setState(() {
                                    _selectedTab = tab;
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

                  if (_selectedTab == "Stats") ...[
                    // D&D Character Attributes
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "D&D CHARACTER ATTRIBUTES",
                          style: GoogleFonts.orbitron(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildStatRow(
                            "Strength (STR)",
                            profile.stats.strength,
                            "Improves weights & strength training",
                            themeColor,
                          ),
                          const SizedBox(height: 10),
                          _buildStatRow(
                            "Dexterity (DEX)",
                            profile.stats.dexterity,
                            "Improves running, cardio & speed sprints",
                            themeColor,
                          ),
                          const SizedBox(height: 10),
                          _buildStatRow(
                            "Constitution (CON)",
                            profile.stats.constitution,
                            "Increases meal absorption & stamina logs",
                            themeColor,
                          ),
                          const SizedBox(height: 10),
                          _buildStatRow(
                            "Intelligence (INT)",
                            profile.stats.intelligence,
                            "Improves cyber device tech & laser efficiency",
                            themeColor,
                          ),
                          const SizedBox(height: 10),
                          _buildStatRow(
                            "Wisdom (WIS)",
                            profile.stats.wisdom,
                            "Enhances flexibility and balance training",
                            themeColor,
                          ),
                          const SizedBox(height: 10),
                          _buildStatRow(
                            "Charisma (CHA)",
                            profile.stats.charisma,
                            "Controls companion bonds & shop discounts",
                            themeColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Lore Alignment Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "ELSAITHER METRICS",
                          style: GoogleFonts.orbitron(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
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
                          children: [
                            _buildLoreMetricRow(
                              "Race Ancestry",
                              _getRaceName(profile),
                            ),
                            const Divider(color: Colors.white10),
                            _buildLoreMetricRow(
                              "Planet of Origin",
                              profile.homePlanet,
                            ),
                            const Divider(color: Colors.white10),
                            _buildLoreMetricRow(
                              "Power Stance",
                              profile.expressionStyle.displayName,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Body Measurements Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "BODY MEASUREMENTS",
                          style: GoogleFonts.orbitron(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
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
                          children: [
                            _buildLoreMetricRow(
                              "Height",
                              "${profile.height.toStringAsFixed(1)} in",
                            ),
                            const Divider(color: Colors.white10),
                            _buildLoreMetricRow(
                              "Weight",
                              "${profile.weight.toStringAsFixed(1)} lbs",
                            ),
                            const Divider(color: Colors.white10),
                            _buildLoreMetricRow(
                              "Chest",
                              "${profile.chest.toStringAsFixed(1)} in",
                            ),
                            const Divider(color: Colors.white10),
                            _buildLoreMetricRow(
                              "Arms",
                              "${profile.arms.toStringAsFixed(1)} in",
                            ),
                            const Divider(color: Colors.white10),
                            _buildLoreMetricRow(
                              "Waist",
                              "${profile.waist.toStringAsFixed(1)} in",
                            ),
                            const Divider(color: Colors.white10),
                            _buildLoreMetricRow(
                              "Hips",
                              "${profile.hips.toStringAsFixed(1)} in",
                            ),
                            const Divider(color: Colors.white10),
                            _buildLoreMetricRow(
                              "Legs",
                              "${profile.legs.toStringAsFixed(1)} in",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else if (_selectedTab == "Badges") ...[
                    _buildBadgesSection(profile, themeColor),
                  ] else if (_selectedTab == "Trials") ...[
                    _buildTrialsSection(profile, themeColor),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrialsSection(UserProfileManager profile, Color themeColor) {
    final trials = [
      {
        "name": "Lift the Fallen Debris",
        "stat": "Strength",
        "desc": "A collapsed structure traps survivors. Use your raw power.",
        "dc": 14,
      },
      {
        "name": "Navigate the Asteroid Field",
        "stat": "Dexterity",
        "desc": "Pilot your craft through a dense field of space debris.",
        "dc": 16,
      },
      {
        "name": "Endure the Toxic Fumes",
        "stat": "Constitution",
        "desc": "A biological leak tests your stamina and resilience.",
        "dc": 15,
      },
      {
        "name": "Hack the Mainframe",
        "stat": "Intelligence",
        "desc": "Bypass the cyber security of a rogue drone.",
        "dc": 16,
      },
      {
        "name": "Track the Invisible Beast",
        "stat": "Wisdom",
        "desc": "Use your intuition and senses to find the hidden threat.",
        "dc": 14,
      },
      {
        "name": "Negotiate with Smugglers",
        "stat": "Charisma",
        "desc": "Convince the black market dealers to lower their prices.",
        "dc": 15,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "ORACLE STAT TRIALS (MINI-GAMES)",
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
            children: trials.map((t) {
              final String statName = t["stat"] as String;
              final int dc = t["dc"] as int;

              int statValue = 10;
              switch (statName) {
                case "Strength":
                  statValue = profile.stats.strength;
                  break;
                case "Dexterity":
                  statValue = profile.stats.dexterity;
                  break;
                case "Constitution":
                  statValue = profile.stats.constitution;
                  break;
                case "Intelligence":
                  statValue = profile.stats.intelligence;
                  break;
                case "Wisdom":
                  statValue = profile.stats.wisdom;
                  break;
                case "Charisma":
                  statValue = profile.stats.charisma;
                  break;
              }
              final mod = ((statValue - 10) / 2).floor();
              final modStr = mod >= 0 ? "+$mod" : "$mod";

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            t["name"] as String,
                            style: GoogleFonts.exo2(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: themeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "DC $dc",
                            style: GoogleFonts.orbitron(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t["desc"] as String,
                      style: GoogleFonts.exo2(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _rollTrial(
                          context,
                          profile,
                          t["name"] as String,
                          statName,
                          mod,
                          dc,
                          themeColor,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          profile.trialsCompletedToday >= 3
                              ? "DAILY LIMIT REACHED (3/3)"
                              : "ROLL $statName ($modStr)",
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
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _rollTrial(
    BuildContext context,
    UserProfileManager profile,
    String trialName,
    String statName,
    int mod,
    int dc,
    Color themeColor,
  ) {
    if (profile.trialsCompletedToday >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You have completed your 3 Oracle Trials for today. Rest and return tomorrow.",
            style: GoogleFonts.exo2(),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    import_math.Random rand = import_math.Random();
    int roll = rand.nextInt(20) + 1;
    int total = roll + mod;
    bool success = total >= dc;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F0F0F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: themeColor.withValues(alpha: 0.3)),
          ),
          title: Text(
            success ? "TRIAL SUCCESS" : "TRIAL FAILED",
            style: GoogleFonts.orbitron(
              color: success ? themeColor : Colors.redAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Rolled a d20: $roll",
                style: GoogleFonts.exo2(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                "Modifier ($statName): $mod",
                style: GoogleFonts.exo2(color: Colors.white70, fontSize: 14),
              ),
              const Divider(color: Colors.white24, height: 24),
              Text(
                "Total: $total",
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Target DC: $dc",
                style: GoogleFonts.exo2(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 24),
              if (success)
                Text(
                  "You overcome the challenge with your $statName!\\n\\n+5 Crystals earned.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.exo2(color: Colors.white, fontSize: 14),
                )
              else
                Text(
                  "Your $statName wasn't high enough this time. Train more and try again later.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.exo2(color: Colors.grey, fontSize: 14),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                profile.recordTrialCompleted();
                if (success) {
                  profile.earnCrystals(5);
                }
              },
              child: Text(
                "CONTINUE",
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBadgesSection(UserProfileManager profile, Color themeColor) {
    final badges = FitnessBadge.allBadges;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "UNLOCKED BADGES",
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
            children: badges.map((badge) {
              final isUnlocked = profile.unlockedBadges.contains(badge.name);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isUnlocked
                          ? themeColor.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isUnlocked
                              ? themeColor.withValues(alpha: 0.15)
                              : Colors.white.withValues(alpha: 0.04),
                        ),
                        child: Icon(
                          isUnlocked
                              ? _iconForBadge(badge.iconName)
                              : Icons.lock,
                          color: isUnlocked ? themeColor : Colors.grey,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              badge.name,
                              style: GoogleFonts.exo2(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isUnlocked ? Colors.white : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              badge.description,
                              style: GoogleFonts.exo2(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (isUnlocked)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "UNLOCKED",
                            style: GoogleFonts.orbitron(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "LOCKED",
                            style: GoogleFonts.orbitron(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  IconData _iconForBadge(String iconName) {
    switch (iconName) {
      case "walk":
        return Icons.directions_walk;
      case "local_fire_department":
        return Icons.local_fire_department;
      case "psychology":
        return Icons.psychology;
      case "verified":
        return Icons.verified;
      case "emoji_events":
        return Icons.emoji_events;
      case "shopping_cart":
        return Icons.shopping_cart;
      case "star":
        return Icons.star;
      default:
        return Icons.workspace_premium;
    }
  }

  Widget _buildStatRow(String label, int value, String desc, Color themeColor) {
    final mod = ((value - 10) / 2).floor();
    final modStr = mod >= 0 ? "+$mod" : "$mod";
    final pct = (value / 100.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
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
                label,
                style: GoogleFonts.exo2(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "$value (Mod: $modStr)",
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
              value: pct,
              minHeight: 4,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                themeColor.withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildLoreMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.exo2(fontSize: 13, color: Colors.grey),
          ),
          Text(
            value,
            style: GoogleFonts.exo2(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
