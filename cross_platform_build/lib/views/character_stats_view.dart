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

                    // Profile Subsections Segmented Picker
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: ["Stats", "Badges", "Shop"].map((tab) {
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
                                      color: isSelected ? Colors.white : Colors.grey,
                                    ),
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: themeColor,
                                backgroundColor: Colors.white.withOpacity(0.04),
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
                    ] else if (_selectedTab == "Badges") ...[
                      _buildBadgesSection(profile, themeColor),
                    ] else if (_selectedTab == "Shop") ...[
                      _buildShopSection(profile, themeColor),
                    ],
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

  Widget _buildShopSection(UserProfileManager profile, Color themeColor) {
    final shopItems = ShopItem.availableItems;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "CRYSTALS SHOP",
                style: GoogleFonts.orbitron(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 2,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "${profile.crystals} 💎",
                    style: GoogleFonts.orbitron(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: shopItems.map((item) {
              final isUnlocked = profile.unlockedShopItems.contains(item.name);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isUnlocked ? Colors.green.withOpacity(0.3) : Colors.white.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isUnlocked ? Colors.green.withOpacity(0.1) : themeColor.withOpacity(0.05),
                        ),
                        child: Icon(
                          _iconForShopItemType(item.type),
                          color: isUnlocked ? Colors.green : themeColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: GoogleFonts.exo2(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              style: GoogleFonts.exo2(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (isUnlocked)
                        Builder(
                          builder: (context) {
                            if (item.type == "stat" || item.type == "badge") {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "UNLOCKED",
                                  style: GoogleFonts.orbitron(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              );
                            } else {
                              final equipped = _isEquipped(profile, item);
                              return ElevatedButton(
                                onPressed: () {
                                  profile.toggleEquipItem(item);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: equipped ? Colors.orange.withOpacity(0.15) : Colors.green.withOpacity(0.15),
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  equipped ? "UNEQUIP" : "EQUIP",
                                  style: GoogleFonts.orbitron(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: equipped ? Colors.orange : Colors.green,
                                  ),
                                ),
                              );
                            }
                          }
                        )
                      else
                        ElevatedButton(
                          onPressed: profile.crystals >= item.cost
                              ? () => profile.buyShopItem(item)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            disabledBackgroundColor: Colors.grey,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${item.cost}",
                                style: GoogleFonts.orbitron(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(Icons.auto_awesome, size: 10, color: Colors.white),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
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
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isUnlocked ? themeColor.withOpacity(0.3) : Colors.white.withOpacity(0.05),
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
                          color: isUnlocked ? themeColor.withOpacity(0.15) : Colors.white.withOpacity(0.04),
                        ),
                        child: Icon(
                          isUnlocked ? _iconForBadge(badge.iconName) : Icons.lock,
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
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (isUnlocked)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.15),
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
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
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
                        )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  IconData _iconForShopItemType(String type) {
    switch (type) {
      case "frame": return Icons.border_outer;
      case "title": return Icons.badge;
      case "aura": return Icons.bubble_chart;
      case "stat": return Icons.bolt;
      case "badge": return Icons.verified;
      default: return Icons.shopping_cart;
    }
  }

  IconData _iconForBadge(String iconName) {
    switch (iconName) {
      case "walk": return Icons.directions_walk;
      case "local_fire_department": return Icons.local_fire_department;
      case "psychology": return Icons.psychology;
      case "verified": return Icons.verified;
      case "emoji_events": return Icons.emoji_events;
      case "shopping_cart": return Icons.shopping_cart;
      case "star": return Icons.star;
      default: return Icons.workspace_premium;
    }
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

  bool _isEquipped(UserProfileManager profile, ShopItem item) {
    switch (item.type) {
      case "frame": return profile.equippedFrame == item.name;
      case "title": return profile.equippedTitle == item.name;
      case "aura": return profile.equippedAura == item.name;
      case "background": return profile.equippedBackground == item.name;
      case "accessory": return profile.equippedAccessory == item.name;
      default: return false;
    }
  }
}
