import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:math' show min, max, Random;

Color hexToColor(String hex) {
  final buffer = StringBuffer();
  if (hex.length == 6 || hex.length == 7) buffer.write('ff');
  buffer.write(hex.replaceFirst('#', ''));
  try {
    return Color(int.parse(buffer.toString(), radix: 16));
  } catch (_) {
    return Colors.red;
  }
}

class LotEElement {
  final String name;
  final String corruptName;
  final String description;
  final String corruptDescription;
  final String standardDetails;
  final String corruptDetails;
  final String balancedDetails;
  final String primaryColorHex;
  final String accentColorHex;
  final String secondaryColorHex;
  final String detailColorHex;
  final String planetOfOrigin;
  final bool inherentDark;

  const LotEElement({
    required this.name,
    required this.corruptName,
    required this.description,
    required this.corruptDescription,
    required this.standardDetails,
    required this.corruptDetails,
    required this.balancedDetails,
    required this.primaryColorHex,
    required this.accentColorHex,
    required this.secondaryColorHex,
    required this.detailColorHex,
    required this.planetOfOrigin,
    required this.inherentDark,
  });

  Color get primaryColor => hexToColor(primaryColorHex);
  Color get accentColor => hexToColor(accentColorHex);
  Color get secondaryColor => hexToColor(secondaryColorHex);
  Color get detailColor => hexToColor(detailColorHex);

  LotEElement corruptedVersion() {
    return LotEElement(
      name: corruptName,
      corruptName: corruptName,
      description: corruptDescription,
      corruptDescription: corruptDescription,
      standardDetails: corruptDetails,
      corruptDetails: corruptDetails,
      balancedDetails: corruptDetails,
      primaryColorHex: primaryColorHex,
      accentColorHex: accentColorHex,
      secondaryColorHex: secondaryColorHex,
      detailColorHex: detailColorHex,
      planetOfOrigin: planetOfOrigin,
      inherentDark: true,
    );
  }

  String displayName(ExpressionStyle expression) {
    if (inherentDark) return name;
    switch (expression) {
      case ExpressionStyle.standard:
        return name;
      case ExpressionStyle.corrupt:
        return corruptName;
      case ExpressionStyle.balanced:
        return 'Balanced $name';
    }
  }
}

enum ExpressionStyle {
  standard('Standard (Light)'),
  corrupt('Corrupted (Dark)'),
  balanced('Balanced (Irghposan)');

  final String displayName;
  const ExpressionStyle(this.displayName);
}

enum CognitiveProfile {
  adhd('The Flame Sentinel'),
  autistic('The Iron Archivist'),
  audhd('The Chimera'),
  neurotypical('The Radiant Vanguard');

  final String title;
  const CognitiveProfile(this.title);

  String get description {
    switch (this) {
      case CognitiveProfile.adhd:
        return "Dopamine-seeking and novelty-driven. You excel when workouts are varied, gamified, and reward you with instant excitement. Routines can feel heavy, so flexibility and quick 'Dopamine Menu' challenges are your secret weapon.";
      case CognitiveProfile.autistic:
        return "Structure-seeking and analytical. You thrive on consistent routines, clear schedules, direct expectations, and deep progress analytics. You find comfort in predictability and detailed records of your training.";
      case CognitiveProfile.audhd:
        return "A unique blend of structure and high-energy novelty. You need a structured skeleton framework to stay grounded, but you require flexible, custom options within that framework to prevent demand avoidance.";
      case CognitiveProfile.neurotypical:
        return "Progressive-overload and habit-loop oriented. You respond well to classic progressive training, habit stacking, goal milestones, and consistent streaks that build up over time.";
    }
  }
}

enum WarriorTier {
  recruit('Elsaither Recruit', 1),
  apprentice('Krenpowen Apprentice', 5),
  vanguard('Warrion Vanguard', 12),
  sentinel('Ninjonian Sentinel', 20),
  master('Irghposan Master', 35),
  legend('Legend of the Elsaither', 50);

  final String displayName;
  final int levelRequired;
  const WarriorTier(this.displayName, this.levelRequired);

  String dynamicDisplayName(String elementName) {
    switch (elementName) {
      case 'Fire':
        switch (this) {
          case WarriorTier.recruit: return "Ember Recruit";
          case WarriorTier.apprentice: return "Flame Apprentice";
          case WarriorTier.vanguard: return "Cinder Vanguard";
          case WarriorTier.sentinel: return "Blaze Sentinel";
          case WarriorTier.master: return "Inferno Master";
          case WarriorTier.legend: return "Legend of the Phoenix";
        }
      case 'Water':
        switch (this) {
          case WarriorTier.recruit: return "Tide Recruit";
          case WarriorTier.apprentice: return "Hydro Apprentice";
          case WarriorTier.vanguard: return "Torrent Vanguard";
          case WarriorTier.sentinel: return "Wave Sentinel";
          case WarriorTier.master: return "Abyss Master";
          case WarriorTier.legend: return "Legend of the Ocean";
        }
      case 'Earth':
        switch (this) {
          case WarriorTier.recruit: return "Stone Recruit";
          case WarriorTier.apprentice: return "Clay Apprentice";
          case WarriorTier.vanguard: return "Rock Vanguard";
          case WarriorTier.sentinel: return "Ridge Sentinel";
          case WarriorTier.master: return "Mountain Master";
          case WarriorTier.legend: return "Legend of the Golem";
        }
      case 'Air':
        switch (this) {
          case WarriorTier.recruit: return "Wind Recruit";
          case WarriorTier.apprentice: return "Gale Apprentice";
          case WarriorTier.vanguard: return "Zephyr Vanguard";
          case WarriorTier.sentinel: return "Vortex Sentinel";
          case WarriorTier.master: return "Tempest Master";
          case WarriorTier.legend: return "Legend of the Storm";
        }
      case 'Lightning':
        switch (this) {
          case WarriorTier.recruit: return "Spark Recruit";
          case WarriorTier.apprentice: return "Bolt Apprentice";
          case WarriorTier.vanguard: return "Shock Vanguard";
          case WarriorTier.sentinel: return "Storm Sentinel";
          case WarriorTier.master: return "Voltage Master";
          case WarriorTier.legend: return "Legend of Thunder";
        }
      case 'Metal':
        switch (this) {
          case WarriorTier.recruit: return "Iron Recruit";
          case WarriorTier.apprentice: return "Steel Apprentice";
          case WarriorTier.vanguard: return "Alloy Vanguard";
          case WarriorTier.sentinel: return "Shield Sentinel";
          case WarriorTier.master: return "Forge Master";
          case WarriorTier.legend: return "Legend of Titanium";
        }
      case 'Ice':
        switch (this) {
          case WarriorTier.recruit: return "Frost Recruit";
          case WarriorTier.apprentice: return "Ice Apprentice";
          case WarriorTier.vanguard: return "Glacier Vanguard";
          case WarriorTier.sentinel: return "Shard Sentinel";
          case WarriorTier.master: return "Tundra Master";
          case WarriorTier.legend: return "Legend of Blizzard";
        }
      case 'Bone':
        switch (this) {
          case WarriorTier.recruit: return "Calcium Recruit";
          case WarriorTier.apprentice: return "Skeletal Apprentice";
          case WarriorTier.vanguard: return "Fossil Vanguard";
          case WarriorTier.sentinel: return "Marrow Sentinel";
          case WarriorTier.master: return "Crypt Master";
          case WarriorTier.legend: return "Legend of the Grave";
        }
      case 'Gas':
        switch (this) {
          case WarriorTier.recruit: return "Vapor Recruit";
          case WarriorTier.apprentice: return "Mist Apprentice";
          case WarriorTier.vanguard: return "Cloud Vanguard";
          case WarriorTier.sentinel: return "Fume Sentinel";
          case WarriorTier.master: return "Plasma Master";
          case WarriorTier.legend: return "Legend of Atmosphere";
        }
      case 'Laser':
        switch (this) {
          case WarriorTier.recruit: return "Ray Recruit";
          case WarriorTier.apprentice: return "Beam Apprentice";
          case WarriorTier.vanguard: return "Pulse Vanguard";
          case WarriorTier.sentinel: return "Focus Sentinel";
          case WarriorTier.master: return "Photon Master";
          case WarriorTier.legend: return "Legend of the Cosmos";
        }
      case 'Zero Space':
        switch (this) {
          case WarriorTier.recruit: return "Node Recruit";
          case WarriorTier.apprentice: return "Rift Apprentice";
          case WarriorTier.vanguard: return "Warp Vanguard";
          case WarriorTier.sentinel: return "Gate Sentinel";
          case WarriorTier.master: return "Singularity Master";
          case WarriorTier.legend: return "Legend of the Void";
        }
      case 'Darki':
        switch (this) {
          case WarriorTier.recruit: return "Dark Recruit";
          case WarriorTier.apprentice: return "Shade Apprentice";
          case WarriorTier.vanguard: return "Night Vanguard";
          case WarriorTier.sentinel: return "Royal Sentinel";
          case WarriorTier.master: return "Sovereign Master";
          case WarriorTier.legend: return "Legend of Eclipse";
        }
      case 'Death':
        switch (this) {
          case WarriorTier.recruit: return "Wither Recruit";
          case WarriorTier.apprentice: return "Decay Apprentice";
          case WarriorTier.vanguard: return "Reaper Vanguard";
          case WarriorTier.sentinel: return "Soul Sentinel";
          case WarriorTier.master: return "Crypt Master";
          case WarriorTier.legend: return "Legend of Doom";
        }
      case 'Knife':
        switch (this) {
          case WarriorTier.recruit: return "Edge Recruit";
          case WarriorTier.apprentice: return "Blade Apprentice";
          case WarriorTier.vanguard: return "Dagger Vanguard";
          case WarriorTier.sentinel: return "Pierce Sentinel";
          case WarriorTier.master: return "Saber Master";
          case WarriorTier.legend: return "Legend of the Sword";
        }
      case 'Poison':
        switch (this) {
          case WarriorTier.recruit: return "Venom Recruit";
          case WarriorTier.apprentice: return "Toxin Apprentice";
          case WarriorTier.vanguard: return "Viper Vanguard";
          case WarriorTier.sentinel: return "Acid Sentinel";
          case WarriorTier.master: return "Serum Master";
          case WarriorTier.legend: return "Legend of Plague";
        }
      case 'Shadow':
        switch (this) {
          case WarriorTier.recruit: return "Shade Recruit";
          case WarriorTier.apprentice: return "Dusk Apprentice";
          case WarriorTier.vanguard: return "Veil Vanguard";
          case WarriorTier.sentinel: return "Phantom Sentinel";
          case WarriorTier.master: return "Eclipse Master";
          case WarriorTier.legend: return "Legend of the Ghost";
        }
      default:
        return displayName;
    }
  }

  String get description {
    switch (this) {
      case WarriorTier.recruit:
        return "A newly awakened warrior finding their resonance. Every step is a discovery.";
      case WarriorTier.apprentice:
        return "Standard elemental channeler learning to shape raw energy and control output.";
      case WarriorTier.vanguard:
        return "Grounded, resilient warrior with refined elemental control and deep endurance.";
      case WarriorTier.sentinel:
        return "Highly disciplined elite protector showing perfect form, technique, and willpower.";
      case WarriorTier.master:
        return "A rare champion who harnesses the power inside or the darkness within.";
      case WarriorTier.legend:
        return "Achieved perfect balance and raw spatial mastery. A force of the cosmos.";
    }
  }
}

enum StatType {
  strength('Strength'),
  dexterity('Dexterity'),
  constitution('Constitution'),
  intelligence('Intelligence'),
  wisdom('Wisdom'),
  charisma('Charisma');

  final String displayName;
  const StatType(this.displayName);
}

class DNDStats {
  int strength;
  int dexterity;
  int constitution;
  int intelligence;
  int wisdom;
  int charisma;

  DNDStats({
    this.strength = 10,
    this.dexterity = 10,
    this.constitution = 10,
    this.intelligence = 10,
    this.wisdom = 10,
    this.charisma = 10,
  });

  Map<String, dynamic> toJson() => {
        'strength': strength,
        'dexterity': dexterity,
        'constitution': constitution,
        'intelligence': intelligence,
        'wisdom': wisdom,
        'charisma': charisma,
      };

  factory DNDStats.fromJson(Map<String, dynamic> json) {
    return DNDStats(
      strength: json['strength'] ?? 10,
      dexterity: json['dexterity'] ?? 10,
      constitution: json['constitution'] ?? 10,
      intelligence: json['intelligence'] ?? 10,
      wisdom: json['wisdom'] ?? 10,
      charisma: json['charisma'] ?? 10,
    );
  }

  int getModifier(StatType stat) {
    int val = 10;
    switch (stat) {
      case StatType.strength: val = strength; break;
      case StatType.dexterity: val = dexterity; break;
      case StatType.constitution: val = constitution; break;
      case StatType.intelligence: val = intelligence; break;
      case StatType.wisdom: val = wisdom; break;
      case StatType.charisma: val = charisma; break;
    }
    return ((val - 10) / 2).floor();
  }

  void increase(StatType stat, int amount) {
    switch (stat) {
      case StatType.strength: strength += amount; break;
      case StatType.dexterity: dexterity += amount; break;
      case StatType.constitution: constitution += amount; break;
      case StatType.intelligence: intelligence += amount; break;
      case StatType.wisdom: wisdom += amount; break;
      case StatType.charisma: charisma += amount; break;
    }
  }

  void decrease(StatType stat, int amount) {
    switch (stat) {
      case StatType.strength: strength = (strength - amount).clamp(1, 999); break;
      case StatType.dexterity: dexterity = (dexterity - amount).clamp(1, 999); break;
      case StatType.constitution: constitution = (constitution - amount).clamp(1, 999); break;
      case StatType.intelligence: intelligence = (intelligence - amount).clamp(1, 999); break;
      case StatType.wisdom: wisdom = (wisdom - amount).clamp(1, 999); break;
      case StatType.charisma: charisma = (charisma - amount).clamp(1, 999); break;
    }
  }
}

class CharacterSprite {
  String hairStyle;
  String hairColorHex;
  String skinColorHex;
  String outfitStyle;
  String outfitColorHex;
  String auraStyle;
  String sex;
  List<List<int>> pixelGrid;

  CharacterSprite({
    this.hairStyle = 'Spiky',
    this.hairColorHex = '#FFEA00',
    this.skinColorHex = '#FFD180',
    this.outfitStyle = 'Ninjonia',
    this.outfitColorHex = '#37474F',
    this.auraStyle = 'Flames',
    this.sex = 'Male',
    List<List<int>>? grid,
  }) : pixelGrid = grid ?? generateGrid(planet: outfitStyle, hairStyle: hairStyle, sex: sex);

  Map<String, dynamic> toJson() => {
        'hairStyle': hairStyle,
        'hairColorHex': hairColorHex,
        'skinColorHex': skinColorHex,
        'outfitStyle': outfitStyle,
        'outfitColorHex': outfitColorHex,
        'auraStyle': auraStyle,
        'sex': sex,
        'pixelGrid': pixelGrid,
      };

  factory CharacterSprite.fromJson(Map<String, dynamic> json) {
    final rawGrid = json['pixelGrid'] as List<dynamic>?;
    List<List<int>> grid;
    final oStyle = json['outfitStyle'] ?? 'Ninjonia';
    final hStyle = json['hairStyle'] ?? 'Spiky';
    final gSex = json['sex'] ?? 'Male';
    if (rawGrid != null) {
      final decoded = rawGrid
          .map((row) => (row as List<dynamic>).map((cell) => cell as int).toList())
          .toList();
      if (decoded.length < 300 || (decoded.isNotEmpty && decoded[0].length < 300)) {
        grid = scale16To300(decoded);
      } else {
        grid = decoded;
      }
    } else {
      grid = generateGrid(planet: oStyle, hairStyle: hStyle, sex: gSex);
    }
    return CharacterSprite(
      hairStyle: hStyle,
      hairColorHex: json['hairColorHex'] ?? '#FFEA00',
      skinColorHex: json['skinColorHex'] ?? '#FFD180',
      outfitStyle: oStyle,
      outfitColorHex: json['outfitColorHex'] ?? '#37474F',
      auraStyle: json['auraStyle'] ?? 'Flames',
      sex: gSex,
      grid: grid,
    );
  }

  static List<List<int>> scale16To300(List<List<int>> grid16) {
    List<List<int>> grid300 = List.generate(300, (_) => List.generate(300, (_) => 0));
    for (int r = 0; r < 300; r++) {
      for (int c = 0; c < 300; c++) {
        int r16 = (r * 16) ~/ 300;
        int c16 = (c * 16) ~/ 300;
        if (r16 < grid16.length && c16 < grid16[r16].length) {
          grid300[r][c] = grid16[r16][c16];
        }
      }
    }
    return grid300;
  }

  static List<List<int>> get defaultGrid {
    return generateGrid(planet: 'Ninjonia', hairStyle: 'Spiky', sex: 'Male');
  }

