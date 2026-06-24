import 'package:flutter/material.dart';

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
  adhd('ADHD (The Flame Sentinel)'),
  autistic('Autistic (The Iron Archivist)'),
  audhd('AuDHD (The Chimera)'),
  neurotypical('Neurotypical (The Radiant Vanguard)');

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
  List<List<int>> pixelGrid;

  CharacterSprite({
    this.hairStyle = 'Spiky',
    this.hairColorHex = '#FFEA00',
    this.skinColorHex = '#FFD180',
    this.outfitStyle = 'Warrior Plate',
    this.outfitColorHex = '#37474F',
    this.auraStyle = 'Flames',
    List<List<int>>? grid,
  }) : pixelGrid = grid ?? defaultGrid;

  Map<String, dynamic> toJson() => {
        'hairStyle': hairStyle,
        'hairColorHex': hairColorHex,
        'skinColorHex': skinColorHex,
        'outfitStyle': outfitStyle,
        'outfitColorHex': outfitColorHex,
        'auraStyle': auraStyle,
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
      outfitStyle: json['outfitStyle'] ?? 'Warrior Plate',
      outfitColorHex: json['outfitColorHex'] ?? '#37474F',
      auraStyle: json['auraStyle'] ?? 'Flames',
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
    // Body / Outfit (rows 9 to 14, cols 4 to 11)
    for (int r = 9; r <= 13; r++) {
      for (int c = 4; c <= 11; c++) {
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
  meditation('Spiritual Focus');

  final String displayName;
  const WorkoutCategory(this.displayName);
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
        title: 'Air Stream Alignment',
        questDescription: 'Align your internal Sho through yoga, stretching, or mobility work. 15 mins.',
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
