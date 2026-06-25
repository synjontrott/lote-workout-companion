//
//  LotEModels.swift
//  LotE Workout Companion
//
//  Created by Antigravity on 6/23/26.
//

import SwiftUI

// MARK: - Element Lore & Theme Colors
public struct LotEElement: Identifiable, Codable, Equatable {
    public var id: String { name }
    public let name: String
    public let corruptName: String
    public let description: String
    public let corruptDescription: String
    public let standardDetails: String
    public let corruptDetails: String
    public let balancedDetails: String
    public let primaryColorHex: String
    public let accentColorHex: String
    public let planetOfOrigin: String
    public let inherentDark: Bool
    
    public var primaryColor: Color {
        Color(hex: primaryColorHex) ?? .red
    }
    
    public var accentColor: Color {
        Color(hex: accentColorHex) ?? .orange
    }
    
    public func displayName(for expression: ExpressionStyle) -> String {
        if inherentDark { return name }
        switch expression {
        case .standard: return name
        case .corrupt: return corruptName
        case .balanced: return "Balanced \(name)"
        }
    }
}

// MARK: - Expression Style
public enum ExpressionStyle: String, Codable, CaseIterable {
    case standard = "Standard (Light)"
    case corrupt = "Corrupted (Dark)"
    case balanced = "Balanced (Irghposan)"
}

// MARK: - D&D Stats Sheet
public struct DNDStats: Codable, Equatable {
    public var strength: Int = 10
    public var dexterity: Int = 10
    public var constitution: Int = 10
    public var intelligence: Int = 10
    public var wisdom: Int = 10
    public var charisma: Int = 10
    
    public mutating func increase(_ stat: StatType, by amount: Int) {
        switch stat {
        case .strength: strength += amount
        case .dexterity: dexterity += amount
        case .constitution: constitution += amount
        case .intelligence: intelligence += amount
        case .wisdom: wisdom += amount
        case .charisma: charisma += amount
        }
    }
}

public enum StatType: String, Codable, CaseIterable {
    case strength = "Strength"
    case dexterity = "Dexterity"
    case constitution = "Constitution"
    case intelligence = "Intelligence"
    case wisdom = "Wisdom"
    case charisma = "Charisma"
}

// MARK: - Level Tiers
public enum WarriorTier: String, Codable, CaseIterable {
    case recruit = "Elsaither Recruit"
    case apprentice = "Krenpowen Apprentice"
    case vanguard = "Warrion Vanguard"
    case sentinel = "Ninjonian Sentinel"
    case master = "Irghposan Master"
    case legend = "Legend of the Elsaither"
    
    public var description: String {
        switch self {
        case .recruit: return "A newly awakened warrior finding their resonance. Every step is a discovery."
        case .apprentice: return "Standard elemental channeler learning to shape raw energy and control output."
        case .vanguard: return "Grounded, resilient warrior with refined elemental control and deep endurance."
        case .sentinel: return "Highly disciplined elite protector showing perfect form, technique, and willpower."
        case .master: return "A rare champion who harnesses the power inside or the darkness within."
        case .legend: return "Achieved perfect balance and raw spatial mastery. A force of the cosmos."
        }
    }
    
    public var levelRequired: Int {
        switch self {
        case .recruit: return 1
        case .apprentice: return 5
        case .vanguard: return 12
        case .sentinel: return 20
        case .master: return 35
        case .legend: return 50
        }
    }

    public func displayName(for elementName: String) -> String {
        switch elementName {
        case "Fire":
            switch self {
            case .recruit: return "Ember Recruit"
            case .apprentice: return "Flame Apprentice"
            case .vanguard: return "Cinder Vanguard"
            case .sentinel: return "Blaze Sentinel"
            case .master: return "Inferno Master"
            case .legend: return "Legend of the Phoenix"
            }
        case "Water":
            switch self {
            case .recruit: return "Tide Recruit"
            case .apprentice: return "Hydro Apprentice"
            case .vanguard: return "Torrent Vanguard"
            case .sentinel: return "Wave Sentinel"
            case .master: return "Abyss Master"
            case .legend: return "Legend of the Ocean"
            }
        case "Earth":
            switch self {
            case .recruit: return "Stone Recruit"
            case .apprentice: return "Clay Apprentice"
            case .vanguard: return "Rock Vanguard"
            case .sentinel: return "Ridge Sentinel"
            case .master: return "Mountain Master"
            case .legend: return "Legend of the Golem"
            }
        case "Air":
            switch self {
            case .recruit: return "Wind Recruit"
            case .apprentice: return "Gale Apprentice"
            case .vanguard: return "Zephyr Vanguard"
            case .sentinel: return "Vortex Sentinel"
            case .master: return "Tempest Master"
            case .legend: return "Legend of the Storm"
            }
        case "Lightning":
            switch self {
            case .recruit: return "Spark Recruit"
            case .apprentice: return "Bolt Apprentice"
            case .vanguard: return "Shock Vanguard"
            case .sentinel: return "Storm Sentinel"
            case .master: return "Voltage Master"
            case .legend: return "Legend of Thunder"
            }
        case "Metal":
            switch self {
            case .recruit: return "Iron Recruit"
            case .apprentice: return "Steel Apprentice"
            case .vanguard: return "Alloy Vanguard"
            case .sentinel: return "Shield Sentinel"
            case .master: return "Forge Master"
            case .legend: return "Legend of Titanium"
            }
        case "Ice":
            switch self {
            case .recruit: return "Frost Recruit"
            case .apprentice: return "Ice Apprentice"
            case .vanguard: return "Glacier Vanguard"
            case .sentinel: return "Shard Sentinel"
            case .master: return "Tundra Master"
            case .legend: return "Legend of Blizzard"
            }
        case "Bone":
            switch self {
            case .recruit: return "Calcium Recruit"
            case .apprentice: return "Skeletal Apprentice"
            case .vanguard: return "Fossil Vanguard"
            case .sentinel: return "Marrow Sentinel"
            case .master: return "Crypt Master"
            case .legend: return "Legend of the Grave"
            }
        case "Gas":
            switch self {
            case .recruit: return "Vapor Recruit"
            case .apprentice: return "Mist Apprentice"
            case .vanguard: return "Cloud Vanguard"
            case .sentinel: return "Fume Sentinel"
            case .master: return "Plasma Master"
            case .legend: return "Legend of Atmosphere"
            }
        case "Laser":
            switch self {
            case .recruit: return "Ray Recruit"
            case .apprentice: return "Beam Apprentice"
            case .vanguard: return "Pulse Vanguard"
            case .sentinel: return "Focus Sentinel"
            case .master: return "Photon Master"
            case .legend: return "Legend of the Cosmos"
            }
        case "Zero Space":
            switch self {
            case .recruit: return "Node Recruit"
            case .apprentice: return "Rift Apprentice"
            case .vanguard: return "Warp Vanguard"
            case .sentinel: return "Gate Sentinel"
            case .master: return "Singularity Master"
            case .legend: return "Legend of the Void"
            }
        case "Darki":
            switch self {
            case .recruit: return "Dark Recruit"
            case .apprentice: return "Shade Apprentice"
            case .vanguard: return "Night Vanguard"
            case .sentinel: return "Royal Sentinel"
            case .master: return "Sovereign Master"
            case .legend: return "Legend of Eclipse"
            }
        case "Death":
            switch self {
            case .recruit: return "Wither Recruit"
            case .apprentice: return "Decay Apprentice"
            case .vanguard: return "Reaper Vanguard"
            case .sentinel: return "Soul Sentinel"
            case .master: return "Crypt Master"
            case .legend: return "Legend of Doom"
            }
        case "Knife":
            switch self {
            case .recruit: return "Edge Recruit"
            case .apprentice: return "Blade Apprentice"
            case .vanguard: return "Dagger Vanguard"
            case .sentinel: return "Pierce Sentinel"
            case .master: return "Saber Master"
            case .legend: return "Legend of the Sword"
            }
        case "Poison":
            switch self {
            case .recruit: return "Venom Recruit"
            case .apprentice: return "Toxin Apprentice"
            case .vanguard: return "Viper Vanguard"
            case .sentinel: return "Acid Sentinel"
            case .master: return "Serum Master"
            case .legend: return "Legend of Plague"
            }
        case "Shadow":
            switch self {
            case .recruit: return "Shade Recruit"
            case .apprentice: return "Dusk Apprentice"
            case .vanguard: return "Veil Vanguard"
            case .sentinel: return "Phantom Sentinel"
            case .master: return "Eclipse Master"
            case .legend: return "Legend of the Ghost"
            }
        default:
            return rawValue
        }
    }
}

