//
//  CharacterStatsView.swift
//  LotE Workout Companion
//
//  Created by Antigravity on 6/23/26.
//

import SwiftUI

struct CharacterStatsView: View {
    @ObservedObject var profileManager: UserProfileManager
    
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
    
    // Decides Mark of the Wild / Spirit Animal
    var spiritAnimal: String {
        let name = profileManager.currentElement.name
        if name == "Fire" || name == "Lightning" || name == "Laser" {
            return "Dragon (Aggressive, Passionate)"
        } else if name == "Earth" || name == "Bone" || name == "Metal" {
            return "Bear (Grounded, Powerful)"
        } else if name == "Water" || name == "Ice" || name == "Poison" {
            return "Wolf (Intuitive, Pack Hunter)"
        } else if name == "Air" || name == "Gas" || name == "Zero Space" {
            return "Eagle (Intellectual, Free)"
        } else if name == "Shadow" || name == "Death" || name == "Knife" {
            return "Owl (Mysterious, Precise)"
        } else {
            return "Sheep (Gentle, Harmonious)"
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
                            loreMetricRow(label: "Mark of the Wild", value: spiritAnimal)
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
}
