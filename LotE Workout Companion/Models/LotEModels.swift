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
    public let secondaryColorHex: String
    public let detailColorHex: String
    public let planetOfOrigin: String
    public let inherentDark: Bool
    
    public var primaryColor: Color {
        Color(hex: primaryColorHex) ?? .red
    }
    
    public var accentColor: Color {
        Color(hex: accentColorHex) ?? .orange
    }
    
    public var secondaryColor: Color {
        Color(hex: secondaryColorHex) ?? .yellow
    }
    
    public var detailColor: Color {
        Color(hex: detailColorHex) ?? .white
    }
    
    public func corruptedVersion() -> LotEElement {
        let newPrimary: String
        let newAccent: String
        let newSecondary: String
        let newDetail: String
        
        switch corruptName {
        case "Blackstone":
            newPrimary = "#1A1613"   // Dark basalt black
            newAccent = "#E64A19"    // Magma orange glow
            newSecondary = "#2E1E1C" // Volcanic brown
            newDetail = "#8D6E63"
        case "Black Fire":
            newPrimary = "#090200"   // Pure soot black
            newAccent = "#E65100"    // Bright dark fire orange
            newSecondary = "#D50000" // Blood fire red
            newDetail = "#FFAB91"
        case "Dark Laser":
            newPrimary = "#120024"   // Dark purple vacuum
            newAccent = "#D500F9"    // Laser violet line glow
            newSecondary = "#4A148C" // Deep royal purple
            newDetail = "#E040FB"
        case "Acid Water":
            newPrimary = "#1B5E20"   // Acid toxic green
            newAccent = "#00E5FF"    // Corrosive neon cyan
            newSecondary = "#004D40" // Deep water decay
            newDetail = "#E0F7FA"
        case "Dark Air":
            newPrimary = "#212121"   // Charcoal smoke
            newAccent = "#757575"    // Storm cloud grey
            newSecondary = "#37474F" // Heavy barometric pressure
            newDetail = "#ECEFF1"
        case "Red Lightning":
            newPrimary = "#311B92"   // Dark void purple
            newAccent = "#FF1744"    // Arcing electric crimson
            newSecondary = "#000000" // Void black gaps
            newDetail = "#FF8A80"
        case "Rusted Metal":
            newPrimary = "#3E2723"   // Deep iron rust
            newAccent = "#E65100"    // Oxidized amber
            newSecondary = "#212121" // Gunmetal grey
            newDetail = "#D7CCC8"
        case "Black Ice":
            newPrimary = "#001D24"   // Deep frozen abyss
            newAccent = "#00E5FF"    // Glacial neon cyan
            newSecondary = "#004D40" // Cold dark water
            newDetail = "#E0F7FA"
        case "Toxic Gas":
            newPrimary = "#4A148C"   // Miasma purple
            newAccent = "#00E676"    // Toxic lime green
            newSecondary = "#1A237E" // Dark blue core
            newDetail = "#EEFF41"
        case "Void Space":
            newPrimary = "#080017"   // Singular black hole
            newAccent = "#AA00FF"    // Event horizon violet
            newSecondary = "#0D47A1" // Dark cosmic blue
            newDetail = "#FFEB3B"
        case "Wither Bone":
            newPrimary = "#2A2522"   // Rotting bone dark grey
            newAccent = "#5D4037"    // Muddy marrow brown
            newSecondary = "#1D1614" // Deep soil rot
            newDetail = "#BCAAA4"
        case "Shadow":
            newPrimary = "#09090C"   // Abyssal shadow void
            newAccent = "#311B92"    // Shrouded dark indigo
            newSecondary = "#010101" // Silhouette absolute black
            newDetail = "#78909C"
        case "Darki":
            newPrimary = "#1F0012"   // Corrupt royalty dark purple
            newAccent = "#C2185B"    // Sovereign dark pink glow
            newSecondary = "#0F0008" // Void core
            newDetail = "#E1BEE7"
        case "Death":
            newPrimary = "#0C0012"   // Underworld black-violet
            newAccent = "#4A148C"    // Soul harvest purple
            newSecondary = "#05000A" // Empty grave
            newDetail = "#B39DDB"
        case "Knife":
            newPrimary = "#0D2E33"   // Dark cold plasma
            newAccent = "#00B8D4"    // Piercing cyan blade edge
            newSecondary = "#041517" // Metallic dark void
            newDetail = "#E0F7FA"
        case "Poison":
            newPrimary = "#0D3311"   // Concentrated venom green
            newAccent = "#AA00FF"    // Toxic purple vapor
            newSecondary = "#041706" // Corroding green acid
            newDetail = "#CCFF90"
        default:
            newPrimary = "#0A0A0A"
            newAccent = "#3E2723"
            newSecondary = "#1A1A1A"
            newDetail = "#9E9E9E"
        }
        
        return LotEElement(
            name: name,
            corruptName: corruptName,
            description: description,
            corruptDescription: corruptDescription,
            standardDetails: standardDetails,
            corruptDetails: corruptDetails,
            balancedDetails: balancedDetails,
            primaryColorHex: newPrimary,
            accentColorHex: newAccent,
            secondaryColorHex: newSecondary,
            detailColorHex: newDetail,
            planetOfOrigin: planetOfOrigin,
            inherentDark: inherentDark
        )
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
    
    // Pixel grid representation: 300x300 pixels
    // 0 = empty, 1 = skin, 2 = hair, 3 = eyes, 4 = outfit, 5 = aura
    public var pixelGrid: [[Int]] = Array(repeating: Array(repeating: 0, count: 300), count: 300)
    
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
        self.pixelGrid = pixelGrid ?? CharacterSprite.generateGrid(planet: outfitStyle, hairStyle: hairStyle, sex: sex)
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
        let decodedGrid = try container.decodeIfPresent([[Int]].self, forKey: .pixelGrid) ?? CharacterSprite.defaultGrid
        if decodedGrid.count < 300 || (decodedGrid.first?.count ?? 0) < 300 {
            pixelGrid = CharacterSprite.scale16To300(decodedGrid)
        } else {
            pixelGrid = decodedGrid
        }
    }
    
    public static func scale16To300(_ grid16: [[Int]]) -> [[Int]] {
        var grid300 = Array(repeating: Array(repeating: 0, count: 300), count: 300)
        for r in 0..<300 {
            for c in 0..<300 {
                let r16 = (r * 16) / 300
                let c16 = (c * 16) / 300
                grid300[r][c] = grid16[r16][c16]
            }
        }
        return grid300
    }
    
    public static func generateGrid(planet: String, hairStyle: String, sex: String) -> [[Int]] {
        var grid = Array(repeating: Array(repeating: 0, count: 300), count: 300)
        let isFemale = sex.lowercased() == "female"
        
        // 1. Cosmic/Elemental Aura Smoke Trails (5)
        for r in 0..<300 {
            for c in 0..<300 {
                let dx = Double(c - 150)
                let dy = Double(r - 150)
                let dist = sqrt(dx*dx + dy*dy)
                
                // Outer energy rings
                if dist >= 128.0 && dist <= 135.0 {
                    if (r + c) % 3 == 0 { grid[r][c] = 5 }
                }
                
                // Wavy smoke plumes rising up
                if r >= 60 && r <= 240 {
                    let wave = sin(Double(r) * 0.08) * 16.0
                    // Left smoke plume
                    if c >= 30 && c < 90 {
                        let edge = 80.0 + wave - Double(r - 60) * 0.08
                        if Double(c) >= edge - 12.0 && Double(c) <= edge {
                            if (r + c) % 2 == 0 { grid[r][c] = 5 }
                        }
                    }
                    // Right smoke plume
                    if c > 210 && c <= 270 {
                        let edge = 220.0 + wave + Double(r - 60) * 0.08
                        if Double(c) >= edge && Double(c) <= edge + 12.0 {
                            if (r + c) % 2 == 0 { grid[r][c] = 5 }
                        }
                    }
                }
            }
        }
        
        // 2. Male Crossed Back Swords (4 for hilt, 5 for glowing energy blades)
        if !isFemale {
            // Sword 1 (hilt top-left to blade bottom-right)
            for i in -30...90 {
                let rCoord = 150 + i
                let cCoord = 150 + i
                if rCoord >= 0 && rCoord < 300 && cCoord >= 0 && cCoord < 300 {
                    // Draw 3-pixel wide swords
                    for offset in -1...1 {
                        if i < 0 {
                            grid[rCoord + offset][cCoord - offset] = 4 // Hilt
                        } else if i >= 20 {
                            grid[rCoord + offset][cCoord - offset] = 5 // Energy Blade
                        }
                    }
                }
            }
            // Sword 2 (hilt top-right to blade bottom-left)
            for i in -30...90 {
                let rCoord = 150 + i
                let cCoord = 150 - i
                if rCoord >= 0 && rCoord < 300 && cCoord >= 0 && cCoord < 300 {
                    for offset in -1...1 {
                        if i < 0 {
                            grid[rCoord + offset][cCoord + offset] = 4 // Hilt
                        } else if i >= 20 {
                            grid[rCoord + offset][cCoord + offset] = 5 // Energy Blade
                        }
                    }
                }
            }
        }
        
        // 3. Wavy Flowing Hair (Back layer for female) (2)
        if isFemale {
            for r in 60...220 {
                let waveL = sin(Double(r) * 0.06) * 7.0
                let waveR = cos(Double(r) * 0.06) * 7.0
                
                // Left lock
                let leftStart = Int(92.0 + waveL)
                let leftEnd = Int(116.0 + waveL)
                for c in leftStart...leftEnd { grid[r][c] = 2 }
                
                // Right lock
                let rightStart = Int(184.0 + waveR)
                let rightEnd = Int(208.0 + waveR)
                for c in rightStart...rightEnd { grid[r][c] = 2 }
            }
        }
        
        // 4. Armored Torso (4) - Differentiated silhouettes & structures
        if planet == "Warrion" {
            // Bulkier Heavy Knight/Lorica Plates
            let startRow = 150
            let endRow = 260
            for r in startRow...endRow {
                let pct = Double(r - startRow) / Double(endRow - startRow)
                let baseHalfW = isFemale ? 56.0 : 76.0
                let waistHalfW = isFemale ? 38.0 : 54.0
                
                // Horizontally segmented plate layers with overhangs
                let segmentIndex = (r - startRow) / 28
                let segmentOffset = Double(segmentIndex) * 2.5
                let halfWidth = baseHalfW - pct * (baseHalfW - waistHalfW) + segmentOffset
                
                let leftC = Int(150.0 - halfWidth)
                let rightC = Int(150.0 + halfWidth)
                for c in leftC...rightC {
                    // Segment borders
                    if (r - startRow) % 28 == 0 || (r - startRow) % 28 == 27 {
                        grid[r][c] = 5 // Golden lining between heavy plates
                    } else if c == leftC || c == rightC {
                        grid[r][c] = 5
                    } else {
                        grid[r][c] = 4
                    }
                }
            }
            
            // Warrion High Neck-Guard Shroud
            for r in 115...142 {
                let guardHalfW = isFemale ? 35 : 48
                for c in (150 - guardHalfW)...(150 + guardHalfW) {
                    if abs(c - 150) > (isFemale ? 20 : 28) {
                        grid[r][c] = 4 // Steel collar shroud flanking face
                    }
                }
            }
            
            // Heavy hip tassets (skirt armor)
            for r in 240...265 {
                let skirtHalfW = isFemale ? 52 : 72
                for c in (150 - skirtHalfW)...(150 + skirtHalfW) {
                    if (c - 150) % 18 == 0 {
                        grid[r][c] = 5 // golden vertical trim
                    } else {
                        grid[r][c] = 4
                    }
                }
            }
            
        } else if planet == "Techno" {
            // Angular Mech chassis / Cyborg frame
            let startRow = 150
            let endRow = 260
            for r in startRow...endRow {
                let baseHalfW = isFemale ? 48.0 : 62.0
                let waistHalfW = isFemale ? 28.0 : 46.0
                // Mechanical boxy cuts
                var halfWidth = baseHalfW
                if r > 185 && r < 225 {
                    halfWidth = waistHalfW // distinct rectangular waist cut
                } else if r >= 225 {
                    halfWidth = baseHalfW - 8.0 // lower mechanical battery frame
                }
                
                let leftC = Int(150.0 - halfWidth)
                let rightC = Int(150.0 + halfWidth)
                for c in leftC...rightC {
                    // Cyber Grid & circuits
                    if r % 14 == 0 || c % 14 == 0 {
                        grid[r][c] = 5 // glowing grid circuitry
                    } else if c == leftC || c == rightC {
                        grid[r][c] = 5
                    } else {
                        grid[r][c] = 4
                    }
                }
            }
            
            // Mech Chest vents / thruster intakes
            for r in 165...185 {
                // Dual rectangular chest vents
                let ventLStart = 110
                let ventLEnd = 126
                let ventRStart = 174
                let ventREnd = 190
                for c in ventLStart...ventLEnd { grid[r][c] = 5 } // Glowing left vent
                for c in ventRStart...ventREnd { grid[r][c] = 5 } // Glowing right vent
            }
            
        } else {
            // Ninjonia - Sleek, aerodynamic stealth wraps
            let startRow = 150
            let endRow = 260
            for r in startRow...endRow {
                let pct = Double(r - startRow) / Double(endRow - startRow)
                let baseHalfW = isFemale ? 42.0 : 54.0
                let waistHalfW = isFemale ? 22.0 : 34.0
                let halfWidth = baseHalfW - pct * (baseHalfW - waistHalfW)
                
                let leftC = Int(150.0 - halfWidth)
                let rightC = Int(150.0 + halfWidth)
                for c in leftC...rightC {
                    // Sleek diagonal wrap lines
                    let wrapLine = (c - 150) - Int((Double(r - 150) * 0.6))
                    if abs(wrapLine) < 3 || c == leftC || c == rightC || c == 150 {
                        grid[r][c] = 5 // light trim/wraps
                    } else {
                        grid[r][c] = 4
                    }
                }
            }
        }
        
        // 5. Curved/Layered Pauldrons (4)
        let shoulderHalfW: Double
        if planet == "Warrion" {
            shoulderHalfW = isFemale ? 56.0 : 76.0
        } else if planet == "Techno" {
            shoulderHalfW = isFemale ? 48.0 : 62.0
        } else {
            shoulderHalfW = isFemale ? 42.0 : 54.0
        }
        
        let pauldronCenterL = 150.0 - shoulderHalfW
        let pauldronCenterR = 150.0 + shoulderHalfW
        
        if planet == "Warrion" {
            // Massive spiked shields anchored to shoulders
            let radius = isFemale ? 16.0 : 22.0
            for r in 136...176 {
                // Left
                let startC = Int(pauldronCenterL - radius)
                let endC = Int(pauldronCenterL + radius * 0.6)
                for c in startC...endC {
                    let dx = Double(c) - pauldronCenterL
                    let dy = Double(r - 156)
                    if dx*dx + dy*dy <= radius * radius {
                        if c == startC && (r % 8 == 0) {
                            grid[r][c] = 5 // golden spike
                        } else {
                            grid[r][c] = 4
                        }
                    }
                }
                // Right
                let startCR = Int(pauldronCenterR - radius * 0.6)
                let endCR = Int(pauldronCenterR + radius)
                for c in startCR...endCR {
                    let dx = Double(c) - pauldronCenterR
                    let dy = Double(r - 156)
                    if dx*dx + dy*dy <= radius * radius {
                        if c == endCR && (r % 8 == 0) {
                            grid[r][c] = 5
                        } else {
                            grid[r][c] = 4
                        }
                    }
                }
            }
        } else if planet == "Techno" {
            // Segmented cyber-plates with thruster nozzles
            let widthW = isFemale ? 14.0 : 20.0
            for r in 142...170 {
                // Left
                let startC = Int(pauldronCenterL - widthW)
                let endC = Int(pauldronCenterL + 6.0)
                for c in startC...endC {
                    let rOffset = (c - startC) / 4
                    if r >= 142 + rOffset && r <= 166 + rOffset {
                        if c == startC {
                            grid[r][c] = 5 // glowing thruster tip
                        } else {
                            grid[r][c] = 4
                        }
                    }
                }
                // Right
                let startCR = Int(pauldronCenterR - 6.0)
                let endCR = Int(pauldronCenterR + widthW)
                for c in startCR...endCR {
                    let rOffset = (endCR - c) / 4
                    if r >= 142 + rOffset && r <= 166 + rOffset {
                        if c == endCR {
                            grid[r][c] = 5
                        } else {
                            grid[r][c] = 4
                        }
                    }
                }
            }
        } else {
            // Ninjonia sleek curved aerodynamic pauldrons
            let radius = isFemale ? 12.0 : 16.0
            for r in 144...168 {
                // Left
                let startC = Int(pauldronCenterL - radius)
                let endC = Int(pauldronCenterL + radius * 0.8)
                for c in startC...endC {
                    let dx = Double(c) - pauldronCenterL
                    let dy = Double(r - 156)
                    if dx*dx + dy*dy <= radius * radius {
                        grid[r][c] = 4
                    }
                }
                // Right
                let startCR = Int(pauldronCenterR - radius * 0.8)
                let endCR = Int(pauldronCenterR + radius)
                for c in startCR...endCR {
                    let dx = Double(c) - pauldronCenterR
                    let dy = Double(r - 156)
                    if dx*dx + dy*dy <= radius * radius {
                        grid[r][c] = 4
                    }
                }
            }
        }
        
        // 6. Scarf / Collar wrapping (4 / 5)
        for r in 130...148 {
            let halfW = isFemale ? 28 : 40
            for c in (150 - halfW)...(150 + halfW) {
                if planet == "Ninjonia" {
                    if (r + c) % 3 == 0 {
                        grid[r][c] = 5
                    } else {
                        grid[r][c] = 4
                    }
                } else {
                    grid[r][c] = 4
                }
            }
        }
        
        // 7. Muscular or Slender Cyber Arms (4)
        for r in 160...250 {
            let pct = Double(r - 160) / 90.0
            if isFemale {
                let leftCenter = Int(150.0 - shoulderHalfW + 4.0 - sin(pct * .pi) * 4.0)
                let rightCenter = Int(150.0 + shoulderHalfW - 4.0 + sin(pct * .pi) * 4.0)
                for c in (leftCenter - 6)...(leftCenter + 6) { grid[r][c] = 4 }
                for c in (rightCenter - 6)...(rightCenter + 6) { grid[r][c] = 4 }
                if planet == "Techno" {
                    grid[r][leftCenter] = 5
                    grid[r][rightCenter] = 5
                }
            } else {
                let leftCenter = Int(150.0 - shoulderHalfW + 8.0 - sin(pct * .pi) * 6.0)
                let rightCenter = Int(150.0 + shoulderHalfW - 8.0 + sin(pct * .pi) * 6.0)
                for c in (leftCenter - 10)...(leftCenter + 10) { grid[r][c] = 4 }
                for c in (rightCenter - 10)...(rightCenter + 10) { grid[r][c] = 4 }
                if planet == "Techno" {
                    grid[r][leftCenter] = 5
                    grid[r][rightCenter] = 5
                }
            }
        }
        
        // 8. Head Face shape (1 for skin, 4 for mask, 3/5 for eyes)
        if isFemale {
            for r in 76...132 {
                let halfW = (r < 100)
                    ? 22.0 + (Double(r - 76) / 24.0) * 6.0
                    : 28.0 - (Double(r - 100) / 32.0) * 20.0
                let startC = Int(150.0 - halfW)
                let endC = Int(150.0 + halfW)
                for c in startC...endC {
                    grid[r][c] = 1
                }
            }
            
            if planet == "Techno" || planet == "Dark Laser" {
                for r in 94...104 {
                    for c in 128...172 { grid[r][c] = 3 }
                }
            } else {
                // Slanted fighter eyes (closer together)
                for r in 94...98 {
                    for c in 134...142 { grid[r][c] = 3 }
                }
                for r in 94...98 {
                    for c in 158...166 { grid[r][c] = 3 }
                }
                for c in 130...144 { grid[90][c] = 2 }
                for c in 156...170 { grid[90][c] = 2 }
            }
            // Lip line for female
            for c in 146...154 { grid[116][c] = 4 }
        } else {
            // Male Hooded Mask
            for r in 44...140 {
                let pct = Double(r - 44) / 96.0
                let hoodHalfW = Int(30.0 + pct * 48.0)
                let innerHalfW = Int(20.0 + pct * 28.0)
                for c in (150 - hoodHalfW)...(150 + hoodHalfW) {
                    if abs(c - 150) > innerHalfW || r < 72 {
                        grid[r][c] = 4
                    } else {
                        grid[r][c] = 1
                    }
                }
            }
            
            for r in 96...132 {
                let maskHalfW = Int(22.0 - Double(r - 96)/36.0 * 12.0)
                for c in (150 - maskHalfW)...(150 + maskHalfW) {
                    grid[r][c] = 4
                }
            }
            
            for r in 86...94 {
                let centerOffset = abs(r - 90)
                for c in (142 + centerOffset)...(158 - centerOffset) {
                    grid[r][c] = 3
                }
            }
        }
        
        // 9. Texturized Detailed Front Hair Styles (2)
        // Hair cap
        for r in 56...80 {
            for c in 116...184 {
                let dx = Double(c - 150)
                let dy = Double(r - 72)
                if (dx*dx)/(34.0*34.0) + (dy*dy)/(16.0*16.0) <= 1.0 {
                    grid[r][c] = 2
                }
            }
        }
        
        // Face framing bangs
        for r in 80...124 {
            for c in 112...120 { grid[r][c] = 2 }
            for c in 180...188 { grid[r][c] = 2 }
            if r >= 88 && r <= 108 {
                grid[r][121] = 2
                grid[r][179] = 2
            }
        }
        
        // Stylized Sweeping Spikes
        if hairStyle == "Spiky" {
            for r in 20...60 {
                for c in 120...180 {
                    let cOffset = c - 150
                    if abs(cOffset) <= 6 && r >= 20 + abs(cOffset) * 4 { grid[r][c] = 2 }
                    if cOffset >= 15 && cOffset <= 30 && r >= 32 + abs(cOffset - 22) * 3 { grid[r][c] = 2 }
                    if cOffset <= -15 && cOffset >= -30 && r >= 32 + abs(cOffset + 22) * 3 { grid[r][c] = 2 }
                }
            }
            for r in 50...85 {
                for c in 96...204 {
                    if c < 116 && r >= 85 - (c - 96) * 2 { grid[r][c] = 2 }
                    if c > 184 && r >= 85 - (204 - c) * 2 { grid[r][c] = 2 }
                }
            }
        } else if hairStyle == "Long" {
            for r in 80...220 {
                let waveL = sin(Double(r) * 0.08) * 5.0
                let waveR = cos(Double(r) * 0.08) * 5.0
                for c in (98 + Int(waveL))...(106 + Int(waveL)) { grid[r][c] = 2 }
                for c in (194 + Int(waveR))...(202 + Int(waveR)) { grid[r][c] = 2 }
            }
        } else if hairStyle == "Mohawk" {
            for r in 15...55 {
                for c in 142...158 {
                    if r >= 15 + abs(c - 150) * 4 { grid[r][c] = 2 }
                }
            }
        } else if hairStyle == "Short" {
            // Textured short crop
            for r in 48...85 {
                for c in 114...186 {
                    let dx = Double(c - 150)
                    let dy = Double(r - 72)
                    if (dx*dx)/(36.0*36.0) + (dy*dy)/(18.0*18.0) <= 1.0 {
                        if (r + c) % 4 < 2 {
                            grid[r][c] = 2
                        }
                    }
                }
            }
        }
        
        // 10. Chest Core Glowing Emblem (5)
        let coreY = isFemale ? 168 : 176
        let coreRadius = isFemale ? 18.0 : 24.0
        let coreRadiusSq = coreRadius * coreRadius
        for r in (coreY - 30)...(coreY + 30) {
            for c in 120...180 {
                let dx = Double(c - 150)
                let dy = Double(r - coreY)
                if dx*dx + dy*dy <= coreRadiusSq {
                    grid[r][c] = 5
                }
            }
        }
        
        // Warrion Chest Emblem (Stone carvings)
        if planet == "Warrion" && !isFemale {
            for r in 190...210 {
                for c in 146...154 { grid[r][c] = 5 }
            }
        }
        
        // 11. Muscular Legs & Heavy Boots (4)
        for r in 252...290 {
            let legHalfW = isFemale ? 10 : 14
            let legLOffset = isFemale ? 120 : 116
            let legROffset = isFemale ? 180 : 184
            for c in (legLOffset - legHalfW)...(legLOffset + legHalfW) { grid[r][c] = 4 }
            for c in (legROffset - legHalfW)...(legROffset + legHalfW) { grid[r][c] = 4 }
        }
        for r in 291...299 {
            let bootHalfW = isFemale ? 14 : 20
            let bootLOffset = isFemale ? 118 : 112
            let bootROffset = isFemale ? 182 : 188
            for c in (bootLOffset - bootHalfW)...(bootLOffset + bootHalfW) { grid[r][c] = 4 }
            for c in (bootROffset - bootHalfW)...(bootROffset + bootHalfW) { grid[r][c] = 4 }
        }
        
        return grid
    }
    
    public static var defaultGrid: [[Int]] {
        return CharacterSprite.generateGrid(planet: "Ninjonia", hairStyle: "Spiky", sex: "Male")
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
    public var requiredMinutes: Double
    
    public var progressRatio: Double {
        return Double(progressCount) / Double(max(1, targetCount))
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, questDescription, workoutType, difficultyRoll, rewardXP, rewardCrystals, statReward, statValue, isCompleted, dateCreated, cadence, progressCount, targetCount, requiredMinutes
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
                targetCount: Int = 1,
                requiredMinutes: Double = 0.0) {
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
        self.requiredMinutes = requiredMinutes
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
        requiredMinutes = try container.decodeIfPresent(Double.self, forKey: .requiredMinutes) ?? 0.0
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

public func generateQuests(forElementName element: String, focuses: [TrainingFocus], cadence: QuestCadence, prs: [String: Double] = [:], waterGoal: Double = 3.0) -> [LotEQuest] {
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
        
        var strengthQuestAdded = false
        var addedCount = 0
        
        // Generate up to 4 unique daily quests
        for i in 0..<uniqueFocuses.count {
            if addedCount >= 4 { break }
            let adjective = themeWords[i % themeWords.count]
            let focus = uniqueFocuses[i]
            
            // Limit functional strength training quests (calisthenics/lifting) to max 1 per day
            if focus == .calisthenics || focus == .lifting {
                if strengthQuestAdded {
                    continue // Skip to avoid duplicate strength quests
                }
                strengthQuestAdded = true
            }
            
            let questId = UUID()
            let title: String
            let desc: String
            let wType: WorkoutCategory
            let stat: StatType
            var reqMinutes = 15.0
            
            switch focus {
            case .calisthenics:
                // Integrate Personal Records (PR) dynamic scaling
                let pullupsPR = prs["Pullups"] ?? 5.0
                let pushupsPR = prs["Pushups"] ?? 20.0
                if i % 2 == 0 {
                    title = "\(adjective) Pullup Ascendance"
                    desc = "Perform a set of \(Int(pullupsPR + 1)) pullups (your current PR is \(Int(pullupsPR))). Target training: at least 15 minutes."
                } else {
                    title = "\(adjective) Pushup Peak"
                    desc = "Perform a set of \(Int(pushupsPR + 2)) pushups (your current PR is \(Int(pushupsPR))). Target training: at least 15 minutes."
                }
                wType = .strength
                stat = .strength
                reqMinutes = 15.0
                
            case .lifting:
                // Integrate PR dynamic scaling for squats
                let squatsPR = prs["Squats"] ?? 30.0
                title = "\(adjective) Squat Breakthrough"
                desc = "Perform a set of \(Int(squatsPR + 2)) squats (your current PR is \(Int(squatsPR))). Target heavy loading: at least 20 minutes."
                wType = .strength
                stat = .strength
                reqMinutes = 20.0
                
            case .cardio:
                let runPR = prs["Run (Miles)"] ?? 1.0
                title = "\(adjective) Horizon Dash"
                desc = "Run/jog a distance of \(String(format: "%.2f", runPR + 0.25)) miles (your current PR is \(String(format: "%.2f", runPR)) miles). Complete a 15-minute run."
                wType = .cardio
                stat = .dexterity
                reqMinutes = 15.0
                
            case .flexibility:
                let titles = [
                    "\(adjective) Elemental Flow",
                    "Fluid \(adjective) Limbering",
                    "\(adjective) Meridian Release"
                ]
                title = titles[i % titles.count]
                desc = "Perform a flexibility, yoga, or dynamic mobility routine. Complete at least 15 minutes."
                wType = .flexibility
                stat = .wisdom
                reqMinutes = 15.0
                
            case .cutting:
                title = "\(adjective) Light Burn"
                desc = "Log a high-protein, calorie-deficit meal and drink at least \(String(format: "%.1f", waterGoal / 2)) Liters of water."
                wType = .nutrition
                stat = .constitution
                reqMinutes = 0.0
                
            case .bulking:
                title = "\(adjective) Nutrient Bulk"
                desc = "Log a calorie-dense bulking meal and drink at least \(String(format: "%.1f", waterGoal / 2)) Liters of water."
                wType = .nutrition
                stat = .constitution
                reqMinutes = 0.0
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
                targetCount: 1,
                requiredMinutes: reqMinutes
            ))
            
            addedCount += 1
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

// MARK: - Workout Session Model
public struct WorkoutSession: Codable, Identifiable, Equatable {
    public var id: UUID
    public let type: String // "Strength", "Walking", "Running", "Yoga", "Cardio"
    public let durationMinutes: Double
    public let date: Date
    
    public init(id: UUID = UUID(), type: String, durationMinutes: Double, date: Date = Date()) {
        self.id = id
        self.type = type
        self.durationMinutes = durationMinutes
        self.date = date
    }
}

// MARK: - Suggested Workout
public enum MuscleGroup: String, Codable, CaseIterable {
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case arms = "Arms"
    case core = "Core & Abs"
    case legs = "Legs & Glutes"
    case fullBody = "Full Body"
    case cardio = "Cardio & Conditioning"
}

public struct SuggestedWorkout: Identifiable, Codable, Equatable {
    public var id: String { name }
    public var category: WorkoutCategory {
        switch muscleGroup {
        case .cardio:
            return .cardio
        case .fullBody:
            return .flexibility
        default:
            return .strength
        }
    }
    public let name: String
    public let muscleGroup: MuscleGroup
    public let difficulty: String // "Easy", "Medium", "Hard", "Legend", "Master"
    public let equipment: String
    public let description: String
    public let instructions: [String]
    public let sets: Int
    public let reps: String
    public let durationMinutes: Double
    
    public init(name: String, muscleGroup: MuscleGroup, difficulty: String, equipment: String, description: String, instructions: [String], sets: Int, reps: String, durationMinutes: Double = 15.0) {
        self.name = name
        self.muscleGroup = muscleGroup
        self.difficulty = difficulty
        self.equipment = equipment
        self.description = description
        self.instructions = instructions
        self.sets = sets
        self.reps = reps
        self.durationMinutes = durationMinutes
    }
    
    public static var allWorkouts: [SuggestedWorkout] {
        return [
                        SuggestedWorkout(
                name: "Knee Pushups Foundation",
                muscleGroup: .chest,
                difficulty: "Easy",
                equipment: "Bodyweight Only",
                description: "Build upper body pushing strength targeting the chest using knees to reduce load.",
                instructions: [
                    "Position hands slightly wider than shoulders.",
                    "Keep core braced and spine neutral from head to knees.",
                    "Lower chest to floor by bending elbows to 45 degrees.",
                    "Push up dynamically through palms to return to starting position."
                ],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Standard Pushups Drill",
                muscleGroup: .chest,
                difficulty: "Medium",
                equipment: "Bodyweight Only",
                description: "Classic chest and triceps builder that challenges core stability.",
                instructions: [
                    "Assume a high plank with hands directly under shoulders.",
                    "Keep spine neutral and glutes engaged.",
                    "Lower under control until chest is one inch from floor.",
                    "Press firmly into the ground to push yourself back up."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Diamond Pushups Precision",
                muscleGroup: .chest,
                difficulty: "Hard",
                equipment: "Bodyweight Only",
                description: "Close-grip pushup variation designed to shift the load onto the inner chest and triceps.",
                instructions: [
                    "Form a diamond shape with index fingers and thumbs touching.",
                    "Maintain a rigid straight line from head to heels.",
                    "Lower chest toward hands, keeping elbows tucked to ribs.",
                    "Press upward dynamically, focusing on inner chest contraction."
                ],
                sets: 4,
                reps: "8-12 reps"
            ),
            SuggestedWorkout(
                name: "Archer Pushups Ascent",
                muscleGroup: .chest,
                difficulty: "Legend",
                equipment: "Bodyweight Only",
                description: "Advanced single-arm loaded pushup variation sliding side-to-side.",
                instructions: [
                    "Assume high plank with hands placed extremely wide.",
                    "Lower body to one side, bending that elbow.",
                    "Keep the opposite arm completely straight.",
                    "Push up from the bent arm to return to center."
                ],
                sets: 4,
                reps: "6-8 reps per side"
            ),
            SuggestedWorkout(
                name: "One-Arm Pushup Progression",
                muscleGroup: .chest,
                difficulty: "Master",
                equipment: "Bodyweight Only",
                description: "The ultimate pushup challenge, loading your entire chest unilaterally.",
                instructions: [
                    "Place feet very wide and one hand centered under chest.",
                    "Keep free hand behind your back.",
                    "Lower under control, keeping hips parallel to floor.",
                    "Drive through the single arm with explosive force."
                ],
                sets: 5,
                reps: "3-5 reps per side"
            ),
            SuggestedWorkout(
                name: "Light Dumbbell Floor Press",
                muscleGroup: .chest,
                difficulty: "Easy",
                equipment: "Dumbbells",
                description: "Safe chest builder that limits range of motion using the floor as a depth stop.",
                instructions: [
                    "Lie flat on your back with knees bent, holding dumbbells over chest.",
                    "Lower elbows slowly until they touch the floor lightly.",
                    "Press dumbbells back up, squeezing chest at the top.",
                    "Avoid slamming elbows into the ground."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Bench Press",
                muscleGroup: .chest,
                difficulty: "Medium",
                equipment: "Dumbbells",
                description: "Classic dumbbell chest exercise that allows for deep contraction.",
                instructions: [
                    "Lie flat on bench holding dumbbells at chest level.",
                    "Press weights up and slightly inward over chest.",
                    "Lower under control until dumbbells are near shoulders.",
                    "Squeeze chest muscles at top of movement."
                ],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Incline Flyes",
                muscleGroup: .chest,
                difficulty: "Hard",
                equipment: "Dumbbells",
                description: "Isolation movement targeting upper chest fibers and shoulder stability.",
                instructions: [
                    "Set bench to a 30-degree incline.",
                    "Hold dumbbells overhead with palms facing each other.",
                    "Open arms wide in a smooth arc, keeping elbows slightly bent.",
                    "Squeeze chest to bring weights back to center."
                ],
                sets: 4,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Heavy Dumbbell Floor Press",
                muscleGroup: .chest,
                difficulty: "Legend",
                equipment: "Dumbbells",
                description: "Heavy overload press targeting mid-range chest drive and tricep lockout.",
                instructions: [
                    "Lie flat on the floor with heavy dumbbells.",
                    "Bring weights to chest height with elbows touching floor.",
                    "Press up with maximum power, locking out elbows.",
                    "Control descent to prevent floor impact."
                ],
                sets: 4,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Squeeze Press",
                muscleGroup: .chest,
                difficulty: "Master",
                equipment: "Dumbbells",
                description: "High-intensity isometric squeeze press that triggers maximum chest recruitment.",
                instructions: [
                    "Lie on bench and press two dumbbells together over chest.",
                    "Maintain constant inward pressure against each other.",
                    "Lower dumbbells to chest while squeezing them together.",
                    "Press back up while maintaining the intense squeeze."
                ],
                sets: 5,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "Bar Hanging Scapular Squeezes",
                muscleGroup: .chest,
                difficulty: "Easy",
                equipment: "Pull-up Bar",
                description: "Introductory shoulder blade alignment and grip builder.",
                instructions: [
                    "Grip the bar with overhand grip, hanging fully.",
                    "Pull shoulder blades down and back without bending arms.",
                    "Hold contraction for 2 seconds.",
                    "Relax to dead hang and repeat."
                ],
                sets: 3,
                reps: "10 reps"
            ),
            SuggestedWorkout(
                name: "Underbar Incline Chest Dips",
                muscleGroup: .chest,
                difficulty: "Medium",
                equipment: "Pull-up Bar",
                description: "Horizontal bodyweight press using low bar setup.",
                instructions: [
                    "Grip a low bar with hands shoulder-width apart.",
                    "Walk feet out so body is inclined at 45 degrees.",
                    "Lower chest to bar by bending elbows.",
                    "Press back up dynamically."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Straight Bar Chest Dips",
                muscleGroup: .chest,
                difficulty: "Hard",
                equipment: "Pull-up Bar",
                description: "Vertical chest press using the bar to support bodyweight.",
                instructions: [
                    "Jump up to support position on top of the bar.",
                    "Lean forward slightly and bend elbows to lower chest.",
                    "Keep elbows close to body to protect shoulders.",
                    "Press back up to locked arm support position."
                ],
                sets: 4,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Single-Bar Dips Mastery",
                muscleGroup: .chest,
                difficulty: "Legend",
                equipment: "Pull-up Bar",
                description: "Advanced bar dip focusing on deep chest stretch and lockout strength.",
                instructions: [
                    "Perform standard straight bar dip but lower chest to touch the bar.",
                    "Hold the bottom position for 1 second.",
                    "Drive upward explosively using chest and triceps.",
                    "Maintain strict control to avoid bar swing."
                ],
                sets: 4,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "Muscle-Up Chest Press Transition",
                muscleGroup: .chest,
                difficulty: "Master",
                equipment: "Pull-up Bar",
                description: "Peak vertical transition loading chest under extreme angles.",
                instructions: [
                    "Pull up explosively and transition chest over the bar.",
                    "Press bodyweight up to full arm extension.",
                    "Lower slowly through the transition phase to dead hang.",
                    "Requires massive explosive pulling and pushing synergy."
                ],
                sets: 5,
                reps: "3-5 reps"
            ),
            SuggestedWorkout(
                name: "Cable Chest Press",
                muscleGroup: .chest,
                difficulty: "Easy",
                equipment: "Full Gym",
                description: "Controlled chest isolation using cable tension for continuous recruitment.",
                instructions: [
                    "Set cables to chest height, stand in center, step forward.",
                    "Bring hands together in front of chest in pressing motion.",
                    "Slowly return to start, feeling stretch in outer chest.",
                    "Keep core tight to prevent torso rotation."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Barbell Bench Press",
                muscleGroup: .chest,
                difficulty: "Medium",
                equipment: "Full Gym",
                description: "The gold standard chest exercise for total upper body push power.",
                instructions: [
                    "Lie on bench, grip barbell slightly wider than shoulders.",
                    "Unrack bar and lower under control to mid-chest.",
                    "Drive bar upward vertically until arms lock.",
                    "Keep feet flat on floor and shoulder blades retracted."
                ],
                sets: 3,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Incline Barbell Press",
                muscleGroup: .chest,
                difficulty: "Hard",
                equipment: "Full Gym",
                description: "Barbell press targeting clavicular chest fibers for upper chest thickness.",
                instructions: [
                    "Set incline bench to 30-45 degrees.",
                    "Unrack bar and lower to upper chest.",
                    "Press bar straight up over shoulders.",
                    "Maintain controlled tempo on the descent."
                ],
                sets: 4,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Weighted Dips Chest Focus",
                muscleGroup: .chest,
                difficulty: "Legend",
                equipment: "Full Gym",
                description: "Weighted vertical dips targeting lower chest sweep and tricep power.",
                instructions: [
                    "Attach weight belt around waist with plates.",
                    "Mount parallel bars, lock arms, lean forward.",
                    "Lower body until shoulders are below elbows.",
                    "Press upward explosively back to lockout."
                ],
                sets: 4,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "Heavy Barbell Bench Press Overload",
                muscleGroup: .chest,
                difficulty: "Master",
                equipment: "Full Gym",
                description: "Absolute strength builder using maximum power output.",
                instructions: [
                    "Warm up and set barbell to near-max lifting weight.",
                    "Maintain absolute core tension and leg drive.",
                    "Lower bar to chest and pause for a split second.",
                    "Press bar upward with explosive drive."
                ],
                sets: 5,
                reps: "2-4 reps"
            ),
            SuggestedWorkout(
                name: "Prone Cobra Lat Squeeze",
                muscleGroup: .back,
                difficulty: "Easy",
                equipment: "Bodyweight Only",
                description: "Lie face down and raise chest to target lats and lower back muscles.",
                instructions: [
                    "Lie flat on stomach with forehead touching ground.",
                    "Lift chest, arms, and feet off floor while pinching shoulder blades.",
                    "Keep neck neutral, looking slightly down.",
                    "Hold the contraction for 2-3 seconds, then lower under control."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Bodyweight Inverted Rows",
                muscleGroup: .back,
                difficulty: "Medium",
                equipment: "Bodyweight Only",
                description: "Use a sturdy horizontal bar or edge to pull bodyweight horizontally.",
                instructions: [
                    "Lie under a bar set at waist height.",
                    "Grip the bar overhand, shoulder-width apart, feet flat.",
                    "Pull your chest to the bar, keeping body in straight plank.",
                    "Lower slowly back to arm extension without sagging."
                ],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Door Frame Pull-ins",
                muscleGroup: .back,
                difficulty: "Hard",
                equipment: "Bodyweight Only",
                description: "Unilateral pulling drill using door frame to build latch control.",
                instructions: [
                    "Stand facing the side edge of a door frame.",
                    "Grip with one hand, step feet close to base.",
                    "Lean back until arm is fully extended.",
                    "Pull chest to frame using back muscles only."
                ],
                sets: 4,
                reps: "12-15 reps per side"
            ),
            SuggestedWorkout(
                name: "Towel Grip Pull-up Prep",
                muscleGroup: .back,
                difficulty: "Legend",
                equipment: "Bodyweight Only",
                description: "Build extreme grip and forearm endurance using hanging towels.",
                instructions: [
                    "Drape a sturdy towel over a bar.",
                    "Grip both ends of the towel firmly.",
                    "Perform controlled pull-ups, drawing chest to hands.",
                    "Keep core braced and prevent swinging."
                ],
                sets: 4,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "L-Sit Pullups Back Control",
                muscleGroup: .back,
                difficulty: "Master",
                equipment: "Bodyweight Only",
                description: "Peak horizontal-to-vertical pulling combo targeting lats and core.",
                instructions: [
                    "Hang from bar and lift legs parallel to floor (L-sit).",
                    "Maintain L-sit shape throughout the movement.",
                    "Pull body upward until chin clears the bar.",
                    "Lower slowly, keeping legs high and locked."
                ],
                sets: 5,
                reps: "5-6 reps"
            ),
            SuggestedWorkout(
                name: "Light Dumbbell Rows",
                muscleGroup: .back,
                difficulty: "Easy",
                equipment: "Dumbbells",
                description: "Target mid-back stability using moderate dumbbell loading.",
                instructions: [
                    "Hinge forward at hips with flat back, holding weights.",
                    "Pull dumbbells to hips, keeping elbows close to ribs.",
                    "Squeeze shoulder blades together at top.",
                    "Lower weights under strict control."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Bent Over Rows",
                muscleGroup: .back,
                difficulty: "Medium",
                equipment: "Dumbbells",
                description: "Classic back builder utilizing double arm dumbbell rows.",
                instructions: [
                    "Stand feet hip-width, bend knees slightly, hinge to 45 degrees.",
                    "Hold dumbbells with neutral grip hanging down.",
                    "Pull dumbbells toward lower chest dynamically.",
                    "Control dumbbells down to full shoulder stretch."
                ],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Renegade Rows",
                muscleGroup: .back,
                difficulty: "Hard",
                equipment: "Dumbbells",
                description: "Core stability and back row combined in high plank position.",
                instructions: [
                    "Assume high plank with hands gripping dumbbells on floor.",
                    "Set feet wide for solid support base.",
                    "Row one dumbbell to rib cage, bracing body.",
                    "Return dumbbell to floor and repeat on opposite side."
                ],
                sets: 4,
                reps: "8-10 reps per side"
            ),
            SuggestedWorkout(
                name: "Single-Arm Dumbbell Row Strength",
                muscleGroup: .back,
                difficulty: "Legend",
                equipment: "Dumbbells",
                description: "Heavy unilateral back overload targeting lat and rear delt.",
                instructions: [
                    "Support one knee and hand on flat bench.",
                    "Hold heavy dumbbell in free hand, arm extended.",
                    "Pull dumbbell to waist, driving elbow high.",
                    "Stretch lat fully at bottom of each rep."
                ],
                sets: 4,
                reps: "6-8 reps per side"
            ),
            SuggestedWorkout(
                name: "Heavy Dumbbell Row Lat Destroy",
                muscleGroup: .back,
                difficulty: "Master",
                equipment: "Dumbbells",
                description: "Peak load pulling workout designed to overload lat thickness.",
                instructions: [
                    "Stand in staggered stance, lean forward with heavy dumbbell.",
                    "Row dumbbell to hip with maximum vertical drive.",
                    "Pause at top, squeezing lat completely.",
                    "Control descent to protect shoulder socket."
                ],
                sets: 5,
                reps: "5-6 reps per side"
            ),
            SuggestedWorkout(
                name: "Scapular Pulls Alignment",
                muscleGroup: .back,
                difficulty: "Easy",
                equipment: "Pull-up Bar",
                description: "Activate shoulder blades and decompress spine from dead hang.",
                instructions: [
                    "Grip pull-up bar shoulder-width apart.",
                    "Draw shoulder blades down, raising body slightly.",
                    "Do not bend elbows; keep arms straight.",
                    "Release back down to dead hang under control."
                ],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Negative Pullups Ascent Prep",
                muscleGroup: .back,
                difficulty: "Medium",
                equipment: "Pull-up Bar",
                description: "Build eccentric pull capacity by resisting gravity on descent.",
                instructions: [
                    "Jump up to bar so chest is touching it.",
                    "Hold the top position for one second.",
                    "Lower body slowly, taking 5 seconds to extend.",
                    "Step down, reset, and repeat next rep."
                ],
                sets: 3,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "Regular Pullups Lats Focus",
                muscleGroup: .back,
                difficulty: "Hard",
                equipment: "Pull-up Bar",
                description: "The ultimate back-building bodyweight pull.",
                instructions: [
                    "Hang from bar with hands slightly wider than shoulders.",
                    "Pull elbows down to lift chest to bar.",
                    "Clear chin over bar without reaching neck.",
                    "Lower under control to full dead hang."
                ],
                sets: 4,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Archer Pullups Pull",
                muscleGroup: .back,
                difficulty: "Legend",
                equipment: "Pull-up Bar",
                description: "Shift body side-to-side to overload one lat at a time.",
                instructions: [
                    "Grip bar with extremely wide hand placement.",
                    "Pull chest up toward right hand, left arm straight.",
                    "Lower back down slowly to center hang.",
                    "Repeat by pulling chest to left hand."
                ],
                sets: 4,
                reps: "5-6 reps per side"
            ),
            SuggestedWorkout(
                name: "One-Arm Pullup Mastery",
                muscleGroup: .back,
                difficulty: "Master",
                equipment: "Pull-up Bar",
                description: "Absolute peak of pulling strength, pulling entire body weight unilaterally.",
                instructions: [
                    "Grip bar with single hand, bracing core.",
                    "Keep legs and free arm rigid to stop spin.",
                    "Pull with maximum force, drawing elbow to waist.",
                    "Lower under control to avoid shoulder strain."
                ],
                sets: 5,
                reps: "2-3 reps per side"
            ),
            SuggestedWorkout(
                name: "Lat Pulldown Machine",
                muscleGroup: .back,
                difficulty: "Easy",
                equipment: "Full Gym",
                description: "Controlled vertical pulling using selectorized resistance.",
                instructions: [
                    "Sit at machine, grip bar wide, lock thighs under pad.",
                    "Pull bar to upper chest, squeezing shoulder blades.",
                    "Slowly return bar to top, stretching lats.",
                    "Avoid leaning back excessively."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Barbell Pendlay Rows",
                muscleGroup: .back,
                difficulty: "Medium",
                equipment: "Full Gym",
                description: "Strict horizontal barbell rowing off the floor.",
                instructions: [
                    "Bent forward flat back, parallel to floor.",
                    "Grip barbell overhand, pull explosively to lower chest.",
                    "Return barbell to rest on floor after each rep.",
                    "Keep torso rigid throughout."
                ],
                sets: 3,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Weighted Pullups Strength",
                muscleGroup: .back,
                difficulty: "Hard",
                equipment: "Full Gym",
                description: "Load vertical pull-ups with external plates or kettlebell.",
                instructions: [
                    "Attach weight belt with plate around waist.",
                    "Grip bar overhand, shoulder-width.",
                    "Pull up dynamically until chest clears bar.",
                    "Lower under control to full extension."
                ],
                sets: 4,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "T-Bar Row Power",
                muscleGroup: .back,
                difficulty: "Legend",
                equipment: "Full Gym",
                description: "Heavy row variation targeting mid-back thickness.",
                instructions: [
                    "Straddle barbell with rowing handle attachment.",
                    "Hinge to 45 degrees, keeping back neutral.",
                    "Pull handle to mid-section, driving elbows back.",
                    "Control descent to full stretch."
                ],
                sets: 4,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "Heavy Deadlift Back Overload",
                muscleGroup: .back,
                difficulty: "Master",
                equipment: "Full Gym",
                description: "Absolute back posterior chain overload.",
                instructions: [
                    "Stand with barbell over mid-foot, hinge to grip.",
                    "Brace core, keep spine flat, pull shoulder blades back.",
                    "Drive through legs to lift bar, locking out hips.",
                    "Lower under control, keeping bar close to shins."
                ],
                sets: 5,
                reps: "3-5 reps"
            ),
            SuggestedWorkout(
                name: "Pike Pushups Base",
                muscleGroup: .shoulders,
                difficulty: "Easy",
                equipment: "Bodyweight Only",
                description: "Deltoid developer modifying push-up geometry.",
                instructions: [
                    "Assume pushup position, walk feet forward, hips high.",
                    "Lower head forward to form triangle with hands.",
                    "Tap crown of head gently on floor.",
                    "Press up and back through shoulders."
                ],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Elevated Pike Pushups",
                muscleGroup: .shoulders,
                difficulty: "Medium",
                equipment: "Bodyweight Only",
                description: "Increase shoulder loading by elevating feet on box.",
                instructions: [
                    "Place feet on box or bench, hips bent 90 degrees.",
                    "Lower head toward floor between hands.",
                    "Press upward through shoulders to return to start.",
                    "Keep core tight and hips high."
                ],
                sets: 3,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Handstand Hold Against Wall",
                muscleGroup: .shoulders,
                difficulty: "Hard",
                equipment: "Bodyweight Only",
                description: "Isolate deltoids using isometric wall-supported support.",
                instructions: [
                    "Kick up against sturdy wall, body vertical.",
                    "Brace core, look between hands, push floor away.",
                    "Keep shoulders active and body straight.",
                    "Hold for specified duration."
                ],
                sets: 4,
                reps: "30-45 secs hold"
            ),
            SuggestedWorkout(
                name: "Handstand Pushups Wall Assist",
                muscleGroup: .shoulders,
                difficulty: "Legend",
                equipment: "Bodyweight Only",
                description: "Vertical push loading body weight against deltoids.",
                instructions: [
                    "Position hands 6-12 inches from wall, kick up.",
                    "Lower head slowly to touch floor.",
                    "Keep elbows at 45-degree angle.",
                    "Press up explosively to arm lockout."
                ],
                sets: 4,
                reps: "5-8 reps"
            ),
            SuggestedWorkout(
                name: "Freestanding Handstand Pushup",
                muscleGroup: .shoulders,
                difficulty: "Master",
                equipment: "Bodyweight Only",
                description: "Ultimate balance and overhead push power coordination.",
                instructions: [
                    "Kick up to freestanding handstand (no wall).",
                    "Maintain absolute core line stability.",
                    "Lower head slightly to chest level.",
                    "Press up to lockout, maintaining balance."
                ],
                sets: 5,
                reps: "3-5 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Lateral Raise",
                muscleGroup: .shoulders,
                difficulty: "Easy",
                equipment: "Dumbbells",
                description: "Target lateral deltoid fibers for shoulder width.",
                instructions: [
                    "Stand holding dumbbells at sides, slight forward lean.",
                    "Raise weights out to sides in wide arc.",
                    "Stop at shoulder height, pinkies tilted up.",
                    "Lower weights under control to sides."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Overhead Press",
                muscleGroup: .shoulders,
                difficulty: "Medium",
                equipment: "Dumbbells",
                description: "Classic dumbbell shoulder press for size and strength.",
                instructions: [
                    "Sit or stand, holding dumbbells at shoulder level.",
                    "Press weights overhead without locking elbows.",
                    "Lower under control back to ear level.",
                    "Keep core braced, avoiding lower back arch."
                ],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Push Press Power",
                muscleGroup: .shoulders,
                difficulty: "Hard",
                equipment: "Dumbbells",
                description: "Incorporate leg drive to overhead press heavier weight.",
                instructions: [
                    "Stand holding dumbbells at shoulders.",
                    "Perform quick dip by bending knees slightly.",
                    "Drive legs straight, pressing weights overhead.",
                    "Control weights slowly back to shoulders."
                ],
                sets: 4,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Rear Delt Flyes",
                muscleGroup: .shoulders,
                difficulty: "Legend",
                equipment: "Dumbbells",
                description: "Isolate posterior deltoids for shoulder balance.",
                instructions: [
                    "Bent forward at hips until chest is near parallel to floor.",
                    "Hold dumbbells down, raise them out to sides.",
                    "Pinch rear delts at top of movement.",
                    "Lower dumbbells slowly to starting hang."
                ],
                sets: 4,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Seated Heavy Dumbbell Press",
                muscleGroup: .shoulders,
                difficulty: "Master",
                equipment: "Dumbbells",
                description: "Overload deltoids in seated position without leg assistance.",
                instructions: [
                    "Sit on upright bench, bring heavy dumbbells to shoulders.",
                    "Press dumbbells overhead with controlled power.",
                    "Lower under control, keeping wrists over elbows.",
                    "Push through sticky point with maximum effort."
                ],
                sets: 5,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "Dead Hang Active Shrugs",
                muscleGroup: .shoulders,
                difficulty: "Easy",
                equipment: "Pull-up Bar",
                description: "Decompress spine and build active shoulder stabilization.",
                instructions: [
                    "Hang from bar with overhand grip.",
                    "Raise shoulders toward ears, then pull them down.",
                    "Focus on active scapular movement.",
                    "Keep arms straight throughout."
                ],
                sets: 3,
                reps: "12 reps"
            ),
            SuggestedWorkout(
                name: "Inverted Pike Hang Shoulder Press",
                muscleGroup: .shoulders,
                difficulty: "Medium",
                equipment: "Pull-up Bar",
                description: "Inverted shoulder push drill using bar stability.",
                instructions: [
                    "Hang upside down in tucked position, legs wrapped.",
                    "Perform inverted pushing shrugs relative to bar.",
                    "Focus on lower traps and posterior delts.",
                    "Keep movements steady and controlled."
                ],
                sets: 3,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Bar Overhead Shoulder Shrugs",
                muscleGroup: .shoulders,
                difficulty: "Hard",
                equipment: "Pull-up Bar",
                description: "Target traps and deltoids using overhead shrugs.",
                instructions: [
                    "Support body on top of bar, lock arms.",
                    "Shrug shoulders up to ears and hold.",
                    "Lower shoulders back down under control.",
                    "Keep core locked to prevent swing."
                ],
                sets: 4,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Behind-Neck Pull-up Hangs",
                muscleGroup: .shoulders,
                difficulty: "Legend",
                equipment: "Pull-up Bar",
                description: "Target rear delts and rotator cuffs with deep pull angles.",
                instructions: [
                    "Grip bar wide, pull body up behind the neck.",
                    "Hold top position for 2 seconds.",
                    "Feel contraction in rear shoulders and upper back.",
                    "Lower slowly back to dead hang."
                ],
                sets: 4,
                reps: "5-6 reps"
            ),
            SuggestedWorkout(
                name: "Front Lever Pull-up Transitions",
                muscleGroup: .shoulders,
                difficulty: "Master",
                equipment: "Pull-up Bar",
                description: "Peak shoulder extension and retraction strength.",
                instructions: [
                    "Pull into horizontal front lever position.",
                    "Perform small pull-up movements.",
                    "Requires massive rear deltoid and rotator shoulder drive.",
                    "Lower back to hang under absolute control."
                ],
                sets: 5,
                reps: "3-4 reps"
            ),
            SuggestedWorkout(
                name: "Machine Shoulder Press",
                muscleGroup: .shoulders,
                difficulty: "Easy",
                equipment: "Full Gym",
                description: "Isolate deltoids using fixed track machine.",
                instructions: [
                    "Adjust seat so handles are at shoulder height.",
                    "Grip handles, press upward smoothly.",
                    "Lower slowly back to starting depth.",
                    "Keep back flat against pad."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Barbell Military Press",
                muscleGroup: .shoulders,
                difficulty: "Medium",
                equipment: "Full Gym",
                description: "Strict barbell overhead press for shoulder power.",
                instructions: [
                    "Unrack barbell at collarbone level.",
                    "Press bar overhead, pulling head forward as bar clears.",
                    "Lock out overhead, then lower bar to upper chest.",
                    "Keep legs locked and glutes tight."
                ],
                sets: 3,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Barbell Behind Press",
                muscleGroup: .shoulders,
                difficulty: "Hard",
                equipment: "Full Gym",
                description: "Target rear and side delts with behind-neck pressing.",
                instructions: [
                    "Unrack barbell behind neck onto upper traps.",
                    "Press bar straight overhead.",
                    "Lower bar under control back to traps.",
                    "Requires good shoulder mobility."
                ],
                sets: 4,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Cable Lateral Raises",
                muscleGroup: .shoulders,
                difficulty: "Legend",
                equipment: "Full Gym",
                description: "Constant tension lateral raise using low cable pulley.",
                instructions: [
                    "Stand next to low pulley, grip cable with far hand.",
                    "Raise arm out to side to shoulder height.",
                    "Feel constant cable tension throughout.",
                    "Control descent back to starting point."
                ],
                sets: 4,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Heavy Barbell Push Press",
                muscleGroup: .shoulders,
                difficulty: "Master",
                equipment: "Full Gym",
                description: "Maximum overload overhead press utilizing explosive leg power.",
                instructions: [
                    "Unrack heavy barbell, dip knees slightly.",
                    "Drive legs upward, pushing bar overhead.",
                    "Lower bar slowly to rack position on collarbones.",
                    "Brace core to stabilize heavy load."
                ],
                sets: 5,
                reps: "4-6 reps"
            ),
            SuggestedWorkout(
                name: "Bench Tricep Dips",
                muscleGroup: .arms,
                difficulty: "Easy",
                equipment: "Bodyweight Only",
                description: "Tricep builder using elevated bench or chair surface.",
                instructions: [
                    "Place hands on bench edge behind you, feet flat on floor.",
                    "Lower hips by bending elbows to 90 degrees.",
                    "Press back up to lock arms.",
                    "Keep back close to bench throughout."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Close-Grip Pushups",
                muscleGroup: .arms,
                difficulty: "Medium",
                equipment: "Bodyweight Only",
                description: "Push-up variation shifting focus to triceps.",
                instructions: [
                    "Assume high plank, hands closer than shoulder-width.",
                    "Lower chest to floor, keeping elbows tucked close to ribs.",
                    "Press up dynamically, locking out triceps.",
                    "Keep core tight to prevent hip drop."
                ],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Diamond Pushups",
                muscleGroup: .arms,
                difficulty: "Hard",
                equipment: "Bodyweight Only",
                description: "Tight grip push-ups to isolate triceps.",
                instructions: [
                    "Form diamond shape with thumbs and index fingers.",
                    "Lower chest to hands, keeping elbows close.",
                    "Press upward, squeezing triceps at lockout.",
                    "Maintain straight body line."
                ],
                sets: 4,
                reps: "8-12 reps"
            ),
            SuggestedWorkout(
                name: "Towel Hammer Bicep Pulls",
                muscleGroup: .arms,
                difficulty: "Legend",
                equipment: "Bodyweight Only",
                description: "Isometric pulling drill to isolate biceps.",
                instructions: [
                    "Loop towel under knee, grip ends firmly.",
                    "Pull upward against leg to create bicep tension.",
                    "Hold max contraction for 5 seconds.",
                    "Release slowly and repeat."
                ],
                sets: 4,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "Bodyweight Triceps Extensions",
                muscleGroup: .arms,
                difficulty: "Master",
                equipment: "Bodyweight Only",
                description: "Bodyweight tricep extension using low bar or floor setup.",
                instructions: [
                    "Place hands on low bar or floor, walk feet back.",
                    "Lower body by bending at elbows only.",
                    "Press back up to arm lockout using triceps.",
                    "Keep body rigid and elbows tucked."
                ],
                sets: 5,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Hammer Curls",
                muscleGroup: .arms,
                difficulty: "Easy",
                equipment: "Dumbbells",
                description: "Target brachialis and forearms using neutral grip curls.",
                instructions: [
                    "Stand holding dumbbells with palms facing each other.",
                    "Curl weights up, keeping elbows fixed at sides.",
                    "Stop at shoulder height, squeeze arms.",
                    "Lower weights under control to starting hang."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Bicep Curls",
                muscleGroup: .arms,
                difficulty: "Medium",
                equipment: "Dumbbells",
                description: "Classic bicep builder with wrist supination.",
                instructions: [
                    "Hold dumbbells at sides, palms forward.",
                    "Curl weights upward, rotating palms facing chest.",
                    "Squeeze biceps at peak contraction.",
                    "Lower weights slowly back to extension."
                ],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Overhead Tricep Extension",
                muscleGroup: .arms,
                difficulty: "Hard",
                equipment: "Dumbbells",
                description: "Target long head of triceps from overhead stretch position.",
                instructions: [
                    "Hold dumbbell with both hands overhead.",
                    "Lower weight behind head by bending elbows.",
                    "Keep elbows pointing forward, not flaring.",
                    "Press weight back up to lockout."
                ],
                sets: 4,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Incline Curls",
                muscleGroup: .arms,
                difficulty: "Legend",
                equipment: "Dumbbells",
                description: "Deep stretch bicep curl on incline bench.",
                instructions: [
                    "Sit on incline bench set to 45 degrees.",
                    "Let dumbbells hang straight down behind shoulders.",
                    "Curl weights up, keeping elbows pinned back.",
                    "Lower weights slowly to full stretch."
                ],
                sets: 4,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Heavy Dumbbell Concentration Curls",
                muscleGroup: .arms,
                difficulty: "Master",
                equipment: "Dumbbells",
                description: "Isolate bicep peak contraction using leg support.",
                instructions: [
                    "Sit on bench, elbow braced against inner thigh.",
                    "Curl heavy dumbbell upward toward chest.",
                    "Squeeze bicep intensely at top.",
                    "Control descent to starting point."
                ],
                sets: 5,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "Underhand Grip Hangs",
                muscleGroup: .arms,
                difficulty: "Easy",
                equipment: "Pull-up Bar",
                description: "Build grip and forearm bicep base endurance.",
                instructions: [
                    "Grip bar with underhand grip (palms facing you).",
                    "Hang with arms fully extended.",
                    "Brace shoulders and hold position.",
                    "Focus on grip strength."
                ],
                sets: 3,
                reps: "30-45 secs hold"
            ),
            SuggestedWorkout(
                name: "Chin-ups Biceps Overload",
                muscleGroup: .arms,
                difficulty: "Medium",
                equipment: "Pull-up Bar",
                description: "Vertically load biceps using underhand grip pull.",
                instructions: [
                    "Grip bar underhand, shoulder-width apart.",
                    "Pull chest to bar, keeping elbows forward.",
                    "Squeeze biceps at top of movement.",
                    "Lower slowly back to dead hang."
                ],
                sets: 3,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Close Grip Pullups",
                muscleGroup: .arms,
                difficulty: "Hard",
                equipment: "Pull-up Bar",
                description: "Overload biceps and inner lats with close grip pull.",
                instructions: [
                    "Grip bar overhand, hands 4 inches apart.",
                    "Pull up dynamically until chin clears bar.",
                    "Lower under control to full extension.",
                    "Avoid swinging or using momentum."
                ],
                sets: 4,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Commando Pullups Trapezius",
                muscleGroup: .arms,
                difficulty: "Legend",
                equipment: "Pull-up Bar",
                description: "Lateral pull-up variation targeting arms unilaterally.",
                instructions: [
                    "Stand under bar, grip with one hand in front of other.",
                    "Pull up, bringing head to right side of bar.",
                    "Lower slowly, then pull up to left side of bar.",
                    "Switch hand placement each set."
                ],
                sets: 4,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "Single-Arm Underhand Chin Negatives",
                muscleGroup: .arms,
                difficulty: "Master",
                equipment: "Pull-up Bar",
                description: "Eccentrically load bicep using single-arm lowering.",
                instructions: [
                    "Jump up to top chin-up position with both hands.",
                    "Release one hand, hold with single underhand grip.",
                    "Lower body slowly over 5 seconds to hang.",
                    "Help with opposite hand to reset."
                ],
                sets: 5,
                reps: "3-5 reps per arm"
            ),
            SuggestedWorkout(
                name: "Cable Tricep Pushdowns",
                muscleGroup: .arms,
                difficulty: "Easy",
                equipment: "Full Gym",
                description: "Isolate triceps using cable pulley with rope attachment.",
                instructions: [
                    "Grip rope attachment, pin elbows to ribs.",
                    "Press rope down, spreading ends at lockout.",
                    "Squeeze triceps at bottom.",
                    "Return rope slowly back to elbow height."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Barbell EZ-Bar Bicep Curls",
                muscleGroup: .arms,
                difficulty: "Medium",
                equipment: "Full Gym",
                description: "Overload biceps using curved EZ barbell to reduce wrist strain.",
                instructions: [
                    "Hold EZ bar with underhand grip.",
                    "Curl bar upward, keeping elbows locked at sides.",
                    "Squeeze biceps at top of motion.",
                    "Lower bar under control back to thighs."
                ],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Lying Barbell Skullcrushers",
                muscleGroup: .arms,
                difficulty: "Hard",
                equipment: "Full Gym",
                description: "Tricep overload pressing barbell to forehead.",
                instructions: [
                    "Lie on flat bench, hold EZ-bar over chest.",
                    "Lower bar to forehead by bending elbows.",
                    "Keep elbows pointing up, not flaring.",
                    "Press bar back up to lockout using triceps."
                ],
                sets: 4,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Preacher Bench Curls",
                muscleGroup: .arms,
                difficulty: "Legend",
                equipment: "Full Gym",
                description: "Strict bicep isolation preventing shoulder assist.",
                instructions: [
                    "Sit at preacher bench, brace arms against pad.",
                    "Lower EZ-bar to near full extension.",
                    "Curl bar up, keeping upper arms flat on pad.",
                    "Squeeze biceps at peak."
                ],
                sets: 4,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Weighted Chin-ups Arm Overload",
                muscleGroup: .arms,
                difficulty: "Master",
                equipment: "Full Gym",
                description: "Vertical bicep overload loading extra plates.",
                instructions: [
                    "Secure weight belt around waist with plates.",
                    "Grip bar underhand, pull chest up.",
                    "Lower under control to full dead hang.",
                    "Requires massive arm strength."
                ],
                sets: 5,
                reps: "4-6 reps"
            ),
            SuggestedWorkout(
                name: "Plank Rotations Obliques",
                muscleGroup: .core,
                difficulty: "Easy",
                equipment: "Bodyweight Only",
                description: "Brace core in low plank and rotate hips side-to-side.",
                instructions: [
                    "Start in forearm plank, elbows under shoulders.",
                    "Rotate hips to right, tapping floor lightly.",
                    "Return to center, then rotate to left.",
                    "Keep shoulders steady and core braced."
                ],
                sets: 3,
                reps: "10 reps per side"
            ),
            SuggestedWorkout(
                name: "Hollow Body Hold",
                muscleGroup: .core,
                difficulty: "Medium",
                equipment: "Bodyweight Only",
                description: "Isometric core builder locking lower back to floor.",
                instructions: [
                    "Lie flat on back, arms overhead, legs straight.",
                    "Lift head, shoulders, and legs off floor.",
                    "Press lower back flat into the ground.",
                    "Hold hollow shape, breathing shallowly."
                ],
                sets: 3,
                reps: "30-40 secs hold"
            ),
            SuggestedWorkout(
                name: "Hanging Knee Raises",
                muscleGroup: .core,
                difficulty: "Hard",
                equipment: "Bodyweight Only",
                description: "Target lower abs hanging from pull-up bar.",
                instructions: [
                    "Hang from bar with straight arms.",
                    "Pull knees to chest, rotating pelvis up.",
                    "Hold top contraction for 1 second.",
                    "Lower knees slowly to avoid swinging."
                ],
                sets: 4,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "L-Sit Progressions",
                muscleGroup: .core,
                difficulty: "Legend",
                equipment: "Bodyweight Only",
                description: "Compression drill targeting abs, hip flexors, and triceps.",
                instructions: [
                    "Sit on floor, hands next to hips.",
                    "Press hands down to lift hips and legs off floor.",
                    "Keep legs straight and parallel to ground.",
                    "Hold lift, bracing core."
                ],
                sets: 4,
                reps: "15-20 secs hold"
            ),
            SuggestedWorkout(
                name: "Dragon Flags Absolute Control",
                muscleGroup: .core,
                difficulty: "Master",
                equipment: "Bodyweight Only",
                description: "Ultimate core leverage drill popularized by Bruce Lee.",
                instructions: [
                    "Lie on bench, grip edge behind head firmly.",
                    "Roll weight onto shoulders and lift entire body vertical.",
                    "Lower body in straight line, pivot only at shoulders.",
                    "Bring body close to bench, then pull back up."
                ],
                sets: 5,
                reps: "5-6 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Russian Twists",
                muscleGroup: .core,
                difficulty: "Easy",
                equipment: "Dumbbells",
                description: "Target obliques with loaded rotational seated twists.",
                instructions: [
                    "Sit on floor, knees bent, hold dumbbell.",
                    "Lean back 45 degrees, lift feet off floor.",
                    "Rotate torso side to side, tapping dumbbell to floor.",
                    "Keep movement slow and controlled."
                ],
                sets: 3,
                reps: "15 reps per side"
            ),
            SuggestedWorkout(
                name: "Dumbbell Plank Pull-Throughs",
                muscleGroup: .core,
                difficulty: "Medium",
                equipment: "Dumbbells",
                description: "Brace core in high plank while dragging weight side-to-side.",
                instructions: [
                    "Assume high plank, dumbbell behind left hand.",
                    "Reach under with right hand, drag dumbbell to right side.",
                    "Switch hands, pull back to left side.",
                    "Keep hips level; do not let them rotate."
                ],
                sets: 3,
                reps: "8-10 reps per side"
            ),
            SuggestedWorkout(
                name: "Weighted Sit-ups Core Lock",
                muscleGroup: .core,
                difficulty: "Hard",
                equipment: "Dumbbells",
                description: "Loaded sit-ups focusing on upper abdominal drive.",
                instructions: [
                    "Lie flat, knees bent, hold dumbbell over chest.",
                    "Perform sit-up, pressing dumbbell overhead.",
                    "Lower torso slowly back to floor.",
                    "Keep dumbbell stable throughout."
                ],
                sets: 4,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Standing Side Bends",
                muscleGroup: .core,
                difficulty: "Legend",
                equipment: "Dumbbells",
                description: "Isolate obliques in standing position.",
                instructions: [
                    "Stand tall, hold dumbbell in one hand.",
                    "Lower dumbbell down side of thigh by bending side.",
                    "Squeeze obliques on opposite side to return upright.",
                    "Avoid twisting hips or shoulders."
                ],
                sets: 4,
                reps: "12-15 reps per side"
            ),
            SuggestedWorkout(
                name: "Dumbbell Renegade Row Core Lift",
                muscleGroup: .core,
                difficulty: "Master",
                equipment: "Dumbbells",
                description: "High plank dumbbell row targeting abs and upper back.",
                instructions: [
                    "High plank gripping dumbbells, feet wide.",
                    "Row dumbbell to ribs, bracing core to stay level.",
                    "Return weight to floor under control.",
                    "Switch sides and repeat next rep."
                ],
                sets: 5,
                reps: "8-10 reps per side"
            ),
            SuggestedWorkout(
                name: "Hanging Knee Raises Prep",
                muscleGroup: .core,
                difficulty: "Easy",
                equipment: "Pull-up Bar",
                description: "Build core compression and hanging tolerance.",
                instructions: [
                    "Hang from bar, palms forward.",
                    "Raise knees to 90 degrees.",
                    "Hold for 1 second, then lower slowly.",
                    "Focus on control."
                ],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Hanging Leg Raises",
                muscleGroup: .core,
                difficulty: "Medium",
                equipment: "Pull-up Bar",
                description: "Raise straight legs vertically from dead hang.",
                instructions: [
                    "Hang from bar, legs locked straight.",
                    "Raise legs parallel to floor.",
                    "Lower under strict control.",
                    "Avoid using momentum or swinging."
                ],
                sets: 3,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Windshield Wipers",
                muscleGroup: .core,
                difficulty: "Hard",
                equipment: "Pull-up Bar",
                description: "Hanging rotational core drill targeting obliques.",
                instructions: [
                    "Hang from bar, raise legs vertical to bar.",
                    "Rotate legs side to side in wide arc.",
                    "Keep hips high and arms locked.",
                    "Control rotation angle."
                ],
                sets: 4,
                reps: "6-8 reps per side"
            ),
            SuggestedWorkout(
                name: "Bar L-Sit Hold",
                muscleGroup: .core,
                difficulty: "Legend",
                equipment: "Pull-up Bar",
                description: "Hanging core compression holding L-shape.",
                instructions: [
                    "Hang from bar, raise straight legs parallel to floor.",
                    "Maintain L-sit position, keeping legs active.",
                    "Hold for specified duration.",
                    "Lower legs slowly at end."
                ],
                sets: 4,
                reps: "20-30 secs hold"
            ),
            SuggestedWorkout(
                name: "Toes to Bar Core Focus",
                muscleGroup: .core,
                difficulty: "Master",
                equipment: "Pull-up Bar",
                description: "Hanging core compression bringing toes to touch bar.",
                instructions: [
                    "Hang from bar, lift straight legs upward.",
                    "Tap shoelaces to bar between hands.",
                    "Lower legs slowly back to dead hang.",
                    "Engage lats to assist core pull."
                ],
                sets: 5,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Cable Woodchoppers",
                muscleGroup: .core,
                difficulty: "Easy",
                equipment: "Full Gym",
                description: "Rotational core drill using cable pulley stack.",
                instructions: [
                    "Stand sideways to high cable pulley, grip handle with both hands.",
                    "Pull cable diagonally down across body, rotating torso.",
                    "Pivot back foot slightly.",
                    "Slowly return to start."
                ],
                sets: 3,
                reps: "12 reps per side"
            ),
            SuggestedWorkout(
                name: "Ab Wheel Rollouts",
                muscleGroup: .core,
                difficulty: "Medium",
                equipment: "Full Gym",
                description: "Extreme anterior core extension using ab roller.",
                instructions: [
                    "Kneel on pad, grip ab wheel handles.",
                    "Roll wheel forward, extending body flat.",
                    "Brace core, do not let lower back sag.",
                    "Pull wheel back to start using abs."
                ],
                sets: 3,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Decline Weighted Situps",
                muscleGroup: .core,
                difficulty: "Hard",
                equipment: "Full Gym",
                description: "Declined sit-ups holding weight plate.",
                instructions: [
                    "Secure feet in decline bench, hold plate at chest.",
                    "Lower torso back until shoulders clear pad.",
                    "Sit up dynamically, squeezing abs.",
                    "Maintain flat back throughout."
                ],
                sets: 4,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Cable Crunches",
                muscleGroup: .core,
                difficulty: "Legend",
                equipment: "Full Gym",
                description: "Kneeling weighted crunch targeting rectus abdominis.",
                instructions: [
                    "Kneel facing cable stack, hold rope behind neck.",
                    "Crunch down, drawing elbows to thighs.",
                    "Exhale fully at bottom contraction.",
                    "Return slowly to upright position."
                ],
                sets: 4,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Weighted Planks Heavy Duty",
                muscleGroup: .core,
                difficulty: "Master",
                equipment: "Full Gym",
                description: "Overload core stabilizers with plate loading.",
                instructions: [
                    "Assume forearm plank position.",
                    "Have partner place heavy plate on lower back.",
                    "Maintain rigid plank, bracing core.",
                    "Hold for specified duration."
                ],
                sets: 5,
                reps: "45-60 secs hold"
            ),
            SuggestedWorkout(
                name: "Assisted Squats Joint Mobility",
                muscleGroup: .legs,
                difficulty: "Easy",
                equipment: "Bodyweight Only",
                description: "Use wall or chair support to build base squat depth.",
                instructions: [
                    "Stand facing support, hands resting on it.",
                    "Squat down, pushing hips back and down.",
                    "Keep chest up, weight in heels.",
                    "Press back up to standing position."
                ],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Bodyweight Air Squats",
                muscleGroup: .legs,
                difficulty: "Medium",
                equipment: "Bodyweight Only",
                description: "Classic quad and glute builder using body weight.",
                instructions: [
                    "Stand feet shoulder-width, toes angled out.",
                    "Squat down until thighs are parallel to floor.",
                    "Keep knees tracking over toes.",
                    "Press up dynamically through heels."
                ],
                sets: 3,
                reps: "15-20 reps"
            ),
            SuggestedWorkout(
                name: "Bulgarian Split Squats",
                muscleGroup: .legs,
                difficulty: "Hard",
                equipment: "Bodyweight Only",
                description: "Unilateral leg developer targeting quads and glutes.",
                instructions: [
                    "Place rear foot on bench behind you.",
                    "Lower front thigh until parallel to ground.",
                    "Keep front knee behind toes.",
                    "Drive up through front heel."
                ],
                sets: 4,
                reps: "10-12 reps per side"
            ),
            SuggestedWorkout(
                name: "Pistol Squat Progression",
                muscleGroup: .legs,
                difficulty: "Legend",
                equipment: "Bodyweight Only",
                description: "Single leg squat requiring balance, mobility, and strength.",
                instructions: [
                    "Stand on one leg, extend other leg forward.",
                    "Lower hips down into deep single-leg squat.",
                    "Keep heel flat and knee stable.",
                    "Drive back up to standing balance."
                ],
                sets: 4,
                reps: "5-6 reps per side"
            ),
            SuggestedWorkout(
                name: "Shrimp Squat Leg Destroy",
                muscleGroup: .legs,
                difficulty: "Master",
                equipment: "Bodyweight Only",
                description: "Advanced single leg squat keeping rear foot bent behind.",
                instructions: [
                    "Stand on one leg, bend rear knee holding foot.",
                    "Lower until rear knee touches floor gently.",
                    "Drive back up using front leg power.",
                    "Keep torso upright."
                ],
                sets: 5,
                reps: "4-6 reps per side"
            ),
            SuggestedWorkout(
                name: "Dumbbell Goblet Squat",
                muscleGroup: .legs,
                difficulty: "Easy",
                equipment: "Dumbbells",
                description: "Load quads holding dumbbell close to chest.",
                instructions: [
                    "Hold dumbbell vertically at chest level.",
                    "Squat down to parallel depth, chest up.",
                    "Push knees outward over toes.",
                    "Press up to standing position."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Romanian Deadlift",
                muscleGroup: .legs,
                difficulty: "Medium",
                equipment: "Dumbbells",
                description: "Target hamstrings and glutes with loaded hip hinge.",
                instructions: [
                    "Stand tall holding dumbbells in front of thighs.",
                    "Hinge forward at hips, sliding weights down legs.",
                    "Keep back flat and knees slightly bent.",
                    "Squeeze glutes to return to standing position."
                ],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Walking Lunges",
                muscleGroup: .legs,
                difficulty: "Hard",
                equipment: "Dumbbells",
                description: "Loaded walking lunges for unilateral leg power.",
                instructions: [
                    "Hold dumbbells at sides, step forward.",
                    "Lower until back knee is near floor.",
                    "Drive through front heel to step forward into next rep.",
                    "Keep torso upright."
                ],
                sets: 4,
                reps: "10-12 steps per side"
            ),
            SuggestedWorkout(
                name: "Dumbbell Step-Ups Quad Burn",
                muscleGroup: .legs,
                difficulty: "Legend",
                equipment: "Dumbbells",
                description: "Step onto elevated box holding dumbbells.",
                instructions: [
                    "Stand holding dumbbells in front of sturdy box.",
                    "Place one foot on box, drive up to stand.",
                    "Control descent back to floor.",
                    "Perform all reps on one leg before switching."
                ],
                sets: 4,
                reps: "8-10 reps per side"
            ),
            SuggestedWorkout(
                name: "Dumbbell Single-Leg Deadlift",
                muscleGroup: .legs,
                difficulty: "Master",
                equipment: "Dumbbells",
                description: "Overload hamstrings unilaterally while testing balance.",
                instructions: [
                    "Hold dumbbell in opposite hand of working leg.",
                    "Hinge forward, extending free leg behind.",
                    "Keep back flat, feel stretch in hamstring.",
                    "Return upright using glutes."
                ],
                sets: 5,
                reps: "6-8 reps per side"
            ),
            SuggestedWorkout(
                name: "Hanging Leg Extensions Prep",
                muscleGroup: .legs,
                difficulty: "Easy",
                equipment: "Pull-up Bar",
                description: "Quad loading using leg extension under hanging support.",
                instructions: [
                    "Hang from bar, bend knees 90 degrees.",
                    "Extend legs straight out and hold.",
                    "Lower legs slowly back to bent angle.",
                    "Keep core tight."
                ],
                sets: 3,
                reps: "12 reps"
            ),
            SuggestedWorkout(
                name: "Bar Assisted Pistol Squats",
                muscleGroup: .legs,
                difficulty: "Medium",
                equipment: "Pull-up Bar",
                description: "Learn pistol squat balance using bar for support.",
                instructions: [
                    "Grip bar at chest height, lift one leg.",
                    "Perform single-leg squat, using bar to assist upward pull.",
                    "Drive up through heel.",
                    "Switch legs each set."
                ],
                sets: 3,
                reps: "8-10 reps per side"
            ),
            SuggestedWorkout(
                name: "Single Leg Calf Raises",
                muscleGroup: .legs,
                difficulty: "Hard",
                equipment: "Pull-up Bar",
                description: "High-rep calf work using bar for balance support.",
                instructions: [
                    "Stand on one foot near bar support, hand on it.",
                    "Raise heel high, pressing onto toes.",
                    "Squeeze calf at top contraction.",
                    "Lower heel slowly."
                ],
                sets: 4,
                reps: "15-20 reps per side"
            ),
            SuggestedWorkout(
                name: "Bar Hanging Leg Swings",
                muscleGroup: .legs,
                difficulty: "Legend",
                equipment: "Pull-up Bar",
                description: "Decompress hips and stretch hamstrings dynamically.",
                instructions: [
                    "Hang from bar, swing legs forward and back.",
                    "Control swing using abs and lower back.",
                    "Stretch hip flexors and hamstrings dynamically.",
                    "Maintain controlled tempo."
                ],
                sets: 4,
                reps: "12 reps"
            ),
            SuggestedWorkout(
                name: "Air Squats Under-Bar Shrugs",
                muscleGroup: .legs,
                difficulty: "Master",
                equipment: "Pull-up Bar",
                description: "Perform deep air squats, shrugging against bar at top.",
                instructions: [
                    "Position bar at shoulder height, stand beneath.",
                    "Perform deep air squat, stand up, shrug against bar.",
                    "Combine leg extension with neck shroud squeeze.",
                    "Maintain strict form."
                ],
                sets: 5,
                reps: "10 reps"
            ),
            SuggestedWorkout(
                name: "Leg Press Machine",
                muscleGroup: .legs,
                difficulty: "Easy",
                equipment: "Full Gym",
                description: "Isolate quads and glutes in fixed track machine.",
                instructions: [
                    "Sit in machine, place feet shoulder-width on sled.",
                    "Release safety pins, lower sled under control.",
                    "Press sled back up without locking knees.",
                    "Keep lower back flat against seat."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Barbell Back Squat",
                muscleGroup: .legs,
                difficulty: "Medium",
                equipment: "Full Gym",
                description: "The king of lower body compound exercises.",
                instructions: [
                    "Rest barbell on upper traps, stand tall.",
                    "Squat down until hips are below knees.",
                    "Keep chest up and knees tracking outward.",
                    "Drive upward through mid-foot."
                ],
                sets: 3,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Barbell Romanian Deadlift",
                muscleGroup: .legs,
                difficulty: "Hard",
                equipment: "Full Gym",
                description: "Heavy hip hinge targeting hamstrings and glutes.",
                instructions: [
                    "Hold barbell with overhand grip at hips.",
                    "Hinge forward, pushing hips back, bar sliding down thighs.",
                    "Stop at mid-shin, feel deep hamstring stretch.",
                    "Squeeze glutes to return upright."
                ],
                sets: 4,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Barbell Front Squats",
                muscleGroup: .legs,
                difficulty: "Legend",
                equipment: "Full Gym",
                description: "Quad-dominant squatting variant holding bar on collarbones.",
                instructions: [
                    "Rack barbell on front of shoulders (front rack).",
                    "Keep elbows pointing forward, chest up.",
                    "Squat deep, keeping torso vertical.",
                    "Drive up through heels."
                ],
                sets: 4,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "Heavy Barbell Deadlift Power",
                muscleGroup: .legs,
                difficulty: "Master",
                equipment: "Full Gym",
                description: "Pure lower body pulling power overload.",
                instructions: [
                    "Stand close to bar, hinge to grip overhand.",
                    "Flatten back, brace abs, engage hamstrings.",
                    "Pull bar off floor in straight vertical line.",
                    "Lock out hips fully at top."
                ],
                sets: 5,
                reps: "3-5 reps"
            ),
            SuggestedWorkout(
                name: "Downward Dog Flow",
                muscleGroup: .fullBody,
                difficulty: "Easy",
                equipment: "Bodyweight Only",
                description: "Flow between high plank and downward dog for full body mobility.",
                instructions: [
                    "Start in high plank, shoulders over wrists.",
                    "Push hips up and back into downward dog.",
                    "Press heels toward floor, stretching hamstrings.",
                    "Flow back to high plank smoothly."
                ],
                sets: 3,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Cobra Stretch Flow",
                muscleGroup: .fullBody,
                difficulty: "Medium",
                equipment: "Bodyweight Only",
                description: "Decompress lower back and open chest dynamically.",
                instructions: [
                    "Lie face down, hands under shoulders.",
                    "Press up, arching back and raising chest.",
                    "Look up, opening anterior chain.",
                    "Lower down slowly to reset."
                ],
                sets: 3,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "World Greatest Stretch",
                muscleGroup: .fullBody,
                difficulty: "Hard",
                equipment: "Bodyweight Only",
                description: "Multijoint mobility drill loading chest, hips, and shoulders.",
                instructions: [
                    "Step forward into deep lunge, hands inside front foot.",
                    "Rotate inside arm up to ceiling, look at hand.",
                    "Bring hand back, extend front knee to stretch hamstring.",
                    "Switch sides and repeat next rep."
                ],
                sets: 4,
                reps: "6-8 reps per side"
            ),
            SuggestedWorkout(
                name: "Inverted Pike Stretch",
                muscleGroup: .fullBody,
                difficulty: "Legend",
                equipment: "Bodyweight Only",
                description: "Active shoulder opening and hamstring length developer.",
                instructions: [
                    "Bent at hips, hands on floor, head tucked.",
                    "Press chest toward toes, opening shoulders.",
                    "Keep knees straight, stretching calves and hamstrings.",
                    "Hold active stretch for 3 seconds."
                ],
                sets: 4,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Bridge Pose Back Extension",
                muscleGroup: .fullBody,
                difficulty: "Master",
                equipment: "Bodyweight Only",
                description: "Full body posterior extension bridging off floor.",
                instructions: [
                    "Lie on back, bend knees, place hands next to ears.",
                    "Press through hands and feet to arch body off floor.",
                    "Extend arms and legs, pushing chest out.",
                    "Lower under control to avoid spine strain."
                ],
                sets: 5,
                reps: "5 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Thrusters",
                muscleGroup: .fullBody,
                difficulty: "Easy",
                equipment: "Dumbbells",
                description: "Combine squat with overhead press using dumbbells.",
                instructions: [
                    "Hold dumbbells at shoulders, squat down.",
                    "Stand up explosively, driving weights overhead.",
                    "Lower weights back to shoulders under control.",
                    "Repeat next rep immediately."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Man Makers",
                muscleGroup: .fullBody,
                difficulty: "Medium",
                equipment: "Dumbbells",
                description: "Burpee, row, clean, and press combined with dumbbells.",
                instructions: [
                    "Plank holding dumbbells, perform push-up.",
                    "Row dumbbell to ribs on right, then left.",
                    "Jump feet forward, clean dumbbells to shoulders.",
                    "Squat and press weights overhead."
                ],
                sets: 3,
                reps: "6-8 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Clean and Press",
                muscleGroup: .fullBody,
                difficulty: "Hard",
                equipment: "Dumbbells",
                description: "Ground to overhead power drill using dumbbells.",
                instructions: [
                    "Stand holding dumbbells at knees, hinge hips.",
                    "Clean dumbbells to shoulders with leg pop.",
                    "Dip knees and press weights overhead.",
                    "Lower dumbbells to sides and repeat."
                ],
                sets: 4,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Farmers Carry",
                muscleGroup: .fullBody,
                difficulty: "Legend",
                equipment: "Dumbbells",
                description: "Full body carry building traps, core, and grip.",
                instructions: [
                    "Deadlift heavy dumbbells to sides.",
                    "Stand tall, brace core, pull shoulders back.",
                    "Walk in straight line using small, controlled steps.",
                    "Avoid letting weights swing."
                ],
                sets: 4,
                reps: "1 min walk"
            ),
            SuggestedWorkout(
                name: "Dumbbell Devil Press",
                muscleGroup: .fullBody,
                difficulty: "Master",
                equipment: "Dumbbells",
                description: "High-intensity dumbbell burpee to snatch.",
                instructions: [
                    "Drop into burpee chest to dumbbells on floor.",
                    "Jump feet wide, swing weights between legs.",
                    "Snatch dumbbells overhead in one continuous path.",
                    "Lower weights under control and repeat next rep."
                ],
                sets: 5,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Active Bar Hanging Alignment",
                muscleGroup: .fullBody,
                difficulty: "Easy",
                equipment: "Pull-up Bar",
                description: "Decompress spine and engage shoulder stabilizers.",
                instructions: [
                    "Grip pull-up bar wide overhand.",
                    "Pull shoulder blades down, bracing abs.",
                    "Keep legs hanging straight, feet close.",
                    "Hold active position, breathing deeply."
                ],
                sets: 3,
                reps: "30-45 secs hold"
            ),
            SuggestedWorkout(
                name: "Kipping Pullups Flow",
                muscleGroup: .fullBody,
                difficulty: "Medium",
                equipment: "Pull-up Bar",
                description: "Incorporate hip swing to drive pull-up count.",
                instructions: [
                    "Initiate kipping swing using shoulders and hips.",
                    "Pull chest to bar as body swings back.",
                    "Push away from bar at top to cycle next rep.",
                    "Maintain rhythmic swing cadence."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Toes-to-Bar Compression",
                muscleGroup: .fullBody,
                difficulty: "Hard",
                equipment: "Pull-up Bar",
                description: "Anterior chain developer bringing toes to bar.",
                instructions: [
                    "Hang from bar, swing legs back slightly.",
                    "Crunch abs, bringing straight legs up to touch bar.",
                    "Lower legs slowly to prevent wild swinging.",
                    "Keep shoulders active."
                ],
                sets: 4,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Muscle-up Bar Transition",
                muscleGroup: .fullBody,
                difficulty: "Legend",
                equipment: "Pull-up Bar",
                description: "Transition pull-up into straight bar dip.",
                instructions: [
                    "Pull up explosively, pulling bar to lower chest.",
                    "Transition wrists over bar, leaning forward.",
                    "Press bodyweight up to full arm extension.",
                    "Lower slowly back to dead hang."
                ],
                sets: 4,
                reps: "4-6 reps"
            ),
            SuggestedWorkout(
                name: "Bar Hanging Around-the-World",
                muscleGroup: .fullBody,
                difficulty: "Master",
                equipment: "Pull-up Bar",
                description: "Full body rotation hanging from bar.",
                instructions: [
                    "Hang from bar, raise straight legs vertical.",
                    "Rotate legs in wide circle (360 degrees).",
                    "Brace core and lats to stabilize body.",
                    "Repeat in opposite direction next set."
                ],
                sets: 5,
                reps: "5-6 reps"
            ),
            SuggestedWorkout(
                name: "Kettlebell Swing Power",
                muscleGroup: .fullBody,
                difficulty: "Easy",
                equipment: "Full Gym",
                description: "Hip hinge movement building hamstrings and glutes.",
                instructions: [
                    "Stand feet wide, hold kettlebell in front.",
                    "Hinge at hips, swinging kettlebell between legs.",
                    "Drive hips forward explosively, swinging bell to chest.",
                    "Control swing back down, hinging again immediately."
                ],
                sets: 3,
                reps: "15-20 reps"
            ),
            SuggestedWorkout(
                name: "Barbell Clean and Press",
                muscleGroup: .fullBody,
                difficulty: "Medium",
                equipment: "Full Gym",
                description: "Olympic lifting basic lifting bar from floor overhead.",
                instructions: [
                    "Deadlift barbell from floor, pull to hips.",
                    "Pop hips, clean bar onto front rack shoulders.",
                    "Dip knees, press barbell overhead.",
                    "Lower bar to chest, then floor, and repeat."
                ],
                sets: 3,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Barbell Snatch Power",
                muscleGroup: .fullBody,
                difficulty: "Hard",
                equipment: "Full Gym",
                description: "Ground-to-overhead barbell pull in one continuous motion.",
                instructions: [
                    "Grip barbell wide, flat back, hinge down.",
                    "Pull bar off floor explosively, shrug shoulders.",
                    "Drop under bar, catching it overhead in squat.",
                    "Stand up fully, locking bar overhead."
                ],
                sets: 4,
                reps: "5-6 reps"
            ),
            SuggestedWorkout(
                name: "Barbell Thrusters Full Body",
                muscleGroup: .fullBody,
                difficulty: "Legend",
                equipment: "Full Gym",
                description: "Front squat to overhead press with heavy barbell.",
                instructions: [
                    "Rack barbell on front of shoulders, squat deep.",
                    "Stand up explosively, pressing bar overhead.",
                    "Lower bar back to front rack under control.",
                    "Repeat next rep immediately."
                ],
                sets: 4,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Heavy Barbell Clean and Jerk",
                muscleGroup: .fullBody,
                difficulty: "Master",
                equipment: "Full Gym",
                description: "The absolute king of full body power output.",
                instructions: [
                    "Clean heavy barbell from floor to front rack shoulders.",
                    "Dip knees, drive bar up while splitting legs (split jerk).",
                    "Lock bar overhead, bring feet back together.",
                    "Lower bar under control to floor and reset next rep."
                ],
                sets: 5,
                reps: "2-3 reps"
            ),
            SuggestedWorkout(
                name: "Jumping Jacks Heat",
                muscleGroup: .cardio,
                difficulty: "Easy",
                equipment: "Bodyweight Only",
                description: "Classic aerobic warming drill.",
                instructions: [
                    "Stand feet close, hands at sides.",
                    "Jump feet wide while bringing hands overhead.",
                    "Jump back to starting position immediately.",
                    "Maintain fast, steady cadence."
                ],
                sets: 3,
                reps: "1 min work"
            ),
            SuggestedWorkout(
                name: "Mountain Climbers Cardio",
                muscleGroup: .cardio,
                difficulty: "Medium",
                equipment: "Bodyweight Only",
                description: "High plank leg driving cardio interval.",
                instructions: [
                    "Assume high plank position.",
                    "Drive right knee to chest, then left knee.",
                    "Alternate legs rapidly as if running.",
                    "Keep hips level and core tight."
                ],
                sets: 3,
                reps: "1 min work"
            ),
            SuggestedWorkout(
                name: "Burpee Interval Energy",
                muscleGroup: .cardio,
                difficulty: "Hard",
                equipment: "Bodyweight Only",
                description: "Full body cardio drill spiking heart rate.",
                instructions: [
                    "Drop to floor chest touching ground.",
                    "Jump feet back in, stand up dynamically.",
                    "Jump vertically, hands clapping overhead.",
                    "Land soft and drop into next rep immediately."
                ],
                sets: 4,
                reps: "15-20 reps"
            ),
            SuggestedWorkout(
                name: "Shadow Boxing Agile",
                muscleGroup: .cardio,
                difficulty: "Legend",
                equipment: "Bodyweight Only",
                description: "Agile shadow boxing intervals focusing on footwork.",
                instructions: [
                    "Assume boxing stance, hands protecting chin.",
                    "Throw rapid punches (jabs, crosses, hooks).",
                    "Move feet constantly, pivoting and ducking.",
                    "Maintain high punch output and fast breathing."
                ],
                sets: 4,
                reps: "2 mins work"
            ),
            SuggestedWorkout(
                name: "Tuck Jumps Cardio",
                muscleGroup: .cardio,
                difficulty: "Master",
                equipment: "Bodyweight Only",
                description: "Explosive vertical jumps drawing knees to chest.",
                instructions: [
                    "Stand tall, dip knees slightly.",
                    "Jump vertically with maximum effort.",
                    "Tuck knees to chest at peak height.",
                    "Land softly on toes, absorb impact, repeat."
                ],
                sets: 5,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Light Dumbbell Shadow Boxing",
                muscleGroup: .cardio,
                difficulty: "Easy",
                equipment: "Dumbbells",
                description: "Shadow box holding light dumbbells to add load.",
                instructions: [
                    "Hold light dumbbells, assume boxing stance.",
                    "Throw controlled punches, focusing on form.",
                    "Do not snap elbows; keep movement smooth.",
                    "Step and move feet constantly."
                ],
                sets: 3,
                reps: "1 min work"
            ),
            SuggestedWorkout(
                name: "Dumbbell Goblet Squat Jumps",
                muscleGroup: .cardio,
                difficulty: "Medium",
                equipment: "Dumbbells",
                description: "Loaded squat jumps using dumbbell goblet grip.",
                instructions: [
                    "Hold dumbbell vertically at chest.",
                    "Squat down to parallel height.",
                    "Jump vertically, extending ankles and knees.",
                    "Land softly, drop back into squat immediately."
                ],
                sets: 3,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Single-Arm Snatch",
                muscleGroup: .cardio,
                difficulty: "Hard",
                equipment: "Dumbbells",
                description: "Rapid dumbbell snatch intervals for aerobic power.",
                instructions: [
                    "Hold dumbbell at knees, hinge hips.",
                    "Pull weight up and snatch overhead.",
                    "Lower under control, switch hands at chest.",
                    "Repeat immediately on opposite arm."
                ],
                sets: 4,
                reps: "15 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Thrusters Cardio",
                muscleGroup: .cardio,
                difficulty: "Legend",
                equipment: "Dumbbells",
                description: "Fast dumbbell thruster sets to spike heart rate.",
                instructions: [
                    "Hold dumbbells at shoulders, squat down.",
                    "Stand up explosively, driving weights overhead.",
                    "Lower weights back to shoulders under control.",
                    "Repeat immediately at fast cardio pace."
                ],
                sets: 4,
                reps: "15-20 reps"
            ),
            SuggestedWorkout(
                name: "Dumbbell Devil Press Cardio",
                muscleGroup: .cardio,
                difficulty: "Master",
                equipment: "Dumbbells",
                description: "Heavy dumbbell burpee to snatch cardio sprint.",
                instructions: [
                    "Burpee chest to dumbbells on floor.",
                    "Jump feet wide, swing weights between legs.",
                    "Snatch dumbbells overhead in one continuous path.",
                    "Lower weights to floor and drop into next rep immediately."
                ],
                sets: 5,
                reps: "10-12 reps"
            ),
            SuggestedWorkout(
                name: "Hanging Fast Knee Raises",
                muscleGroup: .cardio,
                difficulty: "Easy",
                equipment: "Pull-up Bar",
                description: "Hanging knee raise cardio intervals.",
                instructions: [
                    "Hang from bar with straight arms.",
                    "Drive knees to chest at fast cadence.",
                    "Control swing using core stabilizers.",
                    "Keep shoulders active."
                ],
                sets: 3,
                reps: "15-20 reps"
            ),
            SuggestedWorkout(
                name: "Pullup to Knee Raise Cycles",
                muscleGroup: .cardio,
                difficulty: "Medium",
                equipment: "Pull-up Bar",
                description: "Combine pull-up with knee tuck dynamically.",
                instructions: [
                    "Perform pull-up, drawing chin over bar.",
                    "As you lower, pull knees to chest immediately.",
                    "Extend legs, swing back, pull up again.",
                    "Maintain steady pacing."
                ],
                sets: 3,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Burpee Pullup Rapid",
                muscleGroup: .cardio,
                difficulty: "Hard",
                equipment: "Pull-up Bar",
                description: "Burpee under bar transitioning to explosive pull-up.",
                instructions: [
                    "Perform burpee under pull-up bar.",
                    "Jump up to grab bar, pull chest to bar.",
                    "Drop back to floor, go into next burpee immediately.",
                    "Keep transition fast."
                ],
                sets: 4,
                reps: "8-10 reps"
            ),
            SuggestedWorkout(
                name: "Muscle-up Fast Reps",
                muscleGroup: .cardio,
                difficulty: "Legend",
                equipment: "Pull-up Bar",
                description: "Fast muscle-up cycles to test power endurance.",
                instructions: [
                    "Execute dynamic kip pull muscle-up.",
                    "Push away from bar at top to drop under bar.",
                    "Use drop momentum to transition into next rep.",
                    "Maintain strict bar safety."
                ],
                sets: 4,
                reps: "5-6 reps"
            ),
            SuggestedWorkout(
                name: "Toes-to-Bar Fast Pacing",
                muscleGroup: .cardio,
                difficulty: "Master",
                equipment: "Pull-up Bar",
                description: "High rep toes-to-bar intervals.",
                instructions: [
                    "Hang from bar, bring toes to bar dynamically.",
                    "Use controlled kip swing to speed up cycles.",
                    "Brace core to absorb drop extension.",
                    "Maintain high rep cadence."
                ],
                sets: 5,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Gym Rowing Machine",
                muscleGroup: .cardio,
                difficulty: "Easy",
                equipment: "Full Gym",
                description: "Full body cardiovascular rowing intervals.",
                instructions: [
                    "Sit at rower, strap feet, grip handle.",
                    "Drive legs back, lean torso, pull handle to ribs.",
                    "Extend arms, hinge torso, bend knees to slide forward.",
                    "Maintain steady stroke-per-minute pacing."
                ],
                sets: 3,
                reps: "2 mins work"
            ),
            SuggestedWorkout(
                name: "Battle Ropes Wave",
                muscleGroup: .cardio,
                difficulty: "Medium",
                equipment: "Full Gym",
                description: "Upper body rope waves for cardio conditioning.",
                instructions: [
                    "Stand athletic stance, hold ropes.",
                    "Alternate arms to create rapid waves in ropes.",
                    "Keep core tight and knees bent.",
                    "Maintain wave height throughout interval."
                ],
                sets: 3,
                reps: "45 secs work"
            ),
            SuggestedWorkout(
                name: "Barbell Thruster Cardio",
                muscleGroup: .cardio,
                difficulty: "Hard",
                equipment: "Full Gym",
                description: "Barbell thrusters performed at high speed.",
                instructions: [
                    "Rack barbell on chest, squat deep.",
                    "Drive bar overhead explosively.",
                    "Control bar back to chest, dropping into next squat.",
                    "Maintain high-intensity pacing."
                ],
                sets: 4,
                reps: "12-15 reps"
            ),
            SuggestedWorkout(
                name: "Kettlebell Snatch High Reps",
                muscleGroup: .cardio,
                difficulty: "Legend",
                equipment: "Full Gym",
                description: "Unilateral high rep kettlebell snatches off floor.",
                instructions: [
                    "Hinge to grab kettlebell on floor.",
                    "Pull and snatch kettlebell overhead in one motion.",
                    "Drop bell to hips, swing back, repeat next rep.",
                    "Switch hands after specified rep count."
                ],
                sets: 4,
                reps: "15-20 reps per arm"
            ),
            SuggestedWorkout(
                name: "Assault Bike Speed Sprint",
                muscleGroup: .cardio,
                difficulty: "Master",
                equipment: "Full Gym",
                description: "Max effort sprints on air resistance assault bike.",
                instructions: [
                    "Sit on bike, feet on pedals, hands on handles.",
                    "Sprint with maximum effort, pushing handles and pedaling.",
                    "Drive heart rate to maximum output.",
                    "Maintain sprint until timer ends."
                ],
                sets: 5,
                reps: "30 secs sprint"
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

// MARK: - PR Historical Log Entry
public struct PREntry: Codable, Equatable, Identifiable {
    public var id: UUID { UUID() }
    public let date: Date
    public let value: Double
    
    public init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
}