  static List<List<int>> generateGrid({required String planet, required String hairStyle, required String sex}) {
    final grid = List.generate(300, (_) => List.generate(300, (_) => 0));
    final isFemale = sex.toLowerCase() == "female";
    
    // 1. Cosmic/Elemental Aura Smoke Trails (5)
    for (int r = 0; r < 300; r++) {
      for (int c = 0; c < 300; c++) {
        final dx = (c - 150).toDouble();
        final dy = (r - 150).toDouble();
        final dist = math.sqrt(dx*dx + dy*dy);
        
        // Outer energy rings
        if (dist >= 128.0 && dist <= 135.0) {
          if ((r + c) % 3 == 0) { grid[r][c] = 5; }
        }
        
        // Wavy smoke plumes rising up
        if (r >= 60 && r <= 240) {
          final wave = math.sin(r.toDouble() * 0.08) * 16.0;
          // Left smoke plume
          if (c >= 30 && c < 90) {
            final edge = 80.0 + wave - (r - 60).toDouble() * 0.08;
            if (c.toDouble() >= edge - 12.0 && c.toDouble() <= edge) {
              if ((r + c) % 2 == 0) { grid[r][c] = 5; }
            }
          }
          // Right smoke plume
          if (c > 210 && c <= 270) {
            final edge = 220.0 + wave + (r - 60).toDouble() * 0.08;
            if (c.toDouble() >= edge && c.toDouble() <= edge + 12.0) {
              if ((r + c) % 2 == 0) { grid[r][c] = 5; }
            }
          }
        }
      }
    }
    
    // 2. Male Crossed Back Swords (4 for hilt, 5 for glowing energy blades)
    if (!isFemale) {
      // Sword 1
      for (int i = -30; i <= 90; i++) {
        final rCoord = 150 + i;
        final cCoord = 150 + i;
        if (rCoord >= 0 && rCoord < 300 && cCoord >= 0 && cCoord < 300) {
          for (int offset = -1; offset <= 1; offset++) {
            if (i < 0) {
              grid[rCoord + offset][cCoord - offset] = 4;
            } else if (i >= 20) {
              grid[rCoord + offset][cCoord - offset] = 5;
            }
          }
        }
      }
      // Sword 2
      for (int i = -30; i <= 90; i++) {
        final rCoord = 150 + i;
        final cCoord = 150 - i;
        if (rCoord >= 0 && rCoord < 300 && cCoord >= 0 && cCoord < 300) {
          for (int offset = -1; offset <= 1; offset++) {
            if (i < 0) {
              grid[rCoord + offset][cCoord + offset] = 4;
            } else if (i >= 20) {
              grid[rCoord + offset][cCoord + offset] = 5;
            }
          }
        }
      }
    }
    
    // 3. Wavy Flowing Hair (Back layer for female) (2)
    if (isFemale) {
      for (int r = 60; r <= 220; r++) {
        final waveL = math.sin(r.toDouble() * 0.06) * 7.0;
        final waveR = math.cos(r.toDouble() * 0.06) * 7.0;
        
        final leftStart = (92.0 + waveL).toInt();
        final leftEnd = (116.0 + waveL).toInt();
        for (int c = leftStart; c <= leftEnd; c++) { grid[r][c] = 2; }
        
        final rightStart = (184.0 + waveR).toInt();
        final rightEnd = (208.0 + waveR).toInt();
        for (int c = rightStart; c <= rightEnd; c++) { grid[r][c] = 2; }
      }
    }
    
    // 4. Armored Torso (4) - Differentiated silhouettes & structures
    if (planet == "Warrion") {
      const startRow = 150;
      const endRow = 260;
      for (int r = startRow; r <= endRow; r++) {
        final pct = (r - startRow).toDouble() / (endRow - startRow).toDouble();
        final baseHalfW = isFemale ? 56.0 : 76.0;
        final waistHalfW = isFemale ? 38.0 : 54.0;
        
        final segmentIndex = (r - startRow) ~/ 28;
        final segmentOffset = segmentIndex.toDouble() * 2.5;
        final halfWidth = baseHalfW - pct * (baseHalfW - waistHalfW) + segmentOffset;
        
        final leftC = (150.0 - halfWidth).toInt();
        final rightC = (150.0 + halfWidth).toInt();
        for (int c = leftC; c <= rightC; c++) {
          if ((r - startRow) % 28 == 0 || (r - startRow) % 28 == 27) {
            grid[r][c] = 5;
          } else if (c == leftC || c == rightC) {
            grid[r][c] = 5;
          } else {
            grid[r][c] = 4;
          }
        }
      }
      
      // Warrion High Neck-Guard Shroud
      for (int r = 115; r <= 142; r++) {
        final guardHalfW = isFemale ? 35 : 48;
        for (int c = (150 - guardHalfW); c <= (150 + guardHalfW); c++) {
          if ((c - 150).abs() > (isFemale ? 20 : 28)) {
            grid[r][c] = 4;
          }
        }
      }
      
      // Heavy hip tassets (skirt armor)
      for (int r = 240; r <= 265; r++) {
        final skirtHalfW = isFemale ? 52 : 72;
        for (int c = (150 - skirtHalfW); c <= (150 + skirtHalfW); c++) {
          if ((c - 150) % 18 == 0) {
            grid[r][c] = 5;
          } else {
            grid[r][c] = 4;
          }
        }
      }
      
    } else if (planet == "Techno") {
      const startRow = 150;
      const endRow = 260;
      for (int r = startRow; r <= endRow; r++) {
        final baseHalfW = isFemale ? 48.0 : 62.0;
        final waistHalfW = isFemale ? 28.0 : 46.0;
        double halfWidth = baseHalfW;
        if (r > 185 && r < 225) {
          halfWidth = waistHalfW;
        } else if (r >= 225) {
          halfWidth = baseHalfW - 8.0;
        }
        
        final leftC = (150.0 - halfWidth).toInt();
        final rightC = (150.0 + halfWidth).toInt();
        for (int c = leftC; c <= rightC; c++) {
          if (r % 14 == 0 || c % 14 == 0) {
            grid[r][c] = 5;
          } else if (c == leftC || c == rightC) {
            grid[r][c] = 5;
          } else {
            grid[r][c] = 4;
          }
        }
      }
      
      // Mech Chest vents
      for (int r = 165; r <= 185; r++) {
        const ventLStart = 110;
        const ventLEnd = 126;
        const ventRStart = 174;
        const ventREnd = 190;
        for (int c = ventLStart; c <= ventLEnd; c++) { grid[r][c] = 5; }
        for (int c = ventRStart; c <= ventREnd; c++) { grid[r][c] = 5; }
      }
      
    } else {
      // Ninjonia
      const startRow = 150;
      const endRow = 260;
      for (int r = startRow; r <= endRow; r++) {
        final pct = (r - startRow).toDouble() / (endRow - startRow).toDouble();
        final baseHalfW = isFemale ? 42.0 : 54.0;
        final waistHalfW = isFemale ? 22.0 : 34.0;
        final halfWidth = baseHalfW - pct * (baseHalfW - waistHalfW);
        
        final leftC = (150.0 - halfWidth).toInt();
        final rightC = (150.0 + halfWidth).toInt();
        for (int c = leftC; c <= rightC; c++) {
          final wrapLine = (c - 150) - ((r - 150).toDouble() * 0.6).toInt();
          if (wrapLine.abs() < 3 || c == leftC || c == rightC || c == 150) {
            grid[r][c] = 5;
          } else {
            grid[r][c] = 4;
          }
        }
      }
    }
    
    // 5. Curved/Layered Pauldrons (4)
    final double shoulderHalfW;
    if (planet == "Warrion") {
      shoulderHalfW = isFemale ? 56.0 : 76.0;
    } else if (planet == "Techno") {
      shoulderHalfW = isFemale ? 48.0 : 62.0;
    } else {
      shoulderHalfW = isFemale ? 42.0 : 54.0;
    }
    
    final pauldronCenterL = 150.0 - shoulderHalfW;
    final pauldronCenterR = 150.0 + shoulderHalfW;
    
    if (planet == "Warrion") {
      final radius = isFemale ? 16.0 : 22.0;
      for (int r = 136; r <= 176; r++) {
        final startC = (pauldronCenterL - radius).toInt();
        final endC = (pauldronCenterL + radius * 0.6).toInt();
        for (int c = startC; c <= endC; c++) {
          final dx = c.toDouble() - pauldronCenterL;
          final dy = (r - 156).toDouble();
          if (dx*dx + dy*dy <= radius * radius) {
            if (c == startC && (r % 8 == 0)) {
              grid[r][c] = 5;
            } else {
              grid[r][c] = 4;
            }
          }
        }
        final startCR = (pauldronCenterR - radius * 0.6).toInt();
        final endCR = (pauldronCenterR + radius).toInt();
        for (int c = startCR; c <= endCR; c++) {
          final dx = c.toDouble() - pauldronCenterR;
          final dy = (r - 156).toDouble();
          if (dx*dx + dy*dy <= radius * radius) {
            if (c == endCR && (r % 8 == 0)) {
              grid[r][c] = 5;
            } else {
              grid[r][c] = 4;
            }
          }
        }
      }
    } else if (planet == "Techno") {
      final widthW = isFemale ? 14.0 : 20.0;
      for (int r = 142; r <= 170; r++) {
        final startC = (pauldronCenterL - widthW).toInt();
        final endC = (pauldronCenterL + 6.0).toInt();
        for (int c = startC; c <= endC; c++) {
          final rOffset = (c - startC) ~/ 4;
          if (r >= 142 + rOffset && r <= 166 + rOffset) {
            if (c == startC) {
              grid[r][c] = 5;
            } else {
              grid[r][c] = 4;
            }
          }
        }
        final startCR = (pauldronCenterR - 6.0).toInt();
        final endCR = (pauldronCenterR + widthW).toInt();
        for (int c = startCR; c <= endCR; c++) {
          final rOffset = (endCR - c) ~/ 4;
          if (r >= 142 + rOffset && r <= 166 + rOffset) {
            if (c == endCR) {
              grid[r][c] = 5;
            } else {
              grid[r][c] = 4;
            }
          }
        }
      }
    } else {
      final radius = isFemale ? 12.0 : 16.0;
      for (int r = 144; r <= 168; r++) {
        final startC = (pauldronCenterL - radius).toInt();
        final endC = (pauldronCenterL + radius * 0.8).toInt();
        for (int c = startC; c <= endC; c++) {
          final dx = c.toDouble() - pauldronCenterL;
          final dy = (r - 156).toDouble();
          if (dx*dx + dy*dy <= radius * radius) { grid[r][c] = 4; }
        }
        final startCR = (pauldronCenterR - radius * 0.8).toInt();
        final endCR = (pauldronCenterR + radius).toInt();
        for (int c = startCR; c <= endCR; c++) {
          final dx = c.toDouble() - pauldronCenterR;
          final dy = (r - 156).toDouble();
          if (dx*dx + dy*dy <= radius * radius) { grid[r][c] = 4; }
        }
      }
    }
    
    // 6. Scarf / Collar wrapping (4 / 5)
    for (int r = 130; r <= 148; r++) {
      final halfW = isFemale ? 28 : 40;
      for (int c = (150 - halfW); c <= (150 + halfW); c++) {
        if (planet == "Ninjonia") {
          if ((r + c) % 3 == 0) {
            grid[r][c] = 5;
          } else {
            grid[r][c] = 4;
          }
        } else {
          grid[r][c] = 4;
        }
      }
    }
    
    // 7. Muscular or Slender Cyber Arms (4)
    for (int r = 160; r <= 250; r++) {
      final pct = (r - 160).toDouble() / 90.0;
      if (isFemale) {
        final leftCenter = (150.0 - shoulderHalfW + 4.0 - math.sin(pct * math.pi) * 4.0).toInt();
        final rightCenter = (150.0 + shoulderHalfW - 4.0 + math.sin(pct * math.pi) * 4.0).toInt();
        for (int c = (leftCenter - 6); c <= (leftCenter + 6); c++) { grid[r][c] = 4; }
        for (int c = (rightCenter - 6); c <= (rightCenter + 6); c++) { grid[r][c] = 4; }
        if (planet == "Techno") {
          grid[r][leftCenter] = 5;
          grid[r][rightCenter] = 5;
        }
      } else {
        final leftCenter = (150.0 - shoulderHalfW + 8.0 - math.sin(pct * math.pi) * 6.0).toInt();
        final rightCenter = (150.0 + shoulderHalfW - 8.0 + math.sin(pct * math.pi) * 6.0).toInt();
        for (int c = (leftCenter - 10); c <= (leftCenter + 10); c++) { grid[r][c] = 4; }
        for (int c = (rightCenter - 10); c <= (rightCenter + 10); c++) { grid[r][c] = 4; }
        if (planet == "Techno") {
          grid[r][leftCenter] = 5;
          grid[r][rightCenter] = 5;
        }
      }
    }
    
    // 8. Head Face shape
    if (isFemale) {
      for (int r = 76; r <= 132; r++) {
        final halfW = (r < 100)
            ? 22.0 + ((r - 76).toDouble() / 24.0) * 6.0
            : 28.0 - ((r - 100).toDouble() / 32.0) * 20.0;
        final startC = (150.0 - halfW).toInt();
        final endC = (150.0 + halfW).toInt();
        for (int c = startC; c <= endC; c++) {
          grid[r][c] = 1;
        }
      }
      
      if (planet == "Techno" || planet == "Dark Laser") {
        for (int r = 94; r <= 104; r++) {
          for (int c = 128; c <= 172; c++) { grid[r][c] = 3; }
        }
      } else {
        // Slanted fighter eyes (closer together)
        for (int r = 94; r <= 98; r++) {
          for (int c = 134; c <= 142; c++) { grid[r][c] = 3; }
        }
        for (int r = 94; r <= 98; r++) {
          for (int c = 158; c <= 166; c++) { grid[r][c] = 3; }
        }
        for (int c = 130; c <= 144; c++) { grid[90][c] = 2; }
        for (int c = 160; c <= 176; c++) { grid[90][c] = 2; }
      }
      // Lip line for female
      for (int c = 146; c <= 154; c++) { grid[116][c] = 4; }
    } else {
      // Male Hooded Mask
      for (int r = 44; r <= 140; r++) {
        final pct = (r - 44).toDouble() / 96.0;
        final hoodHalfW = (30.0 + pct * 48.0).toInt();
        final innerHalfW = (20.0 + pct * 28.0).toInt();
        for (int c = (150 - hoodHalfW); c <= (150 + hoodHalfW); c++) {
          if ((c - 150).abs() > innerHalfW || r < 72) {
            grid[r][c] = 4;
          } else {
            grid[r][c] = 1;
          }
        }
      }
      
      for (int r = 96; r <= 132; r++) {
        final maskHalfW = (22.0 - (r - 96).toDouble() / 36.0 * 12.0).toInt();
        for (int c = (150 - maskHalfW); c <= (150 + maskHalfW); c++) {
          grid[r][c] = 4;
        }
      }
      
      for (int r = 86; r <= 94; r++) {
        final centerOffset = (r - 90).abs();
        for (int c = (142 + centerOffset); c <= (158 - centerOffset); c++) {
          grid[r][c] = 3;
        }
      }
    }
    
    // 9. Texturized Detailed Front Hair Styles
    // Hair cap
    for (int r = 56; r <= 80; r++) {
      for (int c = 116; c <= 184; c++) {
        final dx = (c - 150).toDouble();
        final dy = (r - 72).toDouble();
        if ((dx*dx)/(34.0*34.0) + (dy*dy)/(16.0*16.0) <= 1.0) {
          grid[r][c] = 2;
        }
      }
    }
    
    // Face framing bangs
    for (int r = 80; r <= 124; r++) {
      for (int c = 112; c <= 120; c++) { grid[r][c] = 2; }
      for (int c = 180; c <= 188; c++) { grid[r][c] = 2; }
      if (r >= 88 && r <= 108) {
        grid[r][121] = 2;
        grid[r][179] = 2;
      }
    }
    
    // Spiky / Long / Mohawk / Short
    if (hairStyle == "Spiky") {
      for (int r = 20; r <= 60; r++) {
        for (int c = 120; c <= 180; c++) {
          final cOffset = c - 150;
          if (cOffset.abs() <= 6 && r >= 20 + cOffset.abs() * 4) { grid[r][c] = 2; }
          if (cOffset >= 15 && cOffset <= 30 && r >= 32 + (cOffset - 22).abs() * 3) { grid[r][c] = 2; }
          if (cOffset <= -15 && cOffset >= -30 && r >= 32 + (cOffset + 22).abs() * 3) { grid[r][c] = 2; }
        }
      }
      for (int r = 50; r <= 85; r++) {
        for (int c = 96; c <= 204; c++) {
          if (c < 116 && r >= 85 - (c - 96) * 2) { grid[r][c] = 2; }
          if (c > 184 && r >= 85 - (204 - c) * 2) { grid[r][c] = 2; }
        }
      }
    } else if (hairStyle == "Long") {
      for (int r = 80; r <= 220; r++) {
        final waveL = math.sin(r.toDouble() * 0.08) * 5.0;
        final waveR = math.cos(r.toDouble() * 0.08) * 5.0;
        for (int c = (98 + waveL.toInt()); c <= (106 + waveL.toInt()); c++) { grid[r][c] = 2; }
        for (int c = (194 + waveR.toInt()); c <= (202 + waveR.toInt()); c++) { grid[r][c] = 2; }
      }
    } else if (hairStyle == "Mohawk") {
      for (int r = 15; r <= 55; r++) {
        for (int c = 142; c <= 158; c++) {
          if (r >= 15 + (c - 150).abs() * 4) { grid[r][c] = 2; }
        }
      }
    } else if (hairStyle == "Short") {
      for (int r = 48; r <= 85; r++) {
        for (int c = 114; c <= 186; c++) {
          final dx = (c - 150).toDouble();
          final dy = (r - 72).toDouble();
          if ((dx*dx)/(36.0*36.0) + (dy*dy)/(18.0*18.0) <= 1.0) {
            if ((r + c) % 4 < 2) {
              grid[r][c] = 2;
            }
          }
        }
      }
    }
    
    // 10. Chest Core Glowing Emblem (5)
    final coreY = isFemale ? 168 : 176;
    final coreRadius = isFemale ? 18.0 : 24.0;
    final coreRadiusSq = coreRadius * coreRadius;
    for (int r = (coreY - 30); r <= (coreY + 30); r++) {
      for (int c = 120; c <= 180; c++) {
        final dx = (c - 150).toDouble();
        final dy = (r - coreY).toDouble();
        if (dx*dx + dy*dy <= coreRadiusSq) {
          grid[r][c] = 5;
        }
      }
    }
    
    // Warrion Chest Emblem
    if (planet == "Warrion" && !isFemale) {
      for (int r = 190; r <= 210; r++) {
        for (int c = 146; c <= 154; c++) { grid[r][c] = 5; }
      }
    }
    
    // 11. Muscular Legs & Heavy Boots (4)
    for (int r = 252; r <= 290; r++) {
      final legHalfW = isFemale ? 10 : 14;
      final legLOffset = isFemale ? 120 : 116;
      final legROffset = isFemale ? 180 : 184;
      for (int c = (legLOffset - legHalfW); c <= (legLOffset + legHalfW); c++) { grid[r][c] = 4; }
      for (int c = (legROffset - legHalfW); c <= (legROffset + legHalfW); c++) { grid[r][c] = 4; }
    }
    for (int r = 291; r <= 299; r++) {
      final bootHalfW = isFemale ? 14 : 20;
      final bootLOffset = isFemale ? 118 : 112;
      final bootROffset = isFemale ? 182 : 188;
      for (int c = (bootLOffset - bootHalfW); c <= (bootLOffset + bootHalfW); c++) { grid[r][c] = 4; }
      for (int c = (bootROffset - bootHalfW); c <= (bootROffset + bootHalfW); c++) { grid[r][c] = 4; }
    }
    
    return grid;
  }
}

