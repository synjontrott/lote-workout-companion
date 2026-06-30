import 'package:flutter/material.dart';
import 'dart:math';

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
    required this.planetOfOrigin,
    required this.inherentDark,
  });

  Color get primaryColor => hexToColor(primaryColorHex);
  Color get accentColor => hexToColor(accentColorHex);

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
  }) : pixelGrid = grid ?? defaultGrid;

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
    if (rawGrid != null) {
      grid = rawGrid
          .map((row) => (row as List<dynamic>).map((cell) => cell as int).toList())
          .toList();
    } else {
      grid = defaultGrid;
    }
    return CharacterSprite(
      hairStyle: json['hairStyle'] ?? 'Spiky',
      hairColorHex: json['hairColorHex'] ?? '#FFEA00',
      skinColorHex: json['skinColorHex'] ?? '#FFD180',
      outfitStyle: json['outfitStyle'] ?? 'Ninjonia',
      outfitColorHex: json['outfitColorHex'] ?? '#37474F',
      auraStyle: json['auraStyle'] ?? 'Flames',
      sex: json['sex'] ?? 'Male',
      grid: grid,
    );
  }

  static List<List<int>> scale16To50(List<List<int>> grid16) {
    List<List<int>> grid50 = List.generate(50, (_) => List.generate(50, (_) => 0));
    for (int r = 0; r < 50; r++) {
      for (int c = 0; c < 50; c++) {
        int r16 = (r * 16) ~/ 50;
        int c16 = (c * 16) ~/ 50;
        grid50[r][c] = grid16[r16][c16];
      }
    }
    return grid50;
  }

  static List<List<int>> get defaultGrid {
    final grid = List.generate(50, (_) => List.generate(50, (_) => 0));
    
    // Aura
    for (int r = 0; r < 50; r++) {
      for (int c = 0; c < 50; c++) {
        final dx = c - 25;
        final dy = r - 25;
        final distSq = dx * dx + dy * dy;
        if (distSq >= 441 && distSq <= 529) {
          if ((r + c) % 3 == 0) { grid[r][c] = 5; }
        }
      }
    }
    
    // Torso / Armor
    for (int r = 25; r <= 42; r++) {
      for (int c = 16; c <= 34; c++) {
        grid[r][c] = 4;
      }
    }
    
    // Legs
    for (int r = 43; r <= 47; r++) {
      for (int c = 18; c <= 22; c++) { grid[r][c] = 4; }
      for (int c = 28; c <= 32; c++) { grid[r][c] = 4; }
    }
    // Boots
    for (int c = 17; c <= 23; c++) { grid[48][c] = 4; grid[49][c] = 4; }
    for (int c = 27; c <= 33; c++) { grid[48][c] = 4; grid[49][c] = 4; }
    
    // Head / Skin
    for (int r = 12; r <= 24; r++) {
      for (int c = 18; c <= 32; c++) {
        grid[r][c] = 1;
      }
    }
    
    // Eyes
    grid[15][21] = 3; grid[15][22] = 3;
    grid[16][21] = 3; grid[16][22] = 3;
    grid[15][28] = 3; grid[15][29] = 3;
    grid[16][28] = 3; grid[16][29] = 3;
    
    // Hair
    for (int r = 8; r <= 11; r++) {
      for (int c = 16; c <= 34; c++) { grid[r][c] = 2; }
    }
    for (int r = 12; r <= 16; r++) {
      grid[r][17] = 2;
      grid[r][33] = 2;
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
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      weight: (json['weight'] as num).toDouble(),
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
        ShopItem(name: "Celestial Dragon Badge", cost: 100, description: "Unlocks the special celestial dragon profile badge indicating elite status.", type: "badge", sprite: "🐉"),
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
        rewardXP: 40,
        rewardCrystals: 15,
        statReward: StatType.dexterity,
        statValue: 1,
      ),
      LotEQuest(
        id: 'q2',
        title: 'Earth Shaking Forging',
        questDescription: 'Lift heavy weights, do bodyweight exercises, or strength training. Perform 20 mins.',
        workoutType: WorkoutCategory.strength,
        difficultyRoll: 10,
        rewardXP: 60,
        rewardCrystals: 25,
        statReward: StatType.strength,
        statValue: 1,
      ),
      LotEQuest(
        id: 'q3',
        title: 'Mobility Routine',
        questDescription: 'Perform a mobility routine, stretching, or yoga to improve flexibility. 15 mins.',
        workoutType: WorkoutCategory.flexibility,
        difficultyRoll: 6,
        rewardXP: 30,
        rewardCrystals: 10,
        statReward: StatType.wisdom,
        statValue: 1,
      ),
      LotEQuest(
        id: 'q4',
        title: 'Consuming Healthy Rations',
        questDescription: 'Log a protein-rich, nourishing meal with fresh vegetables and clean energy hydration.',
        workoutType: WorkoutCategory.nutrition,
        difficultyRoll: 5,
        rewardXP: 25,
        rewardCrystals: 10,
        statReward: StatType.constitution,
        statValue: 1,
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

List<LotEQuest> generateQuests(String element, List<TrainingFocus> focuses, QuestCadence cadence) {
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
          stat = StatType.strength;
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
          stat = StatType.strength;
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
          stat = StatType.dexterity;
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
          stat = StatType.wisdom;
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
          stat = StatType.constitution;
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
          stat = StatType.constitution;
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

class SuggestedWorkout {
  final String id;
  final String name;
  final WorkoutCategory category;
  final String difficulty; // "Easy", "Medium", "Hard", "Legend", "Master"
  final String equipment;
  final String space;
  final String description;
  final List<String> instructions;
  final int sets;
  final String reps;

  SuggestedWorkout({
    required this.id,
    required this.name,
    required this.category,
    required this.difficulty,
    required this.equipment,
    required this.space,
    required this.description,
    required this.instructions,
    required this.sets,
    required this.reps,
  });
  static List<SuggestedWorkout> get allWorkouts => [
        // PUSHUPS SERIES (STRENGTH)
        SuggestedWorkout(
          id: "knee_pushups",
          name: "Knee Pushups Foundation",
          category: WorkoutCategory.strength,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Build upper body pushing strength targeting the chest, triceps, and anterior deltoids using an elevated knee lever to reduce load.",
          instructions: [
            "TARGET MUSCLES: Chest, Triceps, Anterior Deltoids",
            "SETUP & WIDTH: Hand width shoulder-width apart, knees resting on mat.",
            "DIFFICULTY KEY: Easy tier (reduced body weight lever for base conditioning).",
            "Get down on your hands and knees on a soft mat.",
            "Position your hands slightly wider than shoulder-width apart.",
            "Keep your core braced, forming a straight line from your head to your knees.",
            "Lower your chest toward the floor by bending your elbows, keeping them tucked at a 45-degree angle.",
            "Push back up dynamically through your palms to return to the starting lockout position."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "standard_pushups",
          name: "Standard Pushups Drill",
          category: WorkoutCategory.strength,
          difficulty: "Medium",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Classic chest, shoulder, and triceps builder that challenges core stability and upper body pushing stamina.",
          instructions: [
            "TARGET MUSCLES: Chest, Triceps, Core",
            "SETUP & WIDTH: Hand width shoulder-width apart, hands directly under shoulders.",
            "DIFFICULTY KEY: Medium tier (standard horizontal bodyweight push).",
            "Assume a high plank position with feet close together and hands directly under your shoulders.",
            "Keep your spine neutral, glutes squeezed, and abs fully engaged.",
            "Lower your body under control until your chest is about one inch off the floor.",
            "Ensure your elbows do not flare out wide; keep them angled back slightly.",
            "Press firmly into the ground to push yourself back up to the starting lockout."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "diamond_pushups",
          name: "Diamond Pushups Precision",
          category: WorkoutCategory.strength,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "A close-grip pushup variation designed to shift the load onto the triceps and inner chest fibers.",
          instructions: [
            "TARGET MUSCLES: Triceps, Inner Chest",
            "SETUP & WIDTH: Hands close together forming a diamond shape (touching thumbs and index fingers).",
            "DIFFICULTY KEY: Hard tier (shifted load to triceps and chest midline).",
            "Assume a high plank position but bring your hands close together directly under your chest.",
            "Form a diamond shape by touching your index fingers and thumbs together.",
            "Maintain a rigid straight line from head to heels.",
            "Lower your chest toward your hands, keeping your elbows tucked tightly against your ribs.",
            "Press upward dynamically, focusing on squeeze contraction in the triceps."
          ],
          sets: 4,
          reps: "8-12 reps",
        ),
        SuggestedWorkout(
          id: "archer_pushups",
          name: "Archer Pushups Ascent",
          category: WorkoutCategory.strength,
          difficulty: "Legend",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "An advanced single-arm loaded pushup variation. Slide side-to-side to overload one arm at a time.",
          instructions: [
            "TARGET MUSCLES: Pectorals, Core, Single-Arm Overload",
            "SETUP & WIDTH: Hands placed extremely wide apart, fingers angled outward.",
            "DIFFICULTY KEY: Legend tier (unilateral overload, sliding side-to-side).",
            "Assume a high plank position with your hands placed very wide apart, fingers angled outward.",
            "Keep your core locked and lower your body to one side, bending that elbow.",
            "Keep the opposite arm completely straight as you lower down.",
            "Push up from the bent arm to return to the center high plank.",
            "Repeat the movement by lowering to the opposite side."
          ],
          sets: 4,
          reps: "6-8 reps per side",
        ),
        SuggestedWorkout(
          id: "handstand_pushups",
          name: "Handstand Pushups Mastery",
          category: WorkoutCategory.strength,
          difficulty: "Master",
          equipment: "Bodyweight Only",
          space: "Gym Space",
          description: "The ultimate vertical pushing workout for explosive shoulders and triceps, performed against a wall for balance.",
          instructions: [
            "TARGET MUSCLES: Shoulders (Deltoids), Triceps, Trapezius",
            "SETUP & WIDTH: Hands shoulder-width apart, wall support.",
            "DIFFICULTY KEY: Master tier (vertical load utilizing entire bodyweight).",
            "Place your hands about 6-12 inches away from a sturdy wall.",
            "Kick up into a vertical handstand, placing your heels flat against the wall for support.",
            "Slowly lower your body until the top of your head touches the floor lightly.",
            "Keep your elbows tucked at a 45-degree angle relative to your head.",
            "Press upward through your shoulders with max effort to return to locked arms."
          ],
          sets: 5,
          reps: "5-8 reps",
        ),
        
        // PULLUPS SERIES (STRENGTH)
        SuggestedWorkout(
          id: "pullup_negatives",
          name: "Pullup Negatives Ascent",
          category: WorkoutCategory.strength,
          difficulty: "Easy",
          equipment: "Pullup Bar",
          space: "Small Room",
          description: "Build lat, back, and arm strength by focusing entirely on the lowering phase of the pullup.",
          instructions: [
            "TARGET MUSCLES: Latissimus Dorsi, Biceps, Rhomboids",
            "SETUP & WIDTH: Hand width shoulder-width apart, overhand grip.",
            "DIFFICULTY KEY: Easy tier (focuses on slow 5-sec lowering to build base pulling power).",
            "Place a box or stand beneath the pullup bar.",
            "Jump up so your chin is above the bar, gripping it shoulder-width apart.",
            "Hold this position for one second, keeping your core braced.",
            "Slowly lower your body under control, taking a full 5 seconds to reach full extension.",
            "Drop to the floor, step back on the box, and repeat for the target reps."
          ],
          sets: 3,
          reps: "5-6 reps",
        ),
        SuggestedWorkout(
          id: "close_grip_pullups",
          name: "Close Grip Pullups Drill",
          category: WorkoutCategory.strength,
          difficulty: "Medium",
          equipment: "Pullup Bar",
          space: "Small Room",
          description: "Overload the biceps and lower lats by using a narrow overhand grip on the bar.",
          instructions: [
            "TARGET MUSCLES: Biceps, Brachialis, Lower Lats",
            "SETUP & WIDTH: Hand width narrow (4-6 inches apart on the bar).",
            "DIFFICULTY KEY: Medium tier (increased elbow flexion torque to overload arm pulling).",
            "Hang from the bar with your hands placed close together, palms facing away.",
            "Engage your shoulders by pulling your shoulder blades down and together.",
            "Pull your chest up toward the bar, keeping your elbows tucked close to your body.",
            "Squeeze your biceps and upper back at the peak of the movement.",
            "Lower your body slowly to full arm extension before starting the next rep."
          ],
          sets: 3,
          reps: "8-10 reps",
        ),
        SuggestedWorkout(
          id: "wide_grip_pullups",
          name: "Wide Grip Pullups Precision",
          category: WorkoutCategory.strength,
          difficulty: "Hard",
          equipment: "Pullup Bar",
          space: "Small Room",
          description: "Maximize back width by widening your hands, targeting the upper lats and teres major.",
          instructions: [
            "TARGET MUSCLES: Outer Lats (Latissimus Dorsi), Teres Major",
            "SETUP & WIDTH: Hand width wide (1.5x shoulder-width apart).",
            "DIFFICULTY KEY: Hard tier (maximizes back width engagement by shortening biceps leverage).",
            "Grip the bar with hands placed significantly wider than shoulder-width apart.",
            "Depress your scapula and pull from your elbows to lift your body.",
            "Drive your elbows downward toward your ribs to engage the outer lat fibers.",
            "Pull until your chin is fully over the bar.",
            "Lower under control to complete a dead hang stretch."
          ],
          sets: 4,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "archer_pullups",
          name: "Archer Pullups Pull",
          category: WorkoutCategory.strength,
          difficulty: "Legend",
          equipment: "Pullup Bar",
          space: "Gym Space",
          description: "Overload one side of your lats at a time by sliding your chest toward one hand while keeping the other arm straight.",
          instructions: [
            "TARGET MUSCLES: Unilateral Lats, Biceps, Rhomboids",
            "SETUP & WIDTH: Hand width extremely wide apart on the bar.",
            "DIFFICULTY KEY: Legend tier (unilateral pulling load).",
            "Grip the bar with an extremely wide overhand grip.",
            "Pull your body up toward your right hand, keeping your left arm completely straight.",
            "Pause at the top with your chest near your right wrist.",
            "Lower back down slowly to the center hang.",
            "Repeat the movement by pulling up toward your left hand."
          ],
          sets: 4,
          reps: "5-6 reps per side",
        ),
        SuggestedWorkout(
          id: "one_arm_pullup",
          name: "One-Arm Pullup Mastery",
          category: WorkoutCategory.strength,
          difficulty: "Master",
          equipment: "Pullup Bar",
          space: "Gym Space",
          description: "The absolute peak of pulling strength: lifting your entire bodyweight with a single arm.",
          instructions: [
            "TARGET MUSCLES: Biceps, Latissimus Dorsi, Brachialis, Core",
            "SETUP & WIDTH: Single hand grip on bar, free arm bracing body.",
            "DIFFICULTY KEY: Master tier (pulling entire bodyweight with a single arm).",
            "Grip the bar firmly with one hand using a underhand or overhand grip.",
            "Brace your entire core, legs, and free arm to prevent body rotation.",
            "Engage your shoulder blade dynamically from a dead hang.",
            "Pull with maximum power, keeping your elbow tucked tightly to your side.",
            "Lower slowly under control to prevent joint strain."
          ],
          sets: 5,
          reps: "2-3 reps per arm",
        ),
        
        // SPECIFIC MUSCLE GROUP WORKOUTS (DUMBBELLS)
        SuggestedWorkout(
          id: "db_bicep_curl",
          name: "Dumbbell Bicep Curl",
          category: WorkoutCategory.strength,
          difficulty: "Easy",
          equipment: "Dumbbells",
          space: "Small Room",
          description: "Classic arm isolation exercise targeting the biceps brachii, designed to build arm thickness and grip strength.",
          instructions: [
            "TARGET MUSCLES: Biceps Brachii, Brachioradialis",
            "SETUP & WIDTH: Feet shoulder-width, palms facing forward.",
            "DIFFICULTY KEY: Easy tier (isolation focusing on biceps peak).",
            "Stand with feet shoulder-width apart, holding a dumbbell in each hand, palms facing forward.",
            "Keep your elbows locked close to your sides and stabilize your posture.",
            "Exhale and curl the weights upward toward shoulder height, keeping upper arms stationary.",
            "Squeeze your biceps tightly at the peak of the contraction for one second.",
            "Inhale and slowly lower the dumbbells back to full arm extension."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "db_overhead_tricep",
          name: "Dumbbell Overhead Tricep Extension",
          category: WorkoutCategory.strength,
          difficulty: "Medium",
          equipment: "Dumbbells",
          space: "Small Room",
          description: "Triceps isolation exercise targeting the long head of the tricep by pressing overhead and working through a deep stretch.",
          instructions: [
            "TARGET MUSCLES: Triceps Brachii (Long Head)",
            "SETUP & WIDTH: Stand tall, single dumbbell held with both hands overhead.",
            "DIFFICULTY KEY: Medium tier (overhead stretch overloading the triceps).",
            "Stand tall with feet shoulder-width apart, holding a single dumbbell by the bell with both hands.",
            "Raise the dumbbell straight up overhead, keeping your upper arms vertical and close to your ears.",
            "Bend your elbows to slowly lower the dumbbell behind your head in a deep stretch.",
            "Keep your elbows pointed forward and do not let them flare outward.",
            "Contract your triceps to press the dumbbell back up to the starting overhead position."
          ],
          sets: 3,
          reps: "12 reps",
        ),
        SuggestedWorkout(
          id: "db_bent_over_row",
          name: "Dumbbell Bent-Over Row",
          category: WorkoutCategory.strength,
          difficulty: "Medium",
          equipment: "Dumbbells",
          space: "Small Room",
          description: "Compound back exercise targeting the latissimus dorsi, rhomboids, and lower back stability.",
          instructions: [
            "TARGET MUSCLES: Latissimus Dorsi, Rhomboids, Rear Delts",
            "SETUP & WIDTH: Bent torso, dumbbells hanging, feet shoulder-width.",
            "DIFFICULTY KEY: Medium tier (horizontal back pulling, lumbar stabilization).",
            "Stand holding a dumbbell in each hand, palms facing each other, feet shoulder-width apart.",
            "Bend your knees slightly and hinge forward at the hips until your torso is nearly parallel to the floor.",
            "Keep your spine completely flat and let the weights hang straight down.",
            "Pull the dumbbells up toward your ribcage, drawing your elbows back and squeezing your shoulder blades.",
            "Lower the weights slowly under control to return to the starting position."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "db_romanian_deadlift",
          name: "Dumbbell Romanian Deadlift",
          category: WorkoutCategory.strength,
          difficulty: "Medium",
          equipment: "Dumbbells",
          space: "Small Room",
          description: "Posterior chain builder focusing heavily on the hamstrings, gluteus maximus, and lower back stability.",
          instructions: [
            "TARGET MUSCLES: Hamstrings, Glutes, Erector Spinae",
            "SETUP & WIDTH: Feet hip-width apart, dumbbells in front of thighs.",
            "DIFFICULTY KEY: Medium tier (hinging movement focused on posterior loading).",
            "Stand holding dumbbells in front of your thighs with palms facing your body.",
            "Keep your feet hip-width apart and your spine straight and neutral.",
            "Hinge at the hips, pushing them backward while lowering the dumbbells along your shins.",
            "Lower the weights until you feel a deep stretch in your hamstrings, keeping knees slightly bent.",
            "Squeeze your glutes and push your hips forward to return to an upright standing stance."
          ],
          sets: 3,
          reps: "10 reps",
        ),
        
        // CARDIO WORKOUTS
        SuggestedWorkout(
          id: "jumping_jacks",
          name: "Jumping Jacks Ignite",
          category: WorkoutCategory.cardio,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Full-body aerobic builder and agility warmup designed to spike your heart rate and improve circulation.",
          instructions: [
            "TARGET MUSCLES: Calves, Deltoids, Heart (Cardiovascular)",
            "SETUP & WIDTH: Jumping feet wide and arms overhead.",
            "DIFFICULTY KEY: Easy tier (warmup, light metabolic loading).",
            "Stand tall with your feet together and arms hanging down at your sides.",
            "Jump upward while spreading your legs wider than shoulder-width and raising your arms overhead.",
            "Clap your hands together at the peak of the jump.",
            "Jump again to quickly return your feet together and arms back to your sides.",
            "Repeat continuously in a fluid, rhythmic cadence."
          ],
          sets: 3,
          reps: "30 secs",
        ),
        SuggestedWorkout(
          id: "high_knees",
          name: "High Knees Interval",
          category: WorkoutCategory.cardio,
          difficulty: "Medium",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "High-intensity cardio drill targeting leg speed, hip flexor strength, and cardiovascular conditioning.",
          instructions: [
            "TARGET MUSCLES: Hip Flexors, Quadriceps, Core, Calves",
            "SETUP & WIDTH: Running in place, raising knees high.",
            "DIFFICULTY KEY: Medium tier (rapid metabolic spikes and quick hip turnover).",
            "Stand in place with your feet hip-width apart.",
            "Begin running in place, raising your knees upward to hip height.",
            "Pump your arms dynamically in sync with your legs.",
            "Stay light on the balls of your feet and maintain a high pace.",
            "Keep your chest upright and core braced throughout the duration."
          ],
          sets: 3,
          reps: "45 secs",
        ),
        SuggestedWorkout(
          id: "tuck_jump",
          name: "Tuck Jump Explosion",
          category: WorkoutCategory.cardio,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          space: "Large Room",
          description: "Explosive plyometric vertical jump designed to build raw power and test cardiovascular capacity.",
          instructions: [
            "TARGET MUSCLES: Quadriceps, Glutes, Calves, Core",
            "SETUP & WIDTH: Squatting to vertical jump, knees tucked high.",
            "DIFFICULTY KEY: Hard tier (high power plyometric training).",
            "Stand with your feet shoulder-width apart and knees slightly bent.",
            "Drop into a shallow squat, then explode upward into a vertical jump.",
            "While in mid-air, tuck your knees up toward your chest as high as possible.",
            "Release your knees quickly and land softly on the balls of your feet, absorbing the impact.",
            "Reset immediately and repeat the jump."
          ],
          sets: 4,
          reps: "10 reps",
        ),
        SuggestedWorkout(
          id: "double_under",
          name: "Double-Under Jump Rope",
          category: WorkoutCategory.cardio,
          difficulty: "Legend",
          equipment: "Rands/Rope",
          space: "Large Room",
          description: "High velocity jump rope training that requires extreme timing, wrist speed, and aerobic endurance.",
          instructions: [
            "TARGET MUSCLES: Calves, Forearms, Shoulders, Heart",
            "SETUP & WIDTH: Balanced stance, spinning rope twice per jump.",
            "DIFFICULTY KEY: Legend tier (intense coordination, timing, and wrist speed).",
            "Hold a jump rope and assume a balanced jumping stance.",
            "Perform high vertical hops on the balls of your feet.",
            "Spin the rope twice per jump using quick, flicking motions of your wrists.",
            "Keep your elbows tucked close to your hips and bounce off the floor quickly.",
            "Maintain a consistent, relaxed rhythm without losing control."
          ],
          sets: 4,
          reps: "50 jumps",
        ),
        SuggestedWorkout(
          id: "handstand_walk",
          name: "Handstand Walking Cruise",
          category: WorkoutCategory.cardio,
          difficulty: "Master",
          equipment: "Bodyweight Only",
          space: "Gym Space",
          description: "Advanced gymnastics skill combining coordinate movement, shoulder endurance, and core balance while inverted.",
          instructions: [
            "TARGET MUSCLES: Shoulders, Trapezius, Core, Wrists",
            "SETUP & WIDTH: Hand width shoulder-width, inverted walk.",
            "DIFFICULTY KEY: Master tier (extreme weight translation, coordination, and balancing).",
            "Kick up into a vertical handstand position against a wall or freestanding.",
            "Shift your weight slightly forward and take small steps on the floor using your hands.",
            "Keep your legs squeezed together and your hips directly over your shoulders.",
            "Control your balance by pressing actively through your fingertips.",
            "Walk 10 meters continuously to complete a set."
          ],
          sets: 5,
          reps: "10 meters",
        ),
        
        // FLEXIBILITY WORKOUTS
        SuggestedWorkout(
          id: "childs_pose",
          name: "Child's Pose Restorative",
          category: WorkoutCategory.flexibility,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Restorative stretch to release tension in the lower back, hips, and shoulders while soothing the nervous system.",
          instructions: [
            "TARGET MUSCLES: Lower Back, Glutes, Deltoids",
            "SETUP & WIDTH: Knees wide, sit back on heels, forehead on floor.",
            "DIFFICULTY KEY: Easy tier (passive restorative stretching to open spine and hips).",
            "Kneel on the floor, touch your big toes together, and sit back on your heels.",
            "Separate your knees about hip-width apart.",
            "Fold your torso forward over your thighs and lay your forehead on the floor.",
            "Extend your arms straight out in front of you, palms down.",
            "Breathe deeply into your lower back and hold the stretch."
          ],
          sets: 2,
          reps: "1 min hold",
        ),
        SuggestedWorkout(
          id: "downward_dog",
          name: "Downward Dog Stretch",
          category: WorkoutCategory.flexibility,
          difficulty: "Medium",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Classic yoga posture that stretches the hamstrings, calves, shoulders, and spine simultaneously.",
          instructions: [
            "TARGET MUSCLES: Hamstrings, Calves, Shoulders, Spine",
            "SETUP & WIDTH: Hands shoulder-width, feet hip-width, hips high.",
            "DIFFICULTY KEY: Medium tier (active flexibility and calf lengthening).",
            "Start on your hands and knees in a tabletop position.",
            "Tuck your toes, press through your palms, and lift your hips high and back.",
            "Extend your legs to form an inverted 'V' shape.",
            "Press your heels down toward the floor and broaden your shoulders.",
            "Keep your neck relaxed and look toward your feet."
          ],
          sets: 3,
          reps: "45 secs hold",
        ),
        SuggestedWorkout(
          id: "pigeon_pose",
          name: "Deep Pigeon Hip Release",
          category: WorkoutCategory.flexibility,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Intense hip opener targeting the glutes, piriformis, and hip flexors. Highly beneficial for lower body mobility.",
          instructions: [
            "TARGET MUSCLES: Glutes, Piriformis, Hip Flexors",
            "SETUP & WIDTH: Front knee forward behind wrist, back leg flat.",
            "DIFFICULTY KEY: Hard tier (deep hip opening, requiring joint flexibility).",
            "From a plank, bring your right knee forward and place it behind your right wrist.",
            "Angle your right shin across your body toward your left hip.",
            "Slide your left leg straight back behind you, keeping your foot flat.",
            "Lower your hips to the floor and sit tall to align your pelvis.",
            "Lower your torso forward over your front leg and rest on your forearms."
          ],
          sets: 3,
          reps: "1 min per side",
        ),
        SuggestedWorkout(
          id: "full_splits",
          name: "Full Splits Alignment",
          category: WorkoutCategory.flexibility,
          difficulty: "Legend",
          equipment: "Bodyweight Only",
          space: "Large Room",
          description: "Advanced leg split targeting maximal hamstring and hip flexor range of motion.",
          instructions: [
            "TARGET MUSCLES: Hamstrings, Groin, Hip Flexors",
            "SETUP & WIDTH: Legs extended forward and backward along floor.",
            "DIFFICULTY KEY: Legend tier (extreme hip opening and lower body stretching).",
            "Extend one leg straight forward and slide the other leg straight back behind you.",
            "Lower your hips slowly toward the floor, keeping your hips squared.",
            "Support your weight with your hands on blocks or the floor for safety.",
            "Keep your spine upright and breathe deeply as your hips open.",
            "Hold the stretch at a comfortable point of tension."
          ],
          sets: 3,
          reps: "30 secs hold",
        ),
        SuggestedWorkout(
          id: "hollowback_handstand",
          name: "Hollowback Handstand Arch",
          category: WorkoutCategory.flexibility,
          difficulty: "Master",
          equipment: "Bodyweight Only",
          space: "Gym Space",
          description: "Ultimate overhead flexibility and shoulder extension drill performed while inverted in a handstand.",
          instructions: [
            "TARGET MUSCLES: Shoulders, Chest, Abdominals, Spine",
            "SETUP & WIDTH: Handstand, feet resting against wall.",
            "DIFFICULTY KEY: Master tier (active chest arching while supporting bodyweight).",
            "Kick up into a handstand facing away from a wall, about a foot away.",
            "Lower your feet to touch the wall, then arch your chest outward into a deep backbend.",
            "Push your shoulders forward to open the chest and stretch the upper back.",
            "Maintain control of your core and breathe slowly in the arch.",
            "Slowly slide your feet back up to return to a straight handstand."
          ],
          sets: 3,
          reps: "20 secs hold",
        ),
        
        // MEDITATION WORKOUTS
        SuggestedWorkout(
          id: "breath_awareness",
          name: "Breath Awareness",
          category: WorkoutCategory.meditation,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Focuses the mind on nasal airflow to ground your attention, calm the nervous system, and build initial focus.",
          instructions: [
            "TARGET MUSCLES: Brain (Nervous system, cognitive calming).",
            "SETUP & WIDTH: Tall spine, hands relaxed in lap.",
            "DIFFICULTY KEY: Easy tier (grounding attention by monitoring nasal airflow).",
            "Sit comfortably in a chair or on a cushion with a tall, straight spine.",
            "Close your eyes and place your hands relaxed on your lap.",
            "Observe the natural flow of your breath as it enters and exits your nostrils.",
            "Notice the temperature and sensation of the air without trying to change it.",
            "Whenever your mind drifts, gently bring your focus back to the breath."
          ],
          sets: 1,
          reps: "5 mins",
        ),
        SuggestedWorkout(
          id: "body_scan",
          name: "Body Scan Relaxation",
          category: WorkoutCategory.meditation,
          difficulty: "Medium",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "A somatic scanning meditation that systematically releases physical tension throughout the entire body.",
          instructions: [
            "TARGET MUSCLES: Somatic nervous system (stress release).",
            "SETUP & WIDTH: Lie flat in Savasana on a mat.",
            "DIFFICULTY KEY: Medium tier (systematic progressive muscle release from toes to face).",
            "Lie flat on your back in Savasana on a soft mat.",
            "Let your feet fall open and place your arms at your sides, palms up.",
            "Close your eyes and draw your attention to your toes, breathing into them.",
            "Gradually scan upward through your feet, ankles, calves, knees, thighs, and hips.",
            "Continue scanning through your torso, back, arms, neck, and face, releasing all tension."
          ],
          sets: 1,
          reps: "10 mins",
        ),
        SuggestedWorkout(
          id: "chakra_focusing",
          name: "Elemental Chakra Focusing",
          category: WorkoutCategory.meditation,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Deep visualization meditation focusing elemental energy color channels at the body's primary energy centers.",
          instructions: [
            "TARGET MUSCLES: Mind (attention focus, color visualization).",
            "SETUP & WIDTH: Lotus cross-legged pose, mudra hand position.",
            "DIFFICULTY KEY: Hard tier (focusing active element colors expanding from core).",
            "Sit in a cross-legged Lotus position with your hands in a mudra of your choice.",
            "Breathe slowly and visualize a glowing energy core at your navel.",
            "Adopt the color of your active element (e.g. fire red, water blue).",
            "Feel the elemental energy expand with each inhalation, radiating out to your extremities.",
            "Stabilize the energy core, feeling rooted in your warrior element."
          ],
          sets: 1,
          reps: "15 mins",
        ),
        SuggestedWorkout(
          id: "void_resonance",
          name: "Void Resonance Meditation",
          category: WorkoutCategory.meditation,
          difficulty: "Legend",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Zen meditation designed to quiet all mental chatter and settle into absolute void spatial emptiness.",
          instructions: [
            "Sit facing a blank wall in a quiet, darkened room.",
            "Keep your eyes half-open with a soft, unfocused gaze.",
            "Let all thoughts rise and fall like clouds in a vast sky, without attaching to them.",
            "Experience the empty space around you, resonant with absolute silence.",
            "Maintain this state of spacious awareness without effort."
          ],
          sets: 1,
          reps: "20 mins",
        ),
        SuggestedWorkout(
          id: "astral_space",
          name: "Astral Space Integration",
          category: WorkoutCategory.meditation,
          difficulty: "Master",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Advanced transcendental meditation connecting your physical self to the cosmic currents of the LOTE universe.",
          instructions: [
            "Sit in comfortable silence and achieve a deep state of physiological stillness.",
            "Expand your mental awareness beyond the boundaries of your room, imagining the cosmos.",
            "Visualize cosmic stardust flowing into your lungs with every breath.",
            "Settle into the universal flow, experiencing unity with all elemental energies.",
            "Gently return your focus back to the room before opening your eyes."
          ],
          sets: 1,
          reps: "30 mins",
        ),
        
        // NUTRITION WORKOUTS
        SuggestedWorkout(
          id: "hydration_ritual",
          name: "Hydration Ritual",
          category: WorkoutCategory.nutrition,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Daily task to drink 3 liters of fresh water, crucial for muscle recovery, joint lubrication, and cellular energy.",
          instructions: [
            "Drink 500ml of clean water immediately upon waking to kickstart metabolism.",
            "Carry a reusable water container with you throughout the day.",
            "Log each glass or bottle consumed in your fitness companion app.",
            "Consume water before, during, and after your training sessions.",
            "Ensure you complete the 3-liter target before going to bed."
          ],
          sets: 1,
          reps: "3 Liters",
        ),
        SuggestedWorkout(
          id: "protein_prep",
          name: "Clean Protein Prep",
          category: WorkoutCategory.nutrition,
          difficulty: "Medium",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Weekly food prep routine to cook healthy, lean proteins to support muscle synthesis and clean recovery.",
          instructions: [
            "Purchase lean protein sources such as chicken breast, white fish, or firm tofu.",
            "Season light with herbs, garlic, and sea salt, avoiding sugary sauces.",
            "Grill, bake, or steam the protein under clean heat.",
            "Weigh out portions based on your daily macros (e.g. 150-200g per portion).",
            "Store in clean containers in the refrigerator for ready-to-eat meals."
          ],
          sets: 1,
          reps: "3 meals prepped",
        ),
        SuggestedWorkout(
          id: "nutrient_optimization",
          name: "Micro-Nutrient Optimization",
          category: WorkoutCategory.nutrition,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Eat five distinct colors of fresh vegetables today to secure vital vitamins, minerals, and antioxidants.",
          instructions: [
            "Select spinach (green), red bell pepper (red), carrot (orange), purple cabbage (purple), and yellow onion (yellow).",
            "Wash and chop the vegetables fresh.",
            "Cook light or steam to preserve maximum nutrient levels.",
            "Distribute the vegetables across your meals today.",
            "Log the five color micro-nutrients in your fitness dashboard."
          ],
          sets: 1,
          reps: "5 colors logged",
        ),
        SuggestedWorkout(
          id: "bulking_prep",
          name: "Advanced Bulking Prep",
          category: WorkoutCategory.nutrition,
          difficulty: "Legend",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Prepare calorie-dense, macro-balanced bulking meals to support intensive strength gains.",
          instructions: [
            "Measure high-quality carbs (sweet potatoes, brown rice) and lean meats (ground beef, chicken).",
            "Incorporate healthy fats (avocado, olive oil, almonds) into your meals.",
            "Calculate your bulking target to establish a caloric surplus of 300-500 kcal.",
            "Prepare 4 high-calorie clean meals for the next few days.",
            "Log your macros to verify correct protein-to-carb ratios."
          ],
          sets: 1,
          reps: "4 meals prepped",
        ),
        SuggestedWorkout(
          id: "chrono_nutrition",
          name: "Chrono-Nutrition Fasting Alignment",
          category: WorkoutCategory.nutrition,
          difficulty: "Master",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Align your daily eating window to optimize growth hormone release, insulin sensitivity, and gut health.",
          instructions: [
            "Establish a strict eating window of 8 hours (e.g., 12:00 PM to 8:00 PM).",
            "Consume all daily caloric requirements inside this 8-hour target window.",
            "Fast for the remaining 16 hours of the day.",
            "Hydrate only with water, black coffee, or plain tea during the fast.",
            "Log your fast start and end times in your settings log."
          ],
          sets: 1,
          reps: "16/8 window logged",
        ),
        
        // DUMBBELL STRENGTH WORKOUTS (COMPOUND)
        SuggestedWorkout(
          id: "db_goblet_squat",
          name: "Dumbbell Goblet Squat",
          category: WorkoutCategory.strength,
          difficulty: "Easy",
          equipment: "Dumbbells",
          space: "Small Room",
          description: "Excellent lower body movement targeting the quadriceps, glutes, and core stability using a front-loaded weight.",
          instructions: [
            "Stand with feet shoulder-width apart, toes flared outward at 15 degrees.",
            "Hold a single heavy dumbbell vertically at your chest, cupping the top head with both hands.",
            "Lower your hips backward and down, keeping your chest upright and spine neutral.",
            "Squat down until your thighs are parallel to the floor, pushing knees out in line with toes.",
            "Press through your heels to stand back up, squeezing your glutes at the top."
          ],
          sets: 3,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "db_floor_press",
          name: "Dumbbell Floor Press",
          category: WorkoutCategory.strength,
          difficulty: "Medium",
          equipment: "Dumbbells",
          space: "Small Room",
          description: "Horizontal press targeting the pectorals and triceps, utilizing the floor to limit elbow range and protect shoulders.",
          instructions: [
            "Lie flat on your back on the floor, knees bent and feet flat on the ground.",
            "Hold a dumbbell in each hand directly over your chest with arms straight.",
            "Lower the dumbbells slowly until your upper arms rest flat on the floor.",
            "Ensure your elbows are angled at 45 degrees relative to your torso.",
            "Press the weights upward dynamically, focusing on chest contraction."
          ],
          sets: 3,
          reps: "12-15 reps",
        ),
        SuggestedWorkout(
          id: "db_renegade_row",
          name: "Dumbbell Renegade Row",
          category: WorkoutCategory.strength,
          difficulty: "Hard",
          equipment: "Dumbbells",
          space: "Small Room",
          description: "Anti-rotational core stabilization combined with a horizontal back pull. Demands high core engagement.",
          instructions: [
            "Assume a high plank position with your hands gripping dumbbells placed flat on the floor.",
            "Set your feet wider than shoulder-width apart to stabilize your hips.",
            "Brace your core tight and row one dumbbell upward to your lower ribcage.",
            "Keep your hips level; do not let them rotate as you pull.",
            "Lower the dumbbell back to the floor and repeat the row on the opposite side."
          ],
          sets: 4,
          reps: "8-10 reps per arm",
        ),
        SuggestedWorkout(
          id: "db_thrusters",
          name: "Dumbbell Thrusters",
          category: WorkoutCategory.strength,
          difficulty: "Legend",
          equipment: "Dumbbells",
          space: "Large Room",
          description: "High-intensity compound movement combining a front squat with an overhead press in one fluid explosion.",
          instructions: [
            "Stand tall holding dumbbells racked at shoulder height, palms facing each other.",
            "Drop into a deep front squat, keeping your chest up and elbows high.",
            "Explode upward dynamically, using leg power to drive the weights overhead.",
            "Lock out your arms at the top, pressing the dumbbells straight up.",
            "Lower the dumbbells back to your shoulders under control as you squat down again."
          ],
          sets: 4,
          reps: "10-12 reps",
        ),
        SuggestedWorkout(
          id: "db_man_makers",
          name: "Dumbbell Man-Makers",
          category: WorkoutCategory.strength,
          difficulty: "Master",
          equipment: "Dumbbells",
          space: "Gym Space",
          description: "Extremely challenging complex full-body drill: pushup, renegade row, squat clean, and thruster.",
          instructions: [
            "Assume a plank position on dumbbells and perform a full chest-to-floor pushup.",
            "Row the right dumbbell, then the left dumbbell to your ribcage (renegade row).",
            "Jump your feet forward wide, land flat, and clean the dumbbells to your shoulders.",
            "Perform a front squat, then explode up to drive the dumbbells overhead (thruster).",
            "Return the weights to the floor and jump back to the plank position."
          ],
          sets: 5,
          reps: "6-8 reps",
        ),
        
        // DUMBBELL CARDIO WORKOUTS
        SuggestedWorkout(
          id: "db_shadow_boxing",
          name: "Dumbbell Shadow Boxing",
          category: WorkoutCategory.cardio,
          difficulty: "Easy",
          equipment: "Dumbbells",
          space: "Small Room",
          description: "Low-impact cardio and coordination drill using light weights to condition the shoulders and back.",
          instructions: [
            "Hold light dumbbells (1-3 lbs) in guard position at your chin, feet in boxer's stance.",
            "Throw controlled jabs and crosses forward, keeping punches aligned.",
            "Avoid locking out your elbows completely to protect the joints.",
            "Keep your feet moving and shift your weight from side to side.",
            "Maintain a continuous, rhythmic boxing speed."
          ],
          sets: 3,
          reps: "1 min",
        ),
        SuggestedWorkout(
          id: "db_farmers_walk",
          name: "Dumbbell Farmers Walk",
          category: WorkoutCategory.cardio,
          difficulty: "Medium",
          equipment: "Dumbbells",
          space: "Large Room",
          description: "Grip strength, core stability, and heavy aerobic transport drill. Simple but highly taxic.",
          instructions: [
            "Stand between two heavy dumbbells and deadlift them to your sides.",
            "Keep your chest upright, shoulders pulled back, and core braced.",
            "Take quick, short, measured steps in a straight line.",
            "Keep your grip tight and do not let the weights swing.",
            "Walk 50 meters, turn around, and return to the starting line."
          ],
          sets: 3,
          reps: "1 min walk",
        ),
        SuggestedWorkout(
          id: "db_devil_press",
          name: "Dumbbell Devil Press",
          category: WorkoutCategory.cardio,
          difficulty: "Hard",
          equipment: "Dumbbells",
          space: "Large Room",
          description: "Brutal burpee-to-snatch cardiovascular movement that taxes your legs, back, shoulders, and heart.",
          instructions: [
            "Stand holding dumbbells, then drop down into a burpee with chest touching the weights.",
            "Jump your feet up wide, land flat, and hinge at your hips to prepare the lift.",
            "Swing the dumbbells slightly backward between your legs.",
            "Drive your hips forward dynamically and snatch the dumbbells straight overhead in one movement.",
            "Lock them out overhead, then lower them to the floor under control."
          ],
          sets: 4,
          reps: "10 reps",
        ),
        SuggestedWorkout(
          id: "db_clean_press",
          name: "Dumbbell Clean & Press",
          category: WorkoutCategory.cardio,
          difficulty: "Legend",
          equipment: "Dumbbells",
          space: "Gym Space",
          description: "High velocity power conditioning drill that transfers force from the hips straight overhead.",
          instructions: [
            "Stand holding dumbbells at your sides, feet hip-width apart.",
            "Clean the dumbbells upward by popping your hips and catching them on your shoulders.",
            "Perform a quick dip with your knees, bending slightly.",
            "Drive through your legs to press the weights straight up overhead.",
            "Lower the dumbbells back to your sides under control and repeat."
          ],
          sets: 4,
          reps: "12 reps",
        ),
        SuggestedWorkout(
          id: "db_snatch_intervals",
          name: "Dumbbell Snatch Intervals",
          category: WorkoutCategory.cardio,
          difficulty: "Master",
          equipment: "Dumbbells",
          space: "Gym Space",
          description: "Rapid single-arm snatch intervals designed to spike aerobic capacity and build hip snap power.",
          instructions: [
            "Place a dumbbell on the floor between your feet.",
            "Squat down and grip the dumbbell with one hand, keeping your back flat.",
            "Drive upward dynamically, snatching the dumbbell overhead in one clean vertical path.",
            "Bring the weight back down under control, switch hands at chest level, and lower to floor.",
            "Repeat the movement with the opposite arm at a fast, steady cadence."
          ],
          sets: 5,
          reps: "15 reps",
        ),
      ];
}
