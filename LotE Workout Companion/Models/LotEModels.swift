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
            LotEQuest(id: UUID(), title: "Air Stream Alignment", questDescription: "Align your internal Sho through yoga, stretching, or mobility work. 15 mins.", workoutType: .flexibility, difficultyRoll: 6, rewardXP: 30, rewardCrystals: 10, statReward: .wisdom, statValue: 1),
            LotEQuest(id: UUID(), title: "Consuming Healthy Rations", questDescription: "Log a protein-rich, nourishing meal with fresh vegetables and clean energy hydration.", workoutType: .nutrition, difficultyRoll: 5, rewardXP: 25, rewardCrystals: 10, statReward: .constitution, statValue: 1)
        ]
    }
}

public enum WorkoutCategory: String, Codable, CaseIterable {
    case cardio = "Cardio Patrol"
    case strength = "Strength Forge"
    case flexibility = "Flexibility Stream"
    case nutrition = "Healthy Rations"
    case meditation = "Spiritual Focus"
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
