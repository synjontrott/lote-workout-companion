import SwiftUI

struct ShopView: View {
    @ObservedObject var profileManager: UserProfileManager
    @State private var selectedCategory: String = "Name Plates"
    
    let categories = ["Name Plates", "Auras", "Backgrounds", "Legendary Items", "Stats & More"]
    
    var filteredItems: [ShopItem] {
        switch selectedCategory {
        case "Name Plates":
            return ShopItem.availableItems.filter { $0.type == "frame" || $0.type == "title" }
        case "Auras":
            return ShopItem.availableItems.filter { $0.type == "aura" }
        case "Backgrounds":
            return ShopItem.availableItems.filter { $0.type == "background" }
        case "Legendary Items":
            return ShopItem.availableItems.filter { $0.type == "accessory" }
        default:
            return ShopItem.availableItems.filter { $0.type == "stat" || $0.type == "badge" }
        }
    }
    
    var body: some View {
        ZStack {
            // Dark futuristic background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#0F172A")!,
                    Color(hex: "#020617")!
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with glowing element title and crystals balance
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("ELSAITHER ARMORY")
                            .font(.custom("Orbitron-Bold", size: 24).bold())
                            .foregroundColor(.white)
                            .shadow(color: profileManager.currentElement.primaryColor.opacity(0.6), radius: 8)
                        
                        Text("Equip items to style your profile and boost stats")
                            .font(.custom("Exo2-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Crystal Balance Display
                    HStack(spacing: 6) {
                        Text("💎")
                            .font(.system(size: 18))
                        Text("\(profileManager.crystals)")
                            .font(.custom("Orbitron-Bold", size: 16).bold())
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(profileManager.currentElement.primaryColor.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 20)
                
                // Categories selection bar (Horizontal scroll)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { cat in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedCategory = cat
                                }
                            }) {
                                Text(cat)
                                    .font(.custom("Orbitron-Bold", size: 11).bold())
                                    .foregroundColor(selectedCategory == cat ? .black : .white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(
                                        selectedCategory == cat
                                            ? profileManager.currentElement.primaryColor
                                            : Color.white.opacity(0.05)
                                    )
                                    .cornerRadius(18)
                                    .shadow(color: selectedCategory == cat ? profileManager.currentElement.primaryColor.opacity(0.3) : .clear, radius: 6)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 16)
                
                // Shop items listing
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredItems) { item in
                            let isUnlocked = profileManager.unlockedShopItems.contains(item.name)
                            
                            HStack(spacing: 16) {
                                // Large Emoji Sprite representation
                                // Beautiful Pixel Sprite Representation
                                ItemPixelSpriteView(
                                    name: item.name,
                                    type: item.type,
                                    elementColor: profileManager.currentElement.primaryColor
                                )
                                .frame(width: 56, height: 56)
                                .background(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            profileManager.currentElement.primaryColor.opacity(isUnlocked ? 0.3 : 0.1),
                                            Color.clear
                                        ]),
                                        center: .center,
                                        startRadius: 2,
                                        endRadius: 28
                                    )
                                )
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(isUnlocked ? Color.green.opacity(0.4) : Color.white.opacity(0.08), lineWidth: 1)
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(item.name)
                                            .font(.custom("Exo2-Bold", size: 15))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        // Item category type pill tag
                                        Text(item.type.uppercased())
                                            .font(.custom("Orbitron-Bold", size: 8).bold())
                                            .foregroundColor(profileManager.currentElement.primaryColor)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(profileManager.currentElement.primaryColor.opacity(0.12))
                                            .cornerRadius(4)
                                    }
                                    
                                    Text(item.description)
                                        .font(.custom("Exo2-Regular", size: 12))
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                                
                                Spacer()
                                
