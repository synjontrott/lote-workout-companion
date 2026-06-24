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
    public var outfitStyle: String = "Warrior Plate"
    public var outfitColorHex: String = "#37474F"
    public var auraStyle: String = "Flames"
    
    // Pixel grid representation: 16x16 pixels
    // 0 = empty, 1 = skin, 2 = hair, 3 = eyes, 4 = outfit, 5 = aura
    public var pixelGrid: [[Int]] = Array(repeating: Array(repeating: 0, count: 16), count: 16)
    
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
        // Body / Outfit (rows 9 to 14, cols 4 to 11)
        for r in 9...13 {
            for c in 4...11 {
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
    case adhd = "ADHD (The Flame Sentinel)"
    case autistic = "Autistic (The Iron Archivist)"
    case audhd = "AuDHD (The Chimera)"
    case neurotypical = "Neurotypical (The Radiant Vanguard)"
    
    public var title: String { self.rawValue }
    
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

// MARK: - Quest Structure
public struct LotEQuest: Identifiable, Codable, Equatable {
    public let id: UUID
    public let title: String
    public let questDescription: String
    public let workoutType: WorkoutCategory
    public let difficultyRoll: Int // D&D DC (Difficulty Class) e.g., 10
    public let rewardXP: Int
    public let rewardCrystals: Int
    public let statReward: StatType
    public let statValue: Int
    public var isCompleted: Bool = false
    public var dateCreated: Date = Date()
    
    public static var dailyDefaults: [LotEQuest] {
        return [
            LotEQuest(id: UUID(), title: "Patrol the Whispering Woods", questDescription: "A brisk walk or run to clear out stray energy beasts. Requires 15 mins of activity.", workoutType: .cardio, difficultyRoll: 8, rewardXP: 40, rewardCrystals: 15, statReward: .dexterity, statValue: 1),
            LotEQuest(id: UUID(), title: "Earth Shaking Forging", questDescription: "Lift heavy weights, do bodyweight exercises, or strength training. Perform 20 mins.", workoutType: .strength, difficultyRoll: 10, rewardXP: 60, rewardCrystals: 25, statReward: .strength, statValue: 1),
            LotEQuest(id: UUID(), title: "Mobility Routine", questDescription: "Perform a mobility routine, stretching, or yoga to improve flexibility. 15 mins.", workoutType: .flexibility, difficultyRoll: 6, rewardXP: 30, rewardCrystals: 10, statReward: .wisdom, statValue: 1),
            LotEQuest(id: UUID(), title: "Consuming Healthy Rations", questDescription: "Log a protein-rich, nourishing meal with fresh vegetables and clean energy hydration.", workoutType: .nutrition, difficultyRoll: 5, rewardXP: 25, rewardCrystals: 10, statReward: .constitution, statValue: 1)
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
    case weightGain = "Weight Gain"
    case cutting = "Cutting"
    case flexibility = "Yoga & Flexibility"
    case cardio = "Cardio"
}

public func generateQuests(forElementName element: String, focuses: [TrainingFocus]) -> [LotEQuest] {
    var quests: [LotEQuest] = []
    
    // Fallback if no focuses are selected
    let activeFocuses = focuses.isEmpty ? [.cardio, .calisthenics, .flexibility, .cutting] : focuses
    
    for focus in activeFocuses.prefix(4) {
        let questId = UUID()
        let title: String
        let desc: String
        let wType: WorkoutCategory
        let dc: Int
        let xp: Int
        let crystals: Int
        let stat: StatType
        let val: Int
        
        switch focus {
        case .calisthenics:
            title = "\(element) Bar Mastery"
            desc = "Perform bodyweight dips, pushups, or pullups. Complete 15 minutes of gravity defying calisthenics."
            wType = .strength
            dc = 10
            xp = 60
            crystals = 20
            stat = .strength
            val = 1
        case .lifting:
            title = "\(element) Heavy Forge"
            desc = "Perform squat, bench, or deadlift strength training. Complete 20 minutes of heavy lifting."
            wType = .strength
            dc = 12
            xp = 70
            crystals = 25
            stat = .strength
            val = 1
        case .weightGain:
            title = "\(element) Bulking Feast"
            desc = "Log a calorie-dense bulking meal with clean protein and carbs to gain healthy weight."
            wType = .nutrition
            dc = 5
            xp = 40
            crystals = 15
            stat = .constitution
            val = 1
        case .cutting:
            title = "\(element) Lean Burn"
            desc = "Log a high-protein, calorie-deficit meal to burn off excess fat and stay lean."
            wType = .nutrition
            dc = 5
            xp = 40
            crystals = 15
            stat = .constitution
            val = 1
        case .flexibility:
            title = "\(element) Flow Routine"
            desc = "Perform a flexibility, yoga, or dynamic mobility routine. Complete 15 minutes of stretching."
            wType = .flexibility
            dc = 7
            xp = 50
            crystals = 15
            stat = .wisdom
            val = 1
        case .cardio:
            title = "\(element) Speed Patrol"
            desc = "Complete a 15-minute run, jog, cycle, or high-intensity cardio patrol."
            wType = .cardio
            dc = 8
            xp = 50
            crystals = 15
            stat = .dexterity
            val = 1
        }
        
        let customizedTitle: String
        let customizedDesc: String
        
        switch element {
        case "Fire":
            customizedTitle = title.replacingOccurrences(of: element, with: "Ember")
            customizedDesc = desc + " Channel the blazing heat of your inner fire."
        case "Water":
            customizedTitle = title.replacingOccurrences(of: element, with: "Tide")
            customizedDesc = desc + " Keep your movements smooth and flowing like water."
        case "Earth":
            customizedTitle = title.replacingOccurrences(of: element, with: "Stone")
            customizedDesc = desc + " Ground your stance and stand solid as rock."
        case "Air":
            customizedTitle = title.replacingOccurrences(of: element, with: "Zephyr")
            customizedDesc = desc + " Move light and swift as the wind."
        case "Lightning":
            customizedTitle = title.replacingOccurrences(of: element, with: "Volt")
            customizedDesc = desc + " Bring high intensity and electrical speed."
        case "Metal":
            customizedTitle = title.replacingOccurrences(of: element, with: "Iron")
            customizedDesc = desc + " Harden your resolve and forge your steel structure."
        case "Ice":
            customizedTitle = title.replacingOccurrences(of: element, with: "Frost")
            customizedDesc = desc + " Focus with cool precision and frosty control."
        case "Bone":
            customizedTitle = title.replacingOccurrences(of: element, with: "Marrow")
            customizedDesc = desc + " Strengthen your skeletal core and inner structure."
        case "Gas":
            customizedTitle = title.replacingOccurrences(of: element, with: "Vapor")
            customizedDesc = desc + " Flow seamlessly and adjust your form fluidly."
        case "Laser":
            customizedTitle = title.replacingOccurrences(of: element, with: "Photon")
            customizedDesc = desc + " Focus your energy into a concentrated beam of power."
        case "Zero Space":
            customizedTitle = title.replacingOccurrences(of: element, with: "Void")
            customizedDesc = desc + " Transcend standard physical coordinates."
        case "Darki":
            customizedTitle = title.replacingOccurrences(of: element, with: "Dark")
            customizedDesc = desc + " Harness powerful dark waves to fuel your reps."
        case "Death":
            customizedTitle = title.replacingOccurrences(of: element, with: "Decay")
            customizedDesc = desc + " Push through physical boundaries."
        case "Knife":
            customizedTitle = title.replacingOccurrences(of: element, with: "Blade")
            customizedDesc = desc + " Focus on sharp execution and clean cuts."
        case "Poison":
            customizedTitle = title.replacingOccurrences(of: element, with: "Toxic")
            customizedDesc = desc + " Build immunities and clean cellular efficiency."
        case "Shadow":
            customizedTitle = title.replacingOccurrences(of: element, with: "Shade")
            customizedDesc = desc + " Keep your execution silent, stealthy, and phantom-like."
        default:
            customizedTitle = title
            customizedDesc = desc
        }
        
        quests.append(LotEQuest(
            id: questId,
            title: customizedTitle,
            questDescription: customizedDesc,
            workoutType: wType,
            difficultyRoll: dc,
            rewardXP: xp,
            rewardCrystals: crystals,
            statReward: stat,
            statValue: val
        ))
    }
    
    while quests.count < 4 {
        quests.append(LotEQuest(
            id: UUID(),
            title: "General Training Patrol",
            questDescription: "Perform a general physical workout to build overall energy. 15 mins.",
            workoutType: .cardio,
            difficultyRoll: 8,
            rewardXP: 30,
            rewardCrystals: 10,
            statReward: .constitution,
            statValue: 1
        ))
    }
    
    return quests
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