// MARK: - Character Sprite Creator
public struct CharacterSprite: Codable, Equatable {
    public var hairStyle: String = "Spiky"
    public var hairColorHex: String = "#FFEA00"
    public var skinColorHex: String = "#FFD180"
    public var outfitStyle: String = "Ninjonia"
    public var outfitColorHex: String = "#37474F"
    public var auraStyle: String = "Flames"
    public var sex: String = "Male"
    
    // Pixel grid representation: 16x16 pixels
    // 0 = empty, 1 = skin, 2 = hair, 3 = eyes, 4 = outfit, 5 = aura
    public var pixelGrid: [[Int]] = Array(repeating: Array(repeating: 0, count: 16), count: 16)
    
    enum CodingKeys: String, CodingKey {
        case hairStyle, hairColorHex, skinColorHex, outfitStyle, outfitColorHex, auraStyle, pixelGrid, sex
    }
    
    public init(hairStyle: String = "Spiky",
                hairColorHex: String = "#FFEA00",
                skinColorHex: String = "#FFD180",
                outfitStyle: String = "Ninjonia",
                outfitColorHex: String = "#37474F",
                auraStyle: String = "Flames",
                sex: String = "Male",
                pixelGrid: [[Int]]? = nil) {
        self.hairStyle = hairStyle
        self.hairColorHex = hairColorHex
        self.skinColorHex = skinColorHex
        self.outfitStyle = outfitStyle
        self.outfitColorHex = outfitColorHex
        self.auraStyle = auraStyle
        self.sex = sex
        self.pixelGrid = pixelGrid ?? CharacterSprite.defaultGrid
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hairStyle = try container.decodeIfPresent(String.self, forKey: .hairStyle) ?? "Spiky"
        hairColorHex = try container.decodeIfPresent(String.self, forKey: .hairColorHex) ?? "#FFEA00"
        skinColorHex = try container.decodeIfPresent(String.self, forKey: .skinColorHex) ?? "#FFD180"
        outfitStyle = try container.decodeIfPresent(String.self, forKey: .outfitStyle) ?? "Ninjonia"
        outfitColorHex = try container.decodeIfPresent(String.self, forKey: .outfitColorHex) ?? "#37474F"
        auraStyle = try container.decodeIfPresent(String.self, forKey: .auraStyle) ?? "Flames"
        sex = try container.decodeIfPresent(String.self, forKey: .sex) ?? "Male"
        pixelGrid = try container.decodeIfPresent([[Int]].self, forKey: .pixelGrid) ?? CharacterSprite.defaultGrid
    }
    
    public static var defaultGrid: [[Int]] {
        var grid = Array(repeating: Array(repeating: 0, count: 16), count: 16)
        // Draw a simple 16x16 character sprite template
        // Head / Skin (rows 4 to 8, cols 5 to 10)
        for r in 4...8 {
            for c in 5...10 {
                grid[r][c] = 1
            }
        }
        // Hair (rows 2 to 4, cols 4 to 11)
        for r in 2...3 {
            for c in 4...11 {
                grid[r][c] = 2
            }
        }
        grid[4][4] = 2
        grid[4][11] = 2
        // Eyes
        grid[6][6] = 3
        grid[6][9] = 3
        // Body / Outfit (rows 9 to 13, cols 5 to 10)
        for r in 9...13 {
            for c in 5...10 {
                grid[r][c] = 4
            }
        }
        // Legs (row 14, cols 5 and 10)
        grid[14][5] = 4
        grid[14][10] = 4
        // Aura (surrounding border)
        grid[1][3] = 5; grid[1][12] = 5
        grid[5][2] = 5; grid[5][13] = 5
        grid[9][2] = 5; grid[9][13] = 5
        grid[13][3] = 5; grid[13][12] = 5
        
        return grid
    }
}