enum WorkoutCategory {
  cardio('Cardio Patrol'),
  strength('Strength Forge'),
  flexibility('Flexibility Stream'),
  nutrition('Healthy Rations'),
  meditation('Mental Focus');

  final String displayName;
  const WorkoutCategory(this.displayName);
}

class WeightEntry {
  final DateTime date;
  final double weight;
  WeightEntry({required this.date, required this.weight});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'weight': weight,
      };

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

enum QuestCadence { daily, monthly, yearly }

class ShopItem {
  final String name;
  final int cost;
  final String description;
  final String type; // "frame", "title", "aura", "background", "accessory", "stat", "badge"
  final String sprite; // Unicode emoji sprite representation

  ShopItem({
    required this.name,
    required this.cost,
    required this.description,
    required this.type,
    required this.sprite,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'cost': cost,
        'description': description,
        'type': type,
        'sprite': sprite,
      };

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      name: json['name'] ?? '',
      cost: json['cost'] ?? 0,
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      sprite: json['sprite'] ?? '🛡️',
    );
  }

  static List<ShopItem> get availableItems => [
        // Frames
        ShopItem(name: "Ignis Frame", cost: 150, description: "A fiery red profile border that radiates internal warmth and volcanic energy.", type: "frame", sprite: "🔥"),
        ShopItem(name: "Crystalline Frame", cost: 180, description: "Teal frost profile border composed of compressed, unbreakable ice particles.", type: "frame", sprite: "❄️"),
        ShopItem(name: "Umbral Border", cost: 220, description: "Deep shadow profile border that absorbs surrounding ambient light.", type: "frame", sprite: "⬛"),
        ShopItem(name: "Cyber Grid Frame", cost: 250, description: "Neon blue glowing profile border simulating a retro digital grid structure.", type: "frame", sprite: "🌀"),
        // Titles
        ShopItem(name: "Void Sovereign", cost: 200, description: "Exotic warrior status title reserved for those who have quieted the mind's static.", type: "title", sprite: "👑"),
        ShopItem(name: "The Immortal", cost: 300, description: "Immortal warrior status title denoting timeless discipline and grit.", type: "title", sprite: "⏳"),
        ShopItem(name: "Elsaither Vanguard", cost: 150, description: "Elite vanguard title honoring high dedication to the Elsaither realms.", type: "title", sprite: "🛡️"),
        ShopItem(name: "Iron Forge Master", cost: 180, description: "Master smith title representing patience, heavy lifting, and raw creation.", type: "title", sprite: "🔨"),
        // Auras
        ShopItem(name: "Glitch Aura", cost: 300, description: "Cybernetic glowing aura animation effect that flickers with static electricity.", type: "aura", sprite: "⚡"),
        ShopItem(name: "Phoenix Flare", cost: 400, description: "Fiery wings rising aura effect representing constant recovery and rebirth.", type: "aura", sprite: "🦅"),
        ShopItem(name: "Abyssal Mist", cost: 350, description: "Shadowy dark tendrils aura effect that wraps your avatar in mysterious fog.", type: "aura", sprite: "🌫️"),
        ShopItem(name: "Lightning Spark", cost: 320, description: "Electric storm discharge aura effect that crackles with raw kinetic energy.", type: "aura", sprite: "🌩️"),
        // Backgrounds
        ShopItem(name: "Neon Cyber Space", cost: 250, description: "Cyberpunk neon grid backdrop casting vibrant violet hues.", type: "background", sprite: "🌃"),
        ShopItem(name: "Nebula Starfield", cost: 300, description: "Deep space cosmic dust overlay featuring shimmering alien constellations.", type: "background", sprite: "🌌"),
        ShopItem(name: "Volcanic Core", cost: 350, description: "Molten fire cavern backdrop pulsing with geothermal streams.", type: "background", sprite: "🌋"),
        ShopItem(name: "Zen Garden", cost: 200, description: "Serene meditation backdrop with raked gravel and bamboo stalks.", type: "background", sprite: "🎋"),
        // Accessories (Legendary Items)
        ShopItem(name: "Golden Pauldrons", cost: 150, description: "Heavy royal shoulder guards crafted from pure gold that increase presence.", type: "accessory", sprite: "🎗️"),
        ShopItem(name: "Vanguard Greatsword", cost: 250, description: "Massive element-infused blade capable of cleaving mountains.", type: "accessory", sprite: "⚔️"),
        ShopItem(name: "Cybernetic Visor", cost: 200, description: "Glowing red tactical eyepiece that tracks muscle load and recovery times.", type: "accessory", sprite: "🕶️"),
        ShopItem(name: "Elsaither Wings", cost: 400, description: "Hovering mechanical energy wings that grant elevated mobility.", type: "accessory", sprite: "👼"),
        // Stats
        ShopItem(name: "Strength Elixir (+1 STR)", cost: 500, description: "Permanently boost your Strength by 1 point, enhancing lifting capacity.", type: "stat", sprite: "🧪"),
        ShopItem(name: "Gale Boots (+1 DEX)", cost: 500, description: "Permanently boost your Dexterity by 1 point, enhancing agility.", type: "stat", sprite: "🥾"),
        ShopItem(name: "Marrow Brew (+1 CON)", cost: 500, description: "Permanently boost your Constitution by 1 point, enhancing physical endurance.", type: "stat", sprite: "🍺"),
        ShopItem(name: "Mind Stone (+1 INT)", cost: 500, description: "Permanently boost your Intelligence by 1 point, enhancing puzzle solving.", type: "stat", sprite: "💎"),
        ShopItem(name: "Wisdom Herb (+1 WIS)", cost: 500, description: "Permanently boost your Wisdom by 1 point, enhancing awareness.", type: "stat", sprite: "🌿"),
        ShopItem(name: "Crown of Command (+1 CHA)", cost: 500, description: "Permanently boost your Charisma by 1 point, enhancing social influence.", type: "stat", sprite: "👑"),
        // Badges
        ShopItem(name: "Celestial Dragon Badge", cost: 200, description: "Unlocks the special celestial dragon profile badge indicating elite status.", type: "badge", sprite: "🐉"),
      ];
}

class FitnessBadge {
  final String name;
  final String description;
  final String iconName;

  FitnessBadge({
    required this.name,
    required this.description,
    required this.iconName,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'iconName': iconName,
      };

  factory FitnessBadge.fromJson(Map<String, dynamic> json) {
    return FitnessBadge(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconName: json['iconName'] ?? '',
    );
  }

  static List<FitnessBadge> get allBadges => [
        FitnessBadge(name: "First Step", description: "Walk 10,000 steps in a single day", iconName: "directions_walk"),
        FitnessBadge(name: "Flame Starter", description: "Unlock 5 fitness challenges or quests", iconName: "local_fire_department"),
        FitnessBadge(name: "Lore Scholar", description: "Complete the initial psychological evaluations", iconName: "psychology"),
        FitnessBadge(name: "Weight Target Achieved", description: "Successfully reach your target weight goal", iconName: "verified"),
        FitnessBadge(name: "Streak Master", description: "Achieve a consecutive 7-day streak of workouts", iconName: "emoji_events"),
        FitnessBadge(name: "Guild Patron", description: "Buy your first stat elixir or cosmetic from the shop", iconName: "shopping_cart"),
        FitnessBadge(name: "Demi-God", description: "Achieve an Attribute level of 18 or higher in any stat", iconName: "star"),
        // Stretch goals
        FitnessBadge(name: "20k Steps Sentinel", description: "Walk 20,000 steps in a single day", iconName: "directions_run"),
        FitnessBadge(name: "Iron Will (1 Hr)", description: "Complete a 1-hour active workout", iconName: "timer"),
        FitnessBadge(name: "Unstoppable Force (2 Hr)", description: "Complete a 2-hour active workout", iconName: "alarm"),
        FitnessBadge(name: "Quest Crusader (100 Quests)", description: "Complete 100 fitness quests", iconName: "assignment_turned_in"),
        FitnessBadge(name: "Legendary Champion (1000 Quests)", description: "Complete 1000 fitness quests", iconName: "military_tech"),
        FitnessBadge(name: "Vanguard Streak (14 Days)", description: "Achieve a consecutive 14-day workout streak", iconName: "whatshot"),
        FitnessBadge(name: "Sovereign Streak (30 Days)", description: "Achieve a consecutive 30-day workout streak", iconName: "workspace_premium"),
        FitnessBadge(name: "Immortal Streak (100 Days)", description: "Achieve a consecutive 100-day workout streak", iconName: "workspace_premium"),
        // Monthly Challenges Badges
        FitnessBadge(name: "January Resolution Badge", description: "Complete the January challenge: Do 1,000 Pushups", iconName: "check_circle"),
        FitnessBadge(name: "February Cardio Badge", description: "Complete the February challenge: Perform 300 minutes of Cardio", iconName: "directions_run"),
        FitnessBadge(name: "March Flexibility Badge", description: "Complete the March challenge: Perform 120 minutes of Yoga/Flexibility", iconName: "accessibility_new"),
        FitnessBadge(name: "April Hydration Badge", description: "Complete the April challenge: Drink 90 Liters of water", iconName: "water_drop"),
        FitnessBadge(name: "May Walkabout Badge", description: "Complete the May challenge: Walk 50 miles", iconName: "directions_walk"),
        FitnessBadge(name: "June Strength Badge", description: "Complete the June challenge: Complete 20 Strength Forge workouts", iconName: "fitness_center"),
        FitnessBadge(name: "July Zen Badge", description: "Complete the July challenge: Perform 150 minutes of Meditation", iconName: "self_improvement"),
        FitnessBadge(name: "August Hydration Badge", description: "Complete the August challenge: Drink 100 Liters of water", iconName: "opacity"),
        FitnessBadge(name: "September Steps Badge", description: "Complete the September challenge: Log 250,000 steps", iconName: "run_circle"),
        FitnessBadge(name: "October Squats Badge", description: "Complete the October challenge: Do 1,200 Squats", iconName: "sports_martial_arts"),
        FitnessBadge(name: "November Flexibility Badge", description: "Complete the November challenge: Complete 15 Flexibility sessions", iconName: "airline_seat_recline_extra"),
        FitnessBadge(name: "December Quests Badge", description: "Complete the December challenge: Complete 40 Daily Quests", iconName: "stars"),
      ];
}

class MealEntry {
  final String id;
  final DateTime date;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double sugar;

