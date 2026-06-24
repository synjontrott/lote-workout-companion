//
//  UserProfileManager.swift
//  LotE Workout Companion
//
//  Created by Antigravity on 6/23/26.
//

import Foundation
import SwiftUI
import Combine

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

    @Published public var calisthenicsGoal: String {
        didSet { save() }
    }

    @Published public var liftingGoal: String {
        didSet { save() }
    }

    @Published public var customGoal: String {
        didSet { save() }
    }
    
    @Published public var hasCompletedInitialQuiz: Bool {
        didSet { save() }
    }
    
    @Published public var healthyMealsLoggedToday: Int {
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
            primaryColorHex: "#FF007F",
            accentColorHex: "#7B1FA2",
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
            primaryColorHex: "#AA00FF",
            accentColorHex: "#00E676",
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
            planetOfOrigin: "Battacaria",
            inherentDark: false
        )
    ]
    
    public var currentElement: LotEElement {
        UserProfileManager.availableElements[selectedElementIndex]
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
        
        let elementIdx = UserDefaults.standard.integer(forKey: "lote_selected_element_idx")
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
            self.cognitiveProfile = CognitiveProfile(rawValue: savedCognitive)
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
        
        let loadedQuests: [LotEQuest]
        if let questsData = UserDefaults.standard.data(forKey: "lote_daily_quests"),
           let decodedQuests = try? JSONDecoder().decode([LotEQuest].self, from: questsData) {
            loadedQuests = decodedQuests
        } else {
            let elementName = UserProfileManager.availableElements[elementIdx].name
            loadedQuests = generateQuests(forElementName: elementName, focuses: tempFocuses)
        }
        self.dailyQuests = loadedQuests
        
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
        self.calisthenicsGoal = UserDefaults.standard.string(forKey: "lote_calisthenics_goal") ?? "Perform 20 mins of handstands or pulls."
        self.liftingGoal = UserDefaults.standard.string(forKey: "lote_lifting_goal") ?? "Deadlift 2x bodyweight milestone."
        self.customGoal = UserDefaults.standard.string(forKey: "lote_custom_goal") ?? "Complete 3 flexibility routines."
        
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
        UserDefaults.standard.set(calisthenicsGoal, forKey: "lote_calisthenics_goal")
        UserDefaults.standard.set(liftingGoal, forKey: "lote_lifting_goal")
        UserDefaults.standard.set(customGoal, forKey: "lote_custom_goal")
        
        UserDefaults.standard.set(height, forKey: "lote_body_height")
        UserDefaults.standard.set(weight, forKey: "lote_body_weight")
        UserDefaults.standard.set(chest, forKey: "lote_body_chest")
        UserDefaults.standard.set(arms, forKey: "lote_body_arms")
        UserDefaults.standard.set(waist, forKey: "lote_body_waist")
        UserDefaults.standard.set(hips, forKey: "lote_body_hips")
        UserDefaults.standard.set(legs, forKey: "lote_body_legs")
        
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
    }
    
    // MARK: - XP & Rewards Engine
    public func addXP(_ amount: Int) {
        currentXP += amount
        let xpNeeded = requiredXPForLevel(currentLevel)
        if currentXP >= xpNeeded {
            currentXP -= xpNeeded
            currentLevel += 1
            crystals += 50 // Level up reward
            
            // Random Stat Increase on Level Up!
            if let randomStat = StatType.allCases.randomElement() {
                stats.increase(randomStat, by: 1)
            }
        }
    }
    
    public func requiredXPForLevel(_ lvl: Int) -> Int {
        return 100 + (lvl * 50)
    }
    
    public func earnCrystals(_ amount: Int) {
        crystals += amount
    }
    
    // MARK: - Quest Actions
    public func completeQuest(_ quest: LotEQuest, rollValue: Int) -> Bool {
        guard let idx = dailyQuests.firstIndex(where: { $0.id == quest.id }),
              !dailyQuests[idx].isCompleted else {
            return false
        }
        
        // D&D Stat Bonus Modifier
        let statBonus = getStatModifier(for: quest.statReward)
        let totalRoll = rollValue + statBonus
        
        if totalRoll >= quest.difficultyRoll {
            dailyQuests[idx].isCompleted = true
            addXP(quest.rewardXP)
            earnCrystals(quest.rewardCrystals)
            stats.increase(quest.statReward, by: quest.statValue)
            updateStreakOnActivity()
            return true
        } else {
            // Failed roll reward (consolation XP)
            addXP(quest.rewardXP / 3)
            return false
        }
    }
    
    public func logHealthyMeal() {
        healthyMealsLoggedToday += 1
        earnCrystals(10)
        addXP(15)
        stats.increase(.constitution, by: 1)
        updateStreakOnActivity()
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
    
    // MARK: - Day Refresh & Streak Engine
    private func checkNewDayRefresh() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastDate = lastActiveDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            let diff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
            
            if diff > 0 {
                // It's a new day!
                healthyMealsLoggedToday = 0
                regenerateDailyQuests()
                
                if diff > 1 {
                    // Streak broken
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
        self.dailyQuests = generateQuests(forElementName: elementName, focuses: selectedFocuses)
    }
}
