//
//  QuestBoardView.swift
//  LotE Workout Companion
//
//  Created by Antigravity on 6/23/26.
//

import SwiftUI

struct QuestBoardView: View {
    @ObservedObject var profileManager: UserProfileManager
    @State private var selectedQuest: LotEQuest?
    
    // Dice rolling states
    @State private var isRolling: Bool = false
    @State private var diceResult: Int = 1
    @State private var finalOutcomeText: String = ""
    @State private var showOutcomeAlert: Bool = false
    @State private var wasSuccessful: Bool = false
    
    // Dopamine Menu state (for ADHD/AuDHD profiles)
    let dopamineMenu: [(name: String, icon: String, xp: Int, crystals: Int)] = [
        ("Flame Dash (20 Jumping Jacks)", "bolt.fill", 15, 5),
        ("Terra Stomp (15 Body squats)", "leaf.fill", 15, 5),
        ("Aether Breath (10 Deep deep inhalations)", "wind", 10, 3),
        ("Zephyr Spin (2 Min shadow boxing or dancing)", "music.note", 20, 8),
        ("Iron Guard (30 Sec forearm plank)", "shield.fill", 15, 5)
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "#050505")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 22) {
                    // Title
                    VStack(spacing: 6) {
                        Text("GUILD QUEST BOARD")
                            .font(.custom("Orbitron-Bold", size: 22).bold())
                            .foregroundColor(.white)
                            .tracking(4)
                        
                        Text("Complete quests to forge stats and levels")
                            .font(.custom("Exo2-Medium", size: 13))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 25)
                    
                    // ADHD / AuDHD Dopamine Menu Section
                    if profileManager.cognitiveProfile == .adhd || profileManager.cognitiveProfile == .audhd {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "bolt.heart.fill")
                                    .foregroundColor(.orange)
                                Text("DOPAMINE QUICK MENU")
                                    .font(.custom("Orbitron-Bold", size: 13).bold())
                                    .foregroundColor(.white)
                                    .tracking(2)
                            }
                            .padding(.horizontal)
                            
                            Text("Short on executive energy? Tap a quick burst to build momentum:")
                                .font(.custom("Exo2-Medium", size: 11))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(0..<dopamineMenu.count, id: \.self) { idx in
                                        let item = dopamineMenu[idx]
                                        Button(action: {
                                            completeDopamineTask(item.name, xp: item.xp, crys: item.crystals)
                                        }) {
                                            VStack(spacing: 8) {
                                                Image(systemName: item.icon)
                                                    .font(.title2)
                                                    .foregroundColor(profileManager.currentElement.primaryColor)
                                                
                                                Text(item.name)
                                                    .font(.custom("Exo2-Bold", size: 11))
                                                    .foregroundColor(.white)
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(2)
                                                    .frame(width: 100, height: 35)
                                                
                                                Text("+\(item.xp) XP / +\(item.crystals) 💎")
                                                    .font(.system(size: 9))
                                                    .foregroundColor(.orange)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.04))
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(profileManager.currentElement.primaryColor.opacity(0.3), lineWidth: 1)
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 15)
                        .background(Color.orange.opacity(0.03))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.orange.opacity(0.15), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }
                    
                    // Daily Quests list
                    VStack(alignment: .leading, spacing: 14) {
                        Text("DAILY WARRIOR CHALLENGES")
                            .font(.custom("Orbitron-Bold", size: 13).bold())
                            .foregroundColor(.gray)
                            .tracking(2)
                            .padding(.horizontal)
                        
                        ForEach(profileManager.dailyQuests) { quest in
                            Button(action: {
                                selectedQuest = quest
                            }) {
                                HStack(spacing: 15) {
                                    Circle()
                                        .fill(quest.isCompleted ? Color.green.opacity(0.2) : profileManager.currentElement.primaryColor.opacity(0.1))
                                        .frame(width: 44, height: 44)
                                        .overlay(
                                            Image(systemName: iconForWorkoutType(quest.workoutType))
                                                .foregroundColor(quest.isCompleted ? .green : profileManager.currentElement.primaryColor)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(quest.title)
                                            .font(.custom("Exo2-Bold", size: 14))
                                            .foregroundColor(.white)
                                            .strikethrough(quest.isCompleted, color: .gray)
                                        
                                        Text(quest.questDescription)
                                            .font(.custom("Exo2-Regular", size: 11))
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    if quest.isCompleted {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    } else {
                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text("DC \(quest.difficultyRoll)")
                                                .font(.custom("Orbitron-Bold", size: 10).bold())
                                                .foregroundColor(.orange)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color.orange.opacity(0.15))
                                                .cornerRadius(4)
                                            
                                            Text("+\(quest.rewardXP) XP")
                                                .font(.system(size: 10))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.02))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(quest.isCompleted ? Color.green.opacity(0.3) : Color.white.opacity(0.08), lineWidth: 1)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                    }
                    
                    // Nutrition Board
                    VStack(alignment: .leading, spacing: 14) {
                        Text("HEALTHY FOOD INVENTORY")
                            .font(.custom("Orbitron-Bold", size: 13).bold())
                            .foregroundColor(.gray)
                            .tracking(2)
                            .padding(.horizontal)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Nourish your Elsaither energy")
                                    .font(.custom("Exo2-Bold", size: 14))
                                    .foregroundColor(.white)
                                Text("Log a healthy meal to build CON and crystals.")
                                    .font(.custom("Exo2-Regular", size: 11))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                logHealthyMeal()
                            }) {
                                Text("LOG MEAL")
                                    .font(.custom("Orbitron-Bold", size: 11).bold())
                                    .foregroundColor(.white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(profileManager.currentElement.primaryColor)
                                    )
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.02))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 40)
            }
            
            // Dice Roll Modal Overlay
            if let quest = selectedQuest {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if !isRolling { selectedQuest = nil }
                    }
                
                VStack(spacing: 25) {
                    Text(quest.title.uppercased())
                        .font(.custom("Orbitron-Bold", size: 18).bold())
                        .foregroundColor(.white)
                        .tracking(2)
                    
                    Text(quest.questDescription)
                        .font(.custom("Exo2-Medium", size: 13))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Dice Visualizer
                    ZStack {
                        // Background glow
                        Circle()
                            .fill(profileManager.currentElement.primaryColor.opacity(0.2))
                            .frame(width: 140, height: 140)
                            .blur(radius: 20)
                        
                        // Polygon d20 shape
                        Image(systemName: "hexagon.fill")
                            .font(.system(size: 100))
                            .foregroundColor(isRolling ? .orange : profileManager.currentElement.primaryColor)
                            .rotationEffect(.degrees(isRolling ? 360 : 0))
                            .animation(isRolling ? Animation.linear(duration: 0.6).repeatForever(autoreverses: false) : .default, value: isRolling)
                        
                        Text("\(diceResult)")
                            .font(.custom("Orbitron-Bold", size: 28).bold())
                            .foregroundColor(.white)
                    }
                    .frame(width: 150, height: 150)
                    .padding(.vertical, 10)
                    
                    // Modifiers
                    let mod = (profileManager.stats.strength - 10) / 2
                    Text("Your Modifier: +\(mod) (\(quest.statReward.rawValue))")
                        .font(.custom("Exo2-Medium", size: 12))
                        .foregroundColor(.gray)
                    
                    if quest.isCompleted {
                        Text("Quest Completed!")
                            .font(.custom("Exo2-Bold", size: 14))
                            .foregroundColor(.green)
                    } else {
                        Button(action: {
                            rollDiceAndResolve(quest)
                        }) {
                            Text(isRolling ? "ROLLING..." : "ROLL D20 (DC \(quest.difficultyRoll))")
                                .font(.custom("Orbitron-Bold", size: 13).bold())
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 28)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(profileManager.currentElement.primaryColor)
                                )
                        }
                        .disabled(isRolling)
                    }
                }
                .padding(25)
                .frame(width: 310)
                .background(Color(hex: "#0c0c0c"))
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(profileManager.currentElement.primaryColor.opacity(0.4), lineWidth: 1.5)
                )
                .transition(.scale)
            }
        }
        .alert(isPresented: $showOutcomeAlert) {
            Alert(
                title: Text(wasSuccessful ? "QUEST SUCCESS! 🎉" : "QUEST FAILED! ⚔️"),
                message: Text(finalOutcomeText),
                dismissButton: .default(Text("OK")) {
                    selectedQuest = nil
                }
            )
        }
    }
    
    // MARK: - Dice Rolling Logic
    private func rollDiceAndResolve(_ quest: LotEQuest) {
        isRolling = true
        
        // Simulating roll animations
        var count = 0
        Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { timer in
            diceResult = Int.random(in: 1...20)
            count += 1
            if count > 8 {
                timer.invalidate()
                resolveQuestRoll(quest)
            }
        }
    }
    
    private func resolveQuestRoll(_ quest: LotEQuest) {
        isRolling = false
        
        let statBonus: Int
        switch quest.statReward {
        case .strength: statBonus = (profileManager.stats.strength - 10) / 2
        case .dexterity: statBonus = (profileManager.stats.dexterity - 10) / 2
        case .constitution: statBonus = (profileManager.stats.constitution - 10) / 2
        case .intelligence: statBonus = (profileManager.stats.intelligence - 10) / 2
        case .wisdom: statBonus = (profileManager.stats.wisdom - 10) / 2
        case .charisma: statBonus = (profileManager.stats.charisma - 10) / 2
        }
        
        let totalVal = diceResult + statBonus
        
        if totalVal >= quest.difficultyRoll {
            wasSuccessful = true
            let completed = profileManager.completeQuest(quest, rollValue: diceResult)
            if completed {
                finalOutcomeText = "You rolled a \(diceResult) + \(statBonus) modifier = \(totalVal)! You cleared the DC \(quest.difficultyRoll) check! Earning \(quest.rewardXP) XP, \(quest.rewardCrystals) Crystals, and +1 to \(quest.statReward.rawValue)!"
            }
        } else {
            wasSuccessful = false
            profileManager.addXP(quest.rewardXP / 3) // Consolation
            finalOutcomeText = "You rolled a \(diceResult) + \(statBonus) modifier = \(totalVal). Unfortunately, you failed to clear the DC \(quest.difficultyRoll) check. You receive \(quest.rewardXP / 3) XP in training lessons. Try again tomorrow or build up your modifiers!"
        }
        
        showOutcomeAlert = true
    }
    
    // MARK: - Dopamine Burst Action
    private func completeDopamineTask(_ name: String, xp: Int, crys: Int) {
        profileManager.addXP(xp)
        profileManager.earnCrystals(crys)
        
        // Brief local success state in popup
        finalOutcomeText = "Completed sensory burst: \(name)! You earned \(xp) XP and \(crys) Crystals instantly. Keep that momentum rolling!"
        wasSuccessful = true
        showOutcomeAlert = true
    }
    
    // MARK: - Nutrition Log
    private func logHealthyMeal() {
        profileManager.logHealthyMeal()
        finalOutcomeText = "Logged healthy rations! You consume high-nutrition energy cubes, earning +15 XP, +10 Crystals, and +1 Constitution."
        wasSuccessful = true
        showOutcomeAlert = true
    }
    
    // MARK: - Helpers
    private func iconForWorkoutType(_ type: WorkoutCategory) -> String {
        switch type {
        case .cardio: return "figure.run"
        case .strength: return "figure.strengthtraining.functional"
        case .flexibility: return "figure.flexibility"
        case .nutrition: return "fork.knife"
        case .meditation: return "brain.headprofile"
        }
    }
}
