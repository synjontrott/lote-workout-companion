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
    _pixelGrid = List.generate(16, (r) => List.from(profile.sprite.pixelGrid));

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
      _pixelGrid = List.generate(16, (_) => List.generate(16, (_) => 0));
    });
  }

  void _generateBaseFromPresets() {
    setState(() {
      final grid = List.generate(16, (_) => List.generate(16, (_) => 0));

      // 1. Draw Aura (Value 5)
      grid[1][3] = 5; grid[1][12] = 5;
      grid[3][1] = 5; grid[3][14] = 5;
      grid[5][2] = 5; grid[5][13] = 5;
      grid[7][1] = 5; grid[7][14] = 5;
      grid[9][2] = 5; grid[9][13] = 5;
      grid[11][1] = 5; grid[11][14] = 5;
      grid[13][3] = 5; grid[13][12] = 5;
      grid[14][4] = 5; grid[14][11] = 5;

      // 2. Draw Legs/Feet (Value 4 or 1)
      if (_planetPreset == "Warrion") {
        grid[14][5] = 1; grid[14][10] = 1;
        grid[15][5] = 4; grid[15][10] = 4;
      } else if (_planetPreset == "Ninjonia" && _sexPreset == "Female") {
        for (int c = 4; c <= 11; c++) {
          grid[14][c] = 4;
        }
        grid[15][6] = 1; grid[15][9] = 1;
      } else {
        grid[14][5] = 4; grid[14][10] = 4;
        grid[15][5] = 4; grid[15][10] = 4;
      }

      // 3. Draw Body & Arms (Outfit = 4, Skin = 1)
      switch (_planetPreset) {
        case "Ninjonia":
          if (_sexPreset == "Female") {
            grid[9][7] = 1; grid[9][8] = 1; // neck
            grid[10][5] = 4; grid[10][6] = 4; grid[10][7] = 1; grid[10][8] = 1; grid[10][9] = 4; grid[10][10] = 4;
            for (int c = 5; c <= 10; c++) { grid[11][c] = 4; }
            for (int c = 4; c <= 11; c++) { grid[12][c] = 4; }
            for (int c = 3; c <= 12; c++) { grid[13][c] = 4; }
            for (int r = 10; r <= 12; r++) {
              grid[r][3] = 1;
              grid[r][12] = 1;
            }
          } else {
            grid[9][7] = 1; grid[9][8] = 1; // neck
            grid[10][5] = 1; grid[10][6] = 1; grid[10][7] = 4; grid[10][8] = 4; grid[10][9] = 4; grid[10][10] = 4;
            grid[11][5] = 1; grid[11][6] = 4; grid[11][7] = 4; grid[11][8] = 4; grid[11][9] = 4; grid[11][10] = 4;
            for (int c = 5; c <= 10; c++) {
              grid[12][c] = 4;
              grid[13][c] = 4;
            }
            for (int r = 10; r <= 12; r++) {
              grid[r][3] = 1; grid[r][4] = 1;
            }
            for (int r = 10; r <= 12; r++) {
              grid[r][11] = 4; grid[r][12] = 4;
            }
            grid[13][11] = 1; grid[13][12] = 1;
            grid[13][3] = 1; grid[13][4] = 1;
          }
          break;

        case "Techno":
          for (int r = 9; r <= 13; r++) {
            for (int c = 5; c <= 10; c++) {
              grid[r][c] = 4;
            }
          }
          for (int r = 10; r <= 12; r++) {
            grid[r][3] = 4; grid[r][4] = 4;
            grid[r][11] = 4; grid[r][12] = 4;
          }
          grid[13][3] = 1; grid[13][4] = 1;
          grid[13][11] = 1; grid[13][12] = 1;

          grid[8][5] = 4; grid[8][10] = 4;
          grid[8][6] = 4; grid[8][7] = 4; grid[8][8] = 4; grid[8][9] = 4;
          break;

        case "Warrion":
          if (_sexPreset == "Female") {
            grid[9][7] = 1; grid[9][8] = 1; // neck
            for (int c = 5; c <= 10; c++) { grid[10][c] = 4; } // fur top
            for (int c = 5; c <= 10; c++) { grid[11][c] = 1; } // bare midriff
            for (int c = 5; c <= 10; c++) { grid[12][c] = 4; } // belt
            for (int c = 4; c <= 11; c++) { grid[13][c] = 4; } // skirt
          } else {
            grid[9][7] = 1; grid[9][8] = 1; // neck
            grid[10][5] = 1; grid[10][6] = 4; grid[10][7] = 1; grid[10][8] = 1; grid[10][9] = 4; grid[10][10] = 1; // straps
            grid[11][5] = 1; grid[11][6] = 1; grid[11][7] = 4; grid[11][8] = 4; grid[11][9] = 1; grid[11][10] = 1;
            for (int c = 5; c <= 10; c++) { grid[12][c] = 4; }
            grid[13][5] = 1; grid[13][6] = 4; grid[13][7] = 4; grid[13][8] = 4; grid[13][9] = 4; grid[13][10] = 1;
          }
          for (int r = 10; r <= 12; r++) {
            grid[r][3] = 1; grid[r][4] = 1;
            grid[r][11] = 1; grid[r][12] = 1;
          }
          grid[13][3] = 1; grid[13][4] = 1; grid[13][11] = 1; grid[13][12] = 1;
          break;

        case "Battacaria":
          grid[9][7] = 4; grid[9][8] = 4;
          grid[9][4] = 4; grid[10][4] = 4; // left heavy pauldron
          for (int r = 10; r <= 11; r++) {
            for (int c = 5; c <= 10; c++) {
              grid[r][c] = 4;
            }
          }
          for (int c = 4; c <= 11; c++) {
            grid[12][c] = 4;
          }
          for (int c = 4; c <= 11; c++) {
            grid[13][c] = 4;
          }
          for (int r = 10; r <= 12; r++) {
            grid[r][3] = 4;
          }
          grid[10][11] = 1; grid[10][12] = 1;
          grid[11][11] = 1; grid[11][12] = 1;
          grid[12][11] = 4; grid[12][12] = 4; // gauntlet
          grid[13][3] = 4; grid[13][11] = 4; grid[13][12] = 4;
          break;

        default:
          for (int r = 9; r <= 13; r++) {
            for (int c = 5; c <= 10; c++) {
              grid[r][c] = 4;
            }
          }
          for (int r = 10; r <= 12; r++) {
            grid[r][4] = 4; grid[r][11] = 4;
          }
          grid[14][5] = 4; grid[14][10] = 4;
      }

      // 4. Draw Face/Skin (Value 1)
      for (int r = 4; r <= 8; r++) {
        for (int c = 5; c <= 10; c++) {
          if (grid[r][c] != 4) {
            grid[r][c] = 1;
          }
        }
      }
      if (_planetPreset == "Battacaria") {
        grid[4][5] = 4; grid[4][10] = 4;
        grid[5][5] = 4; grid[5][6] = 4; grid[5][9] = 4; grid[5][10] = 4;
      }

      // 5. Draw Eyes (Value 3)
      grid[6][6] = 3;
      grid[6][9] = 3;

      // 6. Draw Hair (Value 2)
      switch (_hairStylePreset) {
        case "Spiky":
          for (int c = 5; c <= 10; c++) { grid[3][c] = 2; }
          grid[2][5] = 2; grid[2][7] = 2; grid[2][8] = 2; grid[2][10] = 2;
          grid[1][5] = 2; grid[1][10] = 2;
          grid[4][4] = 2; grid[4][11] = 2;
          grid[5][4] = 2; grid[5][11] = 2;
          break;

        case "Long":
          for (int c = 5; c <= 10; c++) { grid[3][c] = 2; }
          for (int c = 4; c <= 11; c++) { grid[4][c] = 2; }
          grid[5][4] = 2; grid[5][11] = 2;
          grid[6][4] = 2; grid[6][11] = 2;
          grid[7][4] = 2; grid[7][11] = 2;
          grid[8][4] = 2; grid[8][11] = 2;
          grid[9][4] = 2; grid[9][11] = 2;
          grid[10][4] = 2; grid[10][11] = 2;
          break;

        case "Short":
          for (int c = 4; c <= 11; c++) { grid[3][c] = 2; }
          grid[4][4] = 2; grid[4][11] = 2;
          grid[5][4] = 2; grid[5][11] = 2;
          break;

        case "Mohawk":
          grid[1][7] = 2; grid[1][8] = 2;
          grid[2][7] = 2; grid[2][8] = 2;
          grid[3][7] = 2; grid[3][8] = 2;
          grid[4][7] = 2; grid[4][8] = 2;
          break;

        default:
          for (int c = 4; c <= 11; c++) { grid[3][c] = 2; }
          grid[2][5] = 2; grid[2][10] = 2;
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
                    children: List.generate(16, (r) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(16, (c) {
                          final cellVal = _pixelGrid[r][c];
                          return GestureDetector(
                            onTap: () => _paintPixel(r, c),
                            onPanUpdate: (details) => _paintPixel(r, c),
                            child: Container(
                              width: 16,
                              height: 16,
                              margin: const EdgeInsets.all(0.5),
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
