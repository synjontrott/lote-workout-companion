import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lote_models.dart';
import 'health_manager.dart';

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
  List<LotEQuest> _monthlyQuests = [];
  List<LotEQuest> _yearlyQuests = [];
  int _streak = 0;
  DateTime? _lastActiveDate;
  DateTime? _lastRefreshDate;
  String _shortTermGoal = 'Complete at least one Cardio Patrol this week.';
  String _longTermGoal = 'Reach Krenpowen Apprentice tier rank.';
  bool _hasCompletedInitialQuiz = false;
  int _healthyMealsLoggedToday = 0;
  String _homePlanet = 'Warrion';
  List<MealEntry> _loggedMeals = [];
  
  List<TrainingFocus> _selectedFocuses = [TrainingFocus.calisthenics, TrainingFocus.cardio, TrainingFocus.cutting];
  double _height = 70.0;
  double _weight = 160.0;
  double _startWeight = 160.0;
  double _goalWeight = 150.0;
  double _distanceGoal = 2.0;
  List<WeightEntry> _weightHistory = [];
  List<String> _unlockedShopItems = [];
  List<String> _unlockedBadges = [];
  bool _hasClaimedWeightGoalReward = false;
  bool _hasClaimedDistanceGoalReward = false;
  double _chest = 38.0;
  double _arms = 13.0;
  double _waist = 32.0;
  double _hips = 40.0;
  double _legs = 22.0;

  String _notificationFrequency = 'Medium';
  double _monthlyChallengeProgress = 0.0;
  int _previousStreak = 0;

  double _stepsGoal = 10000.0;
  double _caloriesGoal = 400.0;
  double _activeMinutesGoal = 30.0;
  double _standHoursGoal = 10.0;
  
  double _targetCalories = 2500.0;
  double _targetProtein = 150.0;
  double _targetCarbs = 250.0;
  double _targetFats = 80.0;
  double _targetSugar = 50.0;
  
  int _totalQuestsCompleted = 0;
  List<BodyMeasurementEntry> _measurementHistory = [];
  String _equippedFrame = 'None';
  String _equippedTitle = 'None';
  String _equippedAura = 'None';
  String _equippedBackground = 'None';
  String _equippedAccessory = 'None';

  double _todayWaterIntake = 0.0;
  double _waterIntakeGoal = 3.0;
  bool _useImperialUnits = false;
  Map<String, double> _personalRecords = {
    "Pullups": 5.0,
    "Pushups": 20.0,
    "Squats": 30.0,
    "Dips": 8.0,
    "Run (Miles)": 1.0,
    "Handstand Hold (Sec)": 15.0,
    "Bench Press": 135.0,
    "Deadlift": 185.0,
    "Barbell Squat": 155.0,
    "Overhead Press": 95.0,
  };
  Map<String, List<PREntry>> _prHistory = {};
  List<WorkoutSession> _loggedWorkoutSessions = [];
  bool _isLoaded = false;

  // Getters
  bool get isLoaded => _isLoaded;
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
  List<LotEQuest> get monthlyQuests => _monthlyQuests;
  List<LotEQuest> get yearlyQuests => _yearlyQuests;
  int get streak => _streak;
  DateTime? get lastActiveDate => _lastActiveDate;
  String get shortTermGoal => _shortTermGoal;
  String get longTermGoal => _longTermGoal;
  bool get hasCompletedInitialQuiz => _hasCompletedInitialQuiz;
  int get healthyMealsLoggedToday => _healthyMealsLoggedToday;
  String get homePlanet => _homePlanet;
  List<MealEntry> get loggedMeals => _loggedMeals;
  
  List<TrainingFocus> get selectedFocuses => _selectedFocuses;
  double get height => _height;
  double get weight => _weight;
  double get startWeight => _startWeight;
  double get goalWeight => _goalWeight;
  double get distanceGoal => _distanceGoal;
  List<WeightEntry> get weightHistory => _weightHistory;
  List<String> get unlockedShopItems => _unlockedShopItems;
  List<String> get unlockedBadges => _unlockedBadges;
  bool get hasClaimedWeightGoalReward => _hasClaimedWeightGoalReward;
  bool get hasClaimedDistanceGoalReward => _hasClaimedDistanceGoalReward;
  double get chest => _chest;
  double get arms => _arms;
  double get waist => _waist;
  double get hips => _hips;
  double get legs => _legs;

  double get stepsGoal => _stepsGoal;
  double get caloriesGoal => _caloriesGoal;
  double get activeMinutesGoal => _activeMinutesGoal;
  double get standHoursGoal => _standHoursGoal;
  double get targetCalories => _targetCalories;
  double get targetProtein => _targetProtein;
  double get targetCarbs => _targetCarbs;
  double get targetFats => _targetFats;
  double get targetSugar => _targetSugar;
  int get totalQuestsCompleted => _totalQuestsCompleted;
  List<BodyMeasurementEntry> get measurementHistory => _measurementHistory;
  String get equippedFrame => _equippedFrame;
  String get equippedTitle => _equippedTitle;
  String get equippedAura => _equippedAura;
  String get equippedBackground => _equippedBackground;
  String get equippedAccessory => _equippedAccessory;

  String get notificationFrequency => _notificationFrequency;
  double get monthlyChallengeProgress => _monthlyChallengeProgress;
  int get previousStreak => _previousStreak;

  // Setters with save trigger
  set characterName(String val) { _characterName = val; _save(); notifyListeners(); }
  set selectedElementIndex(int val) { _selectedElementIndex = _normalizedElementIndex(val); _save(); regenerateDailyQuests(); notifyListeners(); }
  set expressionStyle(ExpressionStyle val) { _expressionStyle = val; _save(); notifyListeners(); }
  set cognitiveProfile(CognitiveProfile? val) { _cognitiveProfile = val; _save(); notifyListeners(); }
  set stats(DNDStats val) { _stats = val; _save(); notifyListeners(); }
  set sprite(CharacterSprite val) { _sprite = val; _save(); notifyListeners(); }
  set currentXP(int val) { _currentXP = val; _save(); notifyListeners(); }
  set currentLevel(int val) { _currentLevel = val; _save(); notifyListeners(); }
  set crystals(int val) { _crystals = val; _save(); notifyListeners(); }
  set dailyQuests(List<LotEQuest> val) { _dailyQuests = val; _save(); notifyListeners(); }
  set monthlyQuests(List<LotEQuest> val) { _monthlyQuests = val; _save(); notifyListeners(); }
  set yearlyQuests(List<LotEQuest> val) { _yearlyQuests = val; _save(); notifyListeners(); }
  set streak(int val) { _streak = val; _save(); notifyListeners(); }
  set lastActiveDate(DateTime? val) { _lastActiveDate = val; _save(); notifyListeners(); }
  set shortTermGoal(String val) { _shortTermGoal = val; _save(); notifyListeners(); }
  set longTermGoal(String val) { _longTermGoal = val; _save(); notifyListeners(); }
  set hasCompletedInitialQuiz(bool val) { _hasCompletedInitialQuiz = val; _save(); notifyListeners(); }
  set healthyMealsLoggedToday(int val) { _healthyMealsLoggedToday = val; _save(); notifyListeners(); }
  set homePlanet(String val) { _homePlanet = val; _save(); notifyListeners(); }
  set selectedFocuses(List<TrainingFocus> val) { _selectedFocuses = val; _save(); regenerateDailyQuests(); notifyListeners(); }
  set height(double val) { _height = val; _save(); notifyListeners(); }
  set weight(double val) { 
    if (_weight != val) {
      _weight = val; 
      _weightHistory.add(WeightEntry(date: DateTime.now(), weight: val));
      _save(); 
      checkWeightGoalProgress(); 
      notifyListeners(); 
    }
  }
  set startWeight(double val) { _startWeight = val; _save(); notifyListeners(); }
  
  set stepsGoal(double val) { _stepsGoal = val; _save(); notifyListeners(); }
  set caloriesGoal(double val) { _caloriesGoal = val; _save(); notifyListeners(); }
  set activeMinutesGoal(double val) { _activeMinutesGoal = val; _save(); notifyListeners(); }
  set standHoursGoal(double val) { _standHoursGoal = val; _save(); notifyListeners(); }
  
  set targetCalories(double val) { _targetCalories = val; _save(); notifyListeners(); }
  set targetProtein(double val) { _targetProtein = val; _save(); notifyListeners(); }
  set targetCarbs(double val) { _targetCarbs = val; _save(); notifyListeners(); }
  set targetFats(double val) { _targetFats = val; _save(); notifyListeners(); }
  set targetSugar(double val) { _targetSugar = val; _save(); notifyListeners(); }
  
  set totalQuestsCompleted(int val) { _totalQuestsCompleted = val; _save(); notifyListeners(); }
  set equippedFrame(String val) { _equippedFrame = val; _save(); notifyListeners(); }
  set equippedTitle(String val) { _equippedTitle = val; _save(); notifyListeners(); }
  set equippedAura(String val) { _equippedAura = val; _save(); notifyListeners(); }
  set equippedBackground(String val) { _equippedBackground = val; _save(); notifyListeners(); }
  set equippedAccessory(String val) { _equippedAccessory = val; _save(); notifyListeners(); }
  
  set goalWeight(double val) {
    _goalWeight = val;
    _startWeight = _weight;
    _save();
    notifyListeners();
  }
  set distanceGoal(double val) { _distanceGoal = val; _save(); notifyListeners(); }
  set weightHistory(List<WeightEntry> val) { _weightHistory = val; _save(); notifyListeners(); }
  set unlockedShopItems(List<String> val) { _unlockedShopItems = val; _save(); notifyListeners(); }
  set unlockedBadges(List<String> val) { _unlockedBadges = val; _save(); notifyListeners(); }
  set hasClaimedWeightGoalReward(bool val) { _hasClaimedWeightGoalReward = val; _save(); notifyListeners(); }
  set hasClaimedDistanceGoalReward(bool val) { _hasClaimedDistanceGoalReward = val; _save(); notifyListeners(); }
  set chest(double val) { _chest = val; _save(); notifyListeners(); }
  set arms(double val) { _arms = val; _save(); notifyListeners(); }
  set waist(double val) { _waist = val; _save(); notifyListeners(); }
  set hips(double val) { _hips = val; _save(); notifyListeners(); }
  set legs(double val) { _legs = val; _save(); notifyListeners(); }

  double get todayWaterIntake => _todayWaterIntake;
  set todayWaterIntake(double val) { _todayWaterIntake = val; _save(); notifyListeners(); }

  double get waterIntakeGoal => _waterIntakeGoal;
  set waterIntakeGoal(double val) {
    final double rounded = ((val * 2.0).round() / 2.0).clamp(0.5, double.infinity);
    _waterIntakeGoal = rounded;
    _save();
    notifyListeners();
  }

  bool get useImperialUnits => _useImperialUnits;
  set useImperialUnits(bool val) {
    if (_useImperialUnits != val) {
      if (val) {
        final double rawOzGoal = _waterIntakeGoal * 33.814;
        final double roundedOzGoal = ((rawOzGoal / 8.0).round() * 8.0).clamp(8.0, double.infinity);
        _waterIntakeGoal = roundedOzGoal / 33.814;

        final double rawOzIntake = _todayWaterIntake * 33.814;
        final double roundedOzIntake = (rawOzIntake / 8.0).round() * 8.0;
        _todayWaterIntake = roundedOzIntake / 33.814;
      } else {
        _waterIntakeGoal = ((_waterIntakeGoal * 2.0).round() / 2.0).clamp(0.5, double.infinity);
        _todayWaterIntake = (_todayWaterIntake * 2.0).round() / 2.0;
      }
      _useImperialUnits = val;
      _save();
      notifyListeners();
    }
  }

  double get waterIntakeGoalOz => (_waterIntakeGoal * 33.814).roundToDouble();
  set waterIntakeGoalOz(double val) {
    final double rounded = ((val / 8.0).round() * 8.0).clamp(8.0, double.infinity);
    _waterIntakeGoal = rounded / 33.814;
    _save();
    notifyListeners();
  }

  double get todayWaterIntakeOz => (_todayWaterIntake * 33.814).roundToDouble();
  set todayWaterIntakeOz(double val) {
    final double rounded = ((val / 8.0).round() * 8.0).clamp(0.0, double.infinity);
    _todayWaterIntake = rounded / 33.814;
    _save();
    notifyListeners();
  }


  Map<String, double> get personalRecords => _personalRecords;
  set personalRecords(Map<String, double> val) {
    _personalRecords = val;
    regenerateDailyQuests();
    _save();
    notifyListeners();
  }

  Map<String, List<PREntry>> get prHistory => _prHistory;
  set prHistory(Map<String, List<PREntry>> val) {
    _prHistory = val;
    _save();
    notifyListeners();
  }

  List<WorkoutSession> get loggedWorkoutSessions => _loggedWorkoutSessions;
  set loggedWorkoutSessions(List<WorkoutSession> val) { _loggedWorkoutSessions = val; _save(); notifyListeners(); }

  set notificationFrequency(String val) {
    _notificationFrequency = val;
    _save();
    _scheduleNotificationsMock();
    notifyListeners();
  }

  set monthlyChallengeProgress(double val) {
    _monthlyChallengeProgress = val;
    _save();
    _checkMonthlyChallengeBadge();
    notifyListeners();
  }

  set previousStreak(int val) {
    _previousStreak = val;
    _save();
    notifyListeners();
  }

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
      secondaryColorHex: "#FFC400",
      detailColorHex: "#FFF8E1",
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
      secondaryColorHex: "#00BFA5",
      detailColorHex: "#E0F7FA",
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
      secondaryColorHex: "#9E9E9E",
      detailColorHex: "#8D6E63",
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
      secondaryColorHex: "#CFD8DC",
      detailColorHex: "#FFFFFF",
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
      secondaryColorHex: "#7C4DFF",
      detailColorHex: "#FFFFFF",
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
      secondaryColorHex: "#546E7A",
      detailColorHex: "#ECEFF1",
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
      secondaryColorHex: "#B2EBF2",
      detailColorHex: "#E0F7FA",
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
      secondaryColorHex: "#9E9E9E",
      detailColorHex: "#3E2723",
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
      secondaryColorHex: "#B2DFDB",
      detailColorHex: "#FFF9C4",
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
      primaryColorHex: "#FF0055",
      accentColorHex: "#FF80DF",
      secondaryColorHex: "#FFFFFF",
      detailColorHex: "#FF00FF",
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
      secondaryColorHex: "#1A237E",
      detailColorHex: "#FFEB3B",
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
      secondaryColorHex: "#3E2723",
      detailColorHex: "#E040FB",
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
      secondaryColorHex: "#263238",
      detailColorHex: "#FFFFFF",
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
      secondaryColorHex: "#78909C",
      detailColorHex: "#FFFFFF",
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
      primaryColorHex: "#00E676",
      accentColorHex: "#AA00FF",
      secondaryColorHex: "#8E24AA",
      detailColorHex: "#CCFF90",
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
      secondaryColorHex: "#212121",
      detailColorHex: "#000000",
      planetOfOrigin: "Battacaria",
      inherentDark: false,
    )
  ];

  LotEElement get currentElement {
    final base = availableElements[_normalizedElementIndex(_selectedElementIndex)];
    if (_expressionStyle == ExpressionStyle.corrupt) {
      return base.corruptedVersion();
    }
    return base;
  }

  static int _normalizedElementIndex(int index) {
    return index.clamp(0, availableElements.length - 1).toInt();
  }

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
      _selectedElementIndex = _normalizedElementIndex(prefs.getInt('lote_selected_element_idx') ?? 0);

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

      final focusesJson = prefs.getString('lote_selected_focuses');
      if (focusesJson != null) {
        try {
          final List<dynamic> raw = jsonDecode(focusesJson);
          _selectedFocuses = raw.map((f) {
            if (f == 'weightGain' || f == 'bulking') return TrainingFocus.bulking;
            return TrainingFocus.values.firstWhere(
              (e) => e.name == f,
              orElse: () => TrainingFocus.cardio,
            );
          }).toList();
        } catch (_) {
          _selectedFocuses = [TrainingFocus.calisthenics, TrainingFocus.cardio, TrainingFocus.cutting];
        }
      } else {
        _selectedFocuses = [TrainingFocus.calisthenics, TrainingFocus.cardio, TrainingFocus.cutting];
      }

      _height = prefs.getDouble('lote_body_height') ?? 70.0;
      _weight = prefs.getDouble('lote_body_weight') ?? 160.0;
      _startWeight = prefs.getDouble('lote_start_weight') ?? 160.0;
      _goalWeight = prefs.getDouble('lote_goal_weight') ?? 150.0;
      _distanceGoal = prefs.getDouble('lote_distance_goal') ?? 2.0;
      _hasClaimedWeightGoalReward = prefs.getBool('lote_claimed_weight_reward') ?? false;
      _hasClaimedDistanceGoalReward = prefs.getBool('lote_claimed_distance_reward') ?? false;

      final weightHistoryJson = prefs.getString('lote_weight_history');
      if (weightHistoryJson != null) {
        try {
          final List<dynamic> raw = jsonDecode(weightHistoryJson);
          _weightHistory = raw.map((w) => WeightEntry.fromJson(w)).toList();
        } catch (_) {
          _weightHistory = [WeightEntry(date: DateTime.now(), weight: _weight)];
        }
      } else {
        _weightHistory = [WeightEntry(date: DateTime.now(), weight: _weight)];
      }

      _unlockedShopItems = prefs.getStringList('lote_unlocked_shop_items') ?? [];
      _unlockedBadges = prefs.getStringList('lote_unlocked_badges') ?? [];

      _chest = prefs.getDouble('lote_body_chest') ?? 38.0;
      _arms = prefs.getDouble('lote_body_arms') ?? 13.0;
      _waist = prefs.getDouble('lote_body_waist') ?? 32.0;
      _hips = prefs.getDouble('lote_body_hips') ?? 40.0;
      _legs = prefs.getDouble('lote_body_legs') ?? 22.0;

      _stepsGoal = prefs.getDouble('lote_steps_goal') ?? 10000.0;
      _caloriesGoal = prefs.getDouble('lote_calories_goal') ?? 400.0;
      _activeMinutesGoal = prefs.getDouble('lote_active_minutes_goal') ?? 30.0;
      _standHoursGoal = prefs.getDouble('lote_stand_hours_goal') ?? 10.0;
      
      _targetCalories = prefs.getDouble('lote_target_calories') ?? 2500.0;
      _targetProtein = prefs.getDouble('lote_target_protein') ?? 150.0;
      _targetCarbs = prefs.getDouble('lote_target_carbs') ?? 250.0;
      _targetFats = prefs.getDouble('lote_target_fats') ?? 80.0;
      _targetSugar = prefs.getDouble('lote_target_sugar') ?? 50.0;
      
      _totalQuestsCompleted = prefs.getInt('lote_total_quests_completed') ?? 0;
      _equippedFrame = prefs.getString('lote_equipped_frame') ?? 'None';
      _equippedTitle = prefs.getString('lote_equipped_title') ?? 'None';
      _equippedAura = prefs.getString('lote_equipped_aura') ?? 'None';
      _equippedBackground = prefs.getString('lote_equipped_background') ?? 'None';
      _equippedAccessory = prefs.getString('lote_equipped_accessory') ?? 'None';

      _todayWaterIntake = prefs.getDouble('lote_today_water_intake') ?? 0.0;
      _waterIntakeGoal = prefs.getDouble('lote_water_intake_goal') ?? 3.0;
      _useImperialUnits = prefs.getBool('lote_use_imperial_units') ?? false;

      final prsJson = prefs.getString('lote_personal_records');
      if (prsJson != null) {
        try {
          final Map<String, dynamic> raw = jsonDecode(prsJson);
          _personalRecords = raw.map((k, v) => MapEntry(k, (v as num).toDouble()));
          if (!_personalRecords.containsKey("Bench Press")) _personalRecords["Bench Press"] = 135.0;
          if (!_personalRecords.containsKey("Deadlift")) _personalRecords["Deadlift"] = 185.0;
          if (!_personalRecords.containsKey("Barbell Squat")) _personalRecords["Barbell Squat"] = 155.0;
          if (!_personalRecords.containsKey("Overhead Press")) _personalRecords["Overhead Press"] = 95.0;
        } catch (_) {}
      }

      final prHistoryJson = prefs.getString('lote_pr_history');
      if (prHistoryJson != null) {
        try {
          final Map<String, dynamic> raw = jsonDecode(prHistoryJson);
          _prHistory = raw.map((k, v) => MapEntry(
              k,
              (v as List<dynamic>)
                  .map((e) => PREntry.fromJson(e as Map<String, dynamic>))
                  .toList()));
        } catch (_) {}
      } else {
        final daysAgo = DateTime.now().subtract(const Duration(days: 3));
        _prHistory = {
          "Pullups": [PREntry(date: daysAgo, value: 5.0)],
          "Pushups": [PREntry(date: daysAgo, value: 20.0)],
          "Squats": [PREntry(date: daysAgo, value: 30.0)],
          "Dips": [PREntry(date: daysAgo, value: 8.0)],
          "Run (Miles)": [PREntry(date: daysAgo, value: 1.0)],
          "Handstand Hold (Sec)": [PREntry(date: daysAgo, value: 15.0)],
          "Bench Press": [PREntry(date: daysAgo, value: 135.0)],
          "Deadlift": [PREntry(date: daysAgo, value: 185.0)],
          "Barbell Squat": [PREntry(date: daysAgo, value: 155.0)],
          "Overhead Press": [PREntry(date: daysAgo, value: 95.0)],
        };
      }

      final sessionsJson = prefs.getString('lote_logged_workout_sessions');
      if (sessionsJson != null) {
        try {
          final List<dynamic> raw = jsonDecode(sessionsJson);
          _loggedWorkoutSessions = raw.map((s) => WorkoutSession.fromJson(s)).toList();
        } catch (_) {}
      }

      final measurementHistoryJson = prefs.getString('lote_measurement_history');
      if (measurementHistoryJson != null) {
        try {
          final List<dynamic> raw = jsonDecode(measurementHistoryJson);
          _measurementHistory = raw.map((m) => BodyMeasurementEntry.fromJson(m)).toList();
        } catch (_) {
          _measurementHistory = [];
        }
      } else {
        _measurementHistory = [];
      }

      final questsJson = prefs.getString('lote_daily_quests');
      if (questsJson != null) {
        try {
          final List<dynamic> raw = jsonDecode(questsJson);
          _dailyQuests = raw.map((q) => LotEQuest.fromJson(q)).toList();
        } catch (_) {
          final elementName = availableElements[_selectedElementIndex].name;
          _dailyQuests = generateQuests(elementName, _selectedFocuses, QuestCadence.daily);
        }
      } else {
        final elementName = availableElements[_selectedElementIndex].name;
        _dailyQuests = generateQuests(elementName, _selectedFocuses, QuestCadence.daily);
      }

      final monthlyQuestsJson = prefs.getString('lote_monthly_quests');
      if (monthlyQuestsJson != null) {
        try {
          final List<dynamic> raw = jsonDecode(monthlyQuestsJson);
          _monthlyQuests = raw.map((q) => LotEQuest.fromJson(q)).toList();
        } catch (_) {
          final elementName = availableElements[_selectedElementIndex].name;
          _monthlyQuests = generateQuests(elementName, _selectedFocuses, QuestCadence.monthly);
        }
      } else {
        final elementName = availableElements[_selectedElementIndex].name;
        _monthlyQuests = generateQuests(elementName, _selectedFocuses, QuestCadence.monthly);
      }

      final yearlyQuestsJson = prefs.getString('lote_yearly_quests');
      if (yearlyQuestsJson != null) {
        try {
          final List<dynamic> raw = jsonDecode(yearlyQuestsJson);
          _yearlyQuests = raw.map((q) => LotEQuest.fromJson(q)).toList();
        } catch (_) {
          final elementName = availableElements[_selectedElementIndex].name;
          _yearlyQuests = generateQuests(elementName, _selectedFocuses, QuestCadence.yearly);
        }
      } else {
        final elementName = availableElements[_selectedElementIndex].name;
        _yearlyQuests = generateQuests(elementName, _selectedFocuses, QuestCadence.yearly);
      }

      _streak = prefs.getInt('lote_streak') ?? 0;
      _notificationFrequency = prefs.getString('lote_notification_frequency') ?? 'Medium';
      _monthlyChallengeProgress = prefs.getDouble('lote_monthly_challenge_progress') ?? 0.0;
      _previousStreak = prefs.getInt('lote_previous_streak') ?? 0;

      final dateMs = prefs.getInt('lote_last_active_ms');
      if (dateMs != null) {
        _lastActiveDate = DateTime.fromMillisecondsSinceEpoch(dateMs);
      } else {
        _lastActiveDate = null;
      }
      final refreshMs = prefs.getInt('lote_last_refresh_ms');
      if (refreshMs != null) {
        _lastRefreshDate = DateTime.fromMillisecondsSinceEpoch(refreshMs);
      } else {
        _lastRefreshDate = null;
      }

      _shortTermGoal = prefs.getString('lote_short_goal') ?? 'Complete at least one Cardio Patrol this week.';
      _longTermGoal = prefs.getString('lote_long_goal') ?? 'Reach Krenpowen Apprentice tier rank.';
      _hasCompletedInitialQuiz = prefs.getBool('lote_has_quiz') ?? false;
      _healthyMealsLoggedToday = prefs.getInt('lote_meals_today') ?? 0;
      final mealsJson = prefs.getString('lote_logged_meals');
      if (mealsJson != null) {
        try {
          final List<dynamic> raw = jsonDecode(mealsJson);
          _loggedMeals = raw.map((m) => MealEntry.fromJson(m)).toList();
        } catch (_) {
          _loggedMeals = [];
        }
      } else {
        _loggedMeals = [];
      }
      final defaultPlanet = availableElements[_selectedElementIndex].planetOfOrigin;
      _homePlanet = prefs.getString('lote_home_planet') ?? defaultPlanet;

      checkNewDayRefresh();
    } catch (_) {
      // SharedPreferences might fail under test/mock environment, fallbacks will apply
    }
    _isLoaded = true;
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
      if (_lastRefreshDate != null) {
        await prefs.setInt('lote_last_refresh_ms', _lastRefreshDate!.millisecondsSinceEpoch);
      }
      await prefs.setString('lote_short_goal', _shortTermGoal);
      await prefs.setString('lote_long_goal', _longTermGoal);
      await prefs.setBool('lote_has_quiz', _hasCompletedInitialQuiz);
      await prefs.setInt('lote_meals_today', _healthyMealsLoggedToday);
      await prefs.setString('lote_home_planet', _homePlanet);
      await prefs.setString('lote_notification_frequency', _notificationFrequency);
      await prefs.setDouble('lote_monthly_challenge_progress', _monthlyChallengeProgress);
      await prefs.setInt('lote_previous_streak', _previousStreak);
      await prefs.setString('lote_logged_meals', jsonEncode(_loggedMeals.map((m) => m.toJson()).toList()));
      
      await prefs.setDouble('lote_body_height', _height);
      await prefs.setDouble('lote_body_weight', _weight);
      await prefs.setDouble('lote_body_chest', _chest);
      await prefs.setDouble('lote_body_arms', _arms);
      await prefs.setDouble('lote_body_waist', _waist);
      await prefs.setDouble('lote_body_hips', _hips);
      await prefs.setDouble('lote_body_legs', _legs);

      await prefs.setDouble('lote_steps_goal', _stepsGoal);
      await prefs.setDouble('lote_calories_goal', _caloriesGoal);
      await prefs.setDouble('lote_active_minutes_goal', _activeMinutesGoal);
      await prefs.setDouble('lote_stand_hours_goal', _standHoursGoal);
      await prefs.setDouble('lote_target_calories', _targetCalories);
      await prefs.setDouble('lote_target_protein', _targetProtein);
      await prefs.setDouble('lote_target_carbs', _targetCarbs);
      await prefs.setDouble('lote_target_fats', _targetFats);
      await prefs.setDouble('lote_target_sugar', _targetSugar);
      await prefs.setInt('lote_total_quests_completed', _totalQuestsCompleted);
      await prefs.setString('lote_equipped_frame', _equippedFrame);
      await prefs.setString('lote_equipped_title', _equippedTitle);
      await prefs.setString('lote_equipped_aura', _equippedAura);
      await prefs.setString('lote_equipped_background', _equippedBackground);
      await prefs.setString('lote_equipped_accessory', _equippedAccessory);
      await prefs.setString('lote_measurement_history', jsonEncode(_measurementHistory.map((m) => m.toJson()).toList()));
      await prefs.setString('lote_selected_focuses', jsonEncode(_selectedFocuses.map((f) => f.name).toList()));

      await prefs.setDouble('lote_today_water_intake', _todayWaterIntake);
      await prefs.setDouble('lote_water_intake_goal', _waterIntakeGoal);
      await prefs.setBool('lote_use_imperial_units', _useImperialUnits);
      await prefs.setString('lote_personal_records', jsonEncode(_personalRecords));
      await prefs.setString('lote_pr_history', jsonEncode(_prHistory.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()))));
      await prefs.setString('lote_logged_workout_sessions', jsonEncode(_loggedWorkoutSessions.map((s) => s.toJson()).toList()));

      await prefs.setDouble('lote_start_weight', _startWeight);
      await prefs.setDouble('lote_goal_weight', _goalWeight);
      await prefs.setDouble('lote_distance_goal', _distanceGoal);
      await prefs.setBool('lote_claimed_weight_reward', _hasClaimedWeightGoalReward);
      await prefs.setBool('lote_claimed_distance_reward', _hasClaimedDistanceGoalReward);
      await prefs.setStringList('lote_unlocked_shop_items', _unlockedShopItems);
      await prefs.setStringList('lote_unlocked_badges', _unlockedBadges);
      await prefs.setString('lote_weight_history', jsonEncode(_weightHistory.map((w) => w.toJson()).toList()));
      await prefs.setString('lote_monthly_quests', jsonEncode(_monthlyQuests.map((q) => q.toJson()).toList()));
      await prefs.setString('lote_yearly_quests', jsonEncode(_yearlyQuests.map((q) => q.toJson()).toList()));

      await prefs.setString('lote_dnd_stats', jsonEncode(_stats.toJson()));
      await prefs.setString('lote_character_sprite', jsonEncode(_sprite.toJson()));
      await prefs.setString('lote_daily_quests', jsonEncode(_dailyQuests.map((q) => q.toJson()).toList()));
    } catch (_) {}
  }

  // XP & Rewards Engine
  void addXP(int amount) {
    if (_currentLevel >= 100) {
      _currentLevel = 100;
      _currentXP = 0;
      return;
    }
    _currentXP += amount;
    int xpNeeded = requiredXPForLevel(_currentLevel);
    while (_currentXP >= xpNeeded && _currentLevel < 100) {
      _currentXP -= xpNeeded;
      _currentLevel += 1;
      _crystals += 50; // Level up reward

      // Random Stat Increase on Level Up
      final statsList = List<StatType>.from(StatType.values);
      statsList.shuffle();
      _stats.increase(statsList.first, 1);
      xpNeeded = requiredXPForLevel(_currentLevel);
    }
    if (_currentLevel >= 100) {
      _currentLevel = 100;
      _currentXP = 0;
    }
    _save();
    notifyListeners();
  }

  void removeXP(int amount) {
    _currentXP = (_currentXP - amount).clamp(0, 999999);
    _save();
    notifyListeners();
  }

  int requiredXPForLevel(int lvl) {
    return 1000 + (lvl * 100) + (lvl * lvl * 5);
  }

  void earnCrystals(int amount) {
    _crystals += amount;
    _save();
    notifyListeners();
  }

  void spendCrystals(int amount) {
    _crystals = (_crystals - amount).clamp(0, 999999);
    _save();
    notifyListeners();
  }

  // Shop Purchase Action
  bool buyShopItem(ShopItem item) {
    if (_crystals < item.cost) return false;
    if (_unlockedShopItems.contains(item.name)) return false;

    _crystals -= item.cost;
    _unlockedShopItems.add(item.name);

    // Apply stats boost if it's a stat elixir
    if (item.type == 'stat') {
      if (item.name.contains('STR')) {
        _stats.increase(StatType.strength, 1);
      } else if (item.name.contains('DEX')) {
        _stats.increase(StatType.dexterity, 1);
      } else if (item.name.contains('CON')) {
        _stats.increase(StatType.constitution, 1);
      } else if (item.name.contains('INT')) {
        _stats.increase(StatType.intelligence, 1);
      } else if (item.name.contains('WIS')) {
        _stats.increase(StatType.wisdom, 1);
      } else if (item.name.contains('CHA')) {
        _stats.increase(StatType.charisma, 1);
      }
    }

    unlockBadge("Guild Patron");
    _save();
    notifyListeners();
    return true;
  }

  // Badge Unlock Engine
  void unlockBadge(String name) {
    if (!_unlockedBadges.contains(name)) {
      _unlockedBadges.add(name);
      // Grant badge completion rewards
      addXP(200);
      earnCrystals(50);
      _save();
      notifyListeners();
    }
  }

  void checkBadges(HealthManager healthManager) {
    if (healthManager.latestWeight != null && healthManager.latestWeight! > 0) {
      final weightLbs = healthManager.latestWeight! * 2.20462;
      if ((_weight - weightLbs).abs() > 0.5) {
        weight = double.parse(weightLbs.toStringAsFixed(1));
      }
    }

    if (healthManager.todaySteps >= 10000.0) {
      unlockBadge("First Step");
    }
    if (healthManager.todaySteps >= 20000.0) {
      unlockBadge("20k Steps Sentinel");
    }
    if (healthManager.activeMinutes >= 60.0) {
      unlockBadge("Iron Will (1 Hr)");
    }
    if (healthManager.activeMinutes >= 120.0) {
      unlockBadge("Unstoppable Force (2 Hr)");
    }
    if (_totalQuestsCompleted >= 100) {
      unlockBadge("Quest Crusader (100 Quests)");
    }
    if (_totalQuestsCompleted >= 1000) {
      unlockBadge("Legendary Champion (1000 Quests)");
    }
    if (_streak >= 7) {
      unlockBadge("Streak Master");
    }
    if (_streak >= 14) {
      unlockBadge("Vanguard Streak (14 Days)");
    }
    if (_streak >= 30) {
      unlockBadge("Sovereign Streak (30 Days)");
    }
    if (_streak >= 100) {
      unlockBadge("Immortal Streak (100 Days)");
    }
    if (_stats.strength >= 18 ||
        _stats.dexterity >= 18 ||
        _stats.constitution >= 18 ||
        _stats.wisdom >= 18 ||
        _stats.intelligence >= 18 ||
        _stats.charisma >= 18) {
      unlockBadge("Demi-God");
    }
    if (_hasCompletedInitialQuiz) {
      unlockBadge("Lore Scholar");
    }
    
    // Check daily distance target goal progress
    checkDistanceGoalProgress(healthManager.todaySteps);
  }

  /// Checks profile-only badges (no HealthManager needed).
  /// Called after quest completion and other profile-state mutations.
  void _checkProfileBadges() {
    if (_totalQuestsCompleted >= 100) {
      unlockBadge("Quest Crusader (100 Quests)");
    }
    if (_totalQuestsCompleted >= 1000) {
      unlockBadge("Legendary Champion (1000 Quests)");
    }
    if (_streak >= 7) {
      unlockBadge("Streak Master");
    }
    if (_streak >= 14) {
      unlockBadge("Vanguard Streak (14 Days)");
    }
    if (_streak >= 30) {
      unlockBadge("Sovereign Streak (30 Days)");
    }
    if (_streak >= 100) {
      unlockBadge("Immortal Streak (100 Days)");
    }
    if (_stats.strength >= 18 ||
        _stats.dexterity >= 18 ||
        _stats.constitution >= 18 ||
        _stats.wisdom >= 18 ||
        _stats.intelligence >= 18 ||
        _stats.charisma >= 18) {
      unlockBadge("Demi-God");
    }
    if (_hasCompletedInitialQuiz) {
      unlockBadge("Lore Scholar");
    }
  }

  void checkDistanceGoalProgress(double todaySteps) {
    final currentDistance = todaySteps / 2000.0;
    if (!_hasClaimedDistanceGoalReward && currentDistance >= _distanceGoal) {
      addXP(100);
      earnCrystals(30);
      _hasClaimedDistanceGoalReward = true;
      _save();
    }
  }

  // Target Progress Helper
  void checkWeightGoalProgress() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Record in history, replacing today's entry if already present
    _weightHistory.removeWhere((entry) =>
        entry.date.year == today.year &&
        entry.date.month == today.month &&
        entry.date.day == today.day);
    _weightHistory.add(WeightEntry(date: now, weight: _weight));

    // Auto reward check
    if (!_hasClaimedWeightGoalReward) {
      final isCutting = _startWeight > _goalWeight;
      if (isCutting) {
        if (_weight <= _goalWeight) {
          addXP(2000);
          earnCrystals(1000);
          _hasClaimedWeightGoalReward = true;
          unlockBadge("Weight Target Achieved");
        }
      } else { // Bulking
        if (_weight >= _goalWeight) {
          addXP(2000);
          earnCrystals(1000);
          _hasClaimedWeightGoalReward = true;
          unlockBadge("Weight Target Achieved");
        }
      }
    }
    _save();
  }

  WorkoutCategory? get activeMonthlyChallengeCategory {
    final month = DateTime.now().month;
    switch (month) {
      case 1:
      case 6:
      case 10:
        return WorkoutCategory.strength;
      case 2:
      case 5:
      case 9:
        return WorkoutCategory.cardio;
      case 3:
      case 11:
        return WorkoutCategory.flexibility;
      case 4:
      case 8:
        return WorkoutCategory.nutrition;
      case 7:
        return WorkoutCategory.meditation;
      default:
        return null;
    }
  }

  // Quest Actions
  bool completeQuest(LotEQuest quest) {
    bool isDaily = false;
    bool isMonthly = false;
    bool isYearly = false;
    int foundIndex = -1;

    foundIndex = _dailyQuests.indexWhere((q) => q.id == quest.id);
    if (foundIndex != -1) {
      isDaily = true;
    } else {
      foundIndex = _monthlyQuests.indexWhere((q) => q.id == quest.id);
      if (foundIndex != -1) {
        isMonthly = true;
      } else {
        foundIndex = _yearlyQuests.indexWhere((q) => q.id == quest.id);
        if (foundIndex != -1) {
          isYearly = true;
        }
      }
    }

    if (foundIndex == -1) return false;

    final questToComplete = isDaily
        ? _dailyQuests[foundIndex]
        : (isMonthly ? _monthlyQuests[foundIndex] : _yearlyQuests[foundIndex]);

    if (questToComplete.isCompleted) return false;
    if (questToComplete.progressCount < questToComplete.targetCount) return false;

    if (isDaily) {
      _dailyQuests[foundIndex].isCompleted = true;
      _incrementMonthlyAndYearlyProgress(questToComplete.workoutType);

      final activeCat = activeMonthlyChallengeCategory;
      final challenge = activeMonthlyChallenge;
      if (challenge.targetMetric == "quests") {
        advanceMonthlyChallenge(1.0);
      } else if (activeCat != null && questToComplete.workoutType == activeCat) {
        double amount;
        if (challenge.targetMetric == "reps") {
          amount = 50.0;
        } else if (challenge.targetMetric == "Liters") {
          amount = 3.0;
        } else if (challenge.targetMetric == "miles") {
          amount = 2.0;
        } else if (challenge.targetMetric == "workouts" || challenge.targetMetric == "sessions") {
          amount = 1.0;
        } else if (challenge.targetMetric == "steps") {
          amount = 5000.0;
        } else {
          amount = questToComplete.requiredMinutes > 0 ? questToComplete.requiredMinutes.toDouble() : 15.0;
        }
        advanceMonthlyChallenge(amount);
      }
    } else if (isMonthly) {
      _monthlyQuests[foundIndex].isCompleted = true;
    } else if (isYearly) {
      _yearlyQuests[foundIndex].isCompleted = true;
    }
    _totalQuestsCompleted += 1;

    addXP(questToComplete.rewardXP);
    earnCrystals(questToComplete.rewardCrystals);
    _stats.increase(questToComplete.statReward, questToComplete.statValue);
    updateStreakOnActivity();

    // Unlocks badge on completing all daily quests
    final completedDailies = _dailyQuests.where((q) => q.isCompleted).length;
    if (completedDailies >= 4) {
      unlockBadge("Flame Starter");
    }

    _checkProfileBadges();

    _save();
    notifyListeners();
    return true;
  }

  void _incrementMonthlyAndYearlyProgress(WorkoutCategory category) {
    for (int i = 0; i < _monthlyQuests.length; i++) {
      if (_monthlyQuests[i].workoutType == category && !_monthlyQuests[i].isCompleted) {
        _monthlyQuests[i].progressCount = (_monthlyQuests[i].progressCount + 1).clamp(0, _monthlyQuests[i].targetCount);
      }
    }
    for (int i = 0; i < _yearlyQuests.length; i++) {
      if (_yearlyQuests[i].workoutType == category && !_yearlyQuests[i].isCompleted) {
        _yearlyQuests[i].progressCount = (_yearlyQuests[i].progressCount + 1).clamp(0, _yearlyQuests[i].targetCount);
      }
    }
  }

  void evaluateQuestsCompletion() {
    final now = DateTime.now();
    final todaySessions = _loggedWorkoutSessions.where((s) =>
        s.date.year == now.year && s.date.month == now.month && s.date.day == now.day).toList();
    
    final strengthSessions = todaySessions.where((s) => s.type.contains("Strength"));
    final cardioSessions = todaySessions.where((s) => s.type.contains("Cardio") || s.type.contains("Running"));
    final yogaSessions = todaySessions.where((s) => s.type.contains("Yoga"));

    final strengthDuration = strengthSessions.fold(0.0, (sum, s) => sum + s.durationMinutes);
    final cardioDuration = cardioSessions.fold(0.0, (sum, s) => sum + s.durationMinutes);
    final yogaDuration = yogaSessions.fold(0.0, (sum, s) => sum + s.durationMinutes);

    for (int i = 0; i < _dailyQuests.length; i++) {
      final q = _dailyQuests[i];
      if (q.isCompleted) continue;

      switch (q.workoutType) {
        case WorkoutCategory.strength:
          if (strengthDuration >= q.requiredMinutes || strengthSessions.isNotEmpty) {
            _dailyQuests[i].progressCount = q.targetCount;
          }
          break;
        case WorkoutCategory.cardio:
          if (cardioDuration >= q.requiredMinutes || cardioSessions.isNotEmpty) {
            _dailyQuests[i].progressCount = q.targetCount;
          }
          break;
        case WorkoutCategory.flexibility:
          if (yogaDuration >= q.requiredMinutes || yogaSessions.isNotEmpty) {
            _dailyQuests[i].progressCount = q.targetCount;
          }
          break;
        case WorkoutCategory.nutrition:
          if (q.title.toLowerCase().contains("water") || q.title.toLowerCase().contains("hydration") ||
              q.questDescription.toLowerCase().contains("water") || q.questDescription.toLowerCase().contains("hydration")) {
            if (_todayWaterIntake >= _waterIntakeGoal) {
              _dailyQuests[i].progressCount = q.targetCount;
            }
          } else {
            if (_healthyMealsLoggedToday >= 1) {
              _dailyQuests[i].progressCount = q.targetCount;
            }
          }
          break;
        default:
          break;
      }
    }
  }

  void logWorkout(WorkoutCategory category, {double durationMinutes = 15.0}) {
    final String type;
    switch (category) {
      case WorkoutCategory.strength: type = "Strength"; break;
      case WorkoutCategory.cardio: type = "Cardio"; break;
      case WorkoutCategory.flexibility: type = "Yoga"; break;
      case WorkoutCategory.nutrition: type = "Nutrition"; break;
      default: type = "Cardio"; break;
    }

    final session = WorkoutSession(
      id: UniqueKey().toString(),
      type: type,
      durationMinutes: durationMinutes,
      date: DateTime.now(),
    );
    _loggedWorkoutSessions.add(session);

    evaluateQuestsCompletion();

    for (int i = 0; i < _monthlyQuests.length; i++) {
      if (_monthlyQuests[i].workoutType == category && !_monthlyQuests[i].isCompleted) {
        _monthlyQuests[i].progressCount = (_monthlyQuests[i].progressCount + 1).clamp(0, _monthlyQuests[i].targetCount);
      }
    }
    for (int i = 0; i < _yearlyQuests.length; i++) {
      if (_yearlyQuests[i].workoutType == category && !_yearlyQuests[i].isCompleted) {
        _yearlyQuests[i].progressCount = (_yearlyQuests[i].progressCount + 1).clamp(0, _yearlyQuests[i].targetCount);
      }
    }
    _save();
    notifyListeners();
  }

  void logCustomWorkout({
    required String name,
    required WorkoutCategory category,
    required int sets,
    required String reps,
    required String difficulty,
    double durationMinutes = 15.0,
  }) {
    final String baseType;
    switch (category) {
      case WorkoutCategory.strength: baseType = "Strength"; break;
      case WorkoutCategory.cardio: baseType = "Cardio"; break;
      case WorkoutCategory.flexibility: baseType = "Yoga"; break;
      case WorkoutCategory.nutrition: baseType = "Nutrition"; break;
      default: baseType = "Strength"; break;
    }

    final session = WorkoutSession(
      id: UniqueKey().toString(),
      type: "$baseType (Custom: $name - $sets sets x $reps)",
      durationMinutes: durationMinutes,
      date: DateTime.now(),
    );
    _loggedWorkoutSessions.add(session);

    int xp = 25;
    int crys = 10;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        xp = 15;
        crys = 5;
        break;
      case 'medium':
        xp = 25;
        crys = 10;
        break;
      case 'hard':
        xp = 40;
        crys = 15;
        break;
      case 'legend':
        xp = 60;
        crys = 25;
        break;
      case 'master':
        xp = 80;
        crys = 35;
        break;
    }

    addXP(xp);
    earnCrystals(crys);

    evaluateQuestsCompletion();

    for (int i = 0; i < _monthlyQuests.length; i++) {
      if (_monthlyQuests[i].workoutType == category && !_monthlyQuests[i].isCompleted) {
        _monthlyQuests[i].progressCount = (_monthlyQuests[i].progressCount + 1).clamp(0, _monthlyQuests[i].targetCount);
      }
    }
    for (int i = 0; i < _yearlyQuests.length; i++) {
      if (_yearlyQuests[i].workoutType == category && !_yearlyQuests[i].isCompleted) {
        _yearlyQuests[i].progressCount = (_yearlyQuests[i].progressCount + 1).clamp(0, _yearlyQuests[i].targetCount);
      }
    }
    _save();
    notifyListeners();
  }


  void logDetailedMeal({
    required String name,
    required double calories,
    required double protein,
    required double carbs,
    required double fats,
    required double sugar,
  }) {
    final entry = MealEntry(
      id: UniqueKey().toString(),
      date: DateTime.now(),
      name: name,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fats: fats,
      sugar: sugar,
    );
    _loggedMeals.add(entry);
    _healthyMealsLoggedToday += 1;
    logWorkout(WorkoutCategory.nutrition);
    _save();
    notifyListeners();
  }

  void deleteDetailedMeal(String id) {
    final mealIndex = _loggedMeals.indexWhere((m) => m.id == id);
    if (mealIndex == -1) return;
    
    final meal = _loggedMeals[mealIndex];
    final now = DateTime.now();
    if (meal.date.year == now.year && meal.date.month == now.month && meal.date.day == now.day) {
      if (_healthyMealsLoggedToday > 0) _healthyMealsLoggedToday -= 1;
      
      final sessionIndex = _loggedWorkoutSessions.lastIndexWhere((s) => 
        s.type == "Nutrition" && 
        s.date.year == now.year && s.date.month == now.month && s.date.day == now.day);
      if (sessionIndex != -1) {
        _loggedWorkoutSessions.removeAt(sessionIndex);
      }

      // Roll back monthly/yearly nutrition quest progress to prevent farming
      for (int i = 0; i < _monthlyQuests.length; i++) {
        if (_monthlyQuests[i].workoutType == WorkoutCategory.nutrition && !_monthlyQuests[i].isCompleted && _monthlyQuests[i].progressCount > 0) {
          _monthlyQuests[i].progressCount -= 1;
        }
      }
      for (int i = 0; i < _yearlyQuests.length; i++) {
        if (_yearlyQuests[i].workoutType == WorkoutCategory.nutrition && !_yearlyQuests[i].isCompleted && _yearlyQuests[i].progressCount > 0) {
          _yearlyQuests[i].progressCount -= 1;
        }
      }

      // Reverse daily nutrition quest completion if condition no longer met
      // This prevents the log→complete→delete→repeat farming exploit
      final remainingNutritionSessions = _loggedWorkoutSessions.where((s) =>
          s.type == "Nutrition" &&
          s.date.year == now.year && s.date.month == now.month && s.date.day == now.day).length;

      for (int i = 0; i < _dailyQuests.length; i++) {
        final q = _dailyQuests[i];
        if (q.workoutType != WorkoutCategory.nutrition) continue;
        if (!q.isCompleted) continue;

        // Skip hydration quests — they aren't meal-based
        final isHydration = q.title.toLowerCase().contains("water") ||
            q.title.toLowerCase().contains("hydration") ||
            q.questDescription.toLowerCase().contains("water") ||
            q.questDescription.toLowerCase().contains("hydration");
        if (isHydration) continue;

        // If there are no remaining nutrition sessions or meals today, reverse
        if (_healthyMealsLoggedToday < 1 && remainingNutritionSessions == 0) {
          _dailyQuests[i].isCompleted = false;
          _dailyQuests[i].progressCount = 0;
          if (_totalQuestsCompleted > 0) _totalQuestsCompleted -= 1;
          // Reverse the rewards that were granted
          removeXP(q.rewardXP);
          spendCrystals(q.rewardCrystals);
          _stats.decrease(q.statReward, q.statValue);
        }
      }
    }
    
    _loggedMeals.removeAt(mealIndex);
    _save();
    notifyListeners();
  }

  double get todaySugar {
    final now = DateTime.now();
    return _loggedMeals
        .where((m) => m.date.year == now.year && m.date.month == now.month && m.date.day == now.day)
        .fold(0.0, (sum, m) => sum + m.sugar);
  }

  void logBodyMeasurements({
    required double weight,
    required double chest,
    required double arms,
    required double waist,
    required double hips,
    required double legs,
  }) {
    final entry = BodyMeasurementEntry(
      id: UniqueKey().toString(),
      date: DateTime.now(),
      weight: weight,
      chest: chest,
      arms: arms,
      waist: waist,
      hips: hips,
      legs: legs,
    );
    _measurementHistory.add(entry);
    
    _weight = weight;
    _chest = chest;
    _arms = arms;
    _waist = waist;
    _hips = hips;
    _legs = legs;

    _save();
    notifyListeners();
  }

  void logRestDay() {
    updateStreakOnActivity();
    _save();
    notifyListeners();
  }

  void toggleEquipItem(ShopItem item) {
    if (!_unlockedShopItems.contains(item.name)) return;
    
    switch (item.type) {
      case 'frame':
        _equippedFrame = (_equippedFrame == item.name) ? 'None' : item.name;
        break;
      case 'title':
        _equippedTitle = (_equippedTitle == item.name) ? 'None' : item.name;
        break;
      case 'aura':
        _equippedAura = (_equippedAura == item.name) ? 'None' : item.name;
        break;
      case 'background':
        _equippedBackground = (_equippedBackground == item.name) ? 'None' : item.name;
        break;
      case 'accessory':
        _equippedAccessory = (_equippedAccessory == item.name) ? 'None' : item.name;
        break;
    }
    _save();
    notifyListeners();
  }

  void syncQuestsWithHealthData({
    required double todaySteps,
    required double activeMinutes,
    List<Map<String, dynamic>> recentWorkouts = const [],
  }) {
    final now = DateTime.now();
    for (final hw in recentWorkouts) {
      final DateTime? startDate = DateTime.tryParse(hw['startDate'] ?? '');
      if (startDate != null && startDate.year == now.year && startDate.month == now.month && startDate.day == now.day) {
        final activityType = hw['activityType'] ?? '';
        final String type;
        
        // Determine mapped type. A walking workout is mapped to 'Walking', which is excluded from Strength/Yoga sync.
        if (activityType == 'functionalStrengthTraining' || activityType == 'traditionalStrengthTraining' || activityType == 'coreTraining') {
          type = "Strength";
        } else if (activityType == 'walking') {
          type = "Walking";
        } else if (activityType == 'running') {
          type = "Running";
        } else if (activityType == 'cycling' || activityType == 'rowing' || activityType == 'stairClimbing') {
          type = "Cardio";
        } else if (activityType == 'yoga' || activityType == 'flexibility') {
          type = "Yoga";
        } else {
          type = "Cardio";
        }

        final double durationMins = (hw['duration'] as num?)?.toDouble() ?? 0.0;

        // Check if session is already present
        final exists = _loggedWorkoutSessions.any((s) =>
            s.date.year == startDate.year &&
            s.date.month == startDate.month &&
            s.date.day == startDate.day &&
            s.type == type &&
            (s.durationMinutes - durationMins).abs() < 0.1);

        if (!exists) {
          _loggedWorkoutSessions.add(WorkoutSession(
            id: UniqueKey().toString(),
            type: type,
            durationMinutes: durationMins,
            date: startDate,
          ));
        }
      }
    }

    evaluateQuestsCompletion();

    if (todaySteps >= 5000.0) {
      for (int i = 0; i < _dailyQuests.length; i++) {
        if (_dailyQuests[i].workoutType == WorkoutCategory.cardio) {
          _dailyQuests[i].progressCount = _dailyQuests[i].targetCount;
        }
      }
    }
    _save();
    notifyListeners();
  }

  void resetProgress() {
    _currentLevel = 1;
    _currentXP = 0;
    _crystals = 100;
    _streak = 0;
    _previousStreak = 0;
    _stats = DNDStats();
    _unlockedBadges = [];
    _unlockedShopItems = [];
    _loggedMeals = [];
    _healthyMealsLoggedToday = 0;
    _hasClaimedWeightGoalReward = false;
    _hasClaimedDistanceGoalReward = false;
    _loggedWorkoutSessions = [];
    _totalQuestsCompleted = 0;
    _monthlyChallengeProgress = 0.0;
    _todayWaterIntake = 0.0;
    _measurementHistory = [];
    _weightHistory = [];

    // Reset equipped cosmetics to defaults
    _equippedFrame = 'None';
    _equippedTitle = 'None';
    _equippedAura = 'None';
    _equippedBackground = 'None';
    _equippedAccessory = 'None';

    _personalRecords = {
      "Pullups": 5.0,
      "Pushups": 20.0,
      "Squats": 30.0,
      "Dips": 8.0,
      "Run (Miles)": 1.0,
      "Handstand Hold (Sec)": 15.0,
      "Bench Press": 135.0,
      "Deadlift": 185.0,
      "Barbell Squat": 155.0,
      "Overhead Press": 95.0,
    };
    
    final daysAgo = DateTime.now().subtract(const Duration(days: 3));
    _prHistory = {
      "Pullups": [PREntry(date: daysAgo, value: 5.0)],
      "Pushups": [PREntry(date: daysAgo, value: 20.0)],
      "Squats": [PREntry(date: daysAgo, value: 30.0)],
      "Dips": [PREntry(date: daysAgo, value: 8.0)],
      "Run (Miles)": [PREntry(date: daysAgo, value: 1.0)],
      "Handstand Hold (Sec)": [PREntry(date: daysAgo, value: 15.0)],
      "Bench Press": [PREntry(date: daysAgo, value: 135.0)],
      "Deadlift": [PREntry(date: daysAgo, value: 185.0)],
      "Barbell Squat": [PREntry(date: daysAgo, value: 155.0)],
      "Overhead Press": [PREntry(date: daysAgo, value: 95.0)],
    };
    
    regenerateDailyQuests();
    _save();
    notifyListeners();
  }

  // Day Refresh & Streak Engine
  void checkNewDayRefresh() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastRefreshDate != null) {
      final lastRefreshDay = DateTime(_lastRefreshDate!.year, _lastRefreshDate!.month, _lastRefreshDate!.day);
      
      if (today.difference(lastRefreshDay).inDays > 0) {
        _healthyMealsLoggedToday = 0;
        _todayWaterIntake = 0.0;
        _hasClaimedDistanceGoalReward = false;
        final elementName = availableElements[_normalizedElementIndex(_selectedElementIndex)].name;
        _dailyQuests = generateQuests(elementName, _selectedFocuses, QuestCadence.daily, prs: _personalRecords, waterGoal: _waterIntakeGoal);
        
        if (_lastRefreshDate!.month != now.month) {
          _monthlyChallengeProgress = 0.0;
          _monthlyQuests = generateQuests(elementName, _selectedFocuses, QuestCadence.monthly, prs: _personalRecords, waterGoal: _waterIntakeGoal);
        }
        if (_lastRefreshDate!.year != now.year) {
          _yearlyQuests = generateQuests(elementName, _selectedFocuses, QuestCadence.yearly, prs: _personalRecords, waterGoal: _waterIntakeGoal);
        }

        if (_lastActiveDate != null) {
          final lastActiveDay = DateTime(_lastActiveDate!.year, _lastActiveDate!.month, _lastActiveDate!.day);
          if (today.difference(lastActiveDay).inDays > 1) {
            _previousStreak = _streak;
            _streak = 0;
          }
        }
        
        _lastRefreshDate = now;
        _save();
      }
    } else {
      _lastRefreshDate = now;
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
        _previousStreak = _streak;
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

  void regenerateDailyQuests() {
    final elementName = availableElements[_normalizedElementIndex(_selectedElementIndex)].name;
    _dailyQuests = generateQuests(elementName, _selectedFocuses, QuestCadence.daily, prs: _personalRecords, waterGoal: _waterIntakeGoal);
    _monthlyQuests = generateQuests(elementName, _selectedFocuses, QuestCadence.monthly, prs: _personalRecords, waterGoal: _waterIntakeGoal);
    _yearlyQuests = generateQuests(elementName, _selectedFocuses, QuestCadence.yearly, prs: _personalRecords, waterGoal: _waterIntakeGoal);
    _save();
    notifyListeners();
  }

  // MARK: - Streak Recovery
  bool recoverStreak() {
    if (_previousStreak > 0 && _crystals >= 100) {
      _crystals -= 100;
      _streak = _previousStreak + 1;
      _previousStreak = 0;
      _save();
      notifyListeners();
      return true;
    }
    return false;
  }

  // MARK: - Notification Manager
  void _scheduleNotificationsMock() {
    // Custom notifications would be scheduled using local notification APIs here
  }

  // MARK: - Monthly Challenges
  MonthlyChallenge get activeMonthlyChallenge {
    final month = DateTime.now().month;
    switch (month) {
      case 1:
        return MonthlyChallenge(
            monthName: "January",
            targetDescription: "Do 1,000 Pushups",
            targetMetric: "reps",
            targetAmount: 1000.0,
            currentAmount: _monthlyChallengeProgress);
      case 2:
        return MonthlyChallenge(
            monthName: "February",
            targetDescription: "Perform 300 minutes of Cardio",
            targetMetric: "mins",
            targetAmount: 300.0,
            currentAmount: _monthlyChallengeProgress);
      case 3:
        return MonthlyChallenge(
            monthName: "March",
            targetDescription: "Perform 120 minutes of Yoga/Flexibility",
            targetMetric: "mins",
            targetAmount: 120.0,
            currentAmount: _monthlyChallengeProgress);
      case 4:
        return MonthlyChallenge(
            monthName: "April",
            targetDescription: "Drink 90 Liters of water",
            targetMetric: "Liters",
            targetAmount: 90.0,
            currentAmount: _monthlyChallengeProgress);
      case 5:
        return MonthlyChallenge(
            monthName: "May",
            targetDescription: "Walk 50 miles",
            targetMetric: "miles",
            targetAmount: 50.0,
            currentAmount: _monthlyChallengeProgress);
      case 6:
        return MonthlyChallenge(
            monthName: "June",
            targetDescription: "Complete 20 Strength Forge workouts",
            targetMetric: "workouts",
            targetAmount: 20.0,
            currentAmount: _monthlyChallengeProgress);
      case 7:
        return MonthlyChallenge(
            monthName: "July",
            targetDescription: "Perform 150 minutes of Meditation",
            targetMetric: "mins",
            targetAmount: 150.0,
            currentAmount: _monthlyChallengeProgress);
      case 8:
        return MonthlyChallenge(
            monthName: "August",
            targetDescription: "Drink 100 Liters of water",
            targetMetric: "Liters",
            targetAmount: 100.0,
            currentAmount: _monthlyChallengeProgress);
      case 9:
        return MonthlyChallenge(
            monthName: "September",
            targetDescription: "Log 150,000 steps",
            targetMetric: "steps",
            targetAmount: 150000.0,
            currentAmount: _monthlyChallengeProgress);
      case 10:
        return MonthlyChallenge(
            monthName: "October",
            targetDescription: "Do 1,200 Squats",
            targetMetric: "reps",
            targetAmount: 1200.0,
            currentAmount: _monthlyChallengeProgress);
      case 11:
        return MonthlyChallenge(
            monthName: "November",
            targetDescription: "Complete 15 Flexibility sessions",
            targetMetric: "sessions",
            targetAmount: 15.0,
            currentAmount: _monthlyChallengeProgress);
      default:
        return MonthlyChallenge(
            monthName: "December",
            targetDescription: "Complete 40 Daily Quests",
            targetMetric: "quests",
            targetAmount: 40.0,
            currentAmount: _monthlyChallengeProgress);
    }
  }

  void advanceMonthlyChallenge(double amount) {
    _monthlyChallengeProgress += amount;
    _checkMonthlyChallengeBadge();
    _save();
    notifyListeners();
  }

  void _checkMonthlyChallengeBadge() {
    final challenge = activeMonthlyChallenge;
    if (challenge.currentAmount >= challenge.targetAmount) {
      final Map<String, String> badgeMap = {
        "January": "January Resolution Badge",
        "February": "February Cardio Badge",
        "March": "March Flexibility Badge",
        "April": "April Hydration Badge",
        "May": "May Walkabout Badge",
        "June": "June Strength Badge",
        "July": "July Zen Badge",
        "August": "August Hydration Badge",
        "September": "September Steps Badge",
        "October": "October Squats Badge",
        "November": "November Flexibility Badge",
        "December": "December Quests Badge"
      };
      final specificBadge = badgeMap[challenge.monthName];
      if (specificBadge != null) {
        unlockBadge(specificBadge);
      }
    }
  }

  void logPR(String key, double value) {
    _personalRecords[key] = value;
    final list = _prHistory[key] ?? [];
    list.add(PREntry(date: DateTime.now(), value: value));
    _prHistory[key] = list;
    regenerateDailyQuests();
    _save();
    notifyListeners();
  }
}

class MonthlyChallenge {
  final String monthName;
  final String targetDescription;
  final String targetMetric;
  final double targetAmount;
  final double currentAmount;

  MonthlyChallenge({
    required this.monthName,
    required this.targetDescription,
    required this.targetMetric,
    required this.targetAmount,
    required this.currentAmount,
  });
}
