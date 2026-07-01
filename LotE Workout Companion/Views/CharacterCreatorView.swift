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
                        // High performance character canvas
                        let pixelSize: CGFloat = 0.8
                        let size: CGFloat = 300.0 * pixelSize
                        Canvas { context, sz in
                            for r in 0..<300 {
                                for c in 0..<300 {
                                    let val = pixelGrid[r][c]
                                    if val != 0 {
                                        let color: Color = {
                                            switch val {
                                            case 1: return activeSkinColor
                                            case 2: return activeHairColor
                                            case 3: return activeEyeColor
                                            case 4: return activeOutfitColor
                                            case 5: return activeAuraColor
                                            default: return .clear
                                            }
                                        }()
                                        let rect = CGRect(
                                            x: CGFloat(c) * pixelSize,
                                            y: CGFloat(r) * pixelSize,
                                            width: pixelSize,
                                            height: pixelSize
                                        )
                                        context.fill(Path(rect), with: .color(color))
                                    }
                                }
                            }
                        }
                        .frame(width: size, height: size)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let location = value.location
                                    let col = Int(location.x / pixelSize)
                                    let row = Int(location.y / pixelSize)
                                    if row >= 0 && row < 300 && col >= 0 && col < 300 {
                                        if pixelGrid[row][col] != selectedToolColor {
                                            pixelGrid[row][col] = selectedToolColor
                                        }
                                    }
                                }
                        )
                        .padding(10)
                        .background(Color.black.opacity(0.6))
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
        pixelGrid = Array(repeating: Array(repeating: 0, count: 300), count: 300)
    }
    
    // MARK: - Preset Compositor
    private func generateBaseFromPresets() {
        pixelGrid = CharacterSprite.generateGrid(planet: planetPreset, hairStyle: hairStylePreset, sex: sexPreset)
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