                                // Purchase / Equip button logic
                                if isUnlocked {
                                    if item.type == "stat" || item.type == "badge" {
                                        Text("UNLOCKED")
                                            .font(.custom("Orbitron-Bold", size: 10).bold())
                                            .foregroundColor(.green)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color.green.opacity(0.15))
                                            .cornerRadius(8)
                                    } else {
                                        let equipped = isEquipped(item)
                                        Button(action: {
                                            profileManager.toggleEquipItem(item)
                                        }) {
                                            Text(equipped ? "UNEQUIP" : "EQUIP")
                                                .font(.custom("Orbitron-Bold", size: 10).bold())
                                                .foregroundColor(equipped ? .orange : .green)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 6)
                                                .background(equipped ? Color.orange.opacity(0.15) : Color.green.opacity(0.15))
                                                .cornerRadius(8)
                                        }
                                    }
                                } else {
                                    Button(action: {
                                        _ = profileManager.buyShopItem(item)
                                    }) {
                                        HStack(spacing: 4) {
                                            Text("\(item.cost)")
                                                .font(.custom("Orbitron-Bold", size: 12).bold())
                                                .foregroundColor(.white)
                                            Text("💎")
                                                .font(.system(size: 12))
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(profileManager.currentElement.primaryColor.opacity(0.2))
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(profileManager.currentElement.primaryColor.opacity(0.4), lineWidth: 1)
                                        )
                                    }
                                    .disabled(profileManager.crystals < item.cost)
                                    .opacity(profileManager.crystals < item.cost ? 0.5 : 1.0)
                                }
                            }
                            .padding(.all, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.03))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.white.opacity(0.04), lineWidth: 1)
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
    
    private func isEquipped(_ item: ShopItem) -> Bool {
        if item.type == "frame" {
            return profileManager.equippedFrame == item.name
        } else if item.type == "title" {
            return profileManager.equippedTitle == item.name
        } else if item.type == "aura" {
            return profileManager.equippedAura == item.name
        } else if item.type == "background" {
            return profileManager.equippedBackground == item.name
        } else if item.type == "accessory" {
            return profileManager.equippedAccessory == item.name
        }
        return false
    }
}

// MARK: - Mini Shop Item Pixel Sprite View
struct ItemPixelSpriteView: View {
    let name: String
    let type: String
    let elementColor: Color
    
    var body: some View {
        let grid = generateGrid()
        VStack(spacing: 1) {
            ForEach(0..<8, id: \.self) { r in
                HStack(spacing: 1) {
                    ForEach(0..<8, id: \.self) { c in
                        let val = grid[r][c]
                        Rectangle()
                            .fill(colorForValue(val))
                            .frame(width: 4, height: 4)
                    }
                }
            }
        }
        .frame(width: 44, height: 44)
        .background(Color.black.opacity(0.4))
        .cornerRadius(6)
    }
    
