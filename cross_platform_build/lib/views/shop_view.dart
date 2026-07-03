import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/lote_models.dart';
import '../managers/user_profile_manager.dart';

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  String _selectedCategory = "Name Plates";
  final List<String> _categories = [
    "Name Plates",
    "Auras",
    "Backgrounds",
    "Legendary Items",
    "Stats & More"
  ];

  List<ShopItem> _getFilteredItems() {
    switch (_selectedCategory) {
      case "Name Plates":
        return ShopItem.availableItems
            .where((item) => item.type == "frame" || item.type == "title")
            .toList();
      case "Auras":
        return ShopItem.availableItems
            .where((item) => item.type == "aura")
            .toList();
      case "Backgrounds":
        return ShopItem.availableItems
            .where((item) => item.type == "background")
            .toList();
      case "Legendary Items":
        return ShopItem.availableItems
            .where((item) => item.type == "accessory")
            .toList();
      default:
        return ShopItem.availableItems
            .where((item) => item.type == "stat" || item.type == "badge")
            .toList();
    }
  }

  bool _isEquipped(ShopItem item, UserProfileManager profile) {
    if (item.type == "frame") {
      return profile.equippedFrame == item.name;
    } else if (item.type == "title") {
      return profile.equippedTitle == item.name;
    } else if (item.type == "aura") {
      return profile.equippedAura == item.name;
    } else if (item.type == "background") {
      return profile.equippedBackground == item.name;
    } else if (item.type == "accessory") {
      return profile.equippedAccessory == item.name;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfileManager>(context);
    final themeColor = profile.currentElement.primaryColor;
    final filteredItems = _getFilteredItems();

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ELSAITHER ARMORY",
                          style: GoogleFonts.orbitron(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: themeColor.withValues(alpha: 0.6),
                                blurRadius: 8,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Equip items to style your profile and boost stats",
                          style: GoogleFonts.exo2(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Crystals Balance Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: themeColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "💎",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${profile.crystals}",
                          style: GoogleFonts.orbitron(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Categories list
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? themeColor : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: themeColor.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          cat,
                          style: GoogleFonts.orbitron(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Shop Items List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  final isUnlocked = profile.unlockedShopItems.contains(item.name);
                  final equipped = _isEquipped(item, profile);

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.04),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Large Emoji Sprite
                        Container(
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isUnlocked ? Colors.green.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.08),
                              width: 1,
                            ),
                            gradient: RadialGradient(
                              colors: [
                                themeColor.withValues(alpha: isUnlocked ? 0.25 : 0.08),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: ItemPixelSpriteWidget(
                            name: item.name,
                            type: item.type,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.name,
                                    style: GoogleFonts.exo2(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // Category Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: themeColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item.type.toUpperCase(),
                                      style: GoogleFonts.orbitron(
                                        fontSize: 7,
                                        fontWeight: FontWeight.bold,
                                        color: themeColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.description,
                                style: GoogleFonts.exo2(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Purchase Actions
                        Column(
                          children: [
                            if (isUnlocked)
                              if (item.type == "stat" || item.type == "badge")
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
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
                                ElevatedButton(
                                  onPressed: () {
                                    profile.toggleEquipItem(item);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: equipped ? Colors.orange.withValues(alpha: 0.15) : Colors.green.withValues(alpha: 0.15),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    minimumSize: Size.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    equipped ? "UNEQUIP" : "EQUIP",
                                    style: GoogleFonts.orbitron(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: equipped ? Colors.orange : Colors.green,
                                    ),
                                  ),
                                )
                            else
                              ElevatedButton(
                                onPressed: profile.crystals >= item.cost
                                    ? () {
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
                                                "CONFIRM ACQUISITION",
                                                style: GoogleFonts.orbitron(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 2,
                                                ),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.name.toUpperCase(),
                                                    style: GoogleFonts.orbitron(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: themeColor.withValues(alpha: 0.12),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      item.type.toUpperCase(),
                                                      style: GoogleFonts.orbitron(
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.bold,
                                                        color: themeColor,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    "EXPANDED DESCRIPTION:",
                                                    style: GoogleFonts.orbitron(
                                                      fontSize: 9,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    item.description,
                                                    style: GoogleFonts.exo2(
                                                      fontSize: 12,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Cost: ",
                                                        style: GoogleFonts.exo2(fontSize: 13, color: Colors.grey),
                                                      ),
                                                      Text(
                                                        "${item.cost}",
                                                        style: GoogleFonts.orbitron(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      const Text("💎"),
                                                    ],
                                                  ),
                                                ],
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
                                                    profile.buyShopItem(item);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "CONFIRM PURCHASE",
                                                    style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeColor.withValues(alpha: 0.2),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  minimumSize: Size.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: themeColor.withValues(alpha: 0.4),
                                      width: 1,
                                    ),
                                  ),
                                  elevation: 0,
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
                                    const Text("💎", style: TextStyle(fontSize: 10)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemPixelSpriteWidget extends StatelessWidget {
  final String name;
  final String type;

  const ItemPixelSpriteWidget({
    super.key,
    required this.name,
    required this.type,
  });

  List<List<int>> _generateGrid() {
    if (type == "stat") {
      return [
        [0, 0, 0, 1, 1, 0, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0],
        [0, 0, 2, 2, 2, 2, 0, 0],
        [0, 2, 3, 3, 3, 3, 2, 0],
        [0, 2, 3, 3, 3, 3, 2, 0],
        [0, 2, 3, 3, 3, 3, 2, 0],
        [0, 2, 2, 2, 2, 2, 2, 0],
        [0, 0, 0, 0, 0, 0, 0, 0]
      ];
    } else if (type == "accessory" && name.toLowerCase().contains("sword")) {
      return [
        [0, 0, 0, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 1, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 2, 0, 0, 0, 0, 0],
        [0, 2, 3, 2, 0, 0, 0, 0],
        [2, 0, 2, 0, 0, 0, 0, 0],
        [0, 2, 0, 0, 0, 0, 0, 0]
      ];
    } else if (type == "accessory" && name.contains("Visor")) {
      return [
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [2, 2, 2, 2, 2, 2, 2, 2],
        [2, 1, 1, 1, 1, 1, 1, 2],
        [0, 2, 1, 1, 1, 1, 2, 0],
        [0, 0, 2, 2, 2, 2, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0]
      ];
    } else if (type == "accessory" && name.contains("Wings")) {
      return [
        [0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 0, 0, 0, 0, 1, 1],
        [1, 1, 1, 0, 0, 1, 1, 1],
        [0, 1, 1, 1, 1, 1, 1, 0],
        [0, 0, 1, 2, 2, 1, 0, 0],
        [0, 0, 0, 2, 2, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0]
      ];
    } else if (type == "frame") {
      return [
        [1, 1, 1, 1, 1, 1, 1, 1],
        [1, 2, 2, 2, 2, 2, 2, 1],
        [1, 2, 0, 0, 0, 0, 2, 1],
        [1, 2, 0, 0, 0, 0, 2, 1],
        [1, 2, 0, 0, 0, 0, 2, 1],
        [1, 2, 0, 0, 0, 0, 2, 1],
        [1, 2, 2, 2, 2, 2, 2, 1],
        [1, 1, 1, 1, 1, 1, 1, 1]
      ];
    } else if (type == "aura") {
      return [
        [0, 0, 1, 1, 1, 1, 0, 0],
        [0, 1, 0, 0, 0, 0, 1, 0],
        [1, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 1],
        [0, 1, 0, 0, 0, 0, 1, 0],
        [0, 0, 1, 1, 1, 1, 0, 0]
      ];
    } else if (type == "background") {
      return [
        [1, 1, 1, 1, 1, 1, 1, 1],
        [1, 2, 2, 2, 2, 2, 2, 1],
        [3, 3, 3, 3, 3, 3, 3, 3],
        [3, 3, 4, 4, 4, 4, 3, 3],
        [4, 4, 4, 5, 5, 4, 4, 4],
        [4, 5, 5, 5, 5, 5, 5, 4],
        [5, 5, 5, 5, 5, 5, 5, 5],
        [5, 5, 5, 5, 5, 5, 5, 5]
      ];
    } else if (type == "title" || name.contains("Crown")) {
      return [
        [0, 0, 0, 0, 0, 0, 0, 0],
        [1, 0, 1, 0, 1, 0, 1, 0],
        [1, 0, 1, 0, 1, 0, 1, 0],
        [1, 1, 1, 1, 1, 1, 1, 1],
        [1, 2, 1, 2, 1, 2, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0]
      ];
    } else {
      return [
        [0, 0, 1, 1, 1, 1, 0, 0],
        [0, 1, 2, 2, 2, 2, 1, 0],
        [1, 2, 3, 3, 3, 3, 2, 1],
        [1, 2, 3, 4, 4, 3, 2, 1],
        [1, 2, 3, 4, 4, 3, 2, 1],
        [0, 1, 2, 3, 3, 2, 1, 0],
        [0, 0, 1, 2, 2, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0]
      ];
    }
  }

  Color _getColorForValue(int val) {
    switch (val) {
      case 1:
        if (name.contains("Ignis") || name.contains("Strength") || name.contains("Phoenix") || name.contains("Volcanic")) return Colors.red;
        if (name.contains("Crystalline") || name.contains("Gale") || name.contains("Cyber") || name.contains("Neon") || name.contains("Glitch")) return Colors.cyan;
        if (name.contains("Umbral") || name.contains("Abyssal") || name.contains("Mind") || name.contains("Wisdom")) return Colors.purple;
        return Colors.yellow;
      case 2:
        return Colors.grey;
      case 3:
        if (name.contains("Strength")) return Colors.red;
        if (name.contains("Gale")) return Colors.cyan;
        if (name.contains("Marrow")) return Colors.orange;
        if (name.contains("Mind") || name.contains("Wisdom")) return Colors.purple;
        return Colors.orange;
      case 4:
        return Colors.yellow;
      case 5:
        return Colors.green;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final grid = _generateGrid();
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(8, (r) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(8, (c) {
              final val = grid[r][c];
              return Container(
                width: 4.5,
                height: 4.5,
                color: _getColorForValue(val),
              );
            }),
          );
        }),
      ),
    );
  }
}
