//
//  CharacterCreatorView.swift
//  LotE Workout Companion
//
//  Created by Antigravity on 6/23/26.
//

import SwiftUI

struct CharacterCreatorView: View {
    @ObservedObject var profileManager: UserProfileManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedToolColor: Int = 1 // Palette index: 1=Skin, 2=Hair, 3=Eyes, 4=Outfit, 5=Aura, 0=Eraser
    @State private var pixelGrid: [[Int]] = CharacterSprite.defaultGrid
    
    // Preset configuration state
    @State private var sexPreset: String = "Male"
    @State private var planetPreset: String = "Ninjonia"
    @State private var skinPreset: String = "Fair"
    @State private var hairStylePreset: String = "Spiky"
    @State private var hairColorPreset: String = "Yellow"
    @State private var outfitColorPreset: String = "Gray"
    
    // Colors mapped from selections
    var activeSkinColor: Color { Color(hex: skinHex(for: skinPreset)) ?? .orange }
    var activeHairColor: Color { Color(hex: hairHex(for: hairColorPreset)) ?? .yellow }
    var activeOutfitColor: Color { Color(hex: outfitHex(for: outfitColorPreset)) ?? .gray }
    var activeAuraColor: Color { profileManager.currentElement.accentColor }
    var activeEyeColor: Color { profileManager.currentElement.primaryColor }
    
    var body: some View {
        ZStack {
            Color(hex: "#050505")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("CHARACTER FORGE")
                            .font(.custom("Orbitron-Bold", size: 24).bold())
                            .foregroundColor(.white)
                            .tracking(4)
                        
                        Text("Design your Elsaither Warrior's pixel avatar")
                            .font(.custom("Exo2-Medium", size: 13))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 25)
                    
                    // Sprite Preview & Pixel Grid
                    VStack(spacing: 15) {
                        // Drawing grid canvas
                        VStack(spacing: 1) {
                            ForEach(0..<16, id: \.self) { r in
                                HStack(spacing: 1) {
                                    ForEach(0..<16, id: \.self) { c in
                                        let pixelVal = pixelGrid[r][c]
                                        Rectangle()
                                            .fill(colorForPixelValue(pixelVal))
                                            .frame(width: 15, height: 15)
                                            .overlay(
                                                Rectangle()
                                                    .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                                            )
                                            .onTapGesture {
                                                paintPixel(row: r, col: c)
                                            }
                                            .gesture(
                                                DragGesture(minimumDistance: 0.1)
                                                    .onChanged { _ in
                                                        paintPixel(row: r, col: c)
                                                    }
                                            )
                                    }
                                }
                            }
                        }
                        .padding(6)
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(profileManager.currentElement.primaryColor.opacity(0.4), lineWidth: 1.5)
                        )
                    }
                    
                    // Color Tool Selectors
                    VStack(alignment: .leading, spacing: 8) {
                        Text("PALETTE BRUSHES")
                            .font(.custom("Orbitron-Bold", size: 12).bold())
                            .foregroundColor(.gray)
                            .tracking(2)
                            .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            brushButton(val: 1, label: "Skin", color: activeSkinColor)
                            brushButton(val: 2, label: "Hair", color: activeHairColor)
                            brushButton(val: 3, label: "Eyes", color: activeEyeColor)
                            brushButton(val: 4, label: "Armor", color: activeOutfitColor)
                            brushButton(val: 5, label: "Aura", color: activeAuraColor)
                            brushButton(val: 0, label: "Eraser", color: .black, isEraser: true)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Layer Presets Accordion
                    VStack(spacing: 15) {
                        Text("PRESETS & LAYERS")
                            .font(.custom("Orbitron-Bold", size: 14).bold())
                            .foregroundColor(.white)
                            .tracking(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Preset selectors
                        VStack(spacing: 12) {
                            presetSelector(title: "Sex", selection: $sexPreset, options: ["Male", "Female"])
                            presetSelector(title: "Planet Style", selection: $planetPreset, options: ["Ninjonia", "Techno", "Warrion", "Battacaria"])
                            presetSelector(title: "Skin Tone", selection: $skinPreset, options: ["Fair", "Tan", "Dark", "Celestial", "Golden", "Pale"])
                            presetSelector(title: "Hair Style", selection: $hairStylePreset, options: ["Spiky", "Long", "Short", "Mohawk"])
                            presetSelector(title: "Hair Color", selection: $hairColorPreset, options: ["Yellow", "Red", "Black", "Blue", "Silver", "Green", "Brown", "Orange"])
                            presetSelector(title: "Clothing Color", selection: $outfitColorPreset, options: ["Gray", "Dark Blue", "Crimson", "Gold", "Purple", "Green", "Charcoal", "Steel"])
                        }
                        
                        // Reset Grid or Re-generate preset base
                        HStack(spacing: 15) {
                            Button(action: {
                                generateBaseFromPresets()
                            }) {
                                Text("COMPOSITE PRESETS")
                                    .font(.custom("Orbitron-Bold", size: 11).bold())
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(profileManager.currentElement.primaryColor.opacity(0.3))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(profileManager.currentElement.primaryColor, lineWidth: 1)
                                            )
                                    )
                            }
                            
                            Button(action: {
                                clearCanvas()
                            }) {
                                Text("CLEAR CANVAS")
                                    .font(.custom("Orbitron-Bold", size: 11).bold())
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.top, 5)
                    }
                    .padding(20)
                    .background(Color.white.opacity(0.02))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Save Button
                    Button(action: {
                        saveSprite()
                    }) {
                        Text("FORGE ARTIFACT")
                            .font(.custom("Orbitron-Bold", size: 15).bold())
                            .foregroundColor(.white)
                            .tracking(2)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(profileManager.currentElement.primaryColor)
                                    .shadow(color: profileManager.currentElement.primaryColor.opacity(0.4), radius: 6)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            pixelGrid = profileManager.sprite.pixelGrid
            sexPreset = profileManager.sprite.sex
            planetPreset = profileManager.sprite.outfitStyle.isEmpty ? profileManager.homePlanet : profileManager.sprite.outfitStyle
            skinPreset = skinPresetFromHex(profileManager.sprite.skinColorHex)
            hairStylePreset = profileManager.sprite.hairStyle
            hairColorPreset = hairColorPresetFromHex(profileManager.sprite.hairColorHex)
            outfitColorPreset = outfitColorPresetFromHex(profileManager.sprite.outfitColorHex)
        }
    }
    
