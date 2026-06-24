import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lote_models.dart';

class UserProfileManager extends ChangeNotifier {
  // Persisted Fields
  String _characterName = 'Recruit';
  int _selectedElementIndex = 0;
  ExpressionStyle _expressionStyle = ExpressionStyle.standard;
  CognitiveProfile? _cognitiveProfile;
  DNDStats _stats = DNDStats();
  CharacterSprite _sprite = CharacterSprite(grid: CharacterSprite.defaultGrid);
  int _currentXP = 0;
  int _currentLevel = 1;
  int _crystals = 100;
  List<LotEQuest> _dailyQuests = LotEQuest.dailyDefaults;
  int _streak = 0;
  DateTime? _lastActiveDate;
  String _shortTermGoal = 'Complete at least one Cardio Patrol this week.';
  String _longTermGoal = 'Reach Krenpowen Apprentice tier rank.';
  bool _hasCompletedInitialQuiz = false;
  int _healthyMealsLoggedToday = 0;

  // Getters
  String get characterName => _characterName;
  int get selectedElementIndex => _selectedElementIndex;
  ExpressionStyle get expressionStyle => _expressionStyle;
  CognitiveProfile? get cognitiveProfile => _cognitiveProfile;
  DNDStats get stats => _stats;
  CharacterSprite get sprite => _sprite;
  int get currentXP => _currentXP;
  int get currentLevel => _currentLevel;
  int get crystals => _crystals;
  List<LotEQuest> get dailyQuests => _dailyQuests;
  int get streak => _streak;
  DateTime? get lastActiveDate => _lastActiveDate;
  String get shortTermGoal => _shortTermGoal;
  String get longTermGoal => _longTermGoal;
  bool get hasCompletedInitialQuiz => _hasCompletedInitialQuiz;
  int get healthyMealsLoggedToday => _healthyMealsLoggedToday;

  // Setters with save trigger
  set characterName(String val) { _characterName = val; _save(); notifyListeners(); }
  set selectedElementIndex(int val) { _selectedElementIndex = val; _save(); notifyListeners(); }
  set expressionStyle(ExpressionStyle val) { _expressionStyle = val; _save(); notifyListeners(); }
  set cognitiveProfile(CognitiveProfile? val) { _cognitiveProfile = val; _save(); notifyListeners(); }
  set stats(DNDStats val) { _stats = val; _save(); notifyListeners(); }
  set sprite(CharacterSprite val) { _sprite = val; _save(); notifyListeners(); }
  set currentXP(int val) { _currentXP = val; _save(); notifyListeners(); }
  set currentLevel(int val) { _currentLevel = val; _save(); notifyListeners(); }
  set crystals(int val) { _crystals = val; _save(); notifyListeners(); }
  set dailyQuests(List<LotEQuest> val) { _dailyQuests = val; _save(); notifyListeners(); }
  set streak(int val) { _streak = val; _save(); notifyListeners(); }
  set lastActiveDate(DateTime? val) { _lastActiveDate = val; _save(); notifyListeners(); }
  set shortTermGoal(String val) { _shortTermGoal = val; _save(); notifyListeners(); }
  set longTermGoal(String val) { _longTermGoal = val; _save(); notifyListeners(); }
  set hasCompletedInitialQuiz(bool val) { _hasCompletedInitialQuiz = val; _save(); notifyListeners(); }
  set healthyMealsLoggedToday(int val) { _healthyMealsLoggedToday = val; _save(); notifyListeners(); }

