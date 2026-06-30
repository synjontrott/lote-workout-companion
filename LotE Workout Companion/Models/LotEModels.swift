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
    
    // Pixel grid representation: 50x50 pixels
    // 0 = empty, 1 = skin, 2 = hair, 3 = eyes, 4 = outfit, 5 = aura
    public var pixelGrid: [[Int]] = Array(repeating: Array(repeating: 0, count: 50), count: 50)
    
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
    
    public static func scale16To50(_ grid16: [[Int]]) -> [[Int]] {
        var grid50 = Array(repeating: Array(repeating: 0, count: 50), count: 50)
        for r in 0..<50 {
            for c in 0..<50 {
                let r16 = (r * 16) / 50
                let c16 = (c * 16) / 50
                grid50[r][c] = grid16[r16][c16]
            }
        }
        return grid50
    }
    
    public static var defaultGrid: [[Int]] {
        var grid = Array(repeating: Array(repeating: 0, count: 50), count: 50)
        
        // Aura (5)
        for r in 0..<50 {
            for c in 0..<50 {
                let dx = Double(c - 25)
                let dy = Double(r - 25)
                let dist = sqrt(dx*dx + dy*dy)
                if dist >= 21.0 && dist <= 23.0 {
                    if (r + c) % 3 == 0 { grid[r][c] = 5 }
                }
            }
        }
        
        // Torso / Armor (4)
        for r in 25...42 {
            for c in 16...34 {
                grid[r][c] = 4
            }
        }
        
        // Legs (4)
        for r in 43...47 {
            for c in 18...22 { grid[r][c] = 4 }
            for c in 28...32 { grid[r][c] = 4 }
        }
        // Boots
        for c in 17...23 { grid[48][c] = 4; grid[49][c] = 4 }
        for c in 27...33 { grid[48][c] = 4; grid[49][c] = 4 }
        
        // Head / Skin (1)
        for r in 12...24 {
            for c in 18...32 {
                grid[r][c] = 1
            }
        }
        
        // Eyes (3)
        grid[15][21] = 3; grid[15][22] = 3
        grid[16][21] = 3; grid[16][22] = 3
        grid[15][28] = 3; grid[15][29] = 3
        grid[16][28] = 3; grid[16][29] = 3
        
        // Hair (2)
        for r in 8...11 {
            for c in 16...34 { grid[r][c] = 2 }
        }
        for r in 12...16 {
            grid[r][17] = 2
            grid[r][33] = 2
        }
        
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
    public let sprite: String // Unicode emoji sprite representation
    
    public init(name: String, cost: Int, description: String, type: String, sprite: String) {
        self.name = name
        self.cost = cost
        self.description = description
        self.type = type
        self.sprite = sprite
    }
    
    public static var availableItems: [ShopItem] {
        return [
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
            ShopItem(name: "Celestial Dragon Badge", cost: 100, description: "Unlocks the special celestial dragon profile badge indicating elite status.", type: "badge", sprite: "🐉")
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
            FitnessBadge(name: "Immortal Streak (100 Days)", description: "Achieve a consecutive 100-day workout streak", iconName: "flame.fill"),
            // Monthly Challenges Badges
            FitnessBadge(name: "January Resolution Badge", description: "Complete the January challenge: Do 1,000 Pushups", iconName: "checkmark.seal"),
            FitnessBadge(name: "February Cardio Badge", description: "Complete the February challenge: Perform 300 minutes of Cardio", iconName: "figure.run"),
            FitnessBadge(name: "March Flexibility Badge", description: "Complete the March challenge: Perform 120 minutes of Yoga/Flexibility", iconName: "figure.mind.and.body"),
            FitnessBadge(name: "April Hydration Badge", description: "Complete the April challenge: Drink 90 Liters of water", iconName: "drop.fill"),
            FitnessBadge(name: "May Walkabout Badge", description: "Complete the May challenge: Walk 50 miles", iconName: "figure.walk"),
            FitnessBadge(name: "June Strength Badge", description: "Complete the June challenge: Complete 20 Strength Forge workouts", iconName: "dumbbell.fill"),
            FitnessBadge(name: "July Zen Badge", description: "Complete the July challenge: Perform 150 minutes of Meditation", iconName: "brain.headprofile"),
            FitnessBadge(name: "August Hydration Badge", description: "Complete the August challenge: Drink 100 Liters of water", iconName: "drop.triangle.fill"),
            FitnessBadge(name: "September Steps Badge", description: "Complete the September challenge: Log 250,000 steps", iconName: "figure.walk.circle.fill"),
            FitnessBadge(name: "October Squats Badge", description: "Complete the October challenge: Do 1,200 Squats", iconName: "figure.strengthtraining.functional"),
            FitnessBadge(name: "November Flexibility Badge", description: "Complete the November challenge: Complete 15 Flexibility sessions", iconName: "figure.cooldown"),
            FitnessBadge(name: "December Quests Badge", description: "Complete the December challenge: Complete 40 Daily Quests", iconName: "star.fill")
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
            // PUSHUPS SERIES (STRENGTH)
            SuggestedWorkout(
                name: "Knee Pushups Foundation",
                category: .strength,
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
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Standard Pushups Drill",
                category: .strength,
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
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Diamond Pushups Precision",
                category: .strength,
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
                reps: "8-12 reps"
            ),
            SuggestedWorkout(
                name: "Archer Pushups Ascent",
                category: .strength,
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
                reps: "6-8 reps per side"
            ),
            SuggestedWorkout(
                name: "Handstand Pushups Mastery",
                category: .strength,
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
                reps: "5-8 reps"
            ),
            
            // PULLUPS SERIES (STRENGTH)
            SuggestedWorkout(
                name: "Pullup Negatives Ascent",
                category: .strength,
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
                reps: "5-6 reps"
            ),
            SuggestedWorkout(
                name: "Close Grip Pullups Drill",
                category: .strength,
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
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Wide Grip Pullups Precision",
                category: .strength,
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
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "Archer Pullups Pull",
                category: .strength,
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
                reps: "5-6 reps per side"
            ),
            SuggestedWorkout(
                name: "One-Arm Pullup Mastery",
                category: .strength,
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
                reps: "2-3 reps per arm"
            ),
            
            // SPECIFIC MUSCLE GROUP WORKOUTS (DUMBBELLS)
            SuggestedWorkout(
                name: "Dumbbell Bicep Curl",
                category: .strength,
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
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Overhead Tricep Extension",
                category: .strength,
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
                reps: "12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Bent-Over Row",
                category: .strength,
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
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Romanian Deadlift",
                category: .strength,
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
                reps: "10 reps"
            ),
            
            // CARDIO WORKOUTS
            SuggestedWorkout(
                name: "Jumping Jacks Ignite",
                category: .cardio,
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
                reps: "30 secs"
            ),
            SuggestedWorkout(
                name: "High Knees Interval",
                category: .cardio,
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
                reps: "45 secs"
            ),
            SuggestedWorkout(
                name: "Tuck Jump Explosion",
                category: .cardio,
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
                reps: "10 reps"
            ),
            SuggestedWorkout(
                name: "Double-Under Jump Rope",
                category: .cardio,
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
                reps: "50 jumps"
            ),
            SuggestedWorkout(
                name: "Handstand Walking Cruise",
                category: .cardio,
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
                reps: "10 meters"
            ),
            
            // FLEXIBILITY WORKOUTS
            SuggestedWorkout(
                name: "Child's Pose Restorative",
                category: .flexibility,
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
                reps: "1 min hold"
            ),
            SuggestedWorkout(
                name: "Downward Dog Stretch",
                category: .flexibility,
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
                reps: "45 secs hold"
            ),
            SuggestedWorkout(
                name: "Deep Pigeon Hip Release",
                category: .flexibility,
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
                reps: "1 min per side"
            ),
            SuggestedWorkout(
                name: "Full Splits Alignment",
                category: .flexibility,
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
                reps: "30 secs hold"
            ),
            SuggestedWorkout(
                name: "Hollowback Handstand Arch",
                category: .flexibility,
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
                reps: "20 secs hold"
            ),
            
            // MEDITATION WORKOUTS
            SuggestedWorkout(
                name: "Breath Awareness",
                category: .meditation,
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
                reps: "5 mins"
            ),
            SuggestedWorkout(
                name: "Body Scan Relaxation",
                category: .meditation,
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
                reps: "10 mins"
            ),
            SuggestedWorkout(
                name: "Elemental Chakra Focusing",
                category: .meditation,
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
                reps: "15 mins"
            ),
            
            // NUTRITION WORKOUTS
            SuggestedWorkout(
                name: "Hydration Ritual",
                category: .nutrition,
                difficulty: "Easy",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Daily task to drink 3 liters of fresh water, crucial for muscle recovery, joint lubrication, and cellular energy.",
                instructions: [
                    "TARGET MUSCLES: Whole body hydration, metabolic pathways.",
                    "SETUP & WIDTH: 3 Liters target.",
                    "DIFFICULTY KEY: Easy tier (drinking 500ml upon waking, logging bottles).",
                    "Drink 500ml of clean water immediately upon waking to kickstart metabolism.",
                    "Carry a reusable water container with you throughout the day.",
                    "Log each glass or bottle consumed in your fitness companion app.",
                    "Consume water before, during, and after your training sessions.",
                    "Ensure you complete the 3-liter target before going to bed."
                ],
                sets: 1,
                reps: "3 Liters"
            ),
            SuggestedWorkout(
                name: "Clean Protein Prep",
                category: .nutrition,
                difficulty: "Medium",
                equipment: "Bodyweight Only",
                space: "Small Room",
                description: "Weekly food prep routine to cook healthy, lean proteins to support muscle synthesis and clean recovery.",
                instructions: [
                    "TARGET MUSCLES: Skeletal muscles (synthesis and recovery support).",
                    "SETUP & WIDTH: 3 meals prepped.",
                    "DIFFICULTY KEY: Medium tier (weighing portions, preparing clean containers).",
                    "Purchase lean protein sources such as chicken breast, white fish, or firm tofu.",
                    "Season light with herbs, garlic, and sea salt, avoiding sugary sauces.",
                    "Grill, bake, or steam the protein under clean heat.",
                    "Weigh out portions based on your daily macros (e.g. 150-200g per portion).",
                    "Store in clean containers in the refrigerator for ready-to-eat meals."
                ],
                sets: 1,
                reps: "3 meals prepped"
            ),
            SuggestedWorkout(
                name: "Micro-Nutrient Optimization",
                category: .nutrition,
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
                reps: "5 colors logged"
            ),
            SuggestedWorkout(
                name: "Advanced Bulking Prep",
                category: .nutrition,
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
                reps: "4 meals prepped"
            ),
            SuggestedWorkout(
                name: "Chrono-Nutrition Fasting Alignment",
                category: .nutrition,
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
                reps: "16/8 window logged"
            ),
            
            // DUMBBELL STRENGTH WORKOUTS (COMPOUND)
            SuggestedWorkout(
                name: "Dumbbell Goblet Squat",
                category: .strength,
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
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Floor Press",
                category: .strength,
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
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Renegade Row",
                category: .strength,
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
                reps: "8-10 reps per arm"
            ),
            SuggestedWorkout(
                name: "Dumbbell Thrusters",
                category: .strength,
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
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Man-Makers",
                category: .strength,
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
                reps: "6-8 reps"
            ),
            
            // DUMBBELL CARDIO WORKOUTS
            SuggestedWorkout(
                name: "Dumbbell Shadow Boxing",
                category: .cardio,
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
                reps: "1 min"
            ),
            SuggestedWorkout(
                name: "Dumbbell Farmers Walk",
                category: .cardio,
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
                reps: "1 min walk"
            ),
            SuggestedWorkout(
                name: "Dumbbell Devil Press",
                category: .cardio,
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
                reps: "10 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Clean & Press",
                category: .cardio,
                difficulty: "Legend",
                equipment: "Dumbbells",
                space: "Gym Space",
                description: "High velocity power conditioning drill that transfers force from the hips straight overhead.",
                instructions: [
                    "Stand holding dumbbells at your sides, feet hip-width apart.",
                    "Clean the dumbbells upward by popping your hips and catching them on your shoulders.",
                    "Perform a quick dip with your knees, bending them slightly.",
                    "Drive through your legs to press the weights straight up overhead.",
                    "Lower the dumbbells back to your sides under control and repeat."
                ],
                sets: 4,
                reps: "12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Snatch Intervals",
                category: .cardio,
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