    // MARK: - Brush Button Helper
    @ViewBuilder
    private func brushButton(val: Int, label: String, color: Color, isEraser: Bool = false) -> some View {
        Button(action: {
            selectedToolColor = val
        }) {
            VStack(spacing: 5) {
                if isEraser {
                    Image(systemName: "eraser.line.dashed")
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(6)
                        .foregroundColor(.white)
                } else {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color)
                        .frame(width: 32, height: 32)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white.opacity(0.5), lineWidth: selectedToolColor == val ? 2 : 0)
                        )
                }
                
                Text(label)
                    .font(.system(size: 10))
                    .foregroundColor(selectedToolColor == val ? .white : .gray)
            }
        }
    }
    
    // MARK: - Preset Dropdown Selector
    private func presetSelector(title: String, selection: Binding<String>, options: [String]) -> some View {
        HStack {
            Text(title)
                .font(.custom("Exo2-Medium", size: 14))
                .foregroundColor(.white)
            Spacer()
            Picker(title, selection: selection) {
                ForEach(options, id: \.self) { opt in
                    Text(opt).tag(opt)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .accentColor(profileManager.currentElement.primaryColor)
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.white.opacity(0.03))
        .cornerRadius(8)
    }
    
    // MARK: - Pixel Coloring Helpers
    private func colorForPixelValue(_ val: Int) -> Color {
        switch val {
        case 1: return activeSkinColor
        case 2: return activeHairColor
        case 3: return activeEyeColor
        case 4: return activeOutfitColor
        case 5: return activeAuraColor
        default: return Color.white.opacity(0.08)
        }
    }
    
    private func paintPixel(row: Int, col: Int) {
        if pixelGrid[row][col] != selectedToolColor {
            pixelGrid[row][col] = selectedToolColor
        }
    }
    
    private func clearCanvas() {
        pixelGrid = Array(repeating: Array(repeating: 0, count: 16), count: 16)
    }
    
    // MARK: - Preset Compositor
    private func generateBaseFromPresets() {
        var grid = Array(repeating: Array(repeating: 0, count: 16), count: 16)
        
        // 1. Draw Aura (Value 5)
        grid[1][3] = 5; grid[1][12] = 5
        grid[3][1] = 5; grid[3][14] = 5
        grid[5][2] = 5; grid[5][13] = 5
        grid[7][1] = 5; grid[7][14] = 5
        grid[9][2] = 5; grid[9][13] = 5
        grid[11][1] = 5; grid[11][14] = 5
        grid[13][3] = 5; grid[13][12] = 5
        grid[14][4] = 5; grid[14][11] = 5
        
        // 2. Draw Legs/Feet (Value 4 or 1)
        if planetPreset == "Warrion" {
            grid[14][5] = 1; grid[14][10] = 1
            grid[15][5] = 4; grid[15][10] = 4
        } else if planetPreset == "Ninjonia" && sexPreset == "Female" {
            for c in 4...11 {
                grid[14][c] = 4
            }
            grid[15][6] = 1; grid[15][9] = 1
        } else {
            grid[14][5] = 4; grid[14][10] = 4
            grid[15][5] = 4; grid[15][10] = 4
        }
        
        // 3. Draw Body & Arms (Outfit = 4, Skin = 1)
        switch planetPreset {
        case "Ninjonia":
            if sexPreset == "Female" {
                grid[9][7] = 1; grid[9][8] = 1 // neck
                grid[10][5] = 4; grid[10][6] = 4; grid[10][7] = 1; grid[10][8] = 1; grid[10][9] = 4; grid[10][10] = 4
                for c in 5...10 { grid[11][c] = 4 }
                for c in 4...11 { grid[12][c] = 4 }
                for c in 3...12 { grid[13][c] = 4 }
                for r in 10...12 {
                    grid[r][3] = 1
                    grid[r][12] = 1
                }
            } else {
                grid[9][7] = 1; grid[9][8] = 1 // neck
                grid[10][5] = 1; grid[10][6] = 1; grid[10][7] = 4; grid[10][8] = 4; grid[10][9] = 4; grid[10][10] = 4
                grid[11][5] = 1; grid[11][6] = 4; grid[11][7] = 4; grid[11][8] = 4; grid[11][9] = 4; grid[11][10] = 4
                for c in 5...10 {
                    grid[12][c] = 4
                    grid[13][c] = 4
                }
                for r in 10...12 {
                    grid[r][3] = 1; grid[r][4] = 1
                }
                for r in 10...12 {
                    grid[r][11] = 4; grid[r][12] = 4
                }
                grid[13][11] = 1; grid[13][12] = 1
                grid[13][3] = 1; grid[13][4] = 1
            }
            
        case "Techno":
            for r in 9...13 {
                for c in 5...10 {
                    grid[r][c] = 4
                }
            }
            for r in 10...12 {
                grid[r][3] = 4; grid[r][4] = 4
                grid[r][11] = 4; grid[r][12] = 4
            }
            grid[13][3] = 1; grid[13][4] = 1
            grid[13][11] = 1; grid[13][12] = 1
            
            grid[8][5] = 4; grid[8][10] = 4
            grid[8][6] = 4; grid[8][7] = 4; grid[8][8] = 4; grid[8][9] = 4
            
        case "Warrion":
            if sexPreset == "Female" {
                grid[9][7] = 1; grid[9][8] = 1 // neck
                for c in 5...10 { grid[10][c] = 4 } // fur top
                for c in 5...10 { grid[11][c] = 1 } // bare midriff
                for c in 5...10 { grid[12][c] = 4 } // belt
                for c in 4...11 { grid[13][c] = 4 } // skirt
            } else {
                grid[9][7] = 1; grid[9][8] = 1 // neck
                grid[10][5] = 1; grid[10][6] = 4; grid[10][7] = 1; grid[10][8] = 1; grid[10][9] = 4; grid[10][10] = 1 // straps
                grid[11][5] = 1; grid[11][6] = 1; grid[11][7] = 4; grid[11][8] = 4; grid[11][9] = 1; grid[11][10] = 1
                for c in 5...10 { grid[12][c] = 4 }
                grid[13][5] = 1; grid[13][6] = 4; grid[13][7] = 4; grid[13][8] = 4; grid[13][9] = 4; grid[13][10] = 1
            }
            for r in 10...12 {
                grid[r][3] = 1; grid[r][4] = 1
                grid[r][11] = 1; grid[r][12] = 1
            }
            grid[13][3] = 1; grid[13][4] = 1; grid[13][11] = 1; grid[13][12] = 1
            
        case "Battacaria":
            grid[9][7] = 4; grid[9][8] = 4
            grid[9][4] = 4; grid[10][4] = 4 // left heavy pauldron
            for r in 10...11 {
                for c in 5...10 {
                    grid[r][c] = 4
                }
            }
            for c in 4...11 {
                grid[12][c] = 4
            }
            for c in 4...11 {
                grid[13][c] = 4
            }
            for r in 10...12 {
                grid[r][3] = 4
            }
            grid[10][11] = 1; grid[10][12] = 1
            grid[11][11] = 1; grid[11][12] = 1
            grid[12][11] = 4; grid[12][12] = 4 // gauntlet
            grid[13][3] = 4; grid[13][11] = 4; grid[13][12] = 4
            
        default:
            for r in 9...13 {
                for c in 5...10 {
                    grid[r][c] = 4
                }
            }
            for r in 10...12 {
                grid[r][4] = 4; grid[r][11] = 4
            }
            grid[14][5] = 4; grid[14][10] = 4
        }
        
        // 4. Draw Face/Skin (Value 1)
        for r in 4...8 {
            for c in 5...10 {
                if grid[r][c] != 4 {
                    grid[r][c] = 1
                }
            }
        }
        if planetPreset == "Battacaria" {
            grid[4][5] = 4; grid[4][10] = 4
            grid[5][5] = 4; grid[5][6] = 4; grid[5][9] = 4; grid[5][10] = 4
        }
        
        // 5. Draw Eyes (Value 3)
        grid[6][6] = 3
        grid[6][9] = 3
        
        // 6. Draw Hair (Value 2)
        switch hairStylePreset {
        case "Spiky":
            for c in 5...10 { grid[3][c] = 2 }
            grid[2][5] = 2; grid[2][7] = 2; grid[2][8] = 2; grid[2][10] = 2
            grid[1][5] = 2; grid[1][10] = 2
            grid[4][4] = 2; grid[4][11] = 2
            grid[5][4] = 2; grid[5][11] = 2
            
        case "Long":
            for c in 5...10 { grid[3][c] = 2 }
            for c in 4...11 { grid[4][c] = 2 }
            grid[5][4] = 2; grid[5][11] = 2
            grid[6][4] = 2; grid[6][11] = 2
            grid[7][4] = 2; grid[7][11] = 2
            grid[8][4] = 2; grid[8][11] = 2
            grid[9][4] = 2; grid[9][11] = 2
            grid[10][4] = 2; grid[10][11] = 2
            
        case "Short":
            for c in 4...11 { grid[3][c] = 2 }
            grid[4][4] = 2; grid[4][11] = 2
            grid[5][4] = 2; grid[5][11] = 2
            
        case "Mohawk":
            grid[1][7] = 2; grid[1][8] = 2
            grid[2][7] = 2; grid[2][8] = 2
            grid[3][7] = 2; grid[3][8] = 2
            grid[4][7] = 2; grid[4][8] = 2
            
        default:
            for c in 4...11 { grid[3][c] = 2 }
            grid[2][5] = 2; grid[2][10] = 2
        }
        
        pixelGrid = grid
    }
    
    // Hex mappings for presets
    private func skinHex(for style: String) -> String {
        switch style {
        case "Tan": return "#D7CCC8"
        case "Dark": return "#8D6E63"
        case "Celestial": return "#9575CD"
        case "Golden": return "#FFE082"
        case "Pale": return "#FFECB3"
        default: return "#FFD180" // Fair
        }
    }
    
    private func skinPresetFromHex(_ hex: String) -> String {
        switch hex {
        case "#D7CCC8": return "Tan"
        case "#8D6E63": return "Dark"
        case "#9575CD": return "Celestial"
        case "#FFE082": return "Golden"
        case "#FFECB3": return "Pale"
        default: return "Fair"
        }
    }
    
    private func hairHex(for color: String) -> String {
        switch color {
        case "Red": return "#FF3D00"
        case "Black": return "#212121"
        case "Blue": return "#29B6F6"
        case "Silver": return "#CFD8DC"
        case "Green": return "#66BB6A"
        case "Brown": return "#5D4037"
        case "Orange": return "#FF9100"
        default: return "#FFEA00" // Yellow
        }
    }
    
    private func hairColorPresetFromHex(_ hex: String) -> String {
        switch hex {
        case "#FF3D00": return "Red"
        case "#212121": return "Black"
        case "#29B6F6": return "Blue"
        case "#CFD8DC": return "Silver"
        case "#66BB6A": return "Green"
        case "#5D4037": return "Brown"
        case "#FF9100": return "Orange"
        default: return "Yellow"
        }
    }
    
    private func outfitHex(for color: String) -> String {
        switch color {
        case "Dark Blue": return "#1A237E"
        case "Crimson": return "#B71C1C"
        case "Gold": return "#FFD700"
        case "Purple": return "#4A148C"
        case "Green": return "#1B5E20"
        case "Charcoal": return "#263238"
        case "Steel": return "#455A64"
        default: return "#37474F" // Gray
        }
    }
    
    private func outfitColorPresetFromHex(_ hex: String) -> String {
        switch hex {
        case "#1A237E": return "Dark Blue"
        case "#B71C1C": return "Crimson"
        case "#FFD700": return "Gold"
        case "#4A148C": return "Purple"
        case "#1B5E20": return "Green"
        case "#263238": return "Charcoal"
        case "#455A64": return "Steel"
        default: return "Gray"
        }
    }
    
    // MARK: - Save Sprite Action
    private func saveSprite() {
        profileManager.sprite.pixelGrid = pixelGrid
        profileManager.sprite.skinColorHex = skinHex(for: skinPreset)
        profileManager.sprite.hairColorHex = hairHex(for: hairColorPreset)
        profileManager.sprite.outfitColorHex = outfitHex(for: outfitColorPreset)
        profileManager.sprite.hairStyle = hairStylePreset
        profileManager.sprite.outfitStyle = planetPreset
        profileManager.sprite.sex = sexPreset
        presentationMode.wrappedValue.dismiss()
    }
}
