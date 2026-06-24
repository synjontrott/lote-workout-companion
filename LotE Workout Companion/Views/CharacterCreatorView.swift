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
    @State private var skinPreset: String = "Fair"
    @State private var hairStylePreset: String = "Spiky"
    @State private var hairColorPreset: String = "Yellow"
    @State private var outfitPreset: String = "Warrior Plate"
    @State private var auraPreset: String = "Flames"
    
    // Colors mapped from selections
    var activeSkinColor: Color { Color(hex: skinHex(for: skinPreset)) ?? .orange }
    var activeHairColor: Color { Color(hex: hairHex(for: hairColorPreset)) ?? .yellow }
    var activeOutfitColor: Color { Color(hex: outfitHex(for: outfitPreset)) ?? .gray }
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
                            presetSelector(title: "Skin Type", selection: $skinPreset, options: ["Fair", "Tan", "Dark", "Celestial"])
                            presetSelector(title: "Hair Color", selection: $hairColorPreset, options: ["Yellow", "Red", "Black", "Blue", "Silver", "Green"])
                            presetSelector(title: "Armor Tier", selection: $outfitPreset, options: ["Warrior Plate", "Ninja Garb", "Cyber Suit", "Mage Robes"])
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
        
        // Head / Skin (rows 4 to 8, cols 5 to 10)
        for r in 4...8 {
            for c in 5...10 {
                grid[r][c] = 1
            }
        }
        
        // Hair Styles
        switch hairStylePreset {
        default: // Spiky hair drawing template
            for r in 2...3 {
                for c in 4...11 {
                    grid[r][c] = 2
                }
            }
            grid[1][5] = 2
            grid[1][10] = 2
            grid[4][4] = 2
            grid[4][11] = 2
        }
        
        // Eyes
        grid[6][6] = 3
        grid[6][9] = 3
        
        // Armor (rows 9 to 13, cols 4 to 11)
        for r in 9...13 {
            for c in 4...11 {
                grid[r][c] = 4
            }
        }
        
        // Legs (row 14, cols 5 and 10)
        grid[14][5] = 4
        grid[14][10] = 4
        
        // Aura surrounding sprite
        grid[1][3] = 5; grid[1][12] = 5
        grid[5][2] = 5; grid[5][13] = 5
        grid[9][2] = 5; grid[9][13] = 5
        grid[13][3] = 5; grid[13][12] = 5
        
        pixelGrid = grid
    }
    
    // Hex mappings for presets
    private func skinHex(for style: String) -> String {
        switch style {
        case "Tan": return "#D7CCC8"
        case "Dark": return "#8D6E63"
        case "Celestial": return "#9575CD"
        default: return "#FFD180" // Fair
        }
    }
    
    private func hairHex(for color: String) -> String {
        switch color {
        case "Red": return "#FF3D00"
        case "Black": return "#212121"
        case "Blue": return "#29B6F6"
        case "Silver": return "#CFD8DC"
        case "Green": return "#66BB6A"
        default: return "#FFEA00" // Yellow
        }
    }
    
    private func outfitHex(for style: String) -> String {
        switch style {
        case "Ninja Garb": return "#263238"
        case "Cyber Suit": return "#00E5FF"
        case "Mage Robes": return "#4A148C"
        default: return "#37474F" // Warrior Plate
        }
    }
    
    // MARK: - Save Sprite Action
    private func saveSprite() {
        profileManager.sprite.pixelGrid = pixelGrid
        profileManager.sprite.skinColorHex = skinHex(for: skinPreset)
        profileManager.sprite.hairColorHex = hairHex(for: hairColorPreset)
        profileManager.sprite.outfitColorHex = outfitHex(for: outfitPreset)
        profileManager.sprite.hairStyle = hairStylePreset
        profileManager.sprite.outfitStyle = outfitPreset
        presentationMode.wrappedValue.dismiss()
    }
}