  // Available Elements Lore Database
  static const List<LotEElement> availableElements = [
    LotEElement(
      name: "Fire",
      corruptName: "Black Fire",
      description: "Passionate and driven. Embodying intense heat, forging, and destructive power.",
      corruptDescription: "Dark, violent, void black or purple flames that leave lasting burns.",
      standardDetails: "Controlled, bright flames useful for defense, offense, and crafting/forging.",
      corruptDetails: "Unpredictable void-fire burning with hostile and aggressive intensity.",
      balancedDetails: "Allows for both precise crafting flames and sudden bursts of dark energy.",
      primaryColorHex: "#FF1616",
      accentColorHex: "#FF5E00",
      planetOfOrigin: "Ninjonia",
      inherentDark: false,
    ),
    LotEElement(
      name: "Water",
      corruptName: "Acid Water",
      description: "Adaptable and intuitive. Flows with life currents, providing barriers and hydration.",
      corruptDescription: "Murky, acidic, corrosive water that erodes violently and causes decay.",
      standardDetails: "Clean water used for defensive barriers, waterjets, and healing capabilities.",
      corruptDetails: "Corrosive, toxic shielding and violent infectious outbreaks.",
      balancedDetails: "Mastery of fluid water flows combined with corrosive outbursts.",
      primaryColorHex: "#00A3FF",
      accentColorHex: "#00E5FF",
      planetOfOrigin: "Techno",
      inherentDark: false,
    ),
    LotEElement(
      name: "Earth",
      corruptName: "Blackstone",
      description: "Grounded and resilient. Drawing strength from solid foundations and rock spikes.",
      corruptDescription: "Jagged, unstable black volcanic rock causing sudden tremors and shattering shards.",
      standardDetails: "Stable ground control, defensive shields, platforms, and solid projectiles.",
      corruptDetails: "Violent shifts in the earth's crust, creating dangerous, jagged spikes.",
      balancedDetails: "A perfect blend of solid structural defenses and aggressive, shattering spikes.",
      primaryColorHex: "#4CAF50",
      accentColorHex: "#795548",
      planetOfOrigin: "Warrion",
      inherentDark: false,
    ),
    LotEElement(
      name: "Air",
      corruptName: "Dark Air",
      description: "Intellectual and curious. Soaring on clean gusts, controlling mobility.",
      corruptDescription: "Turbulent, choking winds that disorient, suffocate, and create vortexes.",
      standardDetails: "Agile current creation for speed, deflective barriers, and precision gusts.",
      corruptDetails: "Suffocating void winds that suppress energy and choke opponents.",
      balancedDetails: "Combines high mobility streams with heavy, suffocating pressure fields.",
      primaryColorHex: "#A5D6FF",
      accentColorHex: "#F6F7FC",
      planetOfOrigin: "Ninjonia",
      inherentDark: false,
    ),
    LotEElement(
      name: "Lightning",
      corruptName: "Red Lightning",
      description: "Electrifying and intense. Moving with blinding speed and powering technologies.",
      corruptDescription: "Volatile crimson arcs that disrupt systems and create destructive pulses.",
      standardDetails: "High-voltage electric discharges for precision stun, speed boosts, and charging.",
      corruptDetails: "Red electromagnetic bursts that overload and destroy targets instantly.",
      balancedDetails: "Unifying mechanical conduction with wild electromagnetic discharge.",
      primaryColorHex: "#00F0FF",
      accentColorHex: "#FFEA00",
      planetOfOrigin: "Techno",
      inherentDark: false,
    ),
    LotEElement(
      name: "Metal",
      corruptName: "Rusted Metal",
      description: "Disciplined and structured. Wielding steel plates, weapons, and armor.",
      corruptDescription: "Corroded, jagged shrapnel that inflicts tetanus and heavy bleeding.",
      standardDetails: "Creation and shaping of durable alloys, shield armor, and precise weapons.",
      corruptDetails: "Shattered metal scraps that tear flesh and corrode energy fields.",
      balancedDetails: "Forging pristine defenses that decay into toxic rusted fragments on impact.",
      primaryColorHex: "#B0BEC5",
      accentColorHex: "#FFD700",
      planetOfOrigin: "Warrion",
      inherentDark: false,
    ),
    LotEElement(
      name: "Ice",
      corruptName: "Black Ice",
      description: "Cool-headed and serene. Freezing environments and crafting clear shields.",
      corruptDescription: "Brittle, exploding dark crystal shards that pierce and scatter.",
      standardDetails: "Smooth, dense ice barriers and freezing strikes to immobilize threats.",
      corruptDetails: "Unstable frost arrays that explode upon pressure, launching sharp shrapnel.",
      balancedDetails: "Immobilizing enemies in clear ice, then detonating it with dark frost energy.",
      primaryColorHex: "#26C6DA",
      accentColorHex: "#FFFFFF",
      planetOfOrigin: "Ninjonia",
      inherentDark: false,
    ),
    LotEElement(
      name: "Bone",
      corruptName: "Wither Bone",
      description: "Primal and stoic. Honoring ancestors, hardening skeletal defenses.",
      corruptDescription: "Twisted, rotten bone spires that drain vital energy and entangle.",
      standardDetails: "Durable calcium armor plates, spears, and organic structural barriers.",
      corruptDetails: "Decaying bone spurs that release toxic rot on contact.",
      balancedDetails: "Unbreakable bone shields that latch onto attackers and drain life force.",
      primaryColorHex: "#EEEEEE",
      accentColorHex: "#D7CCC8",
      planetOfOrigin: "Warrion",
      inherentDark: false,
    ),
    LotEElement(
      name: "Gas",
      corruptName: "Toxic Gas",
      description: "Volatile and mysterious. Blending into smokescreens and mist screens.",
      corruptDescription: "Acidic, choking gas clouds that melt armor and burn airways.",
      standardDetails: "Ethereal smoke overlays, sleep vapors, and gas propulsion currents.",
      corruptDetails: "Corrosive chemical clouds that dissolve material structures.",
      balancedDetails: "Controlling vapor density to suffocating points, shifting between mist and poison.",
      primaryColorHex: "#80CBC4",
      accentColorHex: "#E1BEE7",
      planetOfOrigin: "Techno",
      inherentDark: false,
    ),
    LotEElement(
      name: "Laser",
      corruptName: "Dark Laser",
      description: "Sharp-witted and technical. Surgical beam attacks that slice clean.",
      corruptDescription: "Pulsating, unstable radiation waves that burn and disintegrate.",
      standardDetails: "High-concentration light beams for drilling, welding, and focused attacks.",
      corruptDetails: "Erratic radioactive pulses that spread decay and chaotic light energy.",
      balancedDetails: "Precise surgical targeting overlay with highly destructive explosive pulses.",
      primaryColorHex: "#FF007F",
      accentColorHex: "#7B1FA2",
      planetOfOrigin: "Techno",
      inherentDark: false,
    ),
    LotEElement(
      name: "Zero Space",
      corruptName: "Void Space",
      description: "Transcendent and cosmic. Bending coordinates, folding spatial gaps.",
      corruptDescription: "Unstable spatial rifts that tear matter apart and induce gravity crush.",
      standardDetails: "Precise teleportation portals, dimension pocket storage, and displacement.",
      corruptDetails: "Singularities and gravity wells that compress targets into nothingness.",
      balancedDetails: "Maintaining portal nodes while tearing localized space with void micro-rifts.",
      primaryColorHex: "#3F51B5",
      accentColorHex: "#E040FB",
      planetOfOrigin: "Nidosis",
      inherentDark: false,
    ),
    // Inherently Dark Elements
    LotEElement(
      name: "Darki",
      corruptName: "Darki",
      description: "Pure corruptive energy that thrives on ambition, bending shadows, and royal command.",
      corruptDescription: "Pure corruptive energy that thrives on ambition, bending shadows, and royal command.",
      standardDetails: "Highly dangerous corruptive waves that debuff physical defenses.",
      corruptDetails: "Mind domination, dark matter expansion, and black fire combination.",
      balancedDetails: "Balanced output of raw negative energy and sovereign control.",
      primaryColorHex: "#880E4F",
      accentColorHex: "#FFB300",
      planetOfOrigin: "Battacaria",
      inherentDark: true,
    ),
    LotEElement(
      name: "Death",
      corruptName: "Death",
      description: "Morbid decay. Accelerating decomposition and weakening molecular bonds.",
      corruptDescription: "Morbid decay. Accelerating decomposition and weakening molecular bonds.",
      standardDetails: "Slow, creeping decay that exhausts targets and degrades physical structures.",
      corruptDetails: "Sudden cell collapse, spontaneous decomposition, and soul-reaping vibes.",
      balancedDetails: "Controlling the boundary of life and rot to siphon endurance.",
      primaryColorHex: "#4A148C",
      accentColorHex: "#212121",
      planetOfOrigin: "Battacaria",
      inherentDark: true,
    ),
    LotEElement(
      name: "Knife",
      corruptName: "Knife",
      description: "Precision lethality. Cold plasma blades cutting with perfect surgical angles.",
      corruptDescription: "Precision lethality. Cold plasma blades cutting with perfect surgical angles.",
      standardDetails: "Focusing energy into micro-thin plasma cutters for defense and offense.",
      corruptDetails: "Vicious, vibrating jagged blades that leave tearing plasma burns.",
      balancedDetails: "Wielding double-sided blades of surgical energy and raw plasma fire.",
      primaryColorHex: "#00E5FF",
      accentColorHex: "#37474F",
      planetOfOrigin: "Battacaria",
      inherentDark: true,
    ),
    LotEElement(
      name: "Poison",
      corruptName: "Poison",
      description: "Cunning toxins. Injecting chemical formulas to disable, halt, or paralyze.",
      corruptDescription: "Cunning toxins. Injecting chemical formulas to disable, halt, or paralyze.",
      standardDetails: "Neurotoxins that slow down nervous impulses, inducing paralysis and peace.",
      corruptDetails: "Necrotoxins that rot physical flesh instantly on a cellular scale.",
      balancedDetails: "Synthesizing customized antidotes and complex combat serums.",
      primaryColorHex: "#AA00FF",
      accentColorHex: "#00E676",
      planetOfOrigin: "Battacaria",
      inherentDark: true,
    ),
    LotEElement(
      name: "Shadow",
      corruptName: "Shadow",
      description: "Elusive camouflage. Blending into shadows, creating illusions, and silencing footsteps.",
      corruptDescription: "Elusive camouflage. Blending into shadows, creating illusions, and silencing footsteps.",
      standardDetails: "Light refraction, absolute silence fields, and deceptive mirages.",
      corruptDetails: "Oppressive darkness fields that block sensory perception entirely.",
      balancedDetails: "Stealth infiltration coupled with blind darkness fields for quick assassination.",
      primaryColorHex: "#263238",
      accentColorHex: "#311B92",
      planetOfOrigin: "Battacaria",
      inherentDark: true,
    )
  ];