  MealEntry({
    required this.id,
    required this.date,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.sugar,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
        'sugar': sugar,
      };

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      name: json['name'] ?? '',
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fats: (json['fats'] as num?)?.toDouble() ?? 0.0,
      sugar: (json['sugar'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class LotEQuest {
  final String id;
  final String title;
  final String questDescription;
  final WorkoutCategory workoutType;
  final int difficultyRoll;
  final int rewardXP;
  final int rewardCrystals;
  final StatType statReward;
  final int statValue;
  bool isCompleted;
  final DateTime dateCreated;
  QuestCadence cadence;
  int progressCount;
  int targetCount;
  final double requiredMinutes;

  LotEQuest({
    required this.id,
    required this.title,
    required this.questDescription,
    required this.workoutType,
    required this.difficultyRoll,
    required this.rewardXP,
    required this.rewardCrystals,
    required this.statReward,
    required this.statValue,
    this.isCompleted = false,
    DateTime? date,
    this.cadence = QuestCadence.daily,
    this.progressCount = 0,
    this.targetCount = 1,
    this.requiredMinutes = 0.0,
  }) : dateCreated = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'questDescription': questDescription,
        'workoutType': workoutType.name,
        'difficultyRoll': difficultyRoll,
        'rewardXP': rewardXP,
        'rewardCrystals': rewardCrystals,
        'statReward': statReward.name,
        'statValue': statValue,
        'isCompleted': isCompleted,
        'dateCreated': dateCreated.toIso8601String(),
        'cadence': cadence.name,
        'progressCount': progressCount,
        'targetCount': targetCount,
        'requiredMinutes': requiredMinutes,
      };

  factory LotEQuest.fromJson(Map<String, dynamic> json) {
    return LotEQuest(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      questDescription: json['questDescription'] ?? '',
      workoutType: WorkoutCategory.values.firstWhere(
        (e) => e.name == (json['workoutType'] ?? 'cardio'),
        orElse: () => WorkoutCategory.cardio,
      ),
      difficultyRoll: json['difficultyRoll'] ?? 10,
      rewardXP: json['rewardXP'] ?? 50,
      rewardCrystals: json['rewardCrystals'] ?? 15,
      statReward: StatType.values.firstWhere(
        (e) => e.name == (json['statReward'] ?? 'strength'),
        orElse: () => StatType.strength,
      ),
      statValue: json['statValue'] ?? 1,
      isCompleted: json['isCompleted'] ?? false,
      date: DateTime.tryParse(json['dateCreated'] ?? '') ?? DateTime.now(),
      cadence: QuestCadence.values.firstWhere(
        (e) => e.name == (json['cadence'] ?? 'daily'),
        orElse: () => QuestCadence.daily,
      ),
      progressCount: json['progressCount'] ?? 0,
      targetCount: json['targetCount'] ?? 1,
      requiredMinutes: (json['requiredMinutes'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static List<LotEQuest> get dailyDefaults {
    return [
      LotEQuest(
        id: 'q1',
        title: 'Patrol the Whispering Woods',
        questDescription: 'A brisk walk or run to clear out stray energy beasts. Requires 15 mins of activity.',
        workoutType: WorkoutCategory.cardio,
        difficultyRoll: 8,
        rewardXP: 60,
        rewardCrystals: 20,
        statReward: StatType.dexterity,
        statValue: 1,
        requiredMinutes: 15.0,
      ),
      LotEQuest(
        id: 'q2',
        title: 'Earth Shaking Forging',
        questDescription: 'Lift heavy weights, do bodyweight exercises, or strength training. Perform 20 mins.',
        workoutType: WorkoutCategory.strength,
        difficultyRoll: 10,
        rewardXP: 60,
        rewardCrystals: 20,
        statReward: StatType.strength,
        statValue: 1,
        requiredMinutes: 20.0,
      ),
      LotEQuest(
        id: 'q3',
        title: 'Mobility Routine',
        questDescription: 'Perform a mobility routine, stretching, or yoga to improve flexibility. 15 mins.',
        workoutType: WorkoutCategory.flexibility,
        difficultyRoll: 6,
        rewardXP: 60,
        rewardCrystals: 20,
        statReward: StatType.wisdom,
        statValue: 1,
        requiredMinutes: 15.0,
      ),
      LotEQuest(
        id: 'q4',
        title: 'Consuming Healthy Rations',
        questDescription: 'Log a protein-rich, nourishing meal with fresh vegetables and clean energy.',
        workoutType: WorkoutCategory.nutrition,
        difficultyRoll: 5,
        rewardXP: 60,
        rewardCrystals: 20,
        statReward: StatType.constitution,
        statValue: 1,
        requiredMinutes: 0.0,
      ),
    ];
  }
}

enum TrainingFocus {
  calisthenics('Calisthenics'),
  lifting('Lifting'),
  bulking('Bulking'),
  cutting('Cutting'),
  flexibility('Yoga & Flexibility'),
  cardio('Cardio');

  final String displayName;
  const TrainingFocus(this.displayName);
}

List<LotEQuest> generateQuests(
  String element,
  List<TrainingFocus> focuses,
  QuestCadence cadence, {
  Map<String, double> prs = const {},
  double waterGoal = 3.0,
}) {
  List<LotEQuest> quests = [];

  // Fallback if no focuses are selected
  final activeFocuses = focuses.isEmpty
      ? [TrainingFocus.cardio, TrainingFocus.calisthenics]
      : focuses;

  // Element theme adjective mapping
  final List<String> themeWords = (() {
    switch (element) {
      case "Fire": return ["Blazing", "Ember", "Pyro", "Combustion", "Ignition", "Thermal", "Volcanic"];
      case "Water": return ["Tidal", "Aqua", "Fluid", "Torrent", "Hydro", "Oceanic", "Cascade"];
      case "Earth": return ["Stone", "Terra", "Gravel", "Rock", "Seismic", "Tectonic", "Mineral"];
      case "Air": return ["Zephyr", "Aero", "Gale", "Cyclone", "Atmospheric", "Draft", "Breeze"];
      case "Lightning": return ["Volt", "Spark", "Arc", "Charged", "Plasma", "Tesla", "Electro"];
      case "Metal": return ["Steel", "Iron", "Alloy", "Titanium", "Chrome", "Forged", "Metallic"];
      case "Ice": return ["Frost", "Glacial", "Arctic", "Chilled", "Frozen", "Blizzard", "Cryo"];
      case "Bone": return ["Skeletal", "Marrow", "Calcium", "Osteo", "Calcified", "Spined", "Ossified"];
      case "Gas": return ["Vapor", "Aerosol", "Fume", "Mist", "Fog", "Haze", "Gaseous"];
      case "Laser": return ["Beam", "Photon", "Arc", "Reactor", "Focus", "Ray", "Laser"];
      case "Zero Space": return ["Void", "Cosmic", "Astral", "Gravity", "Dimensional", "Nebula", "Warp"];
      case "Darki": return ["Umbral", "Corrupt", "Shadow", "Nightfall", "Vesper", "Abyssal", "Eclipse"];
      case "Death": return ["Decay", "Morbid", "Necro", "Withered", "Cryptic", "Grave", "Doom"];
      case "Knife": return ["Razor", "Blade", "Surgical", "Lethal", "Dagger", "Edge", "Shear"];
      case "Poison": return ["Toxic", "Venom", "Acid", "Noxious", "Serum", "Vial", "Biohazard"];
      case "Shadow": return ["Phantom", "Spectral", "Stealth", "Silhouette", "Veiled", "Cloaked", "Mirage"];
      default: return ["Astral", "Mystic", "Ethereal", "Primeval", "Ancient", "Cosmic"];
    }
  })();

  if (cadence == QuestCadence.daily) {
    // Collect unique focuses
    final List<TrainingFocus> uniqueFocuses = [];
    for (final focus in activeFocuses) {
      if (!uniqueFocuses.contains(focus)) {
        uniqueFocuses.add(focus);
      }
    }

    // Backfill with other focuses if less than 4, ensuring absolute uniqueness
    if (uniqueFocuses.length < 4) {
      for (final f in TrainingFocus.values) {
        if (!uniqueFocuses.contains(f) && uniqueFocuses.length < 4) {
          uniqueFocuses.add(f);
        }
      }
    }

    // Generate up to 4 unique daily quests
    for (int i = 0; i < min(4, uniqueFocuses.length); i++) {
      final adjective = themeWords[i % themeWords.length];
      final focus = uniqueFocuses[i];
      final String title;
      final String desc;
      final WorkoutCategory wType;
      final StatType stat;

      switch (focus) {
        case TrainingFocus.calisthenics:
          final titles = [
            "$adjective Gravity Defiance",
            "$adjective Gymnastic Ascent",
            "Acrobatic $adjective Leverage",
            "Ascetic $adjective Bar Drill",
            "Suspended $adjective Static Hold",
            "$adjective Lever Conditioning",
            "Aura-Fueled Calisthenics Mastery",
            "$adjective Kinetic Core Release"
          ];
          title = titles[i % titles.length];
          desc = "Perform bodyweight dips, pushups, pullups, or handstands. Complete 15 minutes.";
          wType = WorkoutCategory.strength;
          stat = i.isOdd ? (i ~/ 2 % 2 == 0 ? StatType.intelligence : StatType.charisma) : StatType.strength;
          break;
        case TrainingFocus.lifting:
          final titles = [
            "$adjective Heavy Forging",
            "$adjective Steel Press Protocol",
            "Cataclysmic $adjective Deadlift",
            "Barbarian $adjective Squat Ascent",
            "Titan $adjective Bench Mastery",
            "$adjective Iron Load Injection",
            "Aura-Infused Muscle Forge",
            "$adjective Density Progression"
          ];
          title = titles[i % titles.length];
          desc = "Perform squat, bench, or deadlift reps. Complete 20 minutes of heavy structural loading.";
          wType = WorkoutCategory.strength;
          stat = i.isOdd ? (i ~/ 2 % 2 == 0 ? StatType.charisma : StatType.intelligence) : StatType.strength;
          break;
        case TrainingFocus.cardio:
          final titles = [
            "$adjective Speed Patrol",
            "Swift $adjective Horizon Run",
            "$adjective Windwalker Interval",
            "Tempest $adjective Trail Sweep",
            "$adjective Kinetic Gale Jog",
            "Aura-Boosted Endurance Dash",
            "$adjective Boundary Sprint",
            "Vanguard $adjective Scout Patrol"
          ];
          title = titles[i % titles.length];
          desc = "Complete a 15-minute run, jog, cycle, or cardio sprint.";
          wType = WorkoutCategory.cardio;
          stat = i.isOdd ? (i ~/ 2 % 2 == 0 ? StatType.intelligence : StatType.charisma) : StatType.dexterity;
          break;
        case TrainingFocus.flexibility:
          final titles = [
            "$adjective Elemental Flow",
            "Fluid $adjective Limbering",
            "$adjective Meridian Release",
            "Zephyr-Like $adjective Extension",
            "Aura-Stretched Range Recovery",
            "$adjective Elasticity Session",
            "Serene $adjective Muscle Lengthening",
            "$adjective Kinetic Joints Tuning"
          ];
          title = titles[i % titles.length];
          desc = "Perform a flexibility, yoga, or dynamic mobility routine. Complete 15 minutes.";
          wType = WorkoutCategory.flexibility;
          stat = i.isOdd ? (i ~/ 2 % 2 == 0 ? StatType.charisma : StatType.intelligence) : StatType.wisdom;
          break;
        case TrainingFocus.cutting:
          final titles = [
            "$adjective Light Burn",
            "$adjective Deficit Vaporization",
            "Purified $adjective Metabolic Trim",
            "Aura-Fueled Lipid Purge",
            "$adjective Lean Fuel Protocol",
            "Sovereign $adjective Fasting Log"
          ];
          title = titles[i % titles.length];
          desc = "Log a high-protein, calorie-deficit meal to burn off excess fat.";
          wType = WorkoutCategory.nutrition;
          stat = i.isOdd ? (i ~/ 2 % 2 == 0 ? StatType.intelligence : StatType.charisma) : StatType.constitution;
          break;
        case TrainingFocus.bulking:
          final titles = [
            "$adjective Nutrient Bulk",
            "$adjective Caloric Anabolism",
            "Dense $adjective Mass Synthesis",
            "Sovereign $adjective Heavy Feast",
            "$adjective Hypertrophic Load Fuel",
            "Aura-Bound Core Mass Build"
          ];
          title = titles[i % titles.length];
          desc = "Log a calorie-dense bulking meal to build size.";
          wType = WorkoutCategory.nutrition;
          stat = i.isOdd ? (i ~/ 2 % 2 == 0 ? StatType.charisma : StatType.intelligence) : StatType.constitution;
          break;
      }

      quests.add(LotEQuest(
        id: UniqueKey().toString(),
        title: title,
        questDescription: desc,
        workoutType: wType,
        difficultyRoll: 8 + (i % 5),
        rewardXP: 60,
        rewardCrystals: 20,
        statReward: stat,
        statValue: 1,
        cadence: QuestCadence.daily,
        progressCount: 0,
        targetCount: 1,
        requiredMinutes: wType == WorkoutCategory.nutrition ? 0.0 : (wType == WorkoutCategory.cardio ? 20.0 : 15.0),
      ));
    }
  } else if (cadence == QuestCadence.monthly) {
    for (int i = 0; i < 2; i++) {
      final adjective = themeWords[(i + 4) % themeWords.length];
      final focus = activeFocuses[i % activeFocuses.length];
      final String title;
      final String desc;
      final StatType stat;
      final WorkoutCategory wType;
      final int target;

      switch (focus) {
        case TrainingFocus.calisthenics:
          final titles = ["$adjective Bar Mastery Campaign", "Sovereign $adjective Calisthenics Master"];
          title = titles[i % titles.length];
          desc = "Complete 10 calisthenics sessions (handstands, pullups) this month.";
          wType = WorkoutCategory.strength;
          stat = StatType.strength;
          target = 10;
          break;
        case TrainingFocus.lifting:
          final titles = ["$adjective Iron Forge Campaign", "Titan $adjective Weight Ascendance"];
          title = titles[i % titles.length];
          desc = "Complete 10 heavy lifting sessions (squats, deadlifts) this month.";
          wType = WorkoutCategory.strength;
          stat = StatType.strength;
          target = 10;
          break;
        case TrainingFocus.cardio:
          final titles = ["$adjective Marathon Crusade", "$adjective Swiftness Road Campaign"];
          title = titles[i % titles.length];
          desc = "Complete 10 cardio workout sessions this month.";
          wType = WorkoutCategory.cardio;
          stat = StatType.dexterity;
          target = 10;
          break;
        case TrainingFocus.flexibility:
          final titles = ["$adjective Meridian Alignment", "$adjective Joint Elasticity Campaign"];
          title = titles[i % titles.length];
          desc = "Complete 8 dynamic flexibility or stretching routines this month.";
          wType = WorkoutCategory.flexibility;
          stat = StatType.wisdom;
          target = 8;
          break;
        case TrainingFocus.cutting:
        case TrainingFocus.bulking:
          final titles = ["$adjective Metabolic Balance", "Pure $adjective Rations Crusade"];
          title = titles[i % titles.length];
          desc = "Log 15 healthy meals this month to hit target weight.";
          wType = WorkoutCategory.nutrition;
          stat = StatType.constitution;
          target = 15;
          break;
      }

      quests.add(LotEQuest(
        id: UniqueKey().toString(),
        title: title,
        questDescription: desc,
        workoutType: wType,
        difficultyRoll: 14,
        rewardXP: 500,
        rewardCrystals: 200,
        statReward: stat,
        statValue: 3,
        cadence: QuestCadence.monthly,
        progressCount: 0,
        targetCount: target,
      ));
    }
  } else if (cadence == QuestCadence.yearly) {
    final adjective = themeWords.isNotEmpty ? themeWords.first : "Elemental";
    final focus = activeFocuses.first;
    final String title;
    final String desc;
    final WorkoutCategory wType;
    final int target;

    switch (focus) {
      case TrainingFocus.calisthenics:
        title = "Grand $adjective Gravity Champion";
        desc = "Maintain fitness goals and complete 100 calisthenics logs.";
        wType = WorkoutCategory.strength;
        target = 100;
        break;
      case TrainingFocus.lifting:
        title = "Grand $adjective Titan of Iron";
        desc = "Maintain fitness goals and complete 100 heavy lifting logs.";
        wType = WorkoutCategory.strength;
        target = 100;
        break;
      case TrainingFocus.cardio:
        title = "Grand $adjective Swiftness Legend";
        desc = "Maintain fitness goals and complete 100 cardio workouts.";
        wType = WorkoutCategory.cardio;
        target = 100;
        break;
      case TrainingFocus.flexibility:
        title = "Grand $adjective Spiritual Master";
        desc = "Maintain fitness goals and complete 80 flexibility sessions.";
        wType = WorkoutCategory.flexibility;
        target = 80;
        break;
      case TrainingFocus.cutting:
      case TrainingFocus.bulking:
        title = "Grand $adjective Alchemist of Flesh";
        desc = "Reach and sustain your target weight goals. Log 100 healthy meals.";
        wType = WorkoutCategory.nutrition;
        target = 100;
        break;
    }

    quests.add(LotEQuest(
      id: UniqueKey().toString(),
      title: title,
      questDescription: desc,
      workoutType: wType,
      difficultyRoll: 18,
      rewardXP: 5000,
      rewardCrystals: 2000,
      statReward: StatType.constitution,
      statValue: 5,
      cadence: QuestCadence.yearly,
      progressCount: 0,
      targetCount: target,
    ));
  }

  return quests;
}

class BodyMeasurementEntry {
  final String id;
  final DateTime date;
  final double weight;
  final double chest;
  final double arms;
  final double waist;
  final double hips;
  final double legs;

  BodyMeasurementEntry({
    required this.id,
    required this.date,
    required this.weight,
    required this.chest,
    required this.arms,
    required this.waist,
    required this.hips,
    required this.legs,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'weight': weight,
        'chest': chest,
        'arms': arms,
        'waist': waist,
        'hips': hips,
        'legs': legs,
      };

  factory BodyMeasurementEntry.fromJson(Map<String, dynamic> json) {
    return BodyMeasurementEntry(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      chest: (json['chest'] as num?)?.toDouble() ?? 0.0,
      arms: (json['arms'] as num?)?.toDouble() ?? 0.0,
      waist: (json['waist'] as num?)?.toDouble() ?? 0.0,
      hips: (json['hips'] as num?)?.toDouble() ?? 0.0,
      legs: (json['legs'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

enum MuscleGroup {
  chest('Chest'),
  back('Back'),
  shoulders('Shoulders'),
  arms('Arms'),
  core('Core & Abs'),
  legs('Legs & Glutes'),
  fullBody('Full Body'),
  cardio('Cardio & Conditioning');

  final String displayName;
  const MuscleGroup(this.displayName);
}

class SuggestedWorkout {
  final String id;
  final String name;
  final MuscleGroup muscleGroup;
  WorkoutCategory get category {
    switch (muscleGroup) {
      case MuscleGroup.cardio:
        return WorkoutCategory.cardio;
      case MuscleGroup.fullBody:
        return WorkoutCategory.strength;
      default:
        return WorkoutCategory.strength;
    }
  }
  final String difficulty; // "Easy", "Medium", "Hard", "Legend", "Master"
  final String equipment;
  final String description;
  final List<String> instructions;
  final int sets;
  final String reps;
  final double durationMinutes;

  SuggestedWorkout({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.difficulty,
    required this.equipment,
    required this.description,
    required this.instructions,
    required this.sets,
    required this.reps,
    this.durationMinutes = 15.0,
  });

  static List<SuggestedWorkout> get allWorkouts => [
                SuggestedWorkout(
          id: "knee_pushups_foundation",
          name: "Knee Pushups Foundation",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          description: "Build upper body pushing strength targeting the chest using knees to reduce load.",
          instructions: [
            "Position hands slightly wider than shoulders.",
            "Keep core braced and spine neutral from head to knees.",
            "Lower chest to floor by bending elbows to 45 degrees.",
            "Push up dynamically through palms to return to starting position."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "standard_pushups_drill",
          name: "Standard Pushups Drill",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Medium",
          equipment: "Bodyweight Only",
          description: "Classic chest and triceps builder that challenges core stability.",
          instructions: [
            "Assume a high plank with hands directly under shoulders.",
            "Keep spine neutral and glutes engaged.",
            "Lower under control until chest is one inch from floor.",
            "Press firmly into the ground to push yourself back up."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "diamond_pushups_precision",
          name: "Diamond Pushups Precision",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          description: "Close-grip pushup variation designed to shift the load onto the inner chest and triceps.",
          instructions: [
            "Form a diamond shape with index fingers and thumbs touching.",
            "Maintain a rigid straight line from head to heels.",
            "Lower chest toward hands, keeping elbows tucked to ribs.",
            "Press upward dynamically, focusing on inner chest contraction."
          ],
          sets: 4,
          reps: "8-12 reps",
        ),
        SuggestedWorkout(
          id: "archer_pushups_ascent",
          name: "Archer Pushups Ascent",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Legend",
          equipment: "Bodyweight Only",
          description: "Advanced single-arm loaded pushup variation sliding side-to-side.",
          instructions: [
            "Assume high plank with hands placed extremely wide.",
            "Lower body to one side, bending that elbow.",
            "Keep the opposite arm completely straight.",
            "Push up from the bent arm to return to center."
          ],
          sets: 4,
          reps: "6-8 reps per side",
        ),
        SuggestedWorkout(
          id: "one_arm_pushup_progression",
          name: "One-Arm Pushup Progression",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Master",
          equipment: "Bodyweight Only",
          description: "The ultimate pushup challenge, loading your entire chest unilaterally.",
          instructions: [
            "Place feet very wide and one hand centered under chest.",
            "Keep free hand behind your back.",
            "Lower under control, keeping hips parallel to floor.",
            "Drive through the single arm with explosive force."
          ],
          sets: 5,
          reps: "3-5 reps per side",
        ),
        SuggestedWorkout(
          id: "light_dumbbell_floor_press",
          name: "Light Dumbbell Floor Press",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Easy",
          equipment: "Dumbbells",
          description: "Safe chest builder that limits range of motion using the floor as a depth stop.",
          instructions: [
            "Lie flat on your back with knees bent, holding dumbbells over chest.",
            "Lower elbows slowly until they touch the floor lightly.",
            "Press dumbbells back up, squeezing chest at the top.",
            "Avoid slamming elbows into the ground."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_bench_press",
          name: "Dumbbell Bench Press",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Medium",
          equipment: "Dumbbells",
          description: "Classic dumbbell chest exercise that allows for deep contraction.",
          instructions: [
            "Lie flat on bench holding dumbbells at chest level.",
            "Press weights up and slightly inward over chest.",
            "Lower under control until dumbbells are near shoulders.",
            "Squeeze chest muscles at top of movement."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_incline_flyes",
          name: "Dumbbell Incline Flyes",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Hard",
          equipment: "Dumbbells",
          description: "Isolation movement targeting upper chest fibers and shoulder stability.",
          instructions: [
            "Set bench to a 30-degree incline.",
            "Hold dumbbells overhead with palms facing each other.",
            "Open arms wide in a smooth arc, keeping elbows slightly bent.",
            "Squeeze chest to bring weights back to center."
          ],
          sets: 4,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "heavy_dumbbell_floor_press",
          name: "Heavy Dumbbell Floor Press",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Legend",
          equipment: "Dumbbells",
          description: "Heavy overload press targeting mid-range chest drive and tricep lockout.",
          instructions: [
            "Lie flat on the floor with heavy dumbbells.",
            "Bring weights to chest height with elbows touching floor.",
            "Press up with maximum power, locking out elbows.",
            "Control descent to prevent floor impact."
          ],
          sets: 4,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_squeeze_press",
          name: "Dumbbell Squeeze Press",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Master",
          equipment: "Dumbbells",
          description: "High-intensity isometric squeeze press that triggers maximum chest recruitment.",
          instructions: [
            "Lie on bench and press two dumbbells together over chest.",
            "Maintain constant inward pressure against each other.",
            "Lower dumbbells to chest while squeezing them together.",
            "Press back up while maintaining the intense squeeze."
          ],
          sets: 5,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "bar_hanging_scapular_squeezes",
          name: "Bar Hanging Scapular Squeezes",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Easy",
          equipment: "Pull-up Bar",
          description: "Introductory shoulder blade alignment and grip builder.",
          instructions: [
            "Grip the bar with overhand grip, hanging fully.",
            "Pull shoulder blades down and back without bending arms.",
            "Hold contraction for 2 seconds.",
            "Relax to dead hang and repeat."
          ],
          sets: 3,
          reps: "10 reps",
        ),
        SuggestedWorkout(
          id: "underbar_incline_chest_dips",
          name: "Underbar Incline Chest Dips",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Medium",
          equipment: "Pull-up Bar",
          description: "Horizontal bodyweight press using low bar setup.",
          instructions: [
            "Grip a low bar with hands shoulder-width apart.",
            "Walk feet out so body is inclined at 45 degrees.",
            "Lower chest to bar by bending elbows.",
            "Press back up dynamically."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "straight_bar_chest_dips",
          name: "Straight Bar Chest Dips",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Hard",
          equipment: "Pull-up Bar",
          description: "Vertical chest press using the bar to support bodyweight.",
          instructions: [
            "Jump up to support position on top of the bar.",
            "Lean forward slightly and bend elbows to lower chest.",
            "Keep elbows close to body to protect shoulders.",
            "Press back up to locked arm support position."
          ],
          sets: 4,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "single_bar_dips_mastery",
          name: "Single-Bar Dips Mastery",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Legend",
          equipment: "Pull-up Bar",
          description: "Advanced bar dip focusing on deep chest stretch and lockout strength.",
          instructions: [
            "Perform standard straight bar dip but lower chest to touch the bar.",
            "Hold the bottom position for 1 second.",
            "Drive upward explosively using chest and triceps.",
            "Maintain strict control to avoid bar swing."
          ],
          sets: 4,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "muscle_up_chest_press_transition",
          name: "Muscle-Up Chest Press Transition",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Master",
          equipment: "Pull-up Bar",
          description: "Peak vertical transition loading chest under extreme angles.",
          instructions: [
            "Pull up explosively and transition chest over the bar.",
            "Press bodyweight up to full arm extension.",
            "Lower slowly through the transition phase to dead hang.",
            "Requires massive explosive pulling and pushing synergy."
          ],
          sets: 5,
          reps: "3-5 reps",
        ),
        SuggestedWorkout(
          id: "cable_chest_press",
          name: "Cable Chest Press",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Easy",
          equipment: "Full Gym",
          description: "Controlled chest isolation using cable tension for continuous recruitment.",
          instructions: [
            "Set cables to chest height, stand in center, step forward.",
            "Bring hands together in front of chest in pressing motion.",
            "Slowly return to start, feeling stretch in outer chest.",
            "Keep core tight to prevent torso rotation."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "barbell_bench_press",
          name: "Barbell Bench Press",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Medium",
          equipment: "Full Gym",
          description: "The gold standard chest exercise for total upper body push power.",
          instructions: [
            "Lie on bench, grip barbell slightly wider than shoulders.",
            "Unrack bar and lower under control to mid-chest.",
            "Drive bar upward vertically until arms lock.",
            "Keep feet flat on floor and shoulder blades retracted."
          ],
          sets: 3,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "incline_barbell_press",
          name: "Incline Barbell Press",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Hard",
          equipment: "Full Gym",
          description: "Barbell press targeting clavicular chest fibers for upper chest thickness.",
          instructions: [
            "Set incline bench to 30-45 degrees.",
            "Unrack bar and lower to upper chest.",
            "Press bar straight up over shoulders.",
            "Maintain controlled tempo on the descent."
          ],
          sets: 4,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "weighted_dips_chest_focus",
          name: "Weighted Dips Chest Focus",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Legend",
          equipment: "Full Gym",
          description: "Weighted vertical dips targeting lower chest sweep and tricep power.",
          instructions: [
            "Attach weight belt around waist with plates.",
            "Mount parallel bars, lock arms, lean forward.",
            "Lower body until shoulders are below elbows.",
            "Press upward explosively back to lockout."
          ],
          sets: 4,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "heavy_barbell_bench_press_overload",
          name: "Heavy Barbell Bench Press Overload",
          muscleGroup: MuscleGroup.chest,
          difficulty: "Master",
          equipment: "Full Gym",
          description: "Absolute strength builder using maximum power output.",
          instructions: [
            "Warm up and set barbell to near-max lifting weight.",
            "Maintain absolute core tension and leg drive.",
            "Lower bar to chest and pause for a split second.",
            "Press bar upward with explosive drive."
          ],
          sets: 5,
          reps: "2-4 reps",
        ),
        SuggestedWorkout(
          id: "prone_cobra_lat_squeeze",
          name: "Prone Cobra Lat Squeeze",
          muscleGroup: MuscleGroup.back,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          description: "Lie face down and raise chest to target lats and lower back muscles.",
          instructions: [
            "Lie flat on stomach with forehead touching ground.",
            "Lift chest, arms, and feet off floor while pinching shoulder blades.",
            "Keep neck neutral, looking slightly down.",
            "Hold the contraction for 2-3 seconds, then lower under control."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "bodyweight_inverted_rows",
          name: "Bodyweight Inverted Rows",
          muscleGroup: MuscleGroup.back,
          difficulty: "Medium",
          equipment: "Bodyweight Only",
          description: "Use a sturdy horizontal bar or edge to pull bodyweight horizontally.",
          instructions: [
            "Lie under a bar set at waist height.",
            "Grip the bar overhand, shoulder-width apart, feet flat.",
            "Pull your chest to the bar, keeping body in straight plank.",
            "Lower slowly back to arm extension without sagging."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "door_frame_pull_ins",
          name: "Door Frame Pull-ins",
          muscleGroup: MuscleGroup.back,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          description: "Unilateral pulling drill using door frame to build latch control.",
          instructions: [
            "Stand facing the side edge of a door frame.",
            "Grip with one hand, step feet close to base.",
            "Lean back until arm is fully extended.",
            "Pull chest to frame using back muscles only."
          ],
          sets: 4,
          reps: "12-15 reps per side",
        ),
        SuggestedWorkout(
          id: "towel_grip_pull_up_prep",
          name: "Towel Grip Pull-up Prep",
          muscleGroup: MuscleGroup.back,
          difficulty: "Legend",
          equipment: "Bodyweight Only",
          description: "Build extreme grip and forearm endurance using hanging towels.",
          instructions: [
            "Drape a sturdy towel over a bar.",
            "Grip both ends of the towel firmly.",
            "Perform controlled pull-ups, drawing chest to hands.",
            "Keep core braced and prevent swinging."
          ],
          sets: 4,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "l_sit_pullups_back_control",
          name: "L-Sit Pullups Back Control",
          muscleGroup: MuscleGroup.back,
          difficulty: "Master",
          equipment: "Bodyweight Only",
          description: "Peak horizontal-to-vertical pulling combo targeting lats and core.",
          instructions: [
            "Hang from bar and lift legs parallel to floor (L-sit).",
            "Maintain L-sit shape throughout the movement.",
            "Pull body upward until chin clears the bar.",
            "Lower slowly, keeping legs high and locked."
          ],
          sets: 5,
          reps: "5-6 reps",
        ),
        SuggestedWorkout(
          id: "light_dumbbell_rows",
          name: "Light Dumbbell Rows",
          muscleGroup: MuscleGroup.back,
          difficulty: "Easy",
          equipment: "Dumbbells",
          description: "Target mid-back stability using moderate dumbbell loading.",
          instructions: [
            "Hinge forward at hips with flat back, holding weights.",
            "Pull dumbbells to hips, keeping elbows close to ribs.",
            "Squeeze shoulder blades together at top.",
            "Lower weights under strict control."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_bent_over_rows",
          name: "Dumbbell Bent Over Rows",
          muscleGroup: MuscleGroup.back,
          difficulty: "Medium",
          equipment: "Dumbbells",
          description: "Classic back builder utilizing double arm dumbbell rows.",
          instructions: [
            "Stand feet hip-width, bend knees slightly, hinge to 45 degrees.",
            "Hold dumbbells with neutral grip hanging down.",
            "Pull dumbbells toward lower chest dynamically.",
            "Control dumbbells down to full shoulder stretch."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_renegade_rows",
          name: "Dumbbell Renegade Rows",
          muscleGroup: MuscleGroup.back,
          difficulty: "Hard",
          equipment: "Dumbbells",
          description: "Core stability and back row combined in high plank position.",
          instructions: [
            "Assume high plank with hands gripping dumbbells on floor.",
            "Set feet wide for solid support base.",
            "Row one dumbbell to rib cage, bracing body.",
            "Return dumbbell to floor and repeat on opposite side."
          ],
          sets: 4,
          reps: "8-10 reps per side",
        ),
        SuggestedWorkout(
          id: "single_arm_dumbbell_row_strength",
          name: "Single-Arm Dumbbell Row Strength",
          muscleGroup: MuscleGroup.back,
          difficulty: "Legend",
          equipment: "Dumbbells",
          description: "Heavy unilateral back overload targeting lat and rear delt.",
          instructions: [
            "Support one knee and hand on flat bench.",
            "Hold heavy dumbbell in free hand, arm extended.",
            "Pull dumbbell to waist, driving elbow high.",
            "Stretch lat fully at bottom of each rep."
          ],
          sets: 4,
          reps: "6-8 reps per side",
        ),
        SuggestedWorkout(
          id: "heavy_dumbbell_row_lat_destroy",
          name: "Heavy Dumbbell Row Lat Destroy",
          muscleGroup: MuscleGroup.back,
          difficulty: "Master",
          equipment: "Dumbbells",
          description: "Peak load pulling workout designed to overload lat thickness.",
          instructions: [
            "Stand in staggered stance, lean forward with heavy dumbbell.",
            "Row dumbbell to hip with maximum vertical drive.",
            "Pause at top, squeezing lat completely.",
            "Control descent to protect shoulder socket."
          ],
          sets: 5,
          reps: "5-6 reps per side",
        ),
        SuggestedWorkout(
          id: "scapular_pulls_alignment",
          name: "Scapular Pulls Alignment",
          muscleGroup: MuscleGroup.back,
          difficulty: "Easy",
          equipment: "Pull-up Bar",
          description: "Activate shoulder blades and decompress spine from dead hang.",
          instructions: [
            "Grip pull-up bar shoulder-width apart.",
            "Draw shoulder blades down, raising body slightly.",
            "Do not bend elbows; keep arms straight.",
            "Release back down to dead hang under control."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "negative_pullups_ascent_prep",
          name: "Negative Pullups Ascent Prep",
          muscleGroup: MuscleGroup.back,
          difficulty: "Medium",
          equipment: "Pull-up Bar",
          description: "Build eccentric pull capacity by resisting gravity on descent.",
          instructions: [
            "Jump up to bar so chest is touching it.",
            "Hold the top position for one second.",
            "Lower body slowly, taking 5 seconds to extend.",
            "Step down, reset, and repeat next rep."
          ],
          sets: 3,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "regular_pullups_lats_focus",
          name: "Regular Pullups Lats Focus",
          muscleGroup: MuscleGroup.back,
          difficulty: "Hard",
          equipment: "Pull-up Bar",
          description: "The ultimate back-building bodyweight pull.",
          instructions: [
            "Hang from bar with hands slightly wider than shoulders.",
            "Pull elbows down to lift chest to bar.",
            "Clear chin over bar without reaching neck.",
            "Lower under control to full dead hang."
          ],
          sets: 4,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "archer_pullups_pull",
          name: "Archer Pullups Pull",
          muscleGroup: MuscleGroup.back,
          difficulty: "Legend",
          equipment: "Pull-up Bar",
          description: "Shift body side-to-side to overload one lat at a time.",
          instructions: [
            "Grip bar with extremely wide hand placement.",
            "Pull chest up toward right hand, left arm straight.",
            "Lower back down slowly to center hang.",
            "Repeat by pulling chest to left hand."
          ],
          sets: 4,
          reps: "5-6 reps per side",
        ),
        SuggestedWorkout(
          id: "one_arm_pullup_mastery",
          name: "One-Arm Pullup Mastery",
          muscleGroup: MuscleGroup.back,
          difficulty: "Master",
          equipment: "Pull-up Bar",
          description: "Absolute peak of pulling strength, pulling entire body weight unilaterally.",
          instructions: [
            "Grip bar with single hand, bracing core.",
            "Keep legs and free arm rigid to stop spin.",
            "Pull with maximum force, drawing elbow to waist.",
            "Lower under control to avoid shoulder strain."
          ],
          sets: 5,
          reps: "2-3 reps per side",
        ),
        SuggestedWorkout(
          id: "lat_pulldown_machine",
          name: "Lat Pulldown Machine",
          muscleGroup: MuscleGroup.back,
          difficulty: "Easy",
          equipment: "Full Gym",
          description: "Controlled vertical pulling using selectorized resistance.",
          instructions: [
            "Sit at machine, grip bar wide, lock thighs under pad.",
            "Pull bar to upper chest, squeezing shoulder blades.",
            "Slowly return bar to top, stretching lats.",
            "Avoid leaning back excessively."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "barbell_pendlay_rows",
          name: "Barbell Pendlay Rows",
          muscleGroup: MuscleGroup.back,
          difficulty: "Medium",
          equipment: "Full Gym",
          description: "Strict horizontal barbell rowing off the floor.",
          instructions: [
            "Bent forward flat back, parallel to floor.",
            "Grip barbell overhand, pull explosively to lower chest.",
            "Return barbell to rest on floor after each rep.",
            "Keep torso rigid throughout."
          ],
          sets: 3,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "weighted_pullups_strength",
          name: "Weighted Pullups Strength",
          muscleGroup: MuscleGroup.back,
          difficulty: "Hard",
          equipment: "Full Gym",
          description: "Load vertical pull-ups with external plates or kettlebell.",
          instructions: [
            "Attach weight belt with plate around waist.",
            "Grip bar overhand, shoulder-width.",
            "Pull up dynamically until chest clears bar.",
            "Lower under control to full extension."
          ],
          sets: 4,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "t_bar_row_power",
          name: "T-Bar Row Power",
          muscleGroup: MuscleGroup.back,
          difficulty: "Legend",
          equipment: "Full Gym",
          description: "Heavy row variation targeting mid-back thickness.",
          instructions: [
            "Straddle barbell with rowing handle attachment.",
            "Hinge to 45 degrees, keeping back neutral.",
            "Pull handle to mid-section, driving elbows back.",
            "Control descent to full stretch."
          ],
          sets: 4,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "heavy_deadlift_back_overload",
          name: "Heavy Deadlift Back Overload",
          muscleGroup: MuscleGroup.back,
          difficulty: "Master",
          equipment: "Full Gym",
          description: "Absolute back posterior chain overload.",
          instructions: [
            "Stand with barbell over mid-foot, hinge to grip.",
            "Brace core, keep spine flat, pull shoulder blades back.",
            "Drive through legs to lift bar, locking out hips.",
            "Lower under control, keeping bar close to shins."
          ],
          sets: 5,
          reps: "3-5 reps",
        ),
        SuggestedWorkout(
          id: "pike_pushups_base",
          name: "Pike Pushups Base",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          description: "Deltoid developer modifying push-up geometry.",
          instructions: [
            "Assume pushup position, walk feet forward, hips high.",
            "Lower head forward to form triangle with hands.",
            "Tap crown of head gently on floor.",
            "Press up and back through shoulders."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "elevated_pike_pushups",
          name: "Elevated Pike Pushups",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Medium",
          equipment: "Bodyweight Only",
          description: "Increase shoulder loading by elevating feet on box.",
          instructions: [
            "Place feet on box or bench, hips bent 90 degrees.",
            "Lower head toward floor between hands.",
            "Press upward through shoulders to return to start.",
            "Keep core tight and hips high."
          ],
          sets: 3,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "handstand_hold_against_wall",
          name: "Handstand Hold Against Wall",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          description: "Isolate deltoids using isometric wall-supported support.",
          instructions: [
            "Kick up against sturdy wall, body vertical.",
            "Brace core, look between hands, push floor away.",
            "Keep shoulders active and body straight.",
            "Hold for specified duration."
          ],
          sets: 4,
          reps: "30-45 secs hold",
        ),
        SuggestedWorkout(
          id: "handstand_pushups_wall_assist",
          name: "Handstand Pushups Wall Assist",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Legend",
          equipment: "Bodyweight Only",
          description: "Vertical push loading body weight against deltoids.",
          instructions: [
            "Position hands 6-12 inches from wall, kick up.",
            "Lower head slowly to touch floor.",
            "Keep elbows at 45-degree angle.",
            "Press up explosively to arm lockout."
          ],
          sets: 4,
          reps: "5-8 reps",
        ),
        SuggestedWorkout(
          id: "freestanding_handstand_pushup",
          name: "Freestanding Handstand Pushup",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Master",
          equipment: "Bodyweight Only",
          description: "Ultimate balance and overhead push power coordination.",
          instructions: [
            "Kick up to freestanding handstand (no wall).",
            "Maintain absolute core line stability.",
            "Lower head slightly to chest level.",
            "Press up to lockout, maintaining balance."
          ],
          sets: 5,
          reps: "3-5 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_lateral_raise",
          name: "Dumbbell Lateral Raise",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Easy",
          equipment: "Dumbbells",
          description: "Target lateral deltoid fibers for shoulder width.",
          instructions: [
            "Stand holding dumbbells at sides, slight forward lean.",
            "Raise weights out to sides in wide arc.",
            "Stop at shoulder height, pinkies tilted up.",
            "Lower weights under control to sides."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_overhead_press",
          name: "Dumbbell Overhead Press",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Medium",
          equipment: "Dumbbells",
          description: "Classic dumbbell shoulder press for size and strength.",
          instructions: [
            "Sit or stand, holding dumbbells at shoulder level.",
            "Press weights overhead without locking elbows.",
            "Lower under control back to ear level.",
            "Keep core braced, avoiding lower back arch."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_push_press_power",
          name: "Dumbbell Push Press Power",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Hard",
          equipment: "Dumbbells",
          description: "Incorporate leg drive to overhead press heavier weight.",
          instructions: [
            "Stand holding dumbbells at shoulders.",
            "Perform quick dip by bending knees slightly.",
            "Drive legs straight, pressing weights overhead.",
            "Control weights slowly back to shoulders."
          ],
          sets: 4,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_rear_delt_flyes",
          name: "Dumbbell Rear Delt Flyes",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Legend",
          equipment: "Dumbbells",
          description: "Isolate posterior deltoids for shoulder balance.",
          instructions: [
            "Bent forward at hips until chest is near parallel to floor.",
            "Hold dumbbells down, raise them out to sides.",
            "Pinch rear delts at top of movement.",
            "Lower dumbbells slowly to starting hang."
          ],
          sets: 4,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "seated_heavy_dumbbell_press",
          name: "Seated Heavy Dumbbell Press",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Master",
          equipment: "Dumbbells",
          description: "Overload deltoids in seated position without leg assistance.",
          instructions: [
            "Sit on upright bench, bring heavy dumbbells to shoulders.",
            "Press dumbbells overhead with controlled power.",
            "Lower under control, keeping wrists over elbows.",
            "Push through sticky point with maximum effort."
          ],
          sets: 5,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "dead_hang_active_shrugs",
          name: "Dead Hang Active Shrugs",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Easy",
          equipment: "Pull-up Bar",
          description: "Decompress spine and build active shoulder stabilization.",
          instructions: [
            "Hang from bar with overhand grip.",
            "Raise shoulders toward ears, then pull them down.",
            "Focus on active scapular movement.",
            "Keep arms straight throughout."
          ],
          sets: 3,
          reps: "12 reps",
        ),
        SuggestedWorkout(
          id: "inverted_pike_hang_shoulder_press",
          name: "Inverted Pike Hang Shoulder Press",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Medium",
          equipment: "Pull-up Bar",
          description: "Inverted shoulder push drill using bar stability.",
          instructions: [
            "Hang upside down in tucked position, legs wrapped.",
            "Perform inverted pushing shrugs relative to bar.",
            "Focus on lower traps and posterior delts.",
            "Keep movements steady and controlled."
          ],
          sets: 3,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "bar_overhead_shoulder_shrugs",
          name: "Bar Overhead Shoulder Shrugs",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Hard",
          equipment: "Pull-up Bar",
          description: "Target traps and deltoids using overhead shrugs.",
          instructions: [
            "Support body on top of bar, lock arms.",
            "Shrug shoulders up to ears and hold.",
            "Lower shoulders back down under control.",
            "Keep core locked to prevent swing."
          ],
          sets: 4,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "behind_neck_pull_up_hangs",
          name: "Behind-Neck Pull-up Hangs",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Legend",
          equipment: "Pull-up Bar",
          description: "Target rear delts and rotator cuffs with deep pull angles.",
          instructions: [
            "Grip bar wide, pull body up behind the neck.",
            "Hold top position for 2 seconds.",
            "Feel contraction in rear shoulders and upper back.",
            "Lower slowly back to dead hang."
          ],
          sets: 4,
          reps: "5-6 reps",
        ),
        SuggestedWorkout(
          id: "front_lever_pull_up_transitions",
          name: "Front Lever Pull-up Transitions",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Master",
          equipment: "Pull-up Bar",
          description: "Peak shoulder extension and retraction strength.",
          instructions: [
            "Pull into horizontal front lever position.",
            "Perform small pull-up movements.",
            "Requires massive rear deltoid and rotator shoulder drive.",
            "Lower back to hang under absolute control."
          ],
          sets: 5,
          reps: "3-4 reps",
        ),
        SuggestedWorkout(
          id: "machine_shoulder_press",
          name: "Machine Shoulder Press",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Easy",
          equipment: "Full Gym",
          description: "Isolate deltoids using fixed track machine.",
          instructions: [
            "Adjust seat so handles are at shoulder height.",
            "Grip handles, press upward smoothly.",
            "Lower slowly back to starting depth.",
            "Keep back flat against pad."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "barbell_military_press",
          name: "Barbell Military Press",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Medium",
          equipment: "Full Gym",
          description: "Strict barbell overhead press for shoulder power.",
          instructions: [
            "Unrack barbell at collarbone level.",
            "Press bar overhead, pulling head forward as bar clears.",
            "Lock out overhead, then lower bar to upper chest.",
            "Keep legs locked and glutes tight."
          ],
          sets: 3,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "barbell_behind_press",
          name: "Barbell Behind Press",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Hard",
          equipment: "Full Gym",
          description: "Target rear and side delts with behind-neck pressing.",
          instructions: [
            "Unrack barbell behind neck onto upper traps.",
            "Press bar straight overhead.",
            "Lower bar under control back to traps.",
            "Requires good shoulder mobility."
          ],
          sets: 4,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "cable_lateral_raises",
          name: "Cable Lateral Raises",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Legend",
          equipment: "Full Gym",
          description: "Constant tension lateral raise using low cable pulley.",
          instructions: [
            "Stand next to low pulley, grip cable with far hand.",
            "Raise arm out to side to shoulder height.",
            "Feel constant cable tension throughout.",
            "Control descent back to starting point."
          ],
          sets: 4,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "heavy_barbell_push_press",
          name: "Heavy Barbell Push Press",
          muscleGroup: MuscleGroup.shoulders,
          difficulty: "Master",
          equipment: "Full Gym",
          description: "Maximum overload overhead press utilizing explosive leg power.",
          instructions: [
            "Unrack heavy barbell, dip knees slightly.",
            "Drive legs upward, pushing bar overhead.",
            "Lower bar slowly to rack position on collarbones.",
            "Brace core to stabilize heavy load."
          ],
          sets: 5,
          reps: "4-6 reps",
        ),
        SuggestedWorkout(
          id: "bench_tricep_dips",
          name: "Bench Tricep Dips",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          description: "Tricep builder using elevated bench or chair surface.",
          instructions: [
            "Place hands on bench edge behind you, feet flat on floor.",
            "Lower hips by bending elbows to 90 degrees.",
            "Press back up to lock arms.",
            "Keep back close to bench throughout."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "close_grip_pushups",
          name: "Close-Grip Pushups",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Medium",
          equipment: "Bodyweight Only",
          description: "Push-up variation shifting focus to triceps.",
          instructions: [
            "Assume high plank, hands closer than shoulder-width.",
            "Lower chest to floor, keeping elbows tucked close to ribs.",
            "Press up dynamically, locking out triceps.",
            "Keep core tight to prevent hip drop."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "diamond_pushups",
          name: "Diamond Pushups",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          description: "Tight grip push-ups to isolate triceps.",
          instructions: [
            "Form diamond shape with thumbs and index fingers.",
            "Lower chest to hands, keeping elbows close.",
            "Press upward, squeezing triceps at lockout.",
            "Maintain straight body line."
          ],
          sets: 4,
          reps: "8-12 reps",
        ),
        SuggestedWorkout(
          id: "towel_hammer_bicep_pulls",
          name: "Towel Hammer Bicep Pulls",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Legend",
          equipment: "Bodyweight Only",
          description: "Isometric pulling drill to isolate biceps.",
          instructions: [
            "Loop towel under knee, grip ends firmly.",
            "Pull upward against leg to create bicep tension.",
            "Hold max contraction for 5 seconds.",
            "Release slowly and repeat."
          ],
          sets: 4,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "bodyweight_triceps_extensions",
          name: "Bodyweight Triceps Extensions",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Master",
          equipment: "Bodyweight Only",
          description: "Bodyweight tricep extension using low bar or floor setup.",
          instructions: [
            "Place hands on low bar or floor, walk feet back.",
            "Lower body by bending at elbows only.",
            "Press back up to arm lockout using triceps.",
            "Keep body rigid and elbows tucked."
          ],
          sets: 5,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_hammer_curls",
          name: "Dumbbell Hammer Curls",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Easy",
          equipment: "Dumbbells",
          description: "Target brachialis and forearms using neutral grip curls.",
          instructions: [
            "Stand holding dumbbells with palms facing each other.",
            "Curl weights up, keeping elbows fixed at sides.",
            "Stop at shoulder height, squeeze arms.",
            "Lower weights under control to starting hang."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_bicep_curls",
          name: "Dumbbell Bicep Curls",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Medium",
          equipment: "Dumbbells",
          description: "Classic bicep builder with wrist supination.",
          instructions: [
            "Hold dumbbells at sides, palms forward.",
            "Curl weights upward, rotating palms facing chest.",
            "Squeeze biceps at peak contraction.",
            "Lower weights slowly back to extension."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_overhead_tricep_extension",
          name: "Dumbbell Overhead Tricep Extension",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Hard",
          equipment: "Dumbbells",
          description: "Target long head of triceps from overhead stretch position.",
          instructions: [
            "Hold dumbbell with both hands overhead.",
            "Lower weight behind head by bending elbows.",
            "Keep elbows pointing forward, not flaring.",
            "Press weight back up to lockout."
          ],
          sets: 4,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_incline_curls",
          name: "Dumbbell Incline Curls",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Legend",
          equipment: "Dumbbells",
          description: "Deep stretch bicep curl on incline bench.",
          instructions: [
            "Sit on incline bench set to 45 degrees.",
            "Let dumbbells hang straight down behind shoulders.",
            "Curl weights up, keeping elbows pinned back.",
            "Lower weights slowly to full stretch."
          ],
          sets: 4,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "heavy_dumbbell_concentration_curls",
          name: "Heavy Dumbbell Concentration Curls",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Master",
          equipment: "Dumbbells",
          description: "Isolate bicep peak contraction using leg support.",
          instructions: [
            "Sit on bench, elbow braced against inner thigh.",
            "Curl heavy dumbbell upward toward chest.",
            "Squeeze bicep intensely at top.",
            "Control descent to starting point."
          ],
          sets: 5,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "underhand_grip_hangs",
          name: "Underhand Grip Hangs",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Easy",
          equipment: "Pull-up Bar",
          description: "Build grip and forearm bicep base endurance.",
          instructions: [
            "Grip bar with underhand grip (palms facing you).",
            "Hang with arms fully extended.",
            "Brace shoulders and hold position.",
            "Focus on grip strength."
          ],
          sets: 3,
          reps: "30-45 secs hold",
        ),
        SuggestedWorkout(
          id: "chin_ups_biceps_overload",
          name: "Chin-ups Biceps Overload",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Medium",
          equipment: "Pull-up Bar",
          description: "Vertically load biceps using underhand grip pull.",
          instructions: [
            "Grip bar underhand, shoulder-width apart.",
            "Pull chest to bar, keeping elbows forward.",
            "Squeeze biceps at top of movement.",
            "Lower slowly back to dead hang."
          ],
          sets: 3,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "close_grip_pullups",
          name: "Close Grip Pullups",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Hard",
          equipment: "Pull-up Bar",
          description: "Overload biceps and inner lats with close grip pull.",
          instructions: [
            "Grip bar overhand, hands 4 inches apart.",
            "Pull up dynamically until chin clears bar.",
            "Lower under control to full extension.",
            "Avoid swinging or using momentum."
          ],
          sets: 4,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "commando_pullups_trapezius",
          name: "Commando Pullups Trapezius",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Legend",
          equipment: "Pull-up Bar",
          description: "Lateral pull-up variation targeting arms unilaterally.",
          instructions: [
            "Stand under bar, grip with one hand in front of other.",
            "Pull up, bringing head to right side of bar.",
            "Lower slowly, then pull up to left side of bar.",
            "Switch hand placement each set."
          ],
          sets: 4,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "single_arm_underhand_chin_negatives",
          name: "Single-Arm Underhand Chin Negatives",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Master",
          equipment: "Pull-up Bar",
          description: "Eccentrically load bicep using single-arm lowering.",
          instructions: [
            "Jump up to top chin-up position with both hands.",
            "Release one hand, hold with single underhand grip.",
            "Lower body slowly over 5 seconds to hang.",
            "Help with opposite hand to reset."
          ],
          sets: 5,
          reps: "3-5 reps per arm",
        ),
        SuggestedWorkout(
          id: "cable_tricep_pushdowns",
          name: "Cable Tricep Pushdowns",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Easy",
          equipment: "Full Gym",
          description: "Isolate triceps using cable pulley with rope attachment.",
          instructions: [
            "Grip rope attachment, pin elbows to ribs.",
            "Press rope down, spreading ends at lockout.",
            "Squeeze triceps at bottom.",
            "Return rope slowly back to elbow height."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "barbell_ez_bar_bicep_curls",
          name: "Barbell EZ-Bar Bicep Curls",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Medium",
          equipment: "Full Gym",
          description: "Overload biceps using curved EZ barbell to reduce wrist strain.",
          instructions: [
            "Hold EZ bar with underhand grip.",
            "Curl bar upward, keeping elbows locked at sides.",
            "Squeeze biceps at top of motion.",
            "Lower bar under control back to thighs."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "lying_barbell_skullcrushers",
          name: "Lying Barbell Skullcrushers",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Hard",
          equipment: "Full Gym",
          description: "Tricep overload pressing barbell to forehead.",
          instructions: [
            "Lie on flat bench, hold EZ-bar over chest.",
            "Lower bar to forehead by bending elbows.",
            "Keep elbows pointing up, not flaring.",
            "Press bar back up to lockout using triceps."
          ],
          sets: 4,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "preacher_bench_curls",
          name: "Preacher Bench Curls",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Legend",
          equipment: "Full Gym",
          description: "Strict bicep isolation preventing shoulder assist.",
          instructions: [
            "Sit at preacher bench, brace arms against pad.",
            "Lower EZ-bar to near full extension.",
            "Curl bar up, keeping upper arms flat on pad.",
            "Squeeze biceps at peak."
          ],
          sets: 4,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "weighted_chin_ups_arm_overload",
          name: "Weighted Chin-ups Arm Overload",
          muscleGroup: MuscleGroup.arms,
          difficulty: "Master",
          equipment: "Full Gym",
          description: "Vertical bicep overload loading extra plates.",
          instructions: [
            "Secure weight belt around waist with plates.",
            "Grip bar underhand, pull chest up.",
            "Lower under control to full dead hang.",
            "Requires massive arm strength."
          ],
          sets: 5,
          reps: "4-6 reps",
        ),
        SuggestedWorkout(
          id: "plank_rotations_obliques",
          name: "Plank Rotations Obliques",
          muscleGroup: MuscleGroup.core,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          description: "Brace core in low plank and rotate hips side-to-side.",
          instructions: [
            "Start in forearm plank, elbows under shoulders.",
            "Rotate hips to right, tapping floor lightly.",
            "Return to center, then rotate to left.",
            "Keep shoulders steady and core braced."
          ],
          sets: 3,
          reps: "10 reps per side",
        ),
        SuggestedWorkout(
          id: "hollow_body_hold",
          name: "Hollow Body Hold",
          muscleGroup: MuscleGroup.core,
          difficulty: "Medium",
          equipment: "Bodyweight Only",
          description: "Isometric core builder locking lower back to floor.",
          instructions: [
            "Lie flat on back, arms overhead, legs straight.",
            "Lift head, shoulders, and legs off floor.",
            "Press lower back flat into the ground.",
            "Hold hollow shape, breathing shallowly."
          ],
          sets: 3,
          reps: "30-40 secs hold",
        ),
        SuggestedWorkout(
          id: "hanging_knee_raises",
          name: "Hanging Knee Raises",
          muscleGroup: MuscleGroup.core,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          description: "Target lower abs hanging from pull-up bar.",
          instructions: [
            "Hang from bar with straight arms.",
            "Pull knees to chest, rotating pelvis up.",
            "Hold top contraction for 1 second.",
            "Lower knees slowly to avoid swinging."
          ],
          sets: 4,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "l_sit_progressions",
          name: "L-Sit Progressions",
          muscleGroup: MuscleGroup.core,
          difficulty: "Legend",
          equipment: "Bodyweight Only",
          description: "Compression drill targeting abs, hip flexors, and triceps.",
          instructions: [
            "Sit on floor, hands next to hips.",
            "Press hands down to lift hips and legs off floor.",
            "Keep legs straight and parallel to ground.",
            "Hold lift, bracing core."
          ],
          sets: 4,
          reps: "15-20 secs hold",
        ),
        SuggestedWorkout(
          id: "dragon_flags_absolute_control",
          name: "Dragon Flags Absolute Control",
          muscleGroup: MuscleGroup.core,
          difficulty: "Master",
          equipment: "Bodyweight Only",
          description: "Ultimate core leverage drill popularized by Bruce Lee.",
          instructions: [
            "Lie on bench, grip edge behind head firmly.",
            "Roll weight onto shoulders and lift entire body vertical.",
            "Lower body in straight line, pivot only at shoulders.",
            "Bring body close to bench, then pull back up."
          ],
          sets: 5,
          reps: "5-6 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_russian_twists",
          name: "Dumbbell Russian Twists",
          muscleGroup: MuscleGroup.core,
          difficulty: "Easy",
          equipment: "Dumbbells",
          description: "Target obliques with loaded rotational seated twists.",
          instructions: [
            "Sit on floor, knees bent, hold dumbbell.",
            "Lean back 45 degrees, lift feet off floor.",
            "Rotate torso side to side, tapping dumbbell to floor.",
            "Keep movement slow and controlled."
          ],
          sets: 3,
          reps: "15 reps per side",
        ),
        SuggestedWorkout(
          id: "dumbbell_plank_pull_throughs",
          name: "Dumbbell Plank Pull-Throughs",
          muscleGroup: MuscleGroup.core,
          difficulty: "Medium",
          equipment: "Dumbbells",
          description: "Brace core in high plank while dragging weight side-to-side.",
          instructions: [
            "Assume high plank, dumbbell behind left hand.",
            "Reach under with right hand, drag dumbbell to right side.",
            "Switch hands, pull back to left side.",
            "Keep hips level; do not let them rotate."
          ],
          sets: 3,
          reps: "8-10 reps per side",
        ),
        SuggestedWorkout(
          id: "weighted_sit_ups_core_lock",
          name: "Weighted Sit-ups Core Lock",
          muscleGroup: MuscleGroup.core,
          difficulty: "Hard",
          equipment: "Dumbbells",
          description: "Loaded sit-ups focusing on upper abdominal drive.",
          instructions: [
            "Lie flat, knees bent, hold dumbbell over chest.",
            "Perform sit-up, pressing dumbbell overhead.",
            "Lower torso slowly back to floor.",
            "Keep dumbbell stable throughout."
          ],
          sets: 4,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_standing_side_bends",
          name: "Dumbbell Standing Side Bends",
          muscleGroup: MuscleGroup.core,
          difficulty: "Legend",
          equipment: "Dumbbells",
          description: "Isolate obliques in standing position.",
          instructions: [
            "Stand tall, hold dumbbell in one hand.",
            "Lower dumbbell down side of thigh by bending side.",
            "Squeeze obliques on opposite side to return upright.",
            "Avoid twisting hips or shoulders."
          ],
          sets: 4,
          reps: "12-15 reps per side",
        ),
        SuggestedWorkout(
          id: "dumbbell_renegade_row_core_lift",
          name: "Dumbbell Renegade Row Core Lift",
          muscleGroup: MuscleGroup.core,
          difficulty: "Master",
          equipment: "Dumbbells",
          description: "High plank dumbbell row targeting abs and upper back.",
          instructions: [
            "High plank gripping dumbbells, feet wide.",
            "Row dumbbell to ribs, bracing core to stay level.",
            "Return weight to floor under control.",
            "Switch sides and repeat next rep."
          ],
          sets: 5,
          reps: "8-10 reps per side",
        ),
        SuggestedWorkout(
          id: "hanging_knee_raises_prep",
          name: "Hanging Knee Raises Prep",
          muscleGroup: MuscleGroup.core,
          difficulty: "Easy",
          equipment: "Pull-up Bar",
          description: "Build core compression and hanging tolerance.",
          instructions: [
            "Hang from bar, palms forward.",
            "Raise knees to 90 degrees.",
            "Hold for 1 second, then lower slowly.",
            "Focus on control."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "hanging_leg_raises",
          name: "Hanging Leg Raises",
          muscleGroup: MuscleGroup.core,
          difficulty: "Medium",
          equipment: "Pull-up Bar",
          description: "Raise straight legs vertically from dead hang.",
          instructions: [
            "Hang from bar, legs locked straight.",
            "Raise legs parallel to floor.",
            "Lower under strict control.",
            "Avoid using momentum or swinging."
          ],
          sets: 3,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "windshield_wipers",
          name: "Windshield Wipers",
          muscleGroup: MuscleGroup.core,
          difficulty: "Hard",
          equipment: "Pull-up Bar",
          description: "Hanging rotational core drill targeting obliques.",
          instructions: [
            "Hang from bar, raise legs vertical to bar.",
            "Rotate legs side to side in wide arc.",
            "Keep hips high and arms locked.",
            "Control rotation angle."
          ],
          sets: 4,
          reps: "6-8 reps per side",
        ),
        SuggestedWorkout(
          id: "bar_l_sit_hold",
          name: "Bar L-Sit Hold",
          muscleGroup: MuscleGroup.core,
          difficulty: "Legend",
          equipment: "Pull-up Bar",
          description: "Hanging core compression holding L-shape.",
          instructions: [
            "Hang from bar, raise straight legs parallel to floor.",
            "Maintain L-sit position, keeping legs active.",
            "Hold for specified duration.",
            "Lower legs slowly at end."
          ],
          sets: 4,
          reps: "20-30 secs hold",
        ),
        SuggestedWorkout(
          id: "toes_to_bar_core_focus",
          name: "Toes to Bar Core Focus",
          muscleGroup: MuscleGroup.core,
          difficulty: "Master",
          equipment: "Pull-up Bar",
          description: "Hanging core compression bringing toes to touch bar.",
          instructions: [
            "Hang from bar, lift straight legs upward.",
            "Tap shoelaces to bar between hands.",
            "Lower legs slowly back to dead hang.",
            "Engage lats to assist core pull."
          ],
          sets: 5,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "cable_woodchoppers",
          name: "Cable Woodchoppers",
          muscleGroup: MuscleGroup.core,
          difficulty: "Easy",
          equipment: "Full Gym",
          description: "Rotational core drill using cable pulley stack.",
          instructions: [
            "Stand sideways to high cable pulley, grip handle with both hands.",
            "Pull cable diagonally down across body, rotating torso.",
            "Pivot back foot slightly.",
            "Slowly return to start."
          ],
          sets: 3,
          reps: "12 reps per side",
        ),
        SuggestedWorkout(
          id: "ab_wheel_rollouts",
          name: "Ab Wheel Rollouts",
          muscleGroup: MuscleGroup.core,
          difficulty: "Medium",
          equipment: "Full Gym",
          description: "Extreme anterior core extension using ab roller.",
          instructions: [
            "Kneel on pad, grip ab wheel handles.",
            "Roll wheel forward, extending body flat.",
            "Brace core, do not let lower back sag.",
            "Pull wheel back to start using abs."
          ],
          sets: 3,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "decline_weighted_situps",
          name: "Decline Weighted Situps",
          muscleGroup: MuscleGroup.core,
          difficulty: "Hard",
          equipment: "Full Gym",
          description: "Declined sit-ups holding weight plate.",
          instructions: [
            "Secure feet in decline bench, hold plate at chest.",
            "Lower torso back until shoulders clear pad.",
            "Sit up dynamically, squeezing abs.",
            "Maintain flat back throughout."
          ],
          sets: 4,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "cable_crunches",
          name: "Cable Crunches",
          muscleGroup: MuscleGroup.core,
          difficulty: "Legend",
          equipment: "Full Gym",
          description: "Kneeling weighted crunch targeting rectus abdominis.",
          instructions: [
            "Kneel facing cable stack, hold rope behind neck.",
            "Crunch down, drawing elbows to thighs.",
            "Exhale fully at bottom contraction.",
            "Return slowly to upright position."
          ],
          sets: 4,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "weighted_planks_heavy_duty",
          name: "Weighted Planks Heavy Duty",
          muscleGroup: MuscleGroup.core,
          difficulty: "Master",
          equipment: "Full Gym",
          description: "Overload core stabilizers with plate loading.",
          instructions: [
            "Assume forearm plank position.",
            "Have partner place heavy plate on lower back.",
            "Maintain rigid plank, bracing core.",
            "Hold for specified duration."
          ],
          sets: 5,
          reps: "45-60 secs hold",
        ),
        SuggestedWorkout(
          id: "assisted_squats_joint_mobility",
          name: "Assisted Squats Joint Mobility",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          description: "Use wall or chair support to build base squat depth.",
          instructions: [
            "Stand facing support, hands resting on it.",
            "Squat down, pushing hips back and down.",
            "Keep chest up, weight in heels.",
            "Press back up to standing position."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "bodyweight_air_squats",
          name: "Bodyweight Air Squats",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Medium",
          equipment: "Bodyweight Only",
          description: "Classic quad and glute builder using body weight.",
          instructions: [
            "Stand feet shoulder-width, toes angled out.",
            "Squat down until thighs are parallel to floor.",
            "Keep knees tracking over toes.",
            "Press up dynamically through heels."
          ],
          sets: 3,
          reps: "15-20 reps",
        ),
        SuggestedWorkout(
          id: "bulgarian_split_squats",
          name: "Bulgarian Split Squats",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          description: "Unilateral leg developer targeting quads and glutes.",
          instructions: [
            "Place rear foot on bench behind you.",
            "Lower front thigh until parallel to ground.",
            "Keep front knee behind toes.",
            "Drive up through front heel."
          ],
          sets: 4,
          reps: "10-12 reps per side",
        ),
        SuggestedWorkout(
          id: "pistol_squat_progression",
          name: "Pistol Squat Progression",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Legend",
          equipment: "Bodyweight Only",
          description: "Single leg squat requiring balance, mobility, and strength.",
          instructions: [
            "Stand on one leg, extend other leg forward.",
            "Lower hips down into deep single-leg squat.",
            "Keep heel flat and knee stable.",
            "Drive back up to standing balance."
          ],
          sets: 4,
          reps: "5-6 reps per side",
        ),
        SuggestedWorkout(
          id: "shrimp_squat_leg_destroy",
          name: "Shrimp Squat Leg Destroy",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Master",
          equipment: "Bodyweight Only",
          description: "Advanced single leg squat keeping rear foot bent behind.",
          instructions: [
            "Stand on one leg, bend rear knee holding foot.",
            "Lower until rear knee touches floor gently.",
            "Drive back up using front leg power.",
            "Keep torso upright."
          ],
          sets: 5,
          reps: "4-6 reps per side",
        ),
        SuggestedWorkout(
          id: "dumbbell_goblet_squat",
          name: "Dumbbell Goblet Squat",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Easy",
          equipment: "Dumbbells",
          description: "Load quads holding dumbbell close to chest.",
          instructions: [
            "Hold dumbbell vertically at chest level.",
            "Squat down to parallel depth, chest up.",
            "Push knees outward over toes.",
            "Press up to standing position."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_romanian_deadlift",
          name: "Dumbbell Romanian Deadlift",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Medium",
          equipment: "Dumbbells",
          description: "Target hamstrings and glutes with loaded hip hinge.",
          instructions: [
            "Stand tall holding dumbbells in front of thighs.",
            "Hinge forward at hips, sliding weights down legs.",
            "Keep back flat and knees slightly bent.",
            "Squeeze glutes to return to standing position."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_walking_lunges",
          name: "Dumbbell Walking Lunges",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Hard",
          equipment: "Dumbbells",
          description: "Loaded walking lunges for unilateral leg power.",
          instructions: [
            "Hold dumbbells at sides, step forward.",
            "Lower until back knee is near floor.",
            "Drive through front heel to step forward into next rep.",
            "Keep torso upright."
          ],
          sets: 4,
          reps: "10-12 steps per side",
        ),
        SuggestedWorkout(
          id: "dumbbell_step_ups_quad_burn",
          name: "Dumbbell Step-Ups Quad Burn",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Legend",
          equipment: "Dumbbells",
          description: "Step onto elevated box holding dumbbells.",
          instructions: [
            "Stand holding dumbbells in front of sturdy box.",
            "Place one foot on box, drive up to stand.",
            "Control descent back to floor.",
            "Perform all reps on one leg before switching."
          ],
          sets: 4,
          reps: "8-10 reps per side",
        ),
        SuggestedWorkout(
          id: "dumbbell_single_leg_deadlift",
          name: "Dumbbell Single-Leg Deadlift",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Master",
          equipment: "Dumbbells",
          description: "Overload hamstrings unilaterally while testing balance.",
          instructions: [
            "Hold dumbbell in opposite hand of working leg.",
            "Hinge forward, extending free leg behind.",
            "Keep back flat, feel stretch in hamstring.",
            "Return upright using glutes."
          ],
          sets: 5,
          reps: "6-8 reps per side",
        ),
        SuggestedWorkout(
          id: "hanging_leg_extensions_prep",
          name: "Hanging Leg Extensions Prep",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Easy",
          equipment: "Pull-up Bar",
          description: "Quad loading using leg extension under hanging support.",
          instructions: [
            "Hang from bar, bend knees 90 degrees.",
            "Extend legs straight out and hold.",
            "Lower legs slowly back to bent angle.",
            "Keep core tight."
          ],
          sets: 3,
          reps: "12 reps",
        ),
        SuggestedWorkout(
          id: "bar_assisted_pistol_squats",
          name: "Bar Assisted Pistol Squats",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Medium",
          equipment: "Pull-up Bar",
          description: "Learn pistol squat balance using bar for support.",
          instructions: [
            "Grip bar at chest height, lift one leg.",
            "Perform single-leg squat, using bar to assist upward pull.",
            "Drive up through heel.",
            "Switch legs each set."
          ],
          sets: 3,
          reps: "8-10 reps per side",
        ),
        SuggestedWorkout(
          id: "single_leg_calf_raises",
          name: "Single Leg Calf Raises",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Hard",
          equipment: "Pull-up Bar",
          description: "High-rep calf work using bar for balance support.",
          instructions: [
            "Stand on one foot near bar support, hand on it.",
            "Raise heel high, pressing onto toes.",
            "Squeeze calf at top contraction.",
            "Lower heel slowly."
          ],
          sets: 4,
          reps: "15-20 reps per side",
        ),
        SuggestedWorkout(
          id: "bar_hanging_leg_swings",
          name: "Bar Hanging Leg Swings",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Legend",
          equipment: "Pull-up Bar",
          description: "Decompress hips and stretch hamstrings dynamically.",
          instructions: [
            "Hang from bar, swing legs forward and back.",
            "Control swing using abs and lower back.",
            "Stretch hip flexors and hamstrings dynamically.",
            "Maintain controlled tempo."
          ],
          sets: 4,
          reps: "12 reps",
        ),
        SuggestedWorkout(
          id: "air_squats_under_bar_shrugs",
          name: "Air Squats Under-Bar Shrugs",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Master",
          equipment: "Pull-up Bar",
          description: "Perform deep air squats, shrugging against bar at top.",
          instructions: [
            "Position bar at shoulder height, stand beneath.",
            "Perform deep air squat, stand up, shrug against bar.",
            "Combine leg extension with neck shroud squeeze.",
            "Maintain strict form."
          ],
          sets: 5,
          reps: "10 reps",
        ),
        SuggestedWorkout(
          id: "leg_press_machine",
          name: "Leg Press Machine",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Easy",
          equipment: "Full Gym",
          description: "Isolate quads and glutes in fixed track machine.",
          instructions: [
            "Sit in machine, place feet shoulder-width on sled.",
            "Release safety pins, lower sled under control.",
            "Press sled back up without locking knees.",
            "Keep lower back flat against seat."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "barbell_back_squat",
          name: "Barbell Back Squat",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Medium",
          equipment: "Full Gym",
          description: "The king of lower body compound exercises.",
          instructions: [
            "Rest barbell on upper traps, stand tall.",
            "Squat down until hips are below knees.",
            "Keep chest up and knees tracking outward.",
            "Drive upward through mid-foot."
          ],
          sets: 3,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "barbell_romanian_deadlift",
          name: "Barbell Romanian Deadlift",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Hard",
          equipment: "Full Gym",
          description: "Heavy hip hinge targeting hamstrings and glutes.",
          instructions: [
            "Hold barbell with overhand grip at hips.",
            "Hinge forward, pushing hips back, bar sliding down thighs.",
            "Stop at mid-shin, feel deep hamstring stretch.",
            "Squeeze glutes to return upright."
          ],
          sets: 4,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "barbell_front_squats",
          name: "Barbell Front Squats",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Legend",
          equipment: "Full Gym",
          description: "Quad-dominant squatting variant holding bar on collarbones.",
          instructions: [
            "Rack barbell on front of shoulders (front rack).",
            "Keep elbows pointing forward, chest up.",
            "Squat deep, keeping torso vertical.",
            "Drive up through heels."
          ],
          sets: 4,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "heavy_barbell_deadlift_power",
          name: "Heavy Barbell Deadlift Power",
          muscleGroup: MuscleGroup.legs,
          difficulty: "Master",
          equipment: "Full Gym",
          description: "Pure lower body pulling power overload.",
          instructions: [
            "Stand close to bar, hinge to grip overhand.",
            "Flatten back, brace abs, engage hamstrings.",
            "Pull bar off floor in straight vertical line.",
            "Lock out hips fully at top."
          ],
          sets: 5,
          reps: "3-5 reps",
        ),
        SuggestedWorkout(
          id: "downward_dog_flow",
          name: "Downward Dog Flow",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          description: "Flow between high plank and downward dog for full body mobility.",
          instructions: [
            "Start in high plank, shoulders over wrists.",
            "Push hips up and back into downward dog.",
            "Press heels toward floor, stretching hamstrings.",
            "Flow back to high plank smoothly."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "cobra_stretch_flow",
          name: "Cobra Stretch Flow",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Medium",
          equipment: "Bodyweight Only",
          description: "Decompress lower back and open chest dynamically.",
          instructions: [
            "Lie face down, hands under shoulders.",
            "Press up, arching back and raising chest.",
            "Look up, opening anterior chain.",
            "Lower down slowly to reset."
          ],
          sets: 3,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "world_greatest_stretch",
          name: "World Greatest Stretch",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          description: "Multijoint mobility drill loading chest, hips, and shoulders.",
          instructions: [
            "Step forward into deep lunge, hands inside front foot.",
            "Rotate inside arm up to ceiling, look at hand.",
            "Bring hand back, extend front knee to stretch hamstring.",
            "Switch sides and repeat next rep."
          ],
          sets: 4,
          reps: "6-8 reps per side",
        ),
        SuggestedWorkout(
          id: "inverted_pike_stretch",
          name: "Inverted Pike Stretch",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Legend",
          equipment: "Bodyweight Only",
          description: "Active shoulder opening and hamstring length developer.",
          instructions: [
            "Bent at hips, hands on floor, head tucked.",
            "Press chest toward toes, opening shoulders.",
            "Keep knees straight, stretching calves and hamstrings.",
            "Hold active stretch for 3 seconds."
          ],
          sets: 4,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "bridge_pose_back_extension",
          name: "Bridge Pose Back Extension",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Master",
          equipment: "Bodyweight Only",
          description: "Full body posterior extension bridging off floor.",
          instructions: [
            "Lie on back, bend knees, place hands next to ears.",
            "Press through hands and feet to arch body off floor.",
            "Extend arms and legs, pushing chest out.",
            "Lower under control to avoid spine strain."
          ],
          sets: 5,
          reps: "5 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_thrusters",
          name: "Dumbbell Thrusters",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Easy",
          equipment: "Dumbbells",
          description: "Combine squat with overhead press using dumbbells.",
          instructions: [
            "Hold dumbbells at shoulders, squat down.",
            "Stand up explosively, driving weights overhead.",
            "Lower weights back to shoulders under control.",
            "Repeat next rep immediately."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_man_makers",
          name: "Dumbbell Man Makers",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Medium",
          equipment: "Dumbbells",
          description: "Burpee, row, clean, and press combined with dumbbells.",
          instructions: [
            "Plank holding dumbbells, perform push-up.",
            "Row dumbbell to ribs on right, then left.",
            "Jump feet forward, clean dumbbells to shoulders.",
            "Squat and press weights overhead."
          ],
          sets: 3,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_clean_and_press",
          name: "Dumbbell Clean and Press",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Hard",
          equipment: "Dumbbells",
          description: "Ground to overhead power drill using dumbbells.",
          instructions: [
            "Stand holding dumbbells at knees, hinge hips.",
            "Clean dumbbells to shoulders with leg pop.",
            "Dip knees and press weights overhead.",
            "Lower dumbbells to sides and repeat."
          ],
          sets: 4,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_farmers_carry",
          name: "Dumbbell Farmers Carry",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Legend",
          equipment: "Dumbbells",
          description: "Full body carry building traps, core, and grip.",
          instructions: [
            "Deadlift heavy dumbbells to sides.",
            "Stand tall, brace core, pull shoulders back.",
            "Walk in straight line using small, controlled steps.",
            "Avoid letting weights swing."
          ],
          sets: 4,
          reps: "1 min walk",
        ),
        SuggestedWorkout(
          id: "dumbbell_devil_press",
          name: "Dumbbell Devil Press",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Master",
          equipment: "Dumbbells",
          description: "High-intensity dumbbell burpee to snatch.",
          instructions: [
            "Drop into burpee chest to dumbbells on floor.",
            "Jump feet wide, swing weights between legs.",
            "Snatch dumbbells overhead in one continuous path.",
            "Lower weights under control and repeat next rep."
          ],
          sets: 5,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "active_bar_hanging_alignment",
          name: "Active Bar Hanging Alignment",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Easy",
          equipment: "Pull-up Bar",
          description: "Decompress spine and engage shoulder stabilizers.",
          instructions: [
            "Grip pull-up bar wide overhand.",
            "Pull shoulder blades down, bracing abs.",
            "Keep legs hanging straight, feet close.",
            "Hold active position, breathing deeply."
          ],
          sets: 3,
          reps: "30-45 secs hold",
        ),
        SuggestedWorkout(
          id: "kipping_pullups_flow",
          name: "Kipping Pullups Flow",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Medium",
          equipment: "Pull-up Bar",
          description: "Incorporate hip swing to drive pull-up count.",
          instructions: [
            "Initiate kipping swing using shoulders and hips.",
            "Pull chest to bar as body swings back.",
            "Push away from bar at top to cycle next rep.",
            "Maintain rhythmic swing cadence."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "toes_to_bar_compression",
          name: "Toes-to-Bar Compression",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Hard",
          equipment: "Pull-up Bar",
          description: "Anterior chain developer bringing toes to bar.",
          instructions: [
            "Hang from bar, swing legs back slightly.",
            "Crunch abs, bringing straight legs up to touch bar.",
            "Lower legs slowly to prevent wild swinging.",
            "Keep shoulders active."
          ],
          sets: 4,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "muscle_up_bar_transition",
          name: "Muscle-up Bar Transition",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Legend",
          equipment: "Pull-up Bar",
          description: "Transition pull-up into straight bar dip.",
          instructions: [
            "Pull up explosively, pulling bar to lower chest.",
            "Transition wrists over bar, leaning forward.",
            "Press bodyweight up to full arm extension.",
            "Lower slowly back to dead hang."
          ],
          sets: 4,
          reps: "4-6 reps",
        ),
        SuggestedWorkout(
          id: "bar_hanging_around_the_world",
          name: "Bar Hanging Around-the-World",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Master",
          equipment: "Pull-up Bar",
          description: "Full body rotation hanging from bar.",
          instructions: [
            "Hang from bar, raise straight legs vertical.",
            "Rotate legs in wide circle (360 degrees).",
            "Brace core and lats to stabilize body.",
            "Repeat in opposite direction next set."
          ],
          sets: 5,
          reps: "5-6 reps",
        ),
        SuggestedWorkout(
          id: "kettlebell_swing_power",
          name: "Kettlebell Swing Power",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Easy",
          equipment: "Full Gym",
          description: "Hip hinge movement building hamstrings and glutes.",
          instructions: [
            "Stand feet wide, hold kettlebell in front.",
            "Hinge at hips, swinging kettlebell between legs.",
            "Drive hips forward explosively, swinging bell to chest.",
            "Control swing back down, hinging again immediately."
          ],
          sets: 3,
          reps: "15-20 reps",
        ),
        SuggestedWorkout(
          id: "barbell_clean_and_press",
          name: "Barbell Clean and Press",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Medium",
          equipment: "Full Gym",
          description: "Olympic lifting basic lifting bar from floor overhead.",
          instructions: [
            "Deadlift barbell from floor, pull to hips.",
            "Pop hips, clean bar onto front rack shoulders.",
            "Dip knees, press barbell overhead.",
            "Lower bar to chest, then floor, and repeat."
          ],
          sets: 3,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "barbell_snatch_power",
          name: "Barbell Snatch Power",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Hard",
          equipment: "Full Gym",
          description: "Ground-to-overhead barbell pull in one continuous motion.",
          instructions: [
            "Grip barbell wide, flat back, hinge down.",
            "Pull bar off floor explosively, shrug shoulders.",
            "Drop under bar, catching it overhead in squat.",
            "Stand up fully, locking bar overhead."
          ],
          sets: 4,
          reps: "5-6 reps",
        ),
        SuggestedWorkout(
          id: "barbell_thrusters_full_body",
          name: "Barbell Thrusters Full Body",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Legend",
          equipment: "Full Gym",
          description: "Front squat to overhead press with heavy barbell.",
          instructions: [
            "Rack barbell on front of shoulders, squat deep.",
            "Stand up explosively, pressing bar overhead.",
            "Lower bar back to front rack under control.",
            "Repeat next rep immediately."
          ],
          sets: 4,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "heavy_barbell_clean_and_jerk",
          name: "Heavy Barbell Clean and Jerk",
          muscleGroup: MuscleGroup.fullBody,
          difficulty: "Master",
          equipment: "Full Gym",
          description: "The absolute king of full body power output.",
          instructions: [
            "Clean heavy barbell from floor to front rack shoulders.",
            "Dip knees, drive bar up while splitting legs (split jerk).",
            "Lock bar overhead, bring feet back together.",
            "Lower bar under control to floor and reset next rep."
          ],
          sets: 5,
          reps: "2-3 reps",
        ),
        SuggestedWorkout(
          id: "jumping_jacks_heat",
          name: "Jumping Jacks Heat",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          description: "Classic aerobic warming drill.",
          instructions: [
            "Stand feet close, hands at sides.",
            "Jump feet wide while bringing hands overhead.",
            "Jump back to starting position immediately.",
            "Maintain fast, steady cadence."
          ],
          sets: 3,
          reps: "1 min work",
        ),
        SuggestedWorkout(
          id: "mountain_climbers_cardio",
          name: "Mountain Climbers Cardio",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Medium",
          equipment: "Bodyweight Only",
          description: "High plank leg driving cardio interval.",
          instructions: [
            "Assume high plank position.",
            "Drive right knee to chest, then left knee.",
            "Alternate legs rapidly as if running.",
            "Keep hips level and core tight."
          ],
          sets: 3,
          reps: "1 min work",
        ),
        SuggestedWorkout(
          id: "burpee_interval_energy",
          name: "Burpee Interval Energy",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          description: "Full body cardio drill spiking heart rate.",
          instructions: [
            "Drop to floor chest touching ground.",
            "Jump feet back in, stand up dynamically.",
            "Jump vertically, hands clapping overhead.",
            "Land soft and drop into next rep immediately."
          ],
          sets: 4,
          reps: "15-20 reps",
        ),
        SuggestedWorkout(
          id: "shadow_boxing_agile",
          name: "Shadow Boxing Agile",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Legend",
          equipment: "Bodyweight Only",
          description: "Agile shadow boxing intervals focusing on footwork.",
          instructions: [
            "Assume boxing stance, hands protecting chin.",
            "Throw rapid punches (jabs, crosses, hooks).",
            "Move feet constantly, pivoting and ducking.",
            "Maintain high punch output and fast breathing."
          ],
          sets: 4,
          reps: "2 mins work",
        ),
        SuggestedWorkout(
          id: "tuck_jumps_cardio",
          name: "Tuck Jumps Cardio",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Master",
          equipment: "Bodyweight Only",
          description: "Explosive vertical jumps drawing knees to chest.",
          instructions: [
            "Stand tall, dip knees slightly.",
            "Jump vertically with maximum effort.",
            "Tuck knees to chest at peak height.",
            "Land softly on toes, absorb impact, repeat."
          ],
          sets: 5,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "light_dumbbell_shadow_boxing",
          name: "Light Dumbbell Shadow Boxing",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Easy",
          equipment: "Dumbbells",
          description: "Shadow box holding light dumbbells to add load.",
          instructions: [
            "Hold light dumbbells, assume boxing stance.",
            "Throw controlled punches, focusing on form.",
            "Do not snap elbows; keep movement smooth.",
            "Step and move feet constantly."
          ],
          sets: 3,
          reps: "1 min work",
        ),
        SuggestedWorkout(
          id: "dumbbell_goblet_squat_jumps",
          name: "Dumbbell Goblet Squat Jumps",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Medium",
          equipment: "Dumbbells",
          description: "Loaded squat jumps using dumbbell goblet grip.",
          instructions: [
            "Hold dumbbell vertically at chest.",
            "Squat down to parallel height.",
            "Jump vertically, extending ankles and knees.",
            "Land softly, drop back into squat immediately."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_single_arm_snatch",
          name: "Dumbbell Single-Arm Snatch",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Hard",
          equipment: "Dumbbells",
          description: "Rapid dumbbell snatch intervals for aerobic power.",
          instructions: [
            "Hold dumbbell at knees, hinge hips.",
            "Pull weight up and snatch overhead.",
            "Lower under control, switch hands at chest.",
            "Repeat immediately on opposite arm."
          ],
          sets: 4,
          reps: "15 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_thrusters_cardio",
          name: "Dumbbell Thrusters Cardio",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Legend",
          equipment: "Dumbbells",
          description: "Fast dumbbell thruster sets to spike heart rate.",
          instructions: [
            "Hold dumbbells at shoulders, squat down.",
            "Stand up explosively, driving weights overhead.",
            "Lower weights back to shoulders under control.",
            "Repeat immediately at fast cardio pace."
          ],
          sets: 4,
          reps: "15-20 reps",
        ),
        SuggestedWorkout(
          id: "dumbbell_devil_press_cardio",
          name: "Dumbbell Devil Press Cardio",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Master",
          equipment: "Dumbbells",
          description: "Heavy dumbbell burpee to snatch cardio sprint.",
          instructions: [
            "Burpee chest to dumbbells on floor.",
            "Jump feet wide, swing weights between legs.",
            "Snatch dumbbells overhead in one continuous path.",
            "Lower weights to floor and drop into next rep immediately."
          ],
          sets: 5,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "hanging_fast_knee_raises",
          name: "Hanging Fast Knee Raises",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Easy",
          equipment: "Pull-up Bar",
          description: "Hanging knee raise cardio intervals.",
          instructions: [
            "Hang from bar with straight arms.",
            "Drive knees to chest at fast cadence.",
            "Control swing using core stabilizers.",
            "Keep shoulders active."
          ],
          sets: 3,
          reps: "15-20 reps",
        ),
        SuggestedWorkout(
          id: "pullup_to_knee_raise_cycles",
          name: "Pullup to Knee Raise Cycles",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Medium",
          equipment: "Pull-up Bar",
          description: "Combine pull-up with knee tuck dynamically.",
          instructions: [
            "Perform pull-up, drawing chin over bar.",
            "As you lower, pull knees to chest immediately.",
            "Extend legs, swing back, pull up again.",
            "Maintain steady pacing."
          ],
          sets: 3,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "burpee_pullup_rapid",
          name: "Burpee Pullup Rapid",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Hard",
          equipment: "Pull-up Bar",
          description: "Burpee under bar transitioning to explosive pull-up.",
          instructions: [
            "Perform burpee under pull-up bar.",
            "Jump up to grab bar, pull chest to bar.",
            "Drop back to floor, go into next burpee immediately.",
            "Keep transition fast."
          ],
          sets: 4,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "muscle_up_fast_reps",
          name: "Muscle-up Fast Reps",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Legend",
          equipment: "Pull-up Bar",
          description: "Fast muscle-up cycles to test power endurance.",
          instructions: [
            "Execute dynamic kip pull muscle-up.",
            "Push away from bar at top to drop under bar.",
            "Use drop momentum to transition into next rep.",
            "Maintain strict bar safety."
          ],
          sets: 4,
          reps: "5-6 reps",
        ),
        SuggestedWorkout(
          id: "toes_to_bar_fast_pacing",
          name: "Toes-to-Bar Fast Pacing",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Master",
          equipment: "Pull-up Bar",
          description: "High rep toes-to-bar intervals.",
          instructions: [
            "Hang from bar, bring toes to bar dynamically.",
            "Use controlled kip swing to speed up cycles.",
            "Brace core to absorb drop extension.",
            "Maintain high rep cadence."
          ],
          sets: 5,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "gym_rowing_machine",
          name: "Gym Rowing Machine",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Easy",
          equipment: "Full Gym",
          description: "Full body cardiovascular rowing intervals.",
          instructions: [
            "Sit at rower, strap feet, grip handle.",
            "Drive legs back, lean torso, pull handle to ribs.",
            "Extend arms, hinge torso, bend knees to slide forward.",
            "Maintain steady stroke-per-minute pacing."
          ],
          sets: 3,
          reps: "2 mins work",
        ),
        SuggestedWorkout(
          id: "battle_ropes_wave",
          name: "Battle Ropes Wave",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Medium",
          equipment: "Full Gym",
          description: "Upper body rope waves for cardio conditioning.",
          instructions: [
            "Stand athletic stance, hold ropes.",
            "Alternate arms to create rapid waves in ropes.",
            "Keep core tight and knees bent.",
            "Maintain wave height throughout interval."
          ],
          sets: 3,
          reps: "45 secs work",
        ),
        SuggestedWorkout(
          id: "barbell_thruster_cardio",
          name: "Barbell Thruster Cardio",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Hard",
          equipment: "Full Gym",
          description: "Barbell thrusters performed at high speed.",
          instructions: [
            "Rack barbell on chest, squat deep.",
            "Drive bar overhead explosively.",
            "Control bar back to chest, dropping into next squat.",
            "Maintain high-intensity pacing."
          ],
          sets: 4,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "kettlebell_snatch_high_reps",
          name: "Kettlebell Snatch High Reps",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Legend",
          equipment: "Full Gym",
          description: "Unilateral high rep kettlebell snatches off floor.",
          instructions: [
            "Hinge to grab kettlebell on floor.",
            "Pull and snatch kettlebell overhead in one motion.",
            "Drop bell to hips, swing back, repeat next rep.",
            "Switch hands after specified rep count."
          ],
          sets: 4,
          reps: "15-20 reps per arm",
        ),
        SuggestedWorkout(
          id: "assault_bike_speed_sprint",
          name: "Assault Bike Speed Sprint",
          muscleGroup: MuscleGroup.cardio,
          difficulty: "Master",
          equipment: "Full Gym",
          description: "Max effort sprints on air resistance assault bike.",
          instructions: [
            "Sit on bike, feet on pedals, hands on handles.",
            "Sprint with maximum effort, pushing handles and pedaling.",
            "Drive heart rate to maximum output.",
            "Maintain sprint until timer ends."
          ],
          sets: 5,
          reps: "30 secs sprint",
        )
  ];
}

class WorkoutSession {
  final String id;
  final String type;
  final double durationMinutes;
  final DateTime date;

  WorkoutSession({
    required this.id,
    required this.type,
    required this.durationMinutes,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'durationMinutes': durationMinutes,
        'date': date.toIso8601String(),
      };

  factory WorkoutSession.fromJson(Map<String, dynamic> json) => WorkoutSession(
        id: json['id'] ?? '',
        type: json['type'] ?? '',
        durationMinutes: (json['durationMinutes'] as num?)?.toDouble() ?? 0.0,
        date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      );
}

class PREntry {
  final DateTime date;
  final double value;

  PREntry({required this.date, required this.value});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'value': value,
      };

  factory PREntry.fromJson(Map<String, dynamic> json) {
    return PREntry(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}