    private func generateGrid() -> [[Int]] {
        if type == "stat" {
            return [
                [0, 0, 0, 1, 1, 0, 0, 0],
                [0, 0, 0, 1, 1, 0, 0, 0],
                [0, 0, 2, 2, 2, 2, 0, 0],
                [0, 2, 3, 3, 3, 3, 2, 0],
                [0, 2, 3, 3, 3, 3, 2, 0],
                [0, 2, 3, 3, 3, 3, 2, 0],
                [0, 2, 2, 2, 2, 2, 2, 0],
                [0, 0, 0, 0, 0, 0, 0, 0]
            ]
        } else if type == "accessory" && name.lowercased().contains("sword") {
            return [
                [0, 0, 0, 0, 0, 0, 1, 0],
                [0, 0, 0, 0, 0, 1, 0, 0],
                [0, 0, 0, 0, 1, 0, 0, 0],
                [0, 0, 0, 1, 0, 0, 0, 0],
                [0, 0, 2, 0, 0, 0, 0, 0],
                [0, 2, 3, 2, 0, 0, 0, 0],
                [2, 0, 2, 0, 0, 0, 0, 0],
                [0, 2, 0, 0, 0, 0, 0, 0]
            ]
        } else if type == "accessory" && name.contains("Visor") {
            return [
                [0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0],
                [2, 2, 2, 2, 2, 2, 2, 2],
                [2, 1, 1, 1, 1, 1, 1, 2],
                [0, 2, 1, 1, 1, 1, 2, 0],
                [0, 0, 2, 2, 2, 2, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0]
            ]
        } else if type == "accessory" && name.contains("Wings") {
            return [
                [0, 0, 0, 0, 0, 0, 0, 0],
                [1, 1, 0, 0, 0, 0, 1, 1],
                [1, 1, 1, 0, 0, 1, 1, 1],
                [0, 1, 1, 1, 1, 1, 1, 0],
                [0, 0, 1, 2, 2, 1, 0, 0],
                [0, 0, 0, 2, 2, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0]
            ]
        } else if type == "frame" {
            return [
                [1, 1, 1, 1, 1, 1, 1, 1],
                [1, 2, 2, 2, 2, 2, 2, 1],
                [1, 2, 0, 0, 0, 0, 2, 1],
                [1, 2, 0, 0, 0, 0, 2, 1],
                [1, 2, 0, 0, 0, 0, 2, 1],
                [1, 2, 0, 0, 0, 0, 2, 1],
                [1, 2, 2, 2, 2, 2, 2, 1],
                [1, 1, 1, 1, 1, 1, 1, 1]
            ]
        } else if type == "aura" {
            return [
                [0, 0, 1, 1, 1, 1, 0, 0],
                [0, 1, 0, 0, 0, 0, 1, 0],
                [1, 0, 0, 0, 0, 0, 0, 1],
                [1, 0, 0, 0, 0, 0, 0, 1],
                [1, 0, 0, 0, 0, 0, 0, 1],
                [1, 0, 0, 0, 0, 0, 0, 1],
                [0, 1, 0, 0, 0, 0, 1, 0],
                [0, 0, 1, 1, 1, 1, 0, 0]
            ]
        } else if type == "background" {
            return [
                [1, 1, 1, 1, 1, 1, 1, 1],
                [1, 2, 2, 2, 2, 2, 2, 1],
                [3, 3, 3, 3, 3, 3, 3, 3],
                [3, 3, 4, 4, 4, 4, 3, 3],
                [4, 4, 4, 5, 5, 4, 4, 4],
                [4, 5, 5, 5, 5, 5, 5, 4],
                [5, 5, 5, 5, 5, 5, 5, 5],
                [5, 5, 5, 5, 5, 5, 5, 5]
            ]
        } else if type == "title" || name.contains("Crown") {
            return [
                [0, 0, 0, 0, 0, 0, 0, 0],
                [1, 0, 1, 0, 1, 0, 1, 0],
                [1, 0, 1, 0, 1, 0, 1, 0],
                [1, 1, 1, 1, 1, 1, 1, 1],
                [1, 2, 1, 2, 1, 2, 1, 1],
                [1, 1, 1, 1, 1, 1, 1, 1],
                [0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0]
            ]
        } else {
            return [
                [0, 0, 1, 1, 1, 1, 0, 0],
                [0, 1, 2, 2, 2, 2, 1, 0],
                [1, 2, 3, 3, 3, 3, 2, 1],
                [1, 2, 3, 4, 4, 3, 2, 1],
                [1, 2, 3, 4, 4, 3, 2, 1],
                [0, 1, 2, 3, 3, 2, 1, 0],
                [0, 0, 1, 2, 2, 1, 0, 0],
                [0, 0, 0, 1, 1, 0, 0, 0]
            ]
        }
    }
    
    private func colorForValue(_ val: Int) -> Color {
        switch val {
        case 1:
            if name.contains("Ignis") || name.contains("Strength") || name.contains("Phoenix") || name.contains("Volcanic") { return .red }
            if name.contains("Crystalline") || name.contains("Gale") || name.contains("Cyber") || name.contains("Neon") || name.contains("Glitch") { return .cyan }
            if name.contains("Umbral") || name.contains("Abyssal") || name.contains("Mind") || name.contains("Wisdom") { return .purple }
            return .yellow
        case 2:
            return .gray
        case 3:
            if name.contains("Strength") { return .red }
            if name.contains("Gale") { return .cyan }
            if name.contains("Marrow") { return .orange }
            if name.contains("Mind") || name.contains("Wisdom") { return .purple }
            return .orange
        case 4:
            return .yellow
        case 5:
            return .green
        default:
            return .clear
        }
    }
}