// MARK: - Psychological Profile Types
public enum CognitiveProfile: String, Codable, CaseIterable {
    case adhd = "The Flame Sentinel"
    case autistic = "The Iron Archivist"
    case audhd = "The Chimera"
    case neurotypical = "The Radiant Vanguard"
    
    public init?(safeValue: String) {
        if let direct = CognitiveProfile(rawValue: safeValue) {
            self = direct
            return
        }
        let lower = safeValue.lowercased()
        if lower.contains("adhd") || lower.contains("sentinel") {
            self = .adhd
        } else if lower.contains("autistic") || lower.contains("archivist") {
            self = .autistic
        } else if lower.contains("audhd") || lower.contains("chimera") {
            self = .audhd
        } else if lower.contains("neurotypical") || lower.contains("vanguard") {
            self = .neurotypical
        } else {
            return nil
        }
    }
    
    public var title: String {
        return self.rawValue
    }
    
    public var description: String {
        switch self {
        case .adhd:
            return "Dopamine-seeking and novelty-driven. You excel when workouts are varied, gamified, and reward you with instant excitement. Routines can feel heavy, so flexibility and quick 'Dopamine Menu' challenges are your secret weapon."
        case .autistic:
            return "Structure-seeking and analytical. You thrive on consistent routines, clear schedules, direct expectations, and deep progress analytics. You find comfort in predictability and detailed records of your training."
        case .audhd:
            return "A unique blend of structure and high-energy novelty. You need a structured skeleton framework to stay grounded, but you require flexible, custom options within that framework to prevent demand avoidance."
        case .neurotypical:
            return "Progressive-overload and habit-loop oriented. You respond well to classic progressive training, habit stacking, goal milestones, and consistent streaks that build up over time."
        }
    }
}

// MARK: - Weight Entry
public struct WeightEntry: Codable, Equatable, Identifiable {
    public var id: UUID { UUID() }
    public let date: Date
    public let weight: Double
    
    public init(date: Date, weight: Double) {
        self.date = date
        self.weight = weight
    }
}

// MARK: - Body Measurement Entry
public struct BodyMeasurementEntry: Codable, Equatable, Identifiable {
    public var id: UUID
    public let date: Date
    public let weight: Double
    public let chest: Double
    public let arms: Double
    public let waist: Double
    public let hips: Double
    public let legs: Double
    
    public init(id: UUID = UUID(), date: Date = Date(), weight: Double, chest: Double, arms: Double, waist: Double, hips: Double, legs: Double) {
        self.id = id
        self.date = date
        self.weight = weight
        self.chest = chest
        self.arms = arms
        self.waist = waist
        self.hips = hips
        self.legs = legs
    }
}

// MARK: - Quest Cadence
public enum QuestCadence: String, Codable, CaseIterable {
    case daily = "Daily"
    case monthly = "Monthly"
    case yearly = "Yearly"
}

// MARK: - Shop Item
public struct ShopItem: Identifiable, Codable, Equatable {
    public var id: String { name }
    public let name: String
    public let cost: Int
    public let description: String
    public let type: String // "frame", "title", "aura", "background", "accessory", "stat", "badge"
    
    public init(name: String, cost: Int, description: String, type: String) {
        self.name = name
        self.cost = cost
        self.description = description
        self.type = type
    }
    
    public static var availableItems: [ShopItem] {
        return [
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
            ShopItem(name: "Zen Garden", cost: 200, description: "Serene meditation backdrop", type: "background"),
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
            ShopItem(name: "Celestial Dragon Badge", cost: 100, description: "Unlocks the special celestial dragon profile badge", type: "badge")
        ]
    }
}

// MARK: - Fitness Badge
public struct FitnessBadge: Identifiable, Codable, Equatable {
    public var id: String { name }
    public let name: String
    public let description: String
    public let iconName: String
    
    public init(name: String, description: String, iconName: String) {
        self.name = name
        self.description = description
        self.iconName = iconName
    }
    
    public static var allBadges: [FitnessBadge] {
        return [
            FitnessBadge(name: "First Step", description: "Walk 10,000 steps in a single day", iconName: "figure.walk"),
            FitnessBadge(name: "Flame Starter", description: "Unlock 5 fitness challenges or quests", iconName: "flame.fill"),
            FitnessBadge(name: "Lore Scholar", description: "Complete the initial psychological evaluations", iconName: "brain"),
            FitnessBadge(name: "Weight Target Achieved", description: "Successfully reach your target weight goal", iconName: "checkmark.seal.fill"),
            FitnessBadge(name: "Streak Master", description: "Achieve a consecutive 7-day streak of workouts", iconName: "crown.fill"),
            FitnessBadge(name: "Guild Patron", description: "Buy your first stat elixir or cosmetic from the shop", iconName: "cart.fill"),
            FitnessBadge(name: "Demi-God", description: "Achieve an Attribute level of 18 or higher in any stat", iconName: "sparkles"),
            // Stretch goals
            FitnessBadge(name: "20k Steps Sentinel", description: "Walk 20,000 steps in a single day", iconName: "figure.walk"),
            FitnessBadge(name: "Iron Will (1 Hr)", description: "Complete a 1-hour active workout", iconName: "stopwatch"),
            FitnessBadge(name: "Unstoppable Force (2 Hr)", description: "Complete a 2-hour active workout", iconName: "stopwatch.fill"),
            FitnessBadge(name: "Quest Crusader (100 Quests)", description: "Complete 100 fitness quests", iconName: "checklist"),
            FitnessBadge(name: "Legendary Champion (1000 Quests)", description: "Complete 1000 fitness quests", iconName: "medal.fill"),
            FitnessBadge(name: "Vanguard Streak (14 Days)", description: "Achieve a consecutive 14-day workout streak", iconName: "flame.fill"),
            FitnessBadge(name: "Sovereign Streak (30 Days)", description: "Achieve a consecutive 30-day workout streak", iconName: "flame.fill"),
            FitnessBadge(name: "Immortal Streak (100 Days)", description: "Achieve a consecutive 100-day workout streak", iconName: "flame.fill")
        ]
    }
}

public struct MealEntry: Codable, Identifiable {
    public var id: UUID
    public var date: Date
    public var name: String
    public var calories: Double
    public var protein: Double
    public var carbs: Double
    public var fats: Double
    public var sugar: Double
    
