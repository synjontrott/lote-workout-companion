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

  static List<List<int>> get defaultGrid {
    final grid = List.generate(16, (_) => List.generate(16, (_) => 0));
    // Head / Skin (rows 4 to 8, cols 5 to 10)
    for (int r = 4; r <= 8; r++) {
      for (int c = 5; c <= 10; c++) {
        grid[r][c] = 1;
      }
    }
    // Hair (rows 2 to 4, cols 4 to 11)
    for (int r = 2; r <= 3; r++) {
      for (int c = 4; c <= 11; c++) {
        grid[r][c] = 2;
      }
    }
    grid[4][4] = 2;
    grid[4][11] = 2;
    // Eyes
    grid[6][6] = 3;
    grid[6][9] = 3;
    // Body / Outfit (rows 9 to 13, cols 5 to 10)
    for (int r = 9; r <= 13; r++) {
      for (int c = 5; c <= 10; c++) {
        grid[r][c] = 4;
      }
    }
    // Legs (row 14, cols 5 and 10)
    grid[14][5] = 4;
    grid[14][10] = 4;
    // Aura (surrounding border)
    grid[1][3] = 5;
    grid[1][12] = 5;
    grid[5][2] = 5;
    grid[5][13] = 5;
    grid[9][2] = 5;
    grid[9][13] = 5;
    grid[13][3] = 5;
    grid[13][12] = 5;

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
  final String type; // "frame", "title", "aura", "stat", "badge"

  ShopItem({
    required this.name,
    required this.cost,
    required this.description,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'cost': cost,
        'description': description,
        'type': type,
      };

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      name: json['name'] ?? '',
      cost: json['cost'] ?? 0,
      description: json['description'] ?? '',
      type: json['type'] ?? '',
    );
  }

  static List<ShopItem> get availableItems => [
        // Frames
        ShopItem(name: "Ignis Frame", cost: 150, description: "A fiery red profile border", type: "frame"),
        ShopItem(name: "Crystalline Frame", cost: 180, description: "Teal frost profile border", type: "frame"),
        ShopItem(name: "Umbral Border", cost: 220, description: "Deep shadow profile border", type: "frame"),
        ShopItem(name: "Cyber Grid Frame", cost: 250, description: "Neon blue glowing profile border", type: "frame"),
        // Titles
        ShopItem(name: "Void Sovereign", cost: 200, description: "Sovereign warrior status title", type: "title"),
        ShopItem(name: "The Immortal", cost: 300, description: "Immortal warrior status title", type: "title"),
        ShopItem(name: "Elsaither Vanguard", cost: 150, description: "Elite vanguard title", type: "title"),
        ShopItem(name: "Iron Forge Master", cost: 180, description: "Master smith title", type: "title"),
        // Auras
        ShopItem(name: "Glitch Aura", cost: 300, description: "Cybernetic glowing aura animation effect", type: "aura"),
        ShopItem(name: "Phoenix Flare", cost: 400, description: "Fiery wings rising aura effect", type: "aura"),
        ShopItem(name: "Abyssal Mist", cost: 350, description: "Shadowy dark tendrils aura effect", type: "aura"),
        ShopItem(name: "Lightning Spark", cost: 320, description: "Electric storm discharge aura effect", type: "aura"),
        // Backgrounds
        ShopItem(name: "Neon Cyber Space", cost: 250, description: "Cyberpunk neon grid background", type: "background"),
        ShopItem(name: "Nebula Starfield", cost: 300, description: "Space cosmic dust overlay", type: "background"),
        ShopItem(name: "Volcanic Core", cost: 350, description: "Molten fire cavern background", type: "background"),
        ShopItem(name: "Zen Garden", cost: 200, description: "Zen meditation backdrop", type: "background"),
        // Accessories
        ShopItem(name: "Golden Pauldrons", cost: 150, description: "Heavy royal shoulder guards", type: "accessory"),
        ShopItem(name: "Vanguard Greatsword", cost: 250, description: "Massive element-infused blade", type: "accessory"),
        ShopItem(name: "Cybernetic Visor", cost: 200, description: "Glowing red tactical eyepiece", type: "accessory"),
        ShopItem(name: "Elsaither Wings", cost: 400, description: "Hovering mechanical energy wings", type: "accessory"),
        // Stats
        ShopItem(name: "Strength Elixir (+1 STR)", cost: 500, description: "Permanently boost your Strength by 1 point", type: "stat"),
        ShopItem(name: "Gale Boots (+1 DEX)", cost: 500, description: "Permanently boost your Dexterity by 1 point", type: "stat"),
        ShopItem(name: "Marrow Brew (+1 CON)", cost: 500, description: "Permanently boost your Constitution by 1 point", type: "stat"),
        ShopItem(name: "Mind Stone (+1 INT)", cost: 500, description: "Permanently boost your Intelligence by 1 point", type: "stat"),
        ShopItem(name: "Wisdom Herb (+1 WIS)", cost: 500, description: "Permanently boost your Wisdom by 1 point", type: "stat"),
        ShopItem(name: "Crown of Command (+1 CHA)", cost: 500, description: "Permanently boost your Charisma by 1 point", type: "stat"),
        // Badges
        ShopItem(name: "Celestial Dragon Badge", cost: 100, description: "Unlocks the special celestial dragon profile badge", type: "badge"),
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
        // STRENGTH WORKOUTS
        SuggestedWorkout(
          id: "knee_pushups",
          name: "Knee Pushups Foundation",
          category: WorkoutCategory.strength,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Build upper body pushing strength with knee pushups.",
          instructions: ["Get on your hands and knees", "Keep core tight", "Lower chest to ground", "Push back up"],
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
          description: "Standard bodyweight pushups for chest and triceps.",
          instructions: ["Assume high plank position", "Lower body until chest almost touches", "Push back up to plank"],
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
          description: "Focus on triceps and inner chest using a close hand grip.",
          instructions: ["Place hands close forming a diamond", "Lower chest to hands", "Keep body in straight line", "Press up"],
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
          description: "Slide side-to-side to load one arm at a time.",
          instructions: ["Place hands very wide", "Lower to one side, extending other arm", "Push up and repeat on other side"],
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
          description: "Ultimate vertical pushing strength against a wall or freestanding.",
          instructions: ["Kick up into a handstand against wall", "Lower head slowly to floor", "Press back up to straight arms"],
          sets: 5,
          reps: "5-8 reps",
        ),
        
        // CARDIO WORKOUTS
        SuggestedWorkout(
          id: "jumping_jacks",
          name: "Jumping Jacks Ignite",
          category: WorkoutCategory.cardio,
          difficulty: "Easy",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "A simple cardiovascular warmup and aerobic builder.",
          instructions: ["Stand straight, feet together", "Jump while spreading legs and clapping hands overhead", "Return to start"],
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
          description: "Develop speed and heart rate capacity.",
          instructions: ["Run in place raising knees to hip height", "Pump arms dynamically"],
          sets: 3,
          reps: "45 secs",
        ),
        SuggestedWorkout(
          id: "tuck_jumps",
          name: "Tuck Jump Explosion",
          category: WorkoutCategory.cardio,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          space: "Large Room",
          description: "Explosive plyometric cardio jumps.",
          instructions: ["Stand with knees slightly bent", "Jump as high as possible, pulling knees to chest", "Land softly and repeat"],
          sets: 4,
          reps: "10 reps",
        ),
        SuggestedWorkout(
          id: "double_unders",
          name: "Double-Under Jump Rope",
          category: WorkoutCategory.cardio,
          difficulty: "Legend",
          equipment: "Rands/Rope",
          space: "Large Room",
          description: "High velocity jump rope conditioning.",
          instructions: ["Perform rope jumps, spinning rope twice per jump", "Maintain quick wrist flicks"],
          sets: 4,
          reps: "50 jumps",
        ),
        SuggestedWorkout(
          id: "handstand_walking",
          name: "Handstand Walking Cruise",
          category: WorkoutCategory.cardio,
          difficulty: "Master",
          equipment: "Bodyweight Only",
          space: "Gym Space",
          description: "Cardiovascular and coordinate challenge walking on hands.",
          instructions: ["Kick up into handstand", "Walk forward on hands controlling hips", "Walk 10 meters per set"],
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
          description: "Gentle stretch for lower back and shoulders.",
          instructions: ["Kneel and sit on heels", "Fold forward, extending arms on floor", "Breath deeply"],
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
          description: "Stretches hamstrings, calves, and shoulders.",
          instructions: ["Start in plank, push hips high and back", "Press heels toward floor", "Keep back flat"],
          sets: 3,
          reps: "45 secs hold",
        ),
        SuggestedWorkout(
          id: "pigeon_stretch",
          name: "Deep Pigeon Hip Release",
          category: WorkoutCategory.flexibility,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Intense hip opener for tight glutes.",
          instructions: ["Bring one knee forward, shin angled", "Extend back leg straight behind", "Lower torso over front leg"],
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
          description: "Stretch hamstrings and hip flexors for side splits.",
          instructions: ["Extend front leg forward, back leg backward", "Lower hips slowly, supporting with hands", "Breathe"],
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
          description: "Advanced shoulder and upper back mobility against wall.",
          instructions: ["Kick up to handstand facing away from wall", "Push shoulders open and arch chest out", "Breathe carefully"],
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
          description: "Focus on nasal airflow to ground mind.",
          instructions: ["Sit comfortably with straight spine", "Observe breath enter and exit nose", "Gently return mind when distracted"],
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
          description: "Scan body parts systematically to release tension.",
          instructions: ["Lie down in Savasana", "Focus attention from toes up to crown", "Notice sensations, release holding"],
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
          description: "Meditate on your LotE elemental energy centers.",
          instructions: ["Sit in Lotus position", "Visualize your element's color at core", "Feel energy radiating through body"],
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
          description: "Settle into absolute silence and spatial emptiness.",
          instructions: ["Sit in dark room", "Clear all thoughts, resonance with zero space", "Dissolve sense of boundary"],
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
          description: "Transcend consciousness into cosmic flow.",
          instructions: ["Achieve deep state of stillness", "Expand awareness beyond the physical room", "Connect with cosmic energy flow"],
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
          description: "Drink 3 liters of fresh water daily.",
          instructions: ["Drink 500ml water upon waking", "Keep water container nearby", "Log hydration throughout day"],
          sets: 1,
          reps: "3 Liters",
        ),
        SuggestedWorkout(
          id: "clean_protein",
          name: "Clean Protein Prep",
          category: WorkoutCategory.nutrition,
          difficulty: "Medium",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Batch cook clean protein rations for the week.",
          instructions: ["Purchase chicken, fish, or tofu", "Season and grill or bake", "Portion into 3 meal containers"],
          sets: 1,
          reps: "3 meals prepped",
        ),
        SuggestedWorkout(
          id: "micro_nutrient",
          name: "Micro-Nutrient Optimization",
          category: WorkoutCategory.nutrition,
          difficulty: "Hard",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Include 5 colors of fresh vegetables in today's rations.",
          instructions: ["Select spinach (green), pepper (red), carrot (orange), cabbage (purple), onion (white)", "Incorporate into meals"],
          sets: 1,
          reps: "5 colors logged",
        ),
        SuggestedWorkout(
          id: "advanced_bulking",
          name: "Advanced Bulking Prep",
          category: WorkoutCategory.nutrition,
          difficulty: "Legend",
          equipment: "Bodyweight Only",
          space: "Small Room",
          description: "Prep high protein, calorie-dense foods (e.g. rice, beef, eggs, nuts).",
          instructions: ["Measure ingredients for caloric surplus target", "Prep 4 high-calorie clean meals", "Log macros accurately"],
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
          description: "Align nutrient intake to precise metabolic windows.",
          instructions: ["Consume all calories within an 8-hour window", "Fast for remaining 16 hours", "Hydrate with water only during fast"],
          sets: 1,
          reps: "16/8 window logged",
        ),
        SuggestedWorkout(
          id: "db_goblet_squat",
          name: "Dumbbell Goblet Squat",
          category: WorkoutCategory.strength,
          difficulty: "Easy",
          equipment: "Dumbbells",
          space: "Small Room",
          description: "Lower body strength drill using a single front-held dumbbell.",
          instructions: ["Hold dumbbell vertically at chest", "Squat down keeping knees tracked outward", "Stand back up pressing feet into floor"],
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
          description: "Triceps and chest builder performed on the floor to limit range safely.",
          instructions: ["Lie flat on back, knees bent", "Hold dumbbells over chest", "Lower elbows until they touch floor lightly", "Press back up"],
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
          description: "Challenging core stabilization combined with a back pull.",
          instructions: ["Assume plank on dumbbells", "Row one dumbbell to ribcage while keeping hips level", "Repeat on other side"],
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
          description: "Full body integration squat pressing dumbbells overhead dynamically.",
          instructions: ["Rack dumbbells at shoulders", "Perform deep squat", "Explode up, pressing dumbbells overhead in one motion"],
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
          description: "Complex full-body movement: pushup, row, squat clean, thruster.",
          instructions: ["Pushup on dumbbells", "Row each arm", "Jump feet in, clean dumbbells to shoulders", "Perform thruster"],
          sets: 5,
          reps: "6-8 reps",
        ),
        SuggestedWorkout(
          id: "db_shadow_boxing",
          name: "Dumbbell Shadow Boxing",
          category: WorkoutCategory.cardio,
          difficulty: "Easy",
          equipment: "Dumbbells",
          space: "Small Room",
          description: "Low-impact aerobic conditioning with light hand weights.",
          instructions: ["Hold light dumbbells at chin", "Perform controlled straight punches", "Keep feet active in boxer stance"],
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
          description: "Grip strength and heavy aerobic transport conditioning.",
          instructions: ["Hold heavy dumbbells at sides", "Walk in straight line, keeping chest up and shoulders back", "Turn and walk back"],
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
          description: "Burpee directly into a double dumbbell snatch to overhead.",
          instructions: ["Burpee chest-to-floor on dumbbells", "Jump feet up wide", "Swing dumbbells between legs, snatching them overhead"],
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
          description: "High velocity power conditioning using dumbbells.",
          instructions: ["Deadlift dumbbells, cleaning them to shoulders with hip pop", "Push press dumbbells overhead using legs"],
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
          description: "Rapid single-arm snatches to spike aerobic power.",
          instructions: ["Pull dumbbell from floor, punching it straight overhead in one clean path", "Switch arms and repeat at fast pace"],
          sets: 5,
          reps: "15 reps",
        ),
      ];
}
