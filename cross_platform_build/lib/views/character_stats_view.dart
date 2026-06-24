import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../managers/user_profile_manager.dart';
import '../models/lote_models.dart';

class CharacterStatsView extends StatelessWidget {
  const CharacterStatsView({super.key});

  // Decides race based on planet and expression stance
  String _getRaceName(UserProfileManager profile) {
    if (profile.currentElement.inherentDark || profile.expressionStyle == ExpressionStyle.corrupt) {
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

  // Decides Mark of the Wild / Spirit Animal
  String _getSpiritAnimal(UserProfileManager profile) {
    final name = profile.currentElement.name;
    if (name == "Fire" || name == "Lightning" || name == "Laser") {
      return "Dragon (Aggressive, Passionate)";
    } else if (name == "Earth" || name == "Bone" || name == "Metal") {
      return "Bear (Grounded, Powerful)";
    } else if (name == "Water" || name == "Ice" || name == "Poison") {
      return "Wolf (Intuitive, Pack Hunter)";
    } else if (name == "Air" || name == "Gas" || name == "Zero Space") {
      return "Eagle (Intellectual, Free)";
    } else if (name == "Shadow" || name == "Death" || name == "Knife") {
      return "Owl (Mysterious, Precise)";
    } else {
      return "Sheep (Gentle, Harmonious)";
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
                        color: Colors.white.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: themeColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            profile.currentTier.dynamicDisplayName(profile.currentElement.name).toUpperCase(),
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
                              final needed = profile.requiredXPForLevel(profile.currentLevel);
                              final pct = (profile.currentXP / needed).clamp(0.0, 1.0);
                              return Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: pct,
                                      minHeight: 6,
                                      backgroundColor: Colors.white.withOpacity(0.1),
                                      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${profile.currentXP} XP",
                                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                                      ),
                                      Text(
                                        "$needed XP Required",
                                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                                      )
                                    ],
                                  )
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          Text(
                            profile.currentTier.description,
                            style: GoogleFonts.exo2(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

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
                        _buildStatRow("Strength (STR)", profile.stats.strength, "Improves weights & strength training", themeColor),
                        const SizedBox(height: 10),
                        _buildStatRow("Dexterity (DEX)", profile.stats.dexterity, "Improves running, cardio & speed sprints", themeColor),
                        const SizedBox(height: 10),
                        _buildStatRow("Constitution (CON)", profile.stats.constitution, "Increases meal absorption & stamina logs", themeColor),
                        const SizedBox(height: 10),
                        _buildStatRow("Intelligence (INT)", profile.stats.intelligence, "Improves cyber device tech & laser efficiency", themeColor),
                        const SizedBox(height: 10),
                        _buildStatRow("Wisdom (WIS)", profile.stats.wisdom, "Enhances flexibility and balance training", themeColor),
                        const SizedBox(height: 10),
                        _buildStatRow("Charisma (CHA)", profile.stats.charisma, "Controls companion bonds & shop discounts", themeColor),
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
                        color: Colors.white.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: themeColor.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildLoreMetricRow("Race Ancestry", _getRaceName(profile)),
                          const Divider(color: Colors.white10),
                          _buildLoreMetricRow("Planet of Origin", profile.homePlanet),
                          const Divider(color: Colors.white10),
                          _buildLoreMetricRow("Mark of the Wild", _getSpiritAnimal(profile)),
                          const Divider(color: Colors.white10),
                          _buildLoreMetricRow("Power Stance", profile.expressionStyle.displayName),
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
                        color: Colors.white.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: themeColor.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildLoreMetricRow("Height", "${profile.height.toStringAsFixed(1)} in"),
                          const Divider(color: Colors.white10),
                          _buildLoreMetricRow("Weight", "${profile.weight.toStringAsFixed(1)} lbs"),
                          const Divider(color: Colors.white10),
                          _buildLoreMetricRow("Chest", "${profile.chest.toStringAsFixed(1)} in"),
                          const Divider(color: Colors.white10),
                          _buildLoreMetricRow("Arms", "${profile.arms.toStringAsFixed(1)} in"),
                          const Divider(color: Colors.white10),
                          _buildLoreMetricRow("Waist", "${profile.waist.toStringAsFixed(1)} in"),
                          const Divider(color: Colors.white10),
                          _buildLoreMetricRow("Hips", "${profile.hips.toStringAsFixed(1)} in"),
                          const Divider(color: Colors.white10),
                          _buildLoreMetricRow("Legs", "${profile.legs.toStringAsFixed(1)} in"),
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

  Widget _buildStatRow(String label, int value, String desc, Color themeColor) {
    final mod = ((value - 10) / 2).floor();
    final modStr = mod >= 0 ? "+$mod" : "$mod";
    final pct = (value / 30.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
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
              )
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 4,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(themeColor.withOpacity(0.7)),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          )
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
            style: GoogleFonts.exo2(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.exo2(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