  LotEElement get currentElement => availableElements[_selectedElementIndex];

  // Warrior Tier Calculation
  WarriorTier get currentTier {
    final sorted = List<WarriorTier>.from(WarriorTier.values)
      ..sort((a, b) => b.levelRequired.compareTo(a.levelRequired));
    for (var tier in sorted) {
      if (_currentLevel >= tier.levelRequired) {
        return tier;
      }
    }
    return WarriorTier.recruit;
  }

  UserProfileManager() {
    _load();
  }

  // Load Data
  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _characterName = prefs.getString('lote_char_name') ?? 'Recruit';
      _selectedElementIndex = prefs.getInt('lote_selected_element_idx') ?? 0;

      final savedStyle = prefs.getString('lote_expression_style') ?? ExpressionStyle.standard.name;
      _expressionStyle = ExpressionStyle.values.firstWhere(
        (e) => e.name == savedStyle,
        orElse: () => ExpressionStyle.standard,
      );

      final savedCognitive = prefs.getString('lote_cognitive_profile');
      if (savedCognitive != null && savedCognitive.isNotEmpty) {
        _cognitiveProfile = CognitiveProfile.values.firstWhere(
          (e) => e.name == savedCognitive,
          orElse: () => CognitiveProfile.neurotypical,
        );
      } else {
        _cognitiveProfile = null;
      }

