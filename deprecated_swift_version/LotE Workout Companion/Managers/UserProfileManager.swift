//
//  UserProfileManager.swift
//  LotE Workout Companion
//
//  Created by Antigravity on 6/23/26.
//

import Foundation
import SwiftUI
import Combine
import HealthKit

public class UserProfileManager: ObservableObject {
    // MARK: - Persisted Fields
    @Published public var characterName: String {
        didSet { save() }
    }
    
    @Published public var expressionStyle: ExpressionStyle {
        didSet { save() }
    }
    
    @Published public var selectedFocuses: [TrainingFocus] {
        didSet {
            save()
            regenerateDailyQuests()
        }
    }
    
    @Published public var height: Double {
        didSet { save() }
    }
    
    @Published public var weight: Double {
        didSet {
            save()
            checkWeightGoalProgress()
        }
    }
    
    @Published public var startWeight: Double {
        didSet { save() }
    }
    
    @Published public var goalWeight: Double {
        didSet {
            save()
            startWeight = weight
            hasClaimedWeightGoalReward = false
        }
    }
    
    @Published public var distanceGoal: Double {
        didSet { save() }
    }
    
    @Published public var stepsGoal: Double {
        didSet { save() }
    }
    
    @Published public var caloriesGoal: Double {
        didSet { save() }
    }
    
    @Published public var activeMinutesGoal: Double {
        didSet { save() }
    }
    
    @Published public var standHoursGoal: Double {
        didSet { save() }
    }
    
    @Published public var targetCalories: Double {
        didSet { save() }
    }
    
    @Published public var targetProtein: Double {
        didSet { save() }
    }
    
    @Published public var targetCarbs: Double {
        didSet { save() }
    }
    
    @Published public var targetFats: Double {
        didSet { save() }
    }
    
    @Published public var targetSugar: Double {
        didSet { save() }
    }
    
    @Published public var weightHistory: [WeightEntry] {
        didSet { save() }
    }
    
    @Published public var measurementHistory: [BodyMeasurementEntry] {
        didSet { save() }
    }
    
    @Published public var unlockedShopItems: [String] {
        didSet { save() }
    }
    
    @Published public var unlockedBadges: [String] {
        didSet { save() }
    }
    
    @Published public var hasClaimedWeightGoalReward: Bool {
        didSet { save() }
    }
    
    @Published public var hasClaimedDistanceGoalReward: Bool {
        didSet { save() }
    }
    
    @Published public var chest: Double {
        didSet { save() }
    }
    
    @Published public var arms: Double {
        didSet { save() }
    }
    
    @Published public var waist: Double {
        didSet { save() }
    }
    
    @Published public var hips: Double {
        didSet { save() }
    }
    
    @Published public var legs: Double {
        didSet { save() }
    }
    
    @Published public var selectedElementIndex: Int {
        didSet {
            save()
            regenerateDailyQuests()
        }
    }
    
    @Published public var cognitiveProfile: CognitiveProfile? {
        didSet { save() }
    }
    
    @Published public var stats: DNDStats {
        didSet { save() }
    }
    
    @Published public var sprite: CharacterSprite {
        didSet { save() }
    }
    
    @Published public var currentXP: Int {
        didSet { save() }
    }
    
    @Published public var currentLevel: Int {
        didSet { save() }
    }
    
    @Published public var crystals: Int {
        didSet { save() }
    }
    
    @Published public var dailyQuests: [LotEQuest] {
        didSet { save() }
    }
    
    @Published public var notificationFrequency: String {
        didSet {
            save()
            scheduleLocalNotifications()
        }
    }
    
    @Published public var monthlyChallengeProgress: Double {
        didSet {
            save()
            checkMonthlyChallengeBadge()
        }
    }
    
    @Published public var previousStreak: Int {
        didSet { save() }
    }
    
    @Published public var monthlyQuests: [LotEQuest] {
        didSet { save() }
    }
    
    @Published public var yearlyQuests: [LotEQuest] {
        didSet { save() }
    }
    
    @Published public var streak: Int {
        didSet { save() }
    }
    
    @Published public var lastActiveDate: Date? {
        didSet { save() }
    }
    
    @Published public var shortTermGoal: String {
        didSet { save() }
    }
    
    @Published public var longTermGoal: String {
        didSet { save() }
    }

    @Published public var homePlanet: String {
        didSet { save() }
    }

    @Published public var loggedMeals: [MealEntry] {
        didSet { save() }
    }
    
    @Published public var hasCompletedInitialQuiz: Bool {
        didSet { save() }
    }
    
    @Published public var healthyMealsLoggedToday: Int {
        didSet { save() }
    }
    
    @Published public var totalQuestsCompleted: Int {
        didSet { save() }
    }
    
    @Published public var equippedFrame: String {
        didSet { save() }
    }
    
    @Published public var equippedTitle: String {
        didSet { save() }
    }
    
    @Published public var equippedAura: String {
        didSet { save() }
    }
    
    @Published public var equippedBackground: String {
        didSet { save() }
    }
    
    @Published public var equippedAccessory: String {
        didSet { save() }
    }
    
    @Published public var todayWaterIntake: Double {
        didSet { save() }
    }
    
    @Published public var waterIntakeGoal: Double {
        didSet { save() }
    }
    
    @Published public var useImperialUnits: Bool {
        didSet { save() }
    }
    
    public var waterIntakeGoalOz: Double {
        get { (waterIntakeGoal * 33.814).rounded() }
        set { waterIntakeGoal = newValue / 33.814 }
    }
    
    public var todayWaterIntakeOz: Double {
        get { (todayWaterIntake * 33.814).rounded() }
        set { todayWaterIntake = max(0, newValue / 33.814) }
    }
    
    @Published public var personalRecords: [String: Double] {
        didSet {
            save()
            regenerateDailyQuests()
        }
    }
    
    @Published public var prHistory: [String: [PREntry]] {
        didSet {
            save()
        }
    }
    
    @Published public var loggedWorkoutSessions: [WorkoutSession] {
        didSet { save() }
    }
    