    enum CodingKeys: String, CodingKey {
        case id, date, name, calories, protein, carbs, fats, sugar
    }
    
    public init(id: UUID = UUID(), date: Date = Date(), name: String, calories: Double, protein: Double, carbs: Double, fats: Double, sugar: Double) {
        self.id = id
        self.date = date
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
        self.sugar = sugar
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        date = try container.decodeIfPresent(Date.self, forKey: .date) ?? Date()
        name = try container.decode(String.self, forKey: .name)
        calories = try container.decode(Double.self, forKey: .calories)
        protein = try container.decode(Double.self, forKey: .protein)
        carbs = try container.decode(Double.self, forKey: .carbs)
        fats = try container.decode(Double.self, forKey: .fats)
        sugar = try container.decodeIfPresent(Double.self, forKey: .sugar) ?? 0.0
    }
}

// MARK: - Quest Structure
public struct LotEQuest: Codable, Identifiable {
    public var id: UUID
    public var title: String
    public var questDescription: String
    public var workoutType: WorkoutCategory
    public var difficultyRoll: Int
    public var rewardXP: Int
    public var rewardCrystals: Int
    public var statReward: StatType
    public var statValue: Int
    public var isCompleted: Bool
    public var dateCreated: Date
    public var cadence: QuestCadence
    public var progressCount: Int
    public var targetCount: Int
    
    public var progressRatio: Double {
        return Double(progressCount) / Double(max(1, targetCount))
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, questDescription, workoutType, difficultyRoll, rewardXP, rewardCrystals, statReward, statValue, isCompleted, dateCreated, cadence, progressCount, targetCount
    }
    
    public init(id: UUID = UUID(),
                title: String,
                questDescription: String,
                workoutType: WorkoutCategory,
                difficultyRoll: Int,
                rewardXP: Int,
                rewardCrystals: Int,
                statReward: StatType,
                statValue: Int,
                isCompleted: Bool = false,
                dateCreated: Date = Date(),
                cadence: QuestCadence = .daily,
                progressCount: Int = 0,
                targetCount: Int = 1) {
        self.id = id
        self.title = title
        self.questDescription = questDescription
        self.workoutType = workoutType
        self.difficultyRoll = difficultyRoll
        self.rewardXP = rewardXP
        self.rewardCrystals = rewardCrystals
        self.statReward = statReward
        self.statValue = statValue
        self.isCompleted = isCompleted
        self.dateCreated = dateCreated
        self.cadence = cadence
        self.progressCount = progressCount
        self.targetCount = targetCount
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        title = try container.decode(String.self, forKey: .title)
        questDescription = try container.decode(String.self, forKey: .questDescription)
        workoutType = try container.decode(WorkoutCategory.self, forKey: .workoutType)
        difficultyRoll = try container.decode(Int.self, forKey: .difficultyRoll)
        rewardXP = try container.decode(Int.self, forKey: .rewardXP)
        rewardCrystals = try container.decode(Int.self, forKey: .rewardCrystals)
        statReward = try container.decode(StatType.self, forKey: .statReward)
        statValue = try container.decode(Int.self, forKey: .statValue)
        isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted) ?? false
        dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated) ?? Date()
        cadence = try container.decodeIfPresent(QuestCadence.self, forKey: .cadence) ?? .daily
        progressCount = try container.decodeIfPresent(Int.self, forKey: .progressCount) ?? 0
        targetCount = try container.decodeIfPresent(Int.self, forKey: .targetCount) ?? 1
    }
    
    public static var dailyDefaults: [LotEQuest] {
        return [
            LotEQuest(title: "Patrol the Whispering Woods", questDescription: "A brisk walk or run to clear out stray energy beasts. Requires 15 mins of activity.", workoutType: .cardio, difficultyRoll: 8, rewardXP: 40, rewardCrystals: 15, statReward: .dexterity, statValue: 1, progressCount: 0, targetCount: 1),
            LotEQuest(title: "Earth Shaking Forging", questDescription: "Lift heavy weights, do bodyweight exercises, or strength training. Perform 20 mins.", workoutType: .strength, difficultyRoll: 10, rewardXP: 60, rewardCrystals: 25, statReward: .strength, statValue: 1, progressCount: 0, targetCount: 1),
            LotEQuest(title: "Mobility Routine", questDescription: "Perform a mobility routine, stretching, or yoga to improve flexibility. 15 mins.", workoutType: .flexibility, difficultyRoll: 6, rewardXP: 30, rewardCrystals: 10, statReward: .wisdom, statValue: 1, progressCount: 0, targetCount: 1),
            LotEQuest(title: "Consuming Healthy Rations", questDescription: "Log a protein-rich, nourishing meal with fresh vegetables and clean energy hydration.", workoutType: .nutrition, difficultyRoll: 5, rewardXP: 25, rewardCrystals: 10, statReward: .constitution, statValue: 1, progressCount: 0, targetCount: 1)
        ]
    }
}

public enum WorkoutCategory: String, Codable, CaseIterable {
    case cardio = "Cardio Patrol"
    case strength = "Strength Forge"
    case flexibility = "Flexibility Stream"
    case nutrition = "Healthy Rations"
    case meditation = "Mental Focus"
}

// MARK: - Training Focus Objectives
public enum TrainingFocus: String, Codable, CaseIterable, Identifiable {
    public var id: String { rawValue }
    case calisthenics = "Calisthenics"
    case lifting = "Lifting"
    case bulking = "Bulking"
    case cutting = "Cutting"
    case flexibility = "Yoga & Flexibility"
    case cardio = "Cardio"
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let str = try container.decode(String.self)
        if str == "Weight Gain" || str == "weightGain" || str == "Bulking" || str == "bulking" {
            self = .bulking
        } else if let val = TrainingFocus(rawValue: str) {
            self = val
        } else {
            self = .cardio
        }
    }
}