      final statsJson = prefs.getString('lote_dnd_stats');
      if (statsJson != null) {
        try {
          _stats = DNDStats.fromJson(jsonDecode(statsJson));
        } catch (_) {
          _stats = DNDStats();
        }
      } else {
        _stats = DNDStats();
      }

      final spriteJson = prefs.getString('lote_character_sprite');
      if (spriteJson != null) {
        try {
          _sprite = CharacterSprite.fromJson(jsonDecode(spriteJson));
        } catch (_) {
          _sprite = CharacterSprite(grid: CharacterSprite.defaultGrid);
        }
      } else {
        _sprite = CharacterSprite(grid: CharacterSprite.defaultGrid);
      }

      _currentXP = prefs.getInt('lote_current_xp') ?? 0;
      _currentLevel = prefs.getInt('lote_current_level') ?? 1;
      _crystals = prefs.getInt('lote_crystals') ?? 100;

      final questsJson = prefs.getString('lote_daily_quests');
      if (questsJson != null) {
        try {
          final List<dynamic> raw = jsonDecode(questsJson);
          _dailyQuests = raw.map((q) => LotEQuest.fromJson(q)).toList();
        } catch (_) {
          _dailyQuests = LotEQuest.dailyDefaults;
        }
      } else {
        _dailyQuests = LotEQuest.dailyDefaults;
      }

      _streak = prefs.getInt('lote_streak') ?? 0;

      final dateMs = prefs.getInt('lote_last_active_ms');
      if (dateMs != null) {
        _lastActiveDate = DateTime.fromMillisecondsSinceEpoch(dateMs);
      } else {
        _lastActiveDate = null;
      }

      _shortTermGoal = prefs.getString('lote_short_goal') ?? 'Complete at least one Cardio Patrol this week.';
      _longTermGoal = prefs.getString('lote_long_goal') ?? 'Reach Krenpowen Apprentice tier rank.';
      _hasCompletedInitialQuiz = prefs.getBool('lote_has_quiz') ?? false;
      _healthyMealsLoggedToday = prefs.getInt('lote_meals_today') ?? 0;