    // MARK: - Elements Lore Database
    public static let availableElements: [LotEElement] = [
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
            inherentDark: false
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
            inherentDark: false
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
            inherentDark: false
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
            inherentDark: false
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
            inherentDark: false
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
            inherentDark: false
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
            inherentDark: false
        ),
        LotEElement(
            name: "Bone",
            corruptName: "Wither Bone",
            description: "Stoic and primal. Honoring ancestors, hardening skeletal defenses.",
            corruptDescription: "Twisted, rotten bone spires that drain vital energy and entangle.",
            standardDetails: "Durable calcium armor plates, spears, and organic structural barriers.",
            corruptDetails: "Decaying bone spurs that release toxic rot on contact.",
            balancedDetails: "Unbreakable bone shields that latch onto attackers and drain life force.",
            primaryColorHex: "#EEEEEE",
            accentColorHex: "#D7CCC8",
            secondaryColorHex: "#9E9E9E",
            detailColorHex: "#3E2723",
            planetOfOrigin: "Warrion",
            inherentDark: false
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
            inherentDark: false
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
            inherentDark: false
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
            inherentDark: false
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
            inherentDark: true
        ),
        LotEElement(
            name: "Death",
            corruptName: "Death",
            description: "Morbid decay. Accelerating decomposition and weakening structural molecular bounds.",
            corruptDescription: "Morbid decay. Accelerating decomposition and weakening structural molecular bounds.",
            standardDetails: "Slow, creeping decay that exhausts targets and degrades physical structures.",
            corruptDetails: "Sudden cell collapse, spontaneous decomposition, and soul-reaping vibes.",
            balancedDetails: "Controlling the boundary of life and rot to siphon endurance.",
            primaryColorHex: "#4A148C",
            accentColorHex: "#212121",
            secondaryColorHex: "#263238",
            detailColorHex: "#FFFFFF",
            planetOfOrigin: "Battacaria",
            inherentDark: true
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
            inherentDark: true
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
            inherentDark: true
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
            inherentDark: false
        )
    ]
    
    public var currentElement: LotEElement {
        let base = UserProfileManager.availableElements[Self.normalizedElementIndex(selectedElementIndex)]
        if expressionStyle == .corrupt {
            return base.corruptedVersion()
        }
        return base
    }

    private static func normalizedElementIndex(_ index: Int) -> Int {
        min(max(index, 0), availableElements.count - 1)
    }
    
    // MARK: - Warrior Tier Calculation
    public var currentTier: WarriorTier {
        let sorted = WarriorTier.allCases.sorted { $0.levelRequired > $1.levelRequired }
        for tier in sorted {
            if currentLevel >= tier.levelRequired {
                return tier
            }
        }
        return .recruit
    }
    
    // MARK: - Initializer & Load Data
    public init() {
        let name = UserDefaults.standard.string(forKey: "lote_char_name") ?? "Recruit"
        self.characterName = name
        
        let elementIdx = Self.normalizedElementIndex(UserDefaults.standard.integer(forKey: "lote_selected_element_idx"))
        self.selectedElementIndex = elementIdx
        
        let savedStyle = UserDefaults.standard.string(forKey: "lote_expression_style") ?? ExpressionStyle.standard.rawValue
        self.expressionStyle = ExpressionStyle(rawValue: savedStyle) ?? .standard
        
        let tempFocuses: [TrainingFocus]
        if let focusesData = UserDefaults.standard.data(forKey: "lote_selected_focuses"),
           let decodedFocuses = try? JSONDecoder().decode([TrainingFocus].self, from: focusesData) {
            tempFocuses = decodedFocuses
        } else {
            tempFocuses = [.calisthenics, .cardio, .cutting]
        }
        self.selectedFocuses = tempFocuses
        
        let loadedHeight = UserDefaults.standard.double(forKey: "lote_body_height")
        self.height = loadedHeight == 0.0 ? 70.0 : loadedHeight
        
        let loadedWeight = UserDefaults.standard.double(forKey: "lote_body_weight")
        self.weight = loadedWeight == 0.0 ? 160.0 : loadedWeight
        
        let loadedStartWeight = UserDefaults.standard.double(forKey: "lote_start_weight")
        self.startWeight = loadedStartWeight == 0.0 ? 160.0 : loadedStartWeight
        
        let loadedGoalWeight = UserDefaults.standard.double(forKey: "lote_goal_weight")
        self.goalWeight = loadedGoalWeight == 0.0 ? 150.0 : loadedGoalWeight
        
        let loadedDistanceGoal = UserDefaults.standard.double(forKey: "lote_distance_goal")
        self.distanceGoal = loadedDistanceGoal == 0.0 ? 2.0 : loadedDistanceGoal
        
        let loadedStepsGoal = UserDefaults.standard.double(forKey: "lote_steps_goal")
        self.stepsGoal = loadedStepsGoal == 0.0 ? 10000.0 : loadedStepsGoal
        
        let loadedCalGoal = UserDefaults.standard.double(forKey: "lote_cal_goal")
        self.caloriesGoal = loadedCalGoal == 0.0 ? 400.0 : loadedCalGoal
        
        let loadedTargetCal = UserDefaults.standard.double(forKey: "lote_target_calories")
        self.targetCalories = loadedTargetCal == 0.0 ? 2500.0 : loadedTargetCal
        
        let loadedTargetProt = UserDefaults.standard.double(forKey: "lote_target_protein")
        self.targetProtein = loadedTargetProt == 0.0 ? 150.0 : loadedTargetProt
        
        let loadedTargetCarbs = UserDefaults.standard.double(forKey: "lote_target_carbs")
        self.targetCarbs = loadedTargetCarbs == 0.0 ? 250.0 : loadedTargetCarbs
        
        let loadedTargetFats = UserDefaults.standard.double(forKey: "lote_target_fats")
        self.targetFats = loadedTargetFats == 0.0 ? 80.0 : loadedTargetFats
        
        let loadedTargetSugar = UserDefaults.standard.double(forKey: "lote_target_sugar")
        self.targetSugar = loadedTargetSugar == 0.0 ? 50.0 : loadedTargetSugar
        
        let loadedMinGoal = UserDefaults.standard.double(forKey: "lote_min_goal")
        self.activeMinutesGoal = loadedMinGoal == 0.0 ? 30.0 : loadedMinGoal
        
        let loadedStandGoal = UserDefaults.standard.double(forKey: "lote_stand_goal")
        self.standHoursGoal = loadedStandGoal == 0.0 ? 10.0 : loadedStandGoal
        
        self.hasClaimedWeightGoalReward = UserDefaults.standard.bool(forKey: "lote_claimed_weight_reward")
        self.hasClaimedDistanceGoalReward = UserDefaults.standard.bool(forKey: "lote_claimed_distance_reward")
        self.useImperialUnits = UserDefaults.standard.bool(forKey: "lote_use_imperial_units")
        
        if let weightHistoryData = UserDefaults.standard.data(forKey: "lote_weight_history"),
           let decodedWeightHistory = try? JSONDecoder().decode([WeightEntry].self, from: weightHistoryData) {
            self.weightHistory = decodedWeightHistory
        } else {
            self.weightHistory = [WeightEntry(date: Date(), weight: loadedWeight == 0.0 ? 160.0 : loadedWeight)]
        }
        
        if let measurementHistoryData = UserDefaults.standard.data(forKey: "lote_measurement_history"),
           let decodedMeasurementHistory = try? JSONDecoder().decode([BodyMeasurementEntry].self, from: measurementHistoryData) {
            self.measurementHistory = decodedMeasurementHistory
        } else {
            self.measurementHistory = []
        }
        
        self.totalQuestsCompleted = UserDefaults.standard.integer(forKey: "lote_total_quests_completed")
        
        self.unlockedShopItems = UserDefaults.standard.stringArray(forKey: "lote_unlocked_shop_items") ?? []
        self.unlockedBadges = UserDefaults.standard.stringArray(forKey: "lote_unlocked_badges") ?? []
        
        self.equippedFrame = UserDefaults.standard.string(forKey: "lote_equipped_frame") ?? "None"
        self.equippedTitle = UserDefaults.standard.string(forKey: "lote_equipped_title") ?? "None"
        self.equippedAura = UserDefaults.standard.string(forKey: "lote_equipped_aura") ?? "None"
        self.equippedBackground = UserDefaults.standard.string(forKey: "lote_equipped_background") ?? "None"
        self.equippedAccessory = UserDefaults.standard.string(forKey: "lote_equipped_accessory") ?? "None"
        
        let loadedChest = UserDefaults.standard.double(forKey: "lote_body_chest")
        self.chest = loadedChest == 0.0 ? 38.0 : loadedChest
        
        let loadedArms = UserDefaults.standard.double(forKey: "lote_body_arms")
        self.arms = loadedArms == 0.0 ? 13.0 : loadedArms
        
        let loadedWaist = UserDefaults.standard.double(forKey: "lote_body_waist")
        self.waist = loadedWaist == 0.0 ? 32.0 : loadedWaist
        
        let loadedHips = UserDefaults.standard.double(forKey: "lote_body_hips")
        self.hips = loadedHips == 0.0 ? 40.0 : loadedHips
        
        let loadedLegs = UserDefaults.standard.double(forKey: "lote_body_legs")
        self.legs = loadedLegs == 0.0 ? 22.0 : loadedLegs
        
        if let savedCognitive = UserDefaults.standard.string(forKey: "lote_cognitive_profile") {
            self.cognitiveProfile = CognitiveProfile(safeValue: savedCognitive)
        } else {
            self.cognitiveProfile = nil
        }
        
        if let statsData = UserDefaults.standard.data(forKey: "lote_dnd_stats"),
           let decodedStats = try? JSONDecoder().decode(DNDStats.self, from: statsData) {
            self.stats = decodedStats
        } else {
            self.stats = DNDStats()
        }
        
        if let spriteData = UserDefaults.standard.data(forKey: "lote_character_sprite"),
           let decodedSprite = try? JSONDecoder().decode(CharacterSprite.self, from: spriteData) {
            self.sprite = decodedSprite
        } else {
            var defaultSprite = CharacterSprite()
            defaultSprite.pixelGrid = CharacterSprite.defaultGrid
            self.sprite = defaultSprite
        }
        
        let savedXP = UserDefaults.standard.integer(forKey: "lote_current_xp")
        self.currentXP = savedXP == 0 ? 0 : savedXP
        
        let savedLvl = UserDefaults.standard.integer(forKey: "lote_current_level")
        self.currentLevel = savedLvl == 0 ? 1 : savedLvl
        
        let savedCrystals = UserDefaults.standard.integer(forKey: "lote_crystals")
        self.crystals = savedCrystals == 0 ? 100 : savedCrystals
        
        self.notificationFrequency = UserDefaults.standard.string(forKey: "lote_notification_frequency") ?? "Medium"
        self.monthlyChallengeProgress = UserDefaults.standard.double(forKey: "lote_monthly_challenge_progress")
        self.previousStreak = UserDefaults.standard.integer(forKey: "lote_previous_streak")
        
        let loadedQuests: [LotEQuest]
        if let questsData = UserDefaults.standard.data(forKey: "lote_daily_quests"),
           let decodedQuests = try? JSONDecoder().decode([LotEQuest].self, from: questsData) {
            loadedQuests = decodedQuests
        } else {
            let elementName = UserProfileManager.availableElements[elementIdx].name
            loadedQuests = generateQuests(forElementName: elementName, focuses: tempFocuses, cadence: .daily)
        }
        self.dailyQuests = loadedQuests
        
        if let monthlyQuestsData = UserDefaults.standard.data(forKey: "lote_monthly_quests"),
           let decodedMonthlyQuests = try? JSONDecoder().decode([LotEQuest].self, from: monthlyQuestsData) {
            self.monthlyQuests = decodedMonthlyQuests
        } else {
            let elementName = UserProfileManager.availableElements[elementIdx].name
            self.monthlyQuests = generateQuests(forElementName: elementName, focuses: tempFocuses, cadence: .monthly)
        }
        
        if let yearlyQuestsData = UserDefaults.standard.data(forKey: "lote_yearly_quests"),
           let decodedYearlyQuests = try? JSONDecoder().decode([LotEQuest].self, from: yearlyQuestsData) {
            self.yearlyQuests = decodedYearlyQuests
        } else {
            let elementName = UserProfileManager.availableElements[elementIdx].name
            self.yearlyQuests = generateQuests(forElementName: elementName, focuses: tempFocuses, cadence: .yearly)
        }
        
        self.streak = UserDefaults.standard.integer(forKey: "lote_streak")
        
        if let dateVal = UserDefaults.standard.object(forKey: "lote_last_active") as? Date {
            self.lastActiveDate = dateVal
        } else {
            self.lastActiveDate = nil
        }
        
        self.shortTermGoal = UserDefaults.standard.string(forKey: "lote_short_goal") ?? "Complete at least one Cardio Patrol this week."
        self.longTermGoal = UserDefaults.standard.string(forKey: "lote_long_goal") ?? "Reach Krenpowen Apprentice tier rank."
        self.hasCompletedInitialQuiz = UserDefaults.standard.bool(forKey: "lote_has_quiz")
        self.healthyMealsLoggedToday = UserDefaults.standard.integer(forKey: "lote_meals_today")
        
        let defaultPlanet = UserProfileManager.availableElements[elementIdx].planetOfOrigin
        self.homePlanet = UserDefaults.standard.string(forKey: "lote_home_planet") ?? defaultPlanet
        
        if let mealsData = UserDefaults.standard.data(forKey: "lote_logged_meals"),
           let decodedMeals = try? JSONDecoder().decode([MealEntry].self, from: mealsData) {
            self.loggedMeals = decodedMeals
        } else {
            self.loggedMeals = []
        }
        
        self.todayWaterIntake = UserDefaults.standard.double(forKey: "lote_today_water_intake")
        let loadedWaterGoal = UserDefaults.standard.double(forKey: "lote_water_intake_goal")
        self.waterIntakeGoal = loadedWaterGoal == 0.0 ? 3.0 : loadedWaterGoal
        
        if let prsData = UserDefaults.standard.data(forKey: "lote_personal_records"),
           var decodedPRs = try? JSONDecoder().decode([String: Double].self, from: prsData) {
            if decodedPRs["Bench Press"] == nil { decodedPRs["Bench Press"] = 135.0 }
            if decodedPRs["Deadlift"] == nil { decodedPRs["Deadlift"] = 185.0 }
            if decodedPRs["Barbell Squat"] == nil { decodedPRs["Barbell Squat"] = 155.0 }
            if decodedPRs["Overhead Press"] == nil { decodedPRs["Overhead Press"] = 95.0 }
            self.personalRecords = decodedPRs
        } else {
            self.personalRecords = [
                "Pullups": 5.0,
                "Pushups": 20.0,
                "Squats": 30.0,
                "Run (Miles)": 1.0,
                "Handstand Hold (Sec)": 10.0,
                "Dips": 8.0,
                "Bench Press": 135.0,
                "Deadlift": 185.0,
                "Barbell Squat": 155.0,
                "Overhead Press": 95.0
            ]
        }
        
        if let prHistoryData = UserDefaults.standard.data(forKey: "lote_pr_history"),
           let decodedPRHistory = try? JSONDecoder().decode([String: [PREntry]].self, from: prHistoryData) {
            self.prHistory = decodedPRHistory
        } else {
            var initialHistory: [String: [PREntry]] = [:]
            let now = Date()
            let daysAgo = Calendar.current.date(byAdding: .day, value: -3, to: now) ?? now
            initialHistory["Pullups"] = [PREntry(date: daysAgo, value: 5.0)]
            initialHistory["Pushups"] = [PREntry(date: daysAgo, value: 20.0)]
            initialHistory["Squats"] = [PREntry(date: daysAgo, value: 30.0)]
            initialHistory["Run (Miles)"] = [PREntry(date: daysAgo, value: 1.0)]
            initialHistory["Handstand Hold (Sec)"] = [PREntry(date: daysAgo, value: 10.0)]
            initialHistory["Dips"] = [PREntry(date: daysAgo, value: 8.0)]
            initialHistory["Bench Press"] = [PREntry(date: daysAgo, value: 135.0)]
            initialHistory["Deadlift"] = [PREntry(date: daysAgo, value: 185.0)]
            initialHistory["Barbell Squat"] = [PREntry(date: daysAgo, value: 155.0)]
            initialHistory["Overhead Press"] = [PREntry(date: daysAgo, value: 95.0)]
            self.prHistory = initialHistory
        }
        
        if let sessionsData = UserDefaults.standard.data(forKey: "lote_logged_workout_sessions"),
           let decodedSessions = try? JSONDecoder().decode([WorkoutSession].self, from: sessionsData) {
            self.loggedWorkoutSessions = decodedSessions
        } else {
            self.loggedWorkoutSessions = []
        }
        
        // Refresh Quests if it's a new day
        checkNewDayRefresh()
    }
    
    // MARK: - Save State
    private func save() {
        UserDefaults.standard.set(characterName, forKey: "lote_char_name")
        UserDefaults.standard.set(selectedElementIndex, forKey: "lote_selected_element_idx")
        UserDefaults.standard.set(expressionStyle.rawValue, forKey: "lote_expression_style")
        UserDefaults.standard.set(cognitiveProfile?.rawValue, forKey: "lote_cognitive_profile")
        UserDefaults.standard.set(currentXP, forKey: "lote_current_xp")
        UserDefaults.standard.set(currentLevel, forKey: "lote_current_level")
        UserDefaults.standard.set(crystals, forKey: "lote_crystals")
        UserDefaults.standard.set(streak, forKey: "lote_streak")
        UserDefaults.standard.set(lastActiveDate, forKey: "lote_last_active")
        UserDefaults.standard.set(shortTermGoal, forKey: "lote_short_goal")
        UserDefaults.standard.set(longTermGoal, forKey: "lote_long_goal")
        UserDefaults.standard.set(hasCompletedInitialQuiz, forKey: "lote_has_quiz")
        UserDefaults.standard.set(healthyMealsLoggedToday, forKey: "lote_meals_today")
        UserDefaults.standard.set(homePlanet, forKey: "lote_home_planet")
        UserDefaults.standard.set(notificationFrequency, forKey: "lote_notification_frequency")
        UserDefaults.standard.set(monthlyChallengeProgress, forKey: "lote_monthly_challenge_progress")
        UserDefaults.standard.set(previousStreak, forKey: "lote_previous_streak")
        
        UserDefaults.standard.set(todayWaterIntake, forKey: "lote_today_water_intake")
        UserDefaults.standard.set(waterIntakeGoal, forKey: "lote_water_intake_goal")
        UserDefaults.standard.set(useImperialUnits, forKey: "lote_use_imperial_units")
        
        if let prsData = try? JSONEncoder().encode(personalRecords) {
            UserDefaults.standard.set(prsData, forKey: "lote_personal_records")
        }
        if let sessionsData = try? JSONEncoder().encode(loggedWorkoutSessions) {
            UserDefaults.standard.set(sessionsData, forKey: "lote_logged_workout_sessions")
        }
        
        if let mealsData = try? JSONEncoder().encode(loggedMeals) {
            UserDefaults.standard.set(mealsData, forKey: "lote_logged_meals")
        }
        
        UserDefaults.standard.set(height, forKey: "lote_body_height")
        UserDefaults.standard.set(targetCalories, forKey: "lote_target_calories")
        UserDefaults.standard.set(targetProtein, forKey: "lote_target_protein")
        UserDefaults.standard.set(targetCarbs, forKey: "lote_target_carbs")
        UserDefaults.standard.set(targetFats, forKey: "lote_target_fats")
        UserDefaults.standard.set(targetSugar, forKey: "lote_target_sugar")
        UserDefaults.standard.set(weight, forKey: "lote_body_weight")
        UserDefaults.standard.set(startWeight, forKey: "lote_start_weight")
        UserDefaults.standard.set(goalWeight, forKey: "lote_goal_weight")
        UserDefaults.standard.set(distanceGoal, forKey: "lote_distance_goal")
        UserDefaults.standard.set(stepsGoal, forKey: "lote_steps_goal")
        UserDefaults.standard.set(caloriesGoal, forKey: "lote_cal_goal")
        UserDefaults.standard.set(activeMinutesGoal, forKey: "lote_min_goal")
        UserDefaults.standard.set(standHoursGoal, forKey: "lote_stand_goal")
        
        UserDefaults.standard.set(hasClaimedWeightGoalReward, forKey: "lote_claimed_weight_reward")
        UserDefaults.standard.set(hasClaimedDistanceGoalReward, forKey: "lote_claimed_distance_reward")
        UserDefaults.standard.set(unlockedShopItems, forKey: "lote_unlocked_shop_items")
        UserDefaults.standard.set(unlockedBadges, forKey: "lote_unlocked_badges")
        
        UserDefaults.standard.set(equippedFrame, forKey: "lote_equipped_frame")
        UserDefaults.standard.set(equippedTitle, forKey: "lote_equipped_title")
        UserDefaults.standard.set(equippedAura, forKey: "lote_equipped_aura")
        UserDefaults.standard.set(equippedBackground, forKey: "lote_equipped_background")
        UserDefaults.standard.set(equippedAccessory, forKey: "lote_equipped_accessory")
        
        UserDefaults.standard.set(chest, forKey: "lote_body_chest")
        UserDefaults.standard.set(arms, forKey: "lote_body_arms")
        UserDefaults.standard.set(waist, forKey: "lote_body_waist")
        UserDefaults.standard.set(hips, forKey: "lote_body_hips")
        UserDefaults.standard.set(legs, forKey: "lote_body_legs")
        
        UserDefaults.standard.set(totalQuestsCompleted, forKey: "lote_total_quests_completed")
        
        if let focusesData = try? JSONEncoder().encode(selectedFocuses) {
            UserDefaults.standard.set(focusesData, forKey: "lote_selected_focuses")
        }
        
        if let statsData = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(statsData, forKey: "lote_dnd_stats")
        }
        
        if let spriteData = try? JSONEncoder().encode(sprite) {
            UserDefaults.standard.set(spriteData, forKey: "lote_character_sprite")
        }
        
        if let questsData = try? JSONEncoder().encode(dailyQuests) {
            UserDefaults.standard.set(questsData, forKey: "lote_daily_quests")
        }
        
        if let monthlyQuestsData = try? JSONEncoder().encode(monthlyQuests) {
            UserDefaults.standard.set(monthlyQuestsData, forKey: "lote_monthly_quests")
        }
        
        if let yearlyQuestsData = try? JSONEncoder().encode(yearlyQuests) {
            UserDefaults.standard.set(yearlyQuestsData, forKey: "lote_yearly_quests")
        }
        
        if let weightHistoryData = try? JSONEncoder().encode(weightHistory) {
            UserDefaults.standard.set(weightHistoryData, forKey: "lote_weight_history")
        }
        
        if let measurementHistoryData = try? JSONEncoder().encode(measurementHistory) {
            UserDefaults.standard.set(measurementHistoryData, forKey: "lote_measurement_history")
        }
        
        if let prHistoryData = try? JSONEncoder().encode(prHistory) {
            UserDefaults.standard.set(prHistoryData, forKey: "lote_pr_history")
        }
    }
    
    public func logPR(key: String, value: Double) {
        personalRecords[key] = value
        
        var history = prHistory[key] ?? []
        history.append(PREntry(date: Date(), value: value))
        prHistory[key] = history
        
        save()
        regenerateDailyQuests()
    }
    
    // MARK: - XP & Rewards Engine
    public func addXP(_ amount: Int) {
        if currentLevel >= 100 {
            currentLevel = 100
            currentXP = 0
            return
        }
        currentXP += amount
        var xpNeeded = requiredXPForLevel(currentLevel)
        while currentXP >= xpNeeded && currentLevel < 100 {
            currentXP -= xpNeeded
            currentLevel += 1
            crystals += 50 // Level up reward
            
            // Random Stat Increase on Level Up!
            if let randomStat = StatType.allCases.randomElement() {
                stats.increase(randomStat, by: 1)
            }
            xpNeeded = requiredXPForLevel(currentLevel)
        }
        if currentLevel >= 100 {
            currentLevel = 100
            currentXP = 0
        }
    }
    
    public func requiredXPForLevel(_ lvl: Int) -> Int {
        // Multi-year leveling curve reaching level 100 (steeper scaling)
        return 1000 + (lvl * 100) + (lvl * lvl * 5)
    }
    
    public func earnCrystals(_ amount: Int) {
        crystals += amount
    }
    
    // MARK: - Shop Purchase Action
    public func buyShopItem(_ item: ShopItem) -> Bool {
        guard crystals >= item.cost else { return false }
        guard !unlockedShopItems.contains(item.name) else { return false }
        
        crystals -= item.cost
        unlockedShopItems.append(item.name)
        
        // Apply stats boost if it's a stat elixir
        if item.type == "stat" {
            if item.name.contains("STR") { stats.increase(.strength, by: 1) }
            else if item.name.contains("DEX") { stats.increase(.dexterity, by: 1) }
            else if item.name.contains("CON") { stats.increase(.constitution, by: 1) }
            else if item.name.contains("INT") { stats.increase(.intelligence, by: 1) }
            else if item.name.contains("WIS") { stats.increase(.wisdom, by: 1) }
            else if item.name.contains("CHA") { stats.increase(.charisma, by: 1) }
        }
        
        unlockBadge("Guild Patron")
        save()
        return true
    }
    
    public func toggleEquipItem(_ item: ShopItem) {
        guard unlockedShopItems.contains(item.name) else { return }
        
        switch item.type {
        case "frame":
            equippedFrame = (equippedFrame == item.name) ? "None" : item.name
        case "title":
            equippedTitle = (equippedTitle == item.name) ? "None" : item.name
        case "aura":
            equippedAura = (equippedAura == item.name) ? "None" : item.name
        case "background":
            equippedBackground = (equippedBackground == item.name) ? "None" : item.name
        case "accessory":
            equippedAccessory = (equippedAccessory == item.name) ? "None" : item.name
        default:
            break
        }
        save()
    }
    
    // MARK: - Badge Unlock Engine
    public func unlockBadge(_ name: String) {
        if !unlockedBadges.contains(name) {
            unlockedBadges.append(name)
            // Grant badge completion rewards
            addXP(200)
            earnCrystals(50)
            save()
        }
    }
    
    public func checkBadges(healthManager: HealthKitManager) {
        if healthManager.todaySteps >= 10000.0 {
            unlockBadge("First Step")
        }
        if healthManager.todaySteps >= 20000.0 {
            unlockBadge("20k Steps Sentinel")
        }
        if healthManager.activeMinutes >= 60.0 {
            unlockBadge("Iron Will (1 Hr)")
        }
        if healthManager.activeMinutes >= 120.0 {
            unlockBadge("Unstoppable Force (2 Hr)")
        }
        if totalQuestsCompleted >= 100 {
            unlockBadge("Quest Crusader (100 Quests)")
        }
        if totalQuestsCompleted >= 1000 {
            unlockBadge("Legendary Champion (1000 Quests)")
        }
        
        if streak >= 7 {
            unlockBadge("Streak Master")
        }
        if streak >= 14 {
            unlockBadge("Vanguard Streak (14 Days)")
        }
        if streak >= 30 {
            unlockBadge("Sovereign Streak (30 Days)")
        }
        if streak >= 100 {
            unlockBadge("Immortal Streak (100 Days)")
        }
        
        if stats.strength >= 18 || stats.dexterity >= 18 || stats.constitution >= 18 || stats.wisdom >= 18 || stats.intelligence >= 18 || stats.charisma >= 18 {
            unlockBadge("Demi-God")
        }
        if hasCompletedInitialQuiz {
            unlockBadge("Lore Scholar")
        }
        
        // Check daily distance target goal progress
        checkDistanceGoalProgress(todaySteps: healthManager.todaySteps)
    }
    
    public func checkDistanceGoalProgress(todaySteps: Double) {
        let currentDistance = todaySteps / 2000.0
        if !hasClaimedDistanceGoalReward && currentDistance >= distanceGoal {
            addXP(100)
            earnCrystals(30)
            hasClaimedDistanceGoalReward = true
            save()
        }
    }
    
    // MARK: - Target Progress Helper
    public func checkWeightGoalProgress() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Record in history, replacing today's entry if already present
        weightHistory.removeAll { calendar.isDate($0.date, inSameDayAs: today) }
        weightHistory.append(WeightEntry(date: Date(), weight: weight))
        
        // Auto reward check
        if !hasClaimedWeightGoalReward {
            let isCutting = startWeight > goalWeight
            if isCutting {
                if weight <= goalWeight {
                    addXP(2000)
                    earnCrystals(1000)
                    hasClaimedWeightGoalReward = true
                    unlockBadge("Weight Target Achieved")
                }
            } else { // Bulking
                if weight >= goalWeight {
                    addXP(2000)
                    earnCrystals(1000)
                    hasClaimedWeightGoalReward = true
                    unlockBadge("Weight Target Achieved")
                }
            }
        }
        save()
    }
    
    public var activeMonthlyChallengeCategory: WorkoutCategory? {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        switch month {
        case 1, 6, 10: return .strength
        case 2, 5, 9: return .cardio
        case 3, 11: return .flexibility
        case 4, 8: return .nutrition
        case 7: return .meditation
        default: return nil
        }
    }
    
    // MARK: - Quest Actions
    public func completeQuest(_ quest: LotEQuest) -> Bool {
        var isDaily = false
        var isMonthly = false
        var isYearly = false
        var foundIndex = -1
        
        if let idx = dailyQuests.firstIndex(where: { $0.id == quest.id }) {
            isDaily = true
            foundIndex = idx
        } else if let idx = monthlyQuests.firstIndex(where: { $0.id == quest.id }) {
            isMonthly = true
            foundIndex = idx
        } else if let idx = yearlyQuests.firstIndex(where: { $0.id == quest.id }) {
            isYearly = true
            foundIndex = idx
        }
        
        guard foundIndex != -1 else { return false }
        
        let questToComplete = isDaily ? dailyQuests[foundIndex] : (isMonthly ? monthlyQuests[foundIndex] : yearlyQuests[foundIndex])
        guard !questToComplete.isCompleted else { return false }
        guard questToComplete.progressCount >= questToComplete.targetCount else { return false }
        
        if isDaily {
            dailyQuests[foundIndex].isCompleted = true
            incrementMonthlyAndYearlyProgress(for: questToComplete.workoutType)
            
            if let activeCat = activeMonthlyChallengeCategory, questToComplete.workoutType == activeCat {
                let challenge = activeMonthlyChallenge
                let amount: Double
                if challenge.targetMetric == "reps" {
                    amount = 50.0
                } else if challenge.targetMetric == "Liters" {
                    amount = 3.0
                } else if challenge.targetMetric == "miles" {
                    amount = 2.0
                } else {
                    amount = questToComplete.requiredMinutes > 0 ? questToComplete.requiredMinutes : 15.0
                }
                advanceMonthlyChallenge(amount: amount)
            }
        } else if isMonthly {
            monthlyQuests[foundIndex].isCompleted = true
        } else if isYearly {
            yearlyQuests[foundIndex].isCompleted = true
        }
        
        addXP(questToComplete.rewardXP)
        earnCrystals(questToComplete.rewardCrystals)
        stats.increase(questToComplete.statReward, by: questToComplete.statValue)
        updateStreakOnActivity()
        
        totalQuestsCompleted += 1
        
        // Unlocks badge on 5 completed quests
        let completedDailies = dailyQuests.filter { $0.isCompleted }.count
        if completedDailies >= 5 {
            unlockBadge("Flame Starter")
        }
        
        save()
        return true
    }
    
    private func incrementMonthlyAndYearlyProgress(for category: WorkoutCategory) {
        for i in 0..<monthlyQuests.count {
            if monthlyQuests[i].workoutType == category && !monthlyQuests[i].isCompleted {
                monthlyQuests[i].progressCount = min(monthlyQuests[i].progressCount + 1, monthlyQuests[i].targetCount)
            }
        }
        for i in 0..<yearlyQuests.count {
            if yearlyQuests[i].workoutType == category && !yearlyQuests[i].isCompleted {
                yearlyQuests[i].progressCount = min(yearlyQuests[i].progressCount + 1, yearlyQuests[i].targetCount)
            }
        }
    }
    
    public func logWorkout(category: WorkoutCategory, durationMinutes: Double = 15.0) {
        let type: String
        switch category {
        case .strength: type = "Strength"
        case .cardio: type = "Cardio"
        case .flexibility: type = "Yoga"
        case .nutrition: type = "Nutrition"
        case .meditation: type = "Meditation"
        }
        
        let session = WorkoutSession(type: type, durationMinutes: durationMinutes, date: Date())
        loggedWorkoutSessions.append(session)
        
        // Evaluate daily quest completion
        evaluateQuestsCompletion()
        
        // Increment progress on matching monthly quests
        for i in 0..<monthlyQuests.count {
            if monthlyQuests[i].workoutType == category && !monthlyQuests[i].isCompleted {
                monthlyQuests[i].progressCount = min(monthlyQuests[i].progressCount + 1, monthlyQuests[i].targetCount)
            }
        }
        // Increment progress on matching yearly quests
        for i in 0..<yearlyQuests.count {
            if yearlyQuests[i].workoutType == category && !yearlyQuests[i].isCompleted {
                yearlyQuests[i].progressCount = min(yearlyQuests[i].progressCount + 1, yearlyQuests[i].targetCount)
            }
        }
        save()
    }
    
    public func evaluateQuestsCompletion() {
        let calendar = Calendar.current
        let todaySessions = loggedWorkoutSessions.filter { calendar.isDateInToday($0.date) }
        
        // Sum durations by type
        let strengthDuration = todaySessions.filter { $0.type == "Strength" }.reduce(0.0) { $0 + $1.durationMinutes }
        let cardioDuration = todaySessions.filter { $0.type == "Cardio" || $0.type == "Running" }.reduce(0.0) { $0 + $1.durationMinutes }
        let yogaDuration = todaySessions.filter { $0.type == "Yoga" }.reduce(0.0) { $0 + $1.durationMinutes }
        
        // Evaluate daily quests
        for i in 0..<dailyQuests.count {
            let q = dailyQuests[i]
            if q.isCompleted { continue }
            
            switch q.workoutType {
            case .strength:
                if strengthDuration >= q.requiredMinutes {
                    dailyQuests[i].progressCount = q.targetCount
                }
            case .cardio:
                if cardioDuration >= q.requiredMinutes {
                    dailyQuests[i].progressCount = q.targetCount
                }
            case .flexibility:
                if yogaDuration >= q.requiredMinutes {
                    dailyQuests[i].progressCount = q.targetCount
                }
            case .nutrition:
                if (q.title.localizedCaseInsensitiveContains("water") || q.title.localizedCaseInsensitiveContains("Hydration") || q.questDescription.localizedCaseInsensitiveContains("water") || q.questDescription.localizedCaseInsensitiveContains("Hydration")) {
                    if todayWaterIntake >= waterIntakeGoal {
                        dailyQuests[i].progressCount = q.targetCount
                    }
                }
            case .meditation:
                break
            }
        }
    }
    
    public func logDetailedMeal(name: String, calories: Double, protein: Double, carbs: Double, fats: Double, sugar: Double) {
        let entry = MealEntry(name: name, calories: calories, protein: protein, carbs: carbs, fats: fats, sugar: sugar)
        loggedMeals.append(entry)
        healthyMealsLoggedToday += 1
        logWorkout(category: .nutrition, durationMinutes: 0.0)
        save()
    }
    
    public func deleteDetailedMeal(id: UUID) {
        loggedMeals.removeAll(where: { $0.id == id })
        save()
    }
    
    public func logBodyMeasurements(weight: Double, chest: Double, arms: Double, waist: Double, hips: Double, legs: Double) {
        let entry = BodyMeasurementEntry(weight: weight, chest: chest, arms: arms, waist: waist, hips: hips, legs: legs)
        measurementHistory.append(entry)
        
        self.weight = weight
        self.chest = chest
        self.arms = arms
        self.waist = waist
        self.hips = hips
        self.legs = legs
        
        save()
    }
    
    public func logRestDay() {
        updateStreakOnActivity()
        save()
    }
    
    public var todaySugar: Double {
        let calendar = Calendar.current
        return loggedMeals
            .filter { calendar.isDateInToday($0.date) }
            .reduce(0.0) { $0 + $1.sugar }
    }
    
    public func syncQuestsWithHealthData(todaySteps: Double, activeMinutes: Double, recentWorkouts: [HKWorkout]) {
        let calendar = Calendar.current
        for hw in recentWorkouts {
            if calendar.isDateInToday(hw.startDate) {
                // Determine mapped type. A walking workout is mapped to "Walking", which is excluded from Strength/Yoga sync.
                let type: String
                switch hw.workoutActivityType {
                case .functionalStrengthTraining, .traditionalStrengthTraining, .coreTraining:
                    type = "Strength"
                case .walking:
                    type = "Walking"
                case .running:
                    type = "Running"
                case .cycling, .rowing, .stairClimbing:
                    type = "Cardio"
                case .yoga, .flexibility:
                    type = "Yoga"
                default:
                    type = "Cardio"
                }
                
                let durationMins = hw.duration / 60.0
                
                // Add if not already present
                if !loggedWorkoutSessions.contains(where: { calendar.isDate($0.date, inSameDayAs: hw.startDate) && $0.type == type && abs($0.durationMinutes - durationMins) < 0.1 }) {
                    loggedWorkoutSessions.append(WorkoutSession(type: type, durationMinutes: durationMins, date: hw.startDate))
                }
            }
        }
        
        evaluateQuestsCompletion()
        
        // Dynamic fallback steps logic
        if todaySteps >= 5000.0 {
            for i in 0..<dailyQuests.count {
                if dailyQuests[i].workoutType == .cardio {
                    dailyQuests[i].progressCount = dailyQuests[i].targetCount
                }
            }
        }
        save()
    }
    
    public func resetProgress() {
        self.currentLevel = 1
        self.currentXP = 0
        self.crystals = 100
        self.streak = 0
        self.stats = DNDStats()
        self.unlockedBadges = []
        self.unlockedShopItems = []
        self.loggedMeals = []
        self.measurementHistory = []
        self.equippedFrame = "None"
        self.equippedTitle = "None"
        self.equippedAura = "None"
        self.equippedBackground = "None"
        self.equippedAccessory = "None"
        self.totalQuestsCompleted = 0
        self.healthyMealsLoggedToday = 0
        self.hasClaimedWeightGoalReward = false
        self.hasClaimedDistanceGoalReward = false
        
        self.personalRecords = [
            "Pullups": 5.0,
            "Pushups": 20.0,
            "Squats": 30.0,
            "Run (Miles)": 1.0,
            "Handstand Hold (Sec)": 10.0,
            "Dips": 8.0,
            "Bench Press": 135.0,
            "Deadlift": 185.0,
            "Barbell Squat": 155.0,
            "Overhead Press": 95.0
        ]
        
        var initialHistory: [String: [PREntry]] = [:]
        let now = Date()
        let daysAgo = Calendar.current.date(byAdding: .day, value: -3, to: now) ?? now
        initialHistory["Pullups"] = [PREntry(date: daysAgo, value: 5.0)]
        initialHistory["Pushups"] = [PREntry(date: daysAgo, value: 20.0)]
        initialHistory["Squats"] = [PREntry(date: daysAgo, value: 30.0)]
        initialHistory["Run (Miles)"] = [PREntry(date: daysAgo, value: 1.0)]
        initialHistory["Handstand Hold (Sec)"] = [PREntry(date: daysAgo, value: 10.0)]
        initialHistory["Dips"] = [PREntry(date: daysAgo, value: 8.0)]
        initialHistory["Bench Press"] = [PREntry(date: daysAgo, value: 135.0)]
        initialHistory["Deadlift"] = [PREntry(date: daysAgo, value: 185.0)]
        initialHistory["Barbell Squat"] = [PREntry(date: daysAgo, value: 155.0)]
        initialHistory["Overhead Press"] = [PREntry(date: daysAgo, value: 95.0)]
        self.prHistory = initialHistory
        
        self.regenerateDailyQuests()
        save()
    }
    
    private func getStatModifier(for stat: StatType) -> Int {
        let baseVal: Int
        switch stat {
        case .strength: baseVal = stats.strength
        case .dexterity: baseVal = stats.dexterity
        case .constitution: baseVal = stats.constitution
        case .intelligence: baseVal = stats.intelligence
        case .wisdom: baseVal = stats.wisdom
        case .charisma: baseVal = stats.charisma
        }
        return (baseVal - 10) / 2 // Standard D&D modifier calculation
    }
    
    private func checkNewDayRefresh() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastDate = lastActiveDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            let diff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
            
            if diff > 0 {
                // It's a new day!
                healthyMealsLoggedToday = 0
                todayWaterIntake = 0.0
                hasClaimedDistanceGoalReward = false
                let elementName = currentElement.name
                self.dailyQuests = generateQuests(forElementName: elementName, focuses: selectedFocuses, cadence: .daily, prs: personalRecords, waterGoal: waterIntakeGoal)
                
                // If it's a new month, refresh monthly quests
                let lastMonth = calendar.component(.month, from: lastDate)
                let currentMonth = calendar.component(.month, from: Date())
                if lastMonth != currentMonth {
                    self.monthlyQuests = generateQuests(forElementName: elementName, focuses: selectedFocuses, cadence: .monthly, prs: personalRecords, waterGoal: waterIntakeGoal)
                }
                
                // If it's a new year, refresh yearly quests
                let lastYear = calendar.component(.year, from: lastDate)
                let currentYear = calendar.component(.year, from: Date())
                if lastYear != currentYear {
                    self.yearlyQuests = generateQuests(forElementName: elementName, focuses: selectedFocuses, cadence: .yearly, prs: personalRecords, waterGoal: waterIntakeGoal)
                }
                
                if diff > 1 {
                    // Streak broken
                    previousStreak = streak
                    streak = 0
                }
            }
        } else {
            // First time running or no history
            lastActiveDate = Date()
        }
    }
    
    private func updateStreakOnActivity() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastDate = lastActiveDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            let diff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
            
            if diff == 1 {
                // Consecutive day
                streak += 1
            } else if diff > 1 {
                // Streak broken and restarted
                previousStreak = streak
                streak = 1
            } else if streak == 0 {
                // Streak started
                streak = 1
            }
        } else {
            streak = 1
        }
        
        lastActiveDate = Date()
    }
    
    // MARK: - Character Sprite Editing
    public func updatePixelGrid(row: Int, col: Int, value: Int) {
        sprite.pixelGrid[row][col] = value
        save()
    }
    
    public func regenerateDailyQuests() {
        let elementName = currentElement.name
        self.dailyQuests = generateQuests(forElementName: elementName, focuses: selectedFocuses, cadence: .daily, prs: personalRecords, waterGoal: waterIntakeGoal)
        self.monthlyQuests = generateQuests(forElementName: elementName, focuses: selectedFocuses, cadence: .monthly, prs: personalRecords, waterGoal: waterIntakeGoal)
        self.yearlyQuests = generateQuests(forElementName: elementName, focuses: selectedFocuses, cadence: .yearly, prs: personalRecords, waterGoal: waterIntakeGoal)
    }
    
    // MARK: - Streak Recovery
    public func recoverStreak() -> Bool {
        guard previousStreak > 0, crystals >= 100 else { return false }
        crystals -= 100
        streak = previousStreak + 1
        previousStreak = 0
        save()
        return true
    }
    
    // MARK: - Notification Manager
    public func scheduleLocalNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        guard notificationFrequency != "Off" else { return }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            guard granted else { return }
            
            let quip: String
            switch self.currentElement.name {
            case "Fire":
                quip = "Stoke the flames! Get back to your workout goals. Level up before your fire fades!"
            case "Water":
                quip = "The sea is calling, your workout awaits! Keep flowing or stagnant waters will settle."
            case "Earth":
                quip = "Root yourself in discipline. Build your foundation like the mountains."
            case "Air":
                quip = "Float swift, strike fast. Do not let your momentum vanish into thin air."
            default:
                quip = "Train hard, warrior. Level up your stats today!"
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Elsaither Reminder"
            content.body = quip
            content.sound = .default
            
            let count = self.notificationFrequency == "High" ? 3 : (self.notificationFrequency == "Medium" ? 2 : 1)
            let daysInterval = self.notificationFrequency == "Low" ? 7.0 : 1.0
            
            for i in 1...count {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: daysInterval * 86400 * Double(i) / Double(count), repeats: true)
                let request = UNNotificationRequest(identifier: "lote_remind_\(i)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    // MARK: - Monthly Challenges
    public struct MonthlyChallenge {
        public let monthName: String
        public let targetDescription: String
        public let targetMetric: String
        public let targetAmount: Double
        public var currentAmount: Double
    }
    
    public var activeMonthlyChallenge: MonthlyChallenge {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        
        switch month {
        case 1: return MonthlyChallenge(monthName: "January", targetDescription: "Do 1,000 Pushups", targetMetric: "reps", targetAmount: 1000, currentAmount: monthlyChallengeProgress)
        case 2: return MonthlyChallenge(monthName: "February", targetDescription: "Perform 300 minutes of Cardio", targetMetric: "mins", targetAmount: 300, currentAmount: monthlyChallengeProgress)
        case 3: return MonthlyChallenge(monthName: "March", targetDescription: "Perform 120 minutes of Yoga/Flexibility", targetMetric: "mins", targetAmount: 120, currentAmount: monthlyChallengeProgress)
        case 4: return MonthlyChallenge(monthName: "April", targetDescription: "Drink 90 Liters of water", targetMetric: "Liters", targetAmount: 90, currentAmount: monthlyChallengeProgress)
        case 5: return MonthlyChallenge(monthName: "May", targetDescription: "Walk 50 miles", targetMetric: "miles", targetAmount: 50, currentAmount: monthlyChallengeProgress)
        case 6: return MonthlyChallenge(monthName: "June", targetDescription: "Complete 20 Strength Forge workouts", targetMetric: "workouts", targetAmount: 20, currentAmount: monthlyChallengeProgress)
        case 7: return MonthlyChallenge(monthName: "July", targetDescription: "Perform 150 minutes of Meditation", targetMetric: "mins", targetAmount: 150, currentAmount: monthlyChallengeProgress)
        case 8: return MonthlyChallenge(monthName: "August", targetDescription: "Drink 100 Liters of water", targetMetric: "Liters", targetAmount: 100, currentAmount: monthlyChallengeProgress)
        case 9: return MonthlyChallenge(monthName: "September", targetDescription: "Log 250,000 steps", targetMetric: "steps", targetAmount: 250000, currentAmount: monthlyChallengeProgress)
        case 10: return MonthlyChallenge(monthName: "October", targetDescription: "Do 1,200 Squats", targetMetric: "reps", targetAmount: 1200, currentAmount: monthlyChallengeProgress)
        case 11: return MonthlyChallenge(monthName: "November", targetDescription: "Complete 15 Flexibility sessions", targetMetric: "sessions", targetAmount: 15, currentAmount: monthlyChallengeProgress)
        default: return MonthlyChallenge(monthName: "December", targetDescription: "Complete 40 Daily Quests", targetMetric: "quests", targetAmount: 40, currentAmount: monthlyChallengeProgress)
        }
    }
    
    public func advanceMonthlyChallenge(amount: Double) {
        monthlyChallengeProgress += amount
        checkMonthlyChallengeBadge()
    }
    
    private func checkMonthlyChallengeBadge() {
        let challenge = activeMonthlyChallenge
        if challenge.currentAmount >= challenge.targetAmount {
            let badgeMap: [String: String] = [
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
            ]
            if let specificBadge = badgeMap[challenge.monthName] {
                if !unlockedBadges.contains(specificBadge) {
                    unlockedBadges.append(specificBadge)
                    crystals += 100 // Reward crystals for monthly challenge completion
                    save()
                }
            }
        }
    }
}