public func generateQuests(forElementName element: String, focuses: [TrainingFocus], cadence: QuestCadence) -> [LotEQuest] {
    var quests: [LotEQuest] = []
    
    // Fallback if no focuses are selected
    let activeFocuses = focuses.isEmpty ? [.cardio, .calisthenics] : focuses
    
    // Element theme adjective mapping
    let themeWords: [String] = {
        switch element {
        case "Fire": return ["Blazing", "Ember", "Pyro", "Combustion", "Ignition", "Thermal", "Volcanic"]
        case "Water": return ["Tidal", "Aqua", "Fluid", "Torrent", "Hydro", "Oceanic", "Cascade"]
        case "Earth": return ["Stone", "Terra", "Gravel", "Rock", "Seismic", "Tectonic", "Mineral"]
        case "Air": return ["Zephyr", "Aero", "Gale", "Cyclone", "Atmospheric", "Draft", "Breeze"]
        case "Lightning": return ["Volt", "Spark", "Arc", "Charged", "Plasma", "Tesla", "Electro"]
        case "Metal": return ["Steel", "Iron", "Alloy", "Titanium", "Chrome", "Forged", "Metallic"]
        case "Ice": return ["Frost", "Glacial", "Arctic", "Chilled", "Frozen", "Blizzard", "Cryo"]
        case "Bone": return ["Skeletal", "Marrow", "Calcium", "Osteo", "Calcified", "Spined", "Ossified"]
        case "Gas": return ["Vapor", "Aerosol", "Fume", "Mist", "Fog", "Haze", "Gaseous"]
        case "Laser": return ["Beam", "Photon", "Arc", "Reactor", "Focus", "Ray", "Laser"]
        case "Zero Space": return ["Void", "Cosmic", "Astral", "Gravity", "Dimensional", "Nebula", "Warp"]
        case "Darki": return ["Umbral", "Corrupt", "Shadow", "Nightfall", "Vesper", "Abyssal", "Eclipse"]
        case "Death": return ["Decay", "Morbid", "Necro", "Withered", "Cryptic", "Grave", "Doom"]
        case "Knife": return ["Razor", "Blade", "Surgical", "Lethal", "Dagger", "Edge", "Shear"]
        case "Poison": return ["Toxic", "Venom", "Acid", "Noxious", "Serum", "Vial", "Biohazard"]
        case "Shadow": return ["Phantom", "Spectral", "Stealth", "Silhouette", "Veiled", "Cloaked", "Mirage"]
        default: return ["Astral", "Mystic", "Ethereal", "Primeval", "Ancient", "Cosmic"]
        }
    }()
    
    if cadence == .daily {
        // Collect unique focuses
        var uniqueFocuses: [TrainingFocus] = []
        for focus in activeFocuses {
            if !uniqueFocuses.contains(focus) {
                uniqueFocuses.append(focus)
            }
        }
        
        // Backfill with other focuses if less than 4, ensuring absolute uniqueness
        if uniqueFocuses.count < 4 {
            for f in TrainingFocus.allCases {
                if !uniqueFocuses.contains(f) && uniqueFocuses.count < 4 {
                    uniqueFocuses.append(f)
                }
            }
        }
        
        // Generate up to 4 unique daily quests
        for i in 0..<min(4, uniqueFocuses.count) {
            let adjective = themeWords[i % themeWords.count]
            let focus = uniqueFocuses[i]
            let questId = UUID()
            let title: String
            let desc: String
            let wType: WorkoutCategory
            let stat: StatType
            
            switch focus {
            case .calisthenics:
                let titles = [
                    "\(adjective) Gravity Defiance",
                    "\(adjective) Gymnastic Ascent",
                    "Acrobatic \(adjective) Leverage",
                    "Ascetic \(adjective) Bar Drill",
                    "Suspended \(adjective) Static Hold",
                    "\(adjective) Lever Conditioning",
                    "Aura-Fueled Calisthenics Mastery",
                    "\(adjective) Kinetic Core Release"
                ]
                title = titles[i % titles.count]
                desc = "Perform bodyweight dips, pushups, pullups, or handstands. Complete 15 minutes."
                wType = .strength
                stat = .strength
            case .lifting:
                let titles = [
                    "\(adjective) Heavy Forging",
                    "\(adjective) Steel Press Protocol",
                    "Cataclysmic \(adjective) Deadlift",
                    "Barbarian \(adjective) Squat Ascent",
                    "Titan \(adjective) Bench Mastery",
                    "\(adjective) Iron Load Injection",
                    "Aura-Infused Muscle Forge",
                    "\(adjective) Density Progression"
                ]
                title = titles[i % titles.count]
                desc = "Perform squat, bench, or deadlift reps. Complete 20 minutes of heavy structural loading."
                wType = .strength
                stat = .strength
            case .cardio:
                let titles = [
                    "\(adjective) Speed Patrol",
                    "Swift \(adjective) Horizon Run",
                    "\(adjective) Windwalker Interval",
                    "Tempest \(adjective) Trail Sweep",
                    "\(adjective) Kinetic Gale Jog",
                    "Aura-Boosted Endurance Dash",
                    "\(adjective) Boundary Sprint",
                    "Vanguard \(adjective) Scout Patrol"
                ]
                title = titles[i % titles.count]
                desc = "Complete a 15-minute run, jog, cycle, or cardio sprint."
                wType = .cardio
                stat = .dexterity
            case .flexibility:
                let titles = [
                    "\(adjective) Elemental Flow",
                    "Fluid \(adjective) Limbering",
                    "\(adjective) Meridian Release",
                    "Zephyr-Like \(adjective) Extension",
                    "Aura-Stretched Range Recovery",
                    "\(adjective) Elasticity Session",
                    "Serene \(adjective) Muscle Lengthening",
                    "\(adjective) Kinetic Joints Tuning"
                ]
                title = titles[i % titles.count]
                desc = "Perform a flexibility, yoga, or dynamic mobility routine. Complete 15 minutes."
                wType = .flexibility
                stat = .wisdom
            case .cutting:
                let titles = [
                    "\(adjective) Light Burn",
                    "\(adjective) Deficit Vaporization",
                    "Purified \(adjective) Metabolic Trim",
                    "Aura-Fueled Lipid Purge",
                    "\(adjective) Lean Fuel Protocol",
                    "Sovereign \(adjective) Fasting Log"
                ]
                title = titles[i % titles.count]
                desc = "Log a high-protein, calorie-deficit meal to burn off excess fat."
                wType = .nutrition
                stat = .constitution
            case .bulking:
                let titles = [
                    "\(adjective) Nutrient Bulk",
                    "\(adjective) Caloric Anabolism",
                    "Dense \(adjective) Mass Synthesis",
                    "Sovereign \(adjective) Heavy Feast",
                    "\(adjective) Hypertrophic Load Fuel",
                    "Aura-Bound Core Mass Build"
                ]
                title = titles[i % titles.count]
                desc = "Log a calorie-dense bulking meal to build size."
                wType = .nutrition
                stat = .constitution
            }
            
            quests.append(LotEQuest(
                id: questId,
                title: title,
                questDescription: desc,
                workoutType: wType,
                difficultyRoll: Int.random(in: 8...12),
                rewardXP: 60,
                rewardCrystals: 20,
                statReward: stat,
                statValue: 1,
                isCompleted: false,
                dateCreated: Date(),
                cadence: .daily,
                progressCount: 0,
                targetCount: 1
            ))
        }
    } else if cadence == .monthly {
        // Generate 2 monthly challenges
        for i in 0..<2 {
            let adjective = themeWords[(i + 4) % themeWords.count]
            let focus = activeFocuses[i % activeFocuses.count]
            let title: String
            let desc: String
            let stat: StatType
            let wType: WorkoutCategory
            let target: Int
            
            switch focus {
            case .calisthenics:
                let titles = ["\(adjective) Bar Mastery Campaign", "Sovereign \(adjective) Calisthenics Master"]
                title = titles[i % titles.count]
                desc = "Complete 10 calisthenics sessions (handstands, pullups) this month."
                wType = .strength
                stat = .strength
                target = 10
            case .lifting:
                let titles = ["\(adjective) Iron Forge Campaign", "Titan \(adjective) Weight Ascendance"]
                title = titles[i % titles.count]
                desc = "Complete 10 heavy lifting sessions (squats, deadlifts) this month."
                wType = .strength
                stat = .strength
                target = 10
            case .cardio:
                let titles = ["\(adjective) Marathon Crusade", "\(adjective) Swiftness Road Campaign"]
                title = titles[i % titles.count]
                desc = "Complete 10 cardio workout sessions this month."
                wType = .cardio
                stat = .dexterity
                target = 10
            case .flexibility:
                let titles = ["\(adjective) Meridian Alignment", "\(adjective) Joint Elasticity Campaign"]
                title = titles[i % titles.count]
                desc = "Complete 8 dynamic flexibility or stretching routines this month."
                wType = .flexibility
                stat = .wisdom
                target = 8
            case .cutting, .bulking:
                let titles = ["\(adjective) Metabolic Balance", "Pure \(adjective) Rations Crusade"]
                title = titles[i % titles.count]
                desc = "Log 15 healthy meals this month to hit target weight."
                wType = .nutrition
                stat = .constitution
                target = 15
            }
            
            quests.append(LotEQuest(
                id: UUID(),
                title: title,
                questDescription: desc,
                workoutType: wType,
                difficultyRoll: 14,
                rewardXP: 500,
                rewardCrystals: 200,
                statReward: stat,
                statValue: 3,
                isCompleted: false,
                dateCreated: Date(),
                cadence: .monthly,
                progressCount: 0,
                targetCount: target
            ))
        }
    } else if cadence == .yearly {
        // Generate 1 yearly campaign
        let adjective = themeWords.first ?? "Elemental"
        let focus = activeFocuses.first ?? .calisthenics
        let title: String
        let desc: String
        let wType: WorkoutCategory
        let target: Int
        
        switch focus {
        case .calisthenics:
            title = "Grand \(adjective) Gravity Champion"
            desc = "Maintain fitness goals and complete 100 calisthenics logs."
            wType = .strength
            target = 100
        case .lifting:
            title = "Grand \(adjective) Titan of Iron"
            desc = "Maintain fitness goals and complete 100 heavy lifting logs."
            wType = .strength
            target = 100
        case .cardio:
            title = "Grand \(adjective) Swiftness Legend"
            desc = "Maintain fitness goals and complete 100 cardio workouts."
            wType = .cardio
            target = 100
        case .flexibility:
            title = "Grand \(adjective) Spiritual Master"
            desc = "Maintain fitness goals and complete 80 flexibility sessions."
            wType = .flexibility
            target = 80
        case .cutting, .bulking:
            title = "Grand \(adjective) Alchemist of Flesh"
            desc = "Reach and sustain your target weight goals. Log 100 healthy meals."
            wType = .nutrition
            target = 100
        }
        
        quests.append(LotEQuest(
            id: UUID(),
            title: title,
            questDescription: desc,
            workoutType: wType,
            difficultyRoll: 18,
            rewardXP: 5000,
            rewardCrystals: 2000,
            statReward: .constitution,
            statValue: 5,
            isCompleted: false,
            dateCreated: Date(),
            cadence: .yearly,
            progressCount: 0,
            targetCount: target
        ))
    }
    
    return quests
}