      checkNewDayRefresh();
    } catch (_) {
      // SharedPreferences might fail under test/mock environment, fallbacks will apply
    }
    notifyListeners();
  }

  // Save State
  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lote_char_name', _characterName);
      await prefs.setInt('lote_selected_element_idx', _selectedElementIndex);
      await prefs.setString('lote_expression_style', _expressionStyle.name);
      await prefs.setString('lote_cognitive_profile', _cognitiveProfile?.name ?? '');
      await prefs.setInt('lote_current_xp', _currentXP);
      await prefs.setInt('lote_current_level', _currentLevel);
      await prefs.setInt('lote_crystals', _crystals);
      await prefs.setInt('lote_streak', _streak);
      if (_lastActiveDate != null) {
        await prefs.setInt('lote_last_active_ms', _lastActiveDate!.millisecondsSinceEpoch);
      }
      await prefs.setString('lote_short_goal', _shortTermGoal);
      await prefs.setString('lote_long_goal', _longTermGoal);
      await prefs.setBool('lote_has_quiz', _hasCompletedInitialQuiz);
      await prefs.setInt('lote_meals_today', _healthyMealsLoggedToday);

      await prefs.setString('lote_dnd_stats', jsonEncode(_stats.toJson()));
      await prefs.setString('lote_character_sprite', jsonEncode(_sprite.toJson()));
      await prefs.setString('lote_daily_quests', jsonEncode(_dailyQuests.map((q) => q.toJson()).toList()));
    } catch (_) {}
  }

  // XP & Rewards Engine
  void addXP(int amount) {
    _currentXP += amount;
    int xpNeeded = requiredXPForLevel(_currentLevel);
    if (_currentXP >= xpNeeded) {
      _currentXP -= xpNeeded;
      _currentLevel += 1;
      _crystals += 50; // Level up reward

      // Random Stat Increase on Level Up
      final statsList = List<StatType>.from(StatType.values);
      statsList.shuffle();
      _stats.increase(statsList.first, 1);
    }
    _save();
    notifyListeners();
  }

  int requiredXPForLevel(int lvl) {
    return 100 + (lvl * 50);
  }

  void earnCrystals(int amount) {
    _crystals += amount;
    _save();
    notifyListeners();
  }

  // Quest Actions
  bool completeQuest(LotEQuest quest, int rollValue) {
    final idx = _dailyQuests.indexWhere((q) => q.id == quest.id);
    if (idx == -1 || _dailyQuests[idx].isCompleted) {
      return false;
    }

    final statBonus = _stats.getModifier(quest.statReward);
    final totalRoll = rollValue + statBonus;

    if (totalRoll >= quest.difficultyRoll) {
      _dailyQuests[idx].isCompleted = true;
      addXP(quest.rewardXP);
      earnCrystals(quest.rewardCrystals);
      _stats.increase(quest.statReward, quest.statValue);
      updateStreakOnActivity();
      _save();
      notifyListeners();
      return true;
    } else {
      addXP((quest.rewardXP / 3).floor());
      _save();
      notifyListeners();
      return false;
    }
  }

  void logHealthyMeal() {
    _healthyMealsLoggedToday += 1;
    earnCrystals(10);
    addXP(15);
    _stats.increase(StatType.constitution, 1);
    updateStreakOnActivity();
    _save();
    notifyListeners();
  }

  // Day Refresh & Streak Engine
  void checkNewDayRefresh() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastActiveDate != null) {
      final lastDay = DateTime(_lastActiveDate!.year, _lastActiveDate!.month, _lastActiveDate!.day);
      final diff = today.difference(lastDay).inDays;

      if (diff > 0) {
        _healthyMealsLoggedToday = 0;
        _dailyQuests = LotEQuest.dailyDefaults;
        if (diff > 1) {
          _streak = 0;
        }
        _lastActiveDate = now;
        _save();
      }
    } else {
      _lastActiveDate = now;
      _save();
    }
  }

  void updateStreakOnActivity() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastActiveDate != null) {
      final lastDay = DateTime(_lastActiveDate!.year, _lastActiveDate!.month, _lastActiveDate!.day);
      final diff = today.difference(lastDay).inDays;

      if (diff == 1) {
        _streak += 1;
      } else if (diff > 1) {
        _streak = 1;
      } else if (_streak == 0) {
        _streak = 1;
      }
    } else {
      _streak = 1;
    }

    _lastActiveDate = now;
    _save();
  }

  void updatePixelGrid(int row, int col, int value) {
    _sprite.pixelGrid[row][col] = value;
    _save();
    notifyListeners();
  }
}
