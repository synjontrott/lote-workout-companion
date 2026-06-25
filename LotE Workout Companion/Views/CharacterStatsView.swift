//
//  CharacterStatsView.swift
//  LotE Workout Companion
//
//  Created by Antigravity on 6/23/26.
//

import SwiftUI

struct CharacterStatsView: View {
    @ObservedObject var profileManager: UserProfileManager
    @State private var selectedTab: String = "Stats"
    
    // Decides race based on planet and expression stance
    var raceName: String {
        if profileManager.currentElement.inherentDark || profileManager.expressionStyle == .corrupt {
            return "Tenebrie (Corrupt Genes)"
        }
        switch profileManager.homePlanet {
        case "Warrion": return "Warrion (Primal Force)"
        case "Techno": return "Krenpowen (Techno Cyber)"
        case "Ninjonia": return "Krenpowen (Ninjonian Disciplined)"
        default: return "Calthrian Spatialist"
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "#050505")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 22) {
                    // Header
                    VStack(spacing: 6) {
                        Text("WARRIOR PROFILE SHEET")
                            .font(.custom("Orbitron-Bold", size: 22).bold())
                            .foregroundColor(.white)
                            .tracking(3)
                        
                        Text("Status logs from the Elsaither Oracle")
                            .font(.custom("Exo2-Medium", size: 13))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 25)
                    
                    // Level & Tier Summary Card
                    VStack(spacing: 12) {
                        Text(profileManager.currentTier.displayName(for: profileManager.currentElement.name).uppercased())
                            .font(.custom("Orbitron-Bold", size: 16).bold())
                            .foregroundColor(profileManager.currentElement.primaryColor)
                            .tracking(2)
                        
                        Text("LEVEL \(profileManager.currentLevel)")
                            .font(.custom("Orbitron-Bold", size: 28).bold())
                            .foregroundColor(.white)
                        
                        // XP Progress
                        VStack(spacing: 4) {
                            let needed = profileManager.requiredXPForLevel(profileManager.currentLevel)
                            ProgressView(value: Double(profileManager.currentXP), total: Double(needed))
                                .progressViewStyle(LinearProgressViewStyle(tint: profileManager.currentElement.primaryColor))
                            
                            HStack {
                                Text("\(profileManager.currentXP) XP")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(needed) XP Required")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        
                        Text(profileManager.currentTier.description)
                            .font(.custom("Exo2-Medium", size: 12))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top, 5)
                    }
                    .padding(20)
                    .background(Color.white.opacity(0.02))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(profileManager.currentElement.primaryColor.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    // Profile Subsections Segmented Picker
                    Picker("Profile Stance", selection: $selectedTab) {
                        Text("Stats").tag("Stats")
                        Text("Badges").tag("Badges")
                        Text("Shop").tag("Shop")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    if selectedTab == "Stats" {
                        // Attributes D&D Block
                        VStack(alignment: .leading, spacing: 15) {
                            Text("D&D CHARACTER ATTRIBUTES")
                                .font(.custom("Orbitron-Bold", size: 13).bold())
                                .foregroundColor(.gray)
                                .tracking(2)
                                .padding(.horizontal)
                            
                            VStack(spacing: 10) {
                                statRow(name: "Strength (STR)", value: profileManager.stats.strength, desc: "Improves weights & bodyweight quests")
                                statRow(name: "Dexterity (DEX)", value: profileManager.stats.dexterity, desc: "Improves running, cardio & speed sprints")
                                statRow(name: "Constitution (CON)", value: profileManager.stats.constitution, desc: "Increases meal absorption & stamina logs")
                                statRow(name: "Intelligence (INT)", value: profileManager.stats.intelligence, desc: "Improves cyber device tech & laser efficiency")
                                statRow(name: "Wisdom (WIS)", value: profileManager.stats.wisdom, desc: "Enhances flexibility and balance training")
                                statRow(name: "Charisma (CHA)", value: profileManager.stats.charisma, desc: "Controls companion bonds & shop discounts")
                            }
                            .padding(.horizontal)
                        }
                        
                        // Lore Alignment Card
                        VStack(alignment: .leading, spacing: 15) {
                            Text("ELSAITHER METRICS")
                                .font(.custom("Orbitron-Bold", size: 13).bold())
                                .foregroundColor(.gray)
                                .tracking(2)
                            
                            VStack(spacing: 12) {
                                loreMetricRow(label: "Race Ancestry", value: raceName)
                                loreMetricRow(label: "Planet of Origin", value: profileManager.homePlanet)
                                loreMetricRow(label: "Power Stance", value: profileManager.expressionStyle.rawValue)
                            }
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.02))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(profileManager.currentElement.primaryColor.opacity(0.15), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        
                        // Body Measurements Card
                        VStack(alignment: .leading, spacing: 15) {
                            Text("BODY MEASUREMENTS")
                                .font(.custom("Orbitron-Bold", size: 13).bold())
                                .foregroundColor(.gray)
                                .tracking(2)
                            
                            VStack(spacing: 12) {
                                loreMetricRow(label: "Height", value: String(format: "%.1f in", profileManager.height))
                                loreMetricRow(label: "Weight", value: String(format: "%.1f lbs", profileManager.weight))
                                loreMetricRow(label: "Chest", value: String(format: "%.1f in", profileManager.chest))
                                loreMetricRow(label: "Arms", value: String(format: "%.1f in", profileManager.arms))
                                loreMetricRow(label: "Waist", value: String(format: "%.1f in", profileManager.waist))
                                loreMetricRow(label: "Hips", value: String(format: "%.1f in", profileManager.hips))
                                loreMetricRow(label: "Legs", value: String(format: "%.1f in", profileManager.legs))
                            }
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.02))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(profileManager.currentElement.primaryColor.opacity(0.15), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    } else if selectedTab == "Badges" {
                        // Badges Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("UNLOCKED BADGES")
                                .font(.custom("Orbitron-Bold", size: 13).bold())
                                .foregroundColor(.gray)
                                .tracking(2)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ForEach(FitnessBadge.allBadges) { badge in
                                    let isUnlocked = profileManager.unlockedBadges.contains(badge.name)
                                    HStack(spacing: 15) {
                                        Circle()
                                            .fill(isUnlocked ? profileManager.currentElement.primaryColor.opacity(0.15) : Color.white.opacity(0.04))
                                            .frame(width: 48, height: 48)
                                            .overlay(
                                                Image(systemName: isUnlocked ? badge.iconName : "lock.fill")
                                                    .foregroundColor(isUnlocked ? profileManager.currentElement.primaryColor : .gray)
                                                    .font(.title3)
                                            )
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(badge.name)
                                                .font(.custom("Exo2-Bold", size: 14))
                                                .foregroundColor(isUnlocked ? .white : .gray)
                                            Text(badge.description)
                                                .font(.custom("Exo2-Regular", size: 11))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        if isUnlocked {
                                            Text("UNLOCKED")
                                                .font(.custom("Orbitron-Bold", size: 9).bold())
                                                .foregroundColor(.green)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color.green.opacity(0.15))
                                                .cornerRadius(4)
                                        } else {
                                            Text("LOCKED")
                                                .font(.custom("Orbitron-Bold", size: 9).bold())
                                                .foregroundColor(.gray)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color.white.opacity(0.06))
                                                .cornerRadius(4)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.02))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isUnlocked ? profileManager.currentElement.primaryColor.opacity(0.3) : Color.white.opacity(0.05), lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else if selectedTab == "Shop" {
                        // Shop Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("CRYSTALS SHOP")
                                    .font(.custom("Orbitron-Bold", size: 13).bold())
                                    .foregroundColor(.gray)
                                    .tracking(2)
                                Spacer()
                                HStack(spacing: 5) {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.orange)
                                    Text("\(profileManager.crystals) 💎")
                                        .font(.custom("Orbitron-Bold", size: 14).bold())
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ForEach(ShopItem.availableItems) { item in
                                    let isUnlocked = profileManager.unlockedShopItems.contains(item.name)
                                    HStack(spacing: 15) {
                                        Circle()
                                            .fill(isUnlocked ? Color.green.opacity(0.1) : profileManager.currentElement.primaryColor.opacity(0.05))
                                            .frame(width: 44, height: 44)
                                            .overlay(
                                                Image(systemName: iconForShopItemType(item.type))
                                                    .foregroundColor(isUnlocked ? .green : profileManager.currentElement.primaryColor)
                                            )
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.name)
                                                .font(.custom("Exo2-Bold", size: 14))
                                                .foregroundColor(.white)
                                            Text(item.description)
                                                .font(.custom("Exo2-Regular", size: 11))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        if isUnlocked {
                                            if item.type == "stat" || item.type == "badge" {
                                                Text("UNLOCKED")
                                                    .font(.custom("Orbitron-Bold", size: 10).bold())
                                                    .foregroundColor(.green)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(Color.green.opacity(0.15))
                                                    .cornerRadius(6)
                                            } else {
                                                let equipped = isEquipped(item)
                                                Button(action: {
                                                    profileManager.toggleEquipItem(item)
                                                }) {
                                                    Text(equipped ? "UNEQUIP" : "EQUIP")
                                                        .font(.custom("Orbitron-Bold", size: 10).bold())
                                                        .foregroundColor(equipped ? .orange : .green)
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 4)
                                                        .background(equipped ? Color.orange.opacity(0.15) : Color.green.opacity(0.15))
                                                        .cornerRadius(6)
                                                }
                                            }
                                        } else {
                                            Button(action: {
                                                _ = profileManager.buyShopItem(item)
                                            }) {
                                                HStack(spacing: 4) {
                                                    Text("\(item.cost)")
                                                        .font(.custom("Orbitron-Bold", size: 11).bold())
                                                    Image(systemName: "sparkles")
                                                        .font(.system(size: 10))
                                                }
                                                .foregroundColor(.white)
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .fill(profileManager.crystals >= item.cost ? profileManager.currentElement.primaryColor : Color.gray)
                                                )
                                            }
                                            .disabled(profileManager.crystals < item.cost)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.02))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isUnlocked ? Color.green.opacity(0.3) : Color.white.opacity(0.05), lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    // MARK: - Stat Row Helper
    private func statRow(name: String, value: Int, desc: String) -> some View {
        let modifier = (value - 10) / 2
        let modifierStr = modifier >= 0 ? "+\(modifier)" : "\(modifier)"
        
        return VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(name)
                    .font(.custom("Exo2-Bold", size: 14))
                    .foregroundColor(.white)
                Spacer()
                Text("\(value) (Mod: \(modifierStr))")
                    .font(.custom("Orbitron-Bold", size: 13).bold())
                    .foregroundColor(profileManager.currentElement.primaryColor)
            }
            
            // Progress Bar representing value
            ProgressView(value: Double(value), total: 30.0)
                .progressViewStyle(LinearProgressViewStyle(tint: profileManager.currentElement.primaryColor.opacity(0.7)))
            
            Text(desc)
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.02))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
    
    // MARK: - Lore Metric Row Helper
    private func loreMetricRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.custom("Exo2-Medium", size: 13))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.custom("Exo2-Bold", size: 13))
                .foregroundColor(.white)
        }
        .padding(.vertical, 4)
    }
    
    
    // MARK: - Shop Item Icon Helper
    private func iconForShopItemType(_ type: String) -> String {
        switch type {
        case "frame": return "square.and.pencil"
        case "title": return "person.text.rectangle"
        case "aura": return "sparkles"
        case "stat": return "bolt.fill"
        case "badge": return "checkmark.seal.fill"
        default: return "cart.fill"
        }
    }
    
    private func isEquipped(_ item: ShopItem) -> Bool {
        switch item.type {
        case "frame": return profileManager.equippedFrame == item.name
        case "title": return profileManager.equippedTitle == item.name
        case "aura": return profileManager.equippedAura == item.name
        case "background": return profileManager.equippedBackground == item.name
        case "accessory": return profileManager.equippedAccessory == item.name
        default: return false
        }
    }
}