// MARK: - Suggested Workout
public struct SuggestedWorkout: Identifiable, Codable, Equatable {
    public var id: String { name }
    public let name: String
    public let category: WorkoutCategory
    public let difficulty: String // "Easy", "Medium", "Hard", "Legend", "Master"
    public let equipment: String
    public let space: String
    public let description: String
    public let instructions: [String]
    public let sets: Int
    public let reps: String
    
    public static var allWorkouts: [SuggestedWorkout] {
        return [
            // STRENGTH WORKOUTS
            SuggestedWorkout(
                name: "Knee Pushups Foundation",
                category: .strength,
                difficulty: "Easy",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Build upper body pushing strength with knee pushups.",
                instructions: ["Get on your hands and knees", "Keep core tight", "Lower chest to ground", "Push back up"],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Standard Pushups Drill",
                category: .strength,
                difficulty: "Medium",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Standard bodyweight pushups for chest and triceps.",
                instructions: ["Assume high plank position", "Lower body until chest almost touches", "Push back up to plank"],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Diamond Pushups Precision",
                category: .strength,
                difficulty: "Hard",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Focus on triceps and inner chest using a close hand grip.",
                instructions: ["Place hands close forming a diamond", "Lower chest to hands", "Keep body in straight line", "Press up"],
                sets: 4,
                reps: "8-12 reps"
            ),
            SuggestedWorkout(
                name: "Archer Pushups Ascent",
                category: .strength,
                difficulty: "Legend",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Slide side-to-side to load one arm at a time.",
                instructions: ["Place hands very wide", "Lower to one side, extending other arm", "Push up and repeat on other side"],
                sets: 4,
                reps: "6-8 reps per side"
            ),
            SuggestedWorkout(
                name: "Handstand Pushups Mastery",
                category: .strength,
                difficulty: "Master",
                equipment: "Bodyweight Only",
                space: "Gym Space",
                description: "Ultimate vertical pushing strength against a wall or freestanding.",
                instructions: ["Kick up into a handstand against wall", "Lower head slowly to floor", "Press back up to straight arms"],
                sets: 5,
                reps: "5-8 reps"
            ),
            
            // CARDIO WORKOUTS
            SuggestedWorkout(
                name: "Jumping Jacks Ignite",
                category: .cardio,
                difficulty: "Easy",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "A simple cardiovascular warmup and aerobic builder.",
                instructions: ["Stand straight, feet together", "Jump while spreading legs and clapping hands overhead", "Return to start"],
                sets: 3,
                reps: "30 secs"
            ),
            SuggestedWorkout(
                name: "High Knees Interval",
                category: .cardio,
                difficulty: "Medium",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Develop speed and heart rate capacity.",
                instructions: ["Run in place raising knees to hip height", "Pump arms dynamically"],
                sets: 3,
                reps: "45 secs"
            ),
            SuggestedWorkout(
                name: "Tuck Jump Explosion",
                category: .cardio,
                difficulty: "Hard",
                equipment: "Bodyweight Only",
                space: "Large Room",
                description: "Explosive plyometric cardio jumps.",
                instructions: ["Stand with knees slightly bent", "Jump as high as possible, pulling knees to chest", "Land softly and repeat"],
                sets: 4,
                reps: "10 reps"
            ),
            SuggestedWorkout(
                name: "Double-Under Jump Rope",
                category: .cardio,
                difficulty: "Legend",
                equipment: "Rands/Rope",
                space: "Large Room",
                description: "High velocity jump rope conditioning.",
                instructions: ["Perform rope jumps, spinning rope twice per jump", "Maintain quick wrist flicks"],
                sets: 4,
                reps: "50 jumps"
            ),
            SuggestedWorkout(
                name: "Handstand Walking Cruise",
                category: .cardio,
                difficulty: "Master",
                equipment: "Bodyweight Only",
                space: "Gym Space",
                description: "Cardiovascular and coordinate challenge walking on hands.",
                instructions: ["Kick up into handstand", "Walk forward on hands controlling hips", "Walk 10 meters per set"],
                sets: 5,
                reps: "10 meters"
            ),
            
            // FLEXIBILITY WORKOUTS
            SuggestedWorkout(
                name: "Child's Pose Restorative",
                category: .flexibility,
                difficulty: "Easy",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Gentle stretch for lower back and shoulders.",
                instructions: ["Kneel and sit on heels", "Fold forward, extending arms on floor", "Breath deeply"],
                sets: 2,
                reps: "1 min hold"
            ),
            SuggestedWorkout(
                name: "Downward Dog Stretch",
                category: .flexibility,
                difficulty: "Medium",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Stretches hamstrings, calves, and shoulders.",
                instructions: ["Start in plank, push hips high and back", "Press heels toward floor", "Keep back flat"],
                sets: 3,
                reps: "45 secs hold"
            ),
            SuggestedWorkout(
                name: "Deep Pigeon Hip Release",
                category: .flexibility,
                difficulty: "Hard",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Intense hip opener for tight glutes.",
                instructions: ["Bring one knee forward, shin angled", "Extend back leg straight behind", "Lower torso over front leg"],
                sets: 3,
                reps: "1 min per side"
            ),
            SuggestedWorkout(
                name: "Full Splits Alignment",
                category: .flexibility,
                difficulty: "Legend",
                equipment: "Bodyweight Only",
                space: "Large Room",
                description: "Stretch hamstrings and hip flexors for side splits.",
                instructions: ["Extend front leg forward, back leg backward", "Lower hips slowly, supporting with hands", "Breathe"],
                sets: 3,
                reps: "30 secs hold"
            ),
            SuggestedWorkout(
                name: "Hollowback Handstand Arch",
                category: .flexibility,
                difficulty: "Master",
                equipment: "Bodyweight Only",
                space: "Gym Space",
                description: "Advanced shoulder and upper back mobility against wall.",
                instructions: ["Kick up to handstand facing away from wall", "Push shoulders open and arch chest out", "Breathe carefully"],
                sets: 3,
                reps: "20 secs hold"
            ),
            
            // MEDITATION WORKOUTS
            SuggestedWorkout(
                name: "Breath Awareness",
                category: .meditation,
                difficulty: "Easy",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Focus on nasal airflow to ground mind.",
                instructions: ["Sit comfortably with straight spine", "Observe breath enter and exit nose", "Gently return mind when distracted"],
                sets: 1,
                reps: "5 mins"
            ),
            SuggestedWorkout(
                name: "Body Scan Relaxation",
                category: .meditation,
                difficulty: "Medium",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Scan body parts systematically to release tension.",
                instructions: ["Lie down in Savasana", "Focus attention from toes up to crown", "Notice sensations, release holding"],
                sets: 1,
                reps: "10 mins"
            ),
            SuggestedWorkout(
                name: "Elemental Chakra Focusing",
                category: .meditation,
                difficulty: "Hard",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Meditate on your LotE elemental energy centers.",
                instructions: ["Sit in Lotus position", "Visualize your element's color at core", "Feel energy radiating through body"],
                sets: 1,
                reps: "15 mins"
            ),
            SuggestedWorkout(
                name: "Void Resonance Meditation",
                category: .meditation,
                difficulty: "Legend",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Settle into absolute silence and spatial emptiness.",
                instructions: ["Sit in dark room", "Clear all thoughts, resonance with zero space", "Dissolve sense of boundary"],
                sets: 1,
                reps: "20 mins"
            ),
            SuggestedWorkout(
                name: "Astral Space Integration",
                category: .meditation,
                difficulty: "Master",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Transcend consciousness into cosmic flow.",
                instructions: ["Achieve deep state of stillness", "Expand awareness beyond the physical room", "Connect with cosmic energy flow"],
                sets: 1,
                reps: "30 mins"
            ),
            
            // NUTRITION WORKOUTS
            SuggestedWorkout(
                name: "Hydration Ritual",
                category: .nutrition,
                difficulty: "Easy",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Drink 3 liters of fresh water daily.",
                instructions: ["Drink 500ml water upon waking", "Keep water container nearby", "Log hydration throughout day"],
                sets: 1,
                reps: "3 Liters"
            ),
            SuggestedWorkout(
                name: "Clean Protein Prep",
                category: .nutrition,
                difficulty: "Medium",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Batch cook clean protein rations for the week.",
                instructions: ["Purchase chicken, fish, or tofu", "Season and grill or bake", "Portion into 3 meal containers"],
                sets: 1,
                reps: "3 meals prepped"
            ),
            SuggestedWorkout(
                name: "Micro-Nutrient Optimization",
                category: .nutrition,
                difficulty: "Hard",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Include 5 colors of fresh vegetables in today's rations.",
                instructions: ["Select spinach (green), pepper (red), carrot (orange), cabbage (purple), onion (white)", "Incorporate into meals"],
                sets: 1,
                reps: "5 colors logged"
            ),
            SuggestedWorkout(
                name: "Advanced Bulking Prep",
                category: .nutrition,
                difficulty: "Legend",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Prep high protein, calorie-dense foods (e.g. rice, beef, eggs, nuts).",
                instructions: ["Measure ingredients for caloric surplus target", "Prep 4 high-calorie clean meals", "Log macros accurately"],
                sets: 1,
                reps: "4 meals prepped"
            ),
            SuggestedWorkout(
                name: "Chrono-Nutrition Fasting Alignment",
                category: .nutrition,
                difficulty: "Master",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Align nutrient intake to precise metabolic windows.",
                instructions: ["Consume all calories within an 8-hour window", "Fast for remaining 16 hours", "Hydrate with water only during fast"],
                sets: 1,
                reps: "16/8 window logged"
            ),
            
            // DUMBBELL STRENGTH WORKOUTS
            SuggestedWorkout(
                name: "Dumbbell Goblet Squat",
                category: .strength,
                difficulty: "Easy",
                equipment: "Dumbbells",
                space: "Small Room",
                description: "Lower body strength drill using a single front-held dumbbell.",
                instructions: ["Hold dumbbell vertically at chest", "Squat down keeping knees tracked outward", "Stand back up pressing feet into floor"],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Floor Press",
                category: .strength,
                difficulty: "Medium",
                equipment: "Dumbbells",
                space: "Small Room",
                description: "Triceps and chest builder performed on the floor to limit range safely.",
                instructions: ["Lie flat on back, knees bent", "Hold dumbbells over chest", "Lower elbows until they touch floor lightly", "Press back up"],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Renegade Row",
                category: .strength,
                difficulty: "Hard",
                equipment: "Dumbbells",
                space: "Small Room",
                description: "Challenging core stabilization combined with a back pull.",
                instructions: ["Assume plank on dumbbells", "Row one dumbbell to ribcage while keeping hips level", "Repeat on other side"],
                sets: 4,
                reps: "8-10 reps per arm"
            ),
            SuggestedWorkout(
                name: "Dumbbell Thrusters",
                category: .strength,
                difficulty: "Legend",
                equipment: "Dumbbells",
                space: "Large Room",
                description: "Full body integration squat pressing dumbbells overhead dynamically.",
                instructions: ["Rack dumbbells at shoulders", "Perform deep squat", "Explode up, pressing dumbbells overhead in one motion"],
                sets: 4,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Man-Makers",
                category: .strength,
                difficulty: "Master",
                equipment: "Dumbbells",
                space: "Gym Space",
                description: "Complex full-body movement: pushup, row, squat clean, thruster.",
                instructions: ["Pushup on dumbbells", "Row each arm", "Jump feet in, clean dumbbells to shoulders", "Perform thruster"],
                sets: 5,
                reps: "6-8 reps"
            ),
            
            // DUMBBELL CARDIO WORKOUTS
            SuggestedWorkout(
                name: "Dumbbell Shadow Boxing",
                category: .cardio,
                difficulty: "Easy",
                equipment: "Dumbbells",
                space: "Small Room",
                description: "Low-impact aerobic conditioning with light hand weights.",
                instructions: ["Hold light dumbbells at chin", "Perform controlled straight punches", "Keep feet active in boxer stance"],
                sets: 3,
                reps: "1 min"
            ),
            SuggestedWorkout(
                name: "Dumbbell Farmers Walk",
                category: .cardio,
                difficulty: "Medium",
                equipment: "Dumbbells",
                space: "Large Room",
                description: "Grip strength and heavy aerobic transport conditioning.",
                instructions: ["Hold heavy dumbbells at sides", "Walk in straight line, keeping chest up and shoulders back", "Turn and walk back"],
                sets: 3,
                reps: "1 min walk"
            ),
            SuggestedWorkout(
                name: "Dumbbell Devil Press",
                category: .cardio,
                difficulty: "Hard",
                equipment: "Dumbbells",
                space: "Large Room",
                description: "Burpee directly into a double dumbbell snatch to overhead.",
                instructions: ["Burpee chest-to-floor on dumbbells", "Jump feet up wide", "Swing dumbbells between legs, snatching them overhead"],
                sets: 4,
                reps: "10 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Clean & Press",
                category: .cardio,
                difficulty: "Legend",
                equipment: "Dumbbells",
                space: "Gym Space",
                description: "High velocity power conditioning using dumbbells.",
                instructions: ["Deadlift dumbbells, cleaning them to shoulders with hip pop", "Push press dumbbells overhead using legs"],
                sets: 4,
                reps: "12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Snatch Intervals",
                category: .cardio,
                difficulty: "Master",
                equipment: "Dumbbells",
                space: "Gym Space",
                description: "Rapid single-arm snatches to spike aerobic power.",
                instructions: ["Pull dumbbell from floor, punching it straight overhead in one clean path", "Switch arms and repeat at fast pace"],
                sets: 5,
                reps: "15 reps"
            )
        ]
    }
}

// MARK: - Helper Hex Color Extension
extension Color {
    init?(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0
        )
    }
}
