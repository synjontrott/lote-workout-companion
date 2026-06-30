import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../managers/user_profile_manager.dart';
import '../models/lote_models.dart';

class CharacterCreatorView extends StatefulWidget {
  const CharacterCreatorView({super.key});

  @override
  State<CharacterCreatorView> createState() => _CharacterCreatorViewState();
}

class _CharacterCreatorViewState extends State<CharacterCreatorView> {
  int _selectedToolColor = 1; // Palette index: 1=Skin, 2=Hair, 3=Eyes, 4=Outfit, 5=Aura, 0=Eraser
  late List<List<int>> _pixelGrid;

  // Preset values
  String _sexPreset = "Male";
  String _planetPreset = "Ninjonia";
  String _skinPreset = "Fair";
  String _hairStylePreset = "Spiky";
  String _hairColorPreset = "Yellow";
  String _outfitColorPreset = "Gray";

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<UserProfileManager>(context, listen: false);
    // Deep copy pixel grid
    _pixelGrid = List.generate(profile.sprite.pixelGrid.length, (r) => List.from(profile.sprite.pixelGrid[r]));

    // Try to infer presets from loaded hex values
    _sexPreset = profile.sprite.sex;
    _planetPreset = profile.sprite.outfitStyle.isEmpty ? profile.homePlanet : profile.sprite.outfitStyle;
    _skinPreset = _skinPresetFromHex(profile.sprite.skinColorHex);
    _hairStylePreset = profile.sprite.hairStyle;
    _hairColorPreset = _hairColorFromHex(profile.sprite.hairColorHex);
    _outfitColorPreset = _outfitColorFromHex(profile.sprite.outfitColorHex);
  }

  // Preset hex mappings
  String _skinHex(String style) {
    switch (style) {
      case "Tan":
        return "#D7CCC8";
      case "Dark":
        return "#8D6E63";
      case "Celestial":
        return "#9575CD";
      case "Golden":
        return "#FFE082";
      case "Pale":
        return "#FFECB3";
      default:
        return "#FFD180"; // Fair
    }
  }

  String _skinPresetFromHex(String hex) {
    if (hex == "#D7CCC8") return "Tan";
    if (hex == "#8D6E63") return "Dark";
    if (hex == "#9575CD") return "Celestial";
    if (hex == "#FFE082") return "Golden";
    if (hex == "#FFECB3") return "Pale";
    return "Fair";
  }

  String _hairHex(String color) {
    switch (color) {
      case "Red":
        return "#FF3D00";
      case "Black":
        return "#212121";
      case "Blue":
        return "#29B6F6";
      case "Silver":
        return "#CFD8DC";
      case "Green":
        return "#66BB6A";
      case "Brown":
        return "#5D4037";
      case "Orange":
        return "#FF9100";
      default:
        return "#FFEA00"; // Yellow
    }
  }

  String _hairColorFromHex(String hex) {
    if (hex == "#FF3D00") return "Red";
    if (hex == "#212121") return "Black";
    if (hex == "#29B6F6") return "Blue";
    if (hex == "#CFD8DC") return "Silver";
    if (hex == "#66BB6A") return "Green";
    if (hex == "#5D4037") return "Brown";
    if (hex == "#FF9100") return "Orange";
    return "Yellow";
  }

  String _outfitColorHex(String style) {
    switch (style) {
      case "Dark Blue":
        return "#1A237E";
      case "Crimson":
        return "#B71C1C";
      case "Gold":
        return "#FFD700";
      case "Purple":
        return "#4A148C";
      case "Green":
        return "#1B5E20";
      case "Charcoal":
        return "#263238";
      case "Steel":
        return "#455A64";
      default:
        return "#37474F"; // Gray
    }
  }

  String _outfitColorFromHex(String hex) {
    if (hex == "#1A237E") return "Dark Blue";
    if (hex == "#B71C1C") return "Crimson";
    if (hex == "#FFD700") return "Gold";
    if (hex == "#4A148C") return "Purple";
    if (hex == "#1B5E20") return "Green";
    if (hex == "#263238") return "Charcoal";
    if (hex == "#455A64") return "Steel";
    return "Gray";
  }

  Color _activeSkinColor() => hexToColor(_skinHex(_skinPreset));
  Color _activeHairColor() => hexToColor(_hairHex(_hairColorPreset));
  Color _activeOutfitColor() => hexToColor(_outfitColorHex(_outfitColorPreset));

  Color _colorForPixelValue(int val, UserProfileManager profile) {
    switch (val) {
      case 1:
        return _activeSkinColor();
      case 2:
        return _activeHairColor();
      case 3:
        return profile.currentElement.primaryColor;
      case 4:
        return _activeOutfitColor();
      case 5:
        return profile.currentElement.accentColor;
      default:
        return Colors.white.withOpacity(0.08);
    }
  }

  void _paintPixel(int r, int c) {
    setState(() {
      _pixelGrid[r][c] = _selectedToolColor;
    });
  }

  void _clearCanvas() {
    setState(() {
      _pixelGrid = List.generate(50, (_) => List.generate(50, (_) => 0));
    });
  }

  void _generateBaseFromPresets() {
    setState(() {
      final grid = List.generate(50, (_) => List.generate(50, (_) => 0));
      
      // 1. Draw Aura (Value 5) - glowing orbits and particle accents around the margins
      for (int r = 0; r < 50; r++) {
        for (int c = 0; c < 50; c++) {
          final dx = (c - 25).toDouble();
          final dy = (r - 25).toDouble();
          final dist = math.sqrt(dx * dx + dy * dy);
          if (dist >= 21.0 && dist <= 23.5) {
            if ((r + c) % 3 == 0) {
              grid[r][c] = 5;
            }
          }
        }
      }
      
      // 2. Draw Legs / Feet (Value 4 or 1)
      for (int r = 42; r <= 47; r++) {
        for (int c = 18; c <= 22; c++) { grid[r][c] = 4; }
        for (int c = 28; c <= 32; c++) { grid[r][c] = 4; }
      }
      for (int c = 17; c <= 23; c++) { grid[48][c] = 4; grid[49][c] = 4; }
      for (int c = 27; c <= 33; c++) { grid[48][c] = 4; grid[49][c] = 4; }
      
      // 3. Draw Body & Armor (Value 4 = Armor, Value 1 = Skin)
      for (int r = 24; r <= 41; r++) {
        for (int c = 15; c <= 35; c++) {
          grid[r][c] = 4;
        }
      }
      
      // Customize Torso by Planet Style
      if (_planetPreset == "Ninjonia") {
        for (int r = 24; r <= 25; r++) {
          for (int c = 23; c <= 27; c++) {
            grid[r][c] = 1;
          }
        }
        for (int r = 21; r <= 23; r++) {
          for (int c = 18; c <= 32; c++) {
            grid[r][c] = 4;
          }
        }
        for (int i = 0; i <= 10; i++) {
          grid[26 + i][18 + i] = 5;
          grid[26 + i][19 + i] = 5;
        }
      } else if (_planetPreset == "Techno") {
        for (int r = 28; r <= 32; r++) {
          for (int c = 22; c <= 28; c++) {
            grid[r][c] = 5;
          }
        }
        for (int c = 24; c <= 25; c++) { grid[24][c] = 5; grid[25][c] = 5; }
        for (int c = 31; c <= 35; c++) { grid[24][c] = 5; grid[25][c] = 5; }
      } else if (_planetPreset == "Warrion") {
        for (int r = 24; r <= 27; r++) {
          for (int c = 13; c <= 16; c++) { grid[r][c] = 2; }
          for (int c = 34; c <= 37; c++) { grid[r][c] = 2; }
        }
        for (int r = 26; r <= 35; r++) {
          for (int c = 13; c <= 14; c++) { grid[r][c] = 1; }
          for (int c = 36; c <= 37; c++) { grid[r][c] = 1; }
        }
      } else {
        for (int r = 23; r <= 26; r++) {
          for (int c = 12; c <= 16; c++) { grid[r][c] = 4; }
          for (int c = 34; c <= 38; c++) { grid[r][c] = 4; }
        }
        for (int r = 28; r <= 35; r++) {
          grid[r][25] = 5;
        }
      }
      
      // 4. Draw Head / Face (Value 1 = Skin, Value 3 = Eyes)
      for (int r = 12; r <= 23; r++) {
        for (int c = 18; c <= 32; c++) {
          grid[r][c] = 1;
        }
      }
      
      // Visor/Mask variations on face
      if (_planetPreset == "Techno") {
        for (int r = 15; r <= 17; r++) {
          for (int c = 19; c <= 31; c++) {
            grid[r][c] = 3;
          }
        }
      } else if (_planetPreset == "Battacaria") {
        for (int r = 11; r <= 23; r++) {
          for (int c = 18; c <= 32; c++) {
            grid[r][c] = 4;
          }
        }
        for (int r = 14; r <= 16; r++) {
          for (int c = 21; c <= 29; c++) {
            grid[r][c] = 3;
          }
        }
      } else {
        grid[15][21] = 3; grid[15][22] = 3;
        grid[16][21] = 3; grid[16][22] = 3;
        grid[15][28] = 3; grid[15][29] = 3;
        grid[16][28] = 3; grid[16][29] = 3;
      }
      
      // 5. Draw Hair (Value 2)
      switch (_hairStylePreset) {
        case "Spiky":
          for (int c = 17; c <= 33; c++) { grid[11][c] = 2; }
          for (int c = 16; c <= 34; c++) { grid[10][c] = 2; }
          for (final col in [17, 20, 23, 27, 30, 33]) {
            grid[9][col] = 2; grid[8][col] = 2;
          }
          for (int r = 12; r <= 17; r++) {
            grid[r][17] = 2;
            grid[r][33] = 2;
          }
          break;
          
        case "Long":
          for (int r = 7; r <= 11; r++) {
            for (int c = 16; c <= 34; c++) { grid[r][c] = 2; }
          }
          for (int r = 12; r <= 28; r++) {
            for (int c = 15; c <= 17; c++) { grid[r][c] = 2; }
            for (int c = 33; c <= 35; c++) { grid[r][c] = 2; }
          }
          break;
          
        case "Short":
          for (int r = 9; r <= 11; r++) {
            for (int c = 18; c <= 32; c++) { grid[r][c] = 2; }
          }
          for (int r = 12; r <= 15; r++) {
            grid[r][17] = 2;
            grid[r][33] = 2;
          }
          break;
          
        case "Mohawk":
          for (int r = 5; r <= 11; r++) {
            for (int c = 24; c <= 26; c++) { grid[r][c] = 2; }
          }
          break;
          
        default:
          for (int c = 18; c <= 32; c++) { grid[11][c] = 2; }
      }
      
      _pixelGrid = grid;
    });
  }

  void _saveSprite(UserProfileManager profile) {
    profile.sprite.pixelGrid = _pixelGrid;
    profile.sprite.skinColorHex = _skinHex(_skinPreset);
    profile.sprite.hairColorHex = _hairHex(_hairColorPreset);
    profile.sprite.outfitColorHex = _outfitColorHex(_outfitColorPreset);
    profile.sprite.hairStyle = _hairStylePreset;
    profile.sprite.outfitStyle = _planetPreset;
    profile.sprite.sex = _sexPreset;
    profile.sprite = profile.sprite; // Trigger didSet save/notify
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfileManager>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050505),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // Header
              Text(
                "CHARACTER FORGE",
                style: GoogleFonts.orbitron(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Design your Elsaither Warrior's pixel avatar",
                style: GoogleFonts.exo2(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 25),

              // Canvas drawing grid
              Center(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: profile.currentElement.primaryColor.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_pixelGrid.length, (r) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(_pixelGrid[r].length, (c) {
                          final cellVal = _pixelGrid[r][c];
                          final pixelSize = _pixelGrid.length > 16 ? 5.5 : 16.0;
                          return GestureDetector(
                            onTap: () => _paintPixel(r, c),
                            onPanUpdate: (details) => _paintPixel(r, c),
                            child: Container(
                              width: pixelSize,
                              height: pixelSize,
                              margin: const EdgeInsets.all(0.2),
                              decoration: BoxDecoration(
                                color: _colorForPixelValue(cellVal, profile),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.04),
                                  width: 0.5,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Brush Palettes
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "PALETTE BRUSHES",
                  style: GoogleFonts.orbitron(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBrushButton(1, "Skin", _activeSkinColor()),
                  _buildBrushButton(2, "Hair", _activeHairColor()),
                  _buildBrushButton(3, "Eyes", profile.currentElement.primaryColor),
                  _buildBrushButton(4, "Armor", _activeOutfitColor()),
                  _buildBrushButton(5, "Aura", profile.currentElement.accentColor),
                  _buildBrushButton(0, "Eraser", Colors.black, isEraser: true),
                ],
              ),
              const SizedBox(height: 25),

              // Presets Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PRESETS & LAYERS",
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    _buildPresetDropdown("Sex", _sexPreset, ["Male", "Female"], (val) {
                      setState(() {
                        _sexPreset = val!;
                      });
                    }, profile),
                    _buildPresetDropdown("Planet Style", _planetPreset, ["Ninjonia", "Techno", "Warrion", "Battacaria"], (val) {
                      setState(() {
                        _planetPreset = val!;
                      });
                    }, profile),
                    _buildPresetDropdown("Skin Tone", _skinPreset, ["Fair", "Tan", "Dark", "Celestial", "Golden", "Pale"], (val) {
                      setState(() {
                        _skinPreset = val!;
                      });
                    }, profile),
                    _buildPresetDropdown("Hair Style", _hairStylePreset, ["Spiky", "Long", "Short", "Mohawk"], (val) {
                      setState(() {
                        _hairStylePreset = val!;
                      });
                    }, profile),
                    _buildPresetDropdown("Hair Color", _hairColorPreset, ["Yellow", "Red", "Black", "Blue", "Silver", "Green", "Brown", "Orange"], (val) {
                      setState(() {
                        _hairColorPreset = val!;
                      });
                    }, profile),
                    _buildPresetDropdown("Clothing Color", _outfitColorPreset, ["Gray", "Dark Blue", "Crimson", "Gold", "Purple", "Green", "Charcoal", "Steel"], (val) {
                      setState(() {
                        _outfitColorPreset = val!;
                      });
                    }, profile),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _generateBaseFromPresets,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: profile.currentElement.primaryColor.withOpacity(0.2),
                              side: BorderSide(color: profile.currentElement.primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "COMPOSITE PRESETS",
                              style: GoogleFonts.orbitron(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _clearCanvas,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "CLEAR CANVAS",
                              style: GoogleFonts.orbitron(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _saveSprite(profile),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: profile.currentElement.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 6,
                    shadowColor: profile.currentElement.primaryColor.withOpacity(0.4),
                  ),
                  child: Text(
                    "FORGE ARTIFACT",
                    style: GoogleFonts.orbitron(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrushButton(int val, String label, Color color, {bool isEraser = false}) {
    final isSelected = _selectedToolColor == val;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedToolColor = val;
        });
      },
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isEraser ? Colors.white.withOpacity(0.15) : color,
              borderRadius: BorderRadius.circular(6),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : Border.all(color: Colors.transparent, width: 2),
            ),
            child: isEraser
                ? const Icon(Icons.cleaning_services_rounded, color: Colors.white, size: 18)
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPresetDropdown(
    String title,
    String currentValue,
    List<String> options,
    ValueChanged<String?> onChanged,
    UserProfileManager profile,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.exo2(fontSize: 13, color: Colors.white),
            ),
            DropdownButton<String>(
              value: currentValue,
              items: options.map((opt) {
                return DropdownMenuItem<String>(
                  value: opt,
                  child: Text(
                    opt,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              dropdownColor: const Color(0xFF0F0F0F),
              underline: const SizedBox(),
              iconEnabledColor: profile.currentElement.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
