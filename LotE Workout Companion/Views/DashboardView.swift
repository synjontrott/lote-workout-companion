//
//  DashboardView.swift
//  LotE Workout Companion
//
//  Created by Antigravity on 6/23/26.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var profileManager: UserProfileManager
    @ObservedObject var healthManager: HealthKitManager
    
    // Idle animation state for the retro sprite
    @State private var spriteBobbingOffset: CGFloat = 0
    @State private var showingQuickSprintTimer = false
    @State private var sprintTimeRemaining = 300 // 5 minutes
    @State private var sprintTimerActive = false
    
    // Colors mapped from profile sprite
    var skinColor: Color { Color(hex: profileManager.sprite.skinColorHex) ?? .orange }
    var hairColor: Color { Color(hex: profileManager.sprite.hairColorHex) ?? .yellow }
    var outfitColor: Color { Color(hex: profileManager.sprite.outfitColorHex) ?? .gray }
    var eyeColor: Color { profileManager.currentElement.primaryColor }
    var auraColor: Color { profileManager.currentElement.accentColor }
    
    // Dynamic timer format helper
    var timerString: String {
        let mins = sprintTimeRemaining / 60
        let secs = sprintTimeRemaining % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    var body: some View {
        ZStack {
            Color(hex: "#050505")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Character Cockpit
                    HStack(spacing: 20) {
                        // Animated Pixel Sprite
                        ZStack {
                            // Element aura glow
                            Circle()
                                .fill(profileManager.currentElement.primaryColor.opacity(0.15))
                                .frame(width: 85, height: 85)
                                .blur(radius: 12)
                            
                            PixelSpriteView(
                                grid: profileManager.sprite.pixelGrid,
                                skin: skinColor,
                                hair: hairColor,
                                eye: eyeColor,
                                outfit: outfitColor,
                                aura: auraColor,
                                pixelSize: 4.5
                            )
                            .offset(y: spriteBobbingOffset)
                        }
                        .frame(width: 90, height: 90)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(profileManager.characterName.uppercased())
                                .font(.custom("Orbitron-Bold", size: 18).bold())
                                .foregroundColor(.white)
                                .tracking(2)
                            
                            Text(profileManager.currentTier.displayName(for: profileManager.currentElement.name))
                                .font(.custom("Orbitron-Bold", size: 11).bold())
                                .foregroundColor(profileManager.currentElement.primaryColor)
                            
                            HStack(spacing: 12) {
                                Label("\(profileManager.streak) DAYS", systemImage: "flame.fill")
                                    .font(.system(size: 10).bold())
                                    .foregroundColor(profileManager.streak > 0 ? .orange : .gray)
                                
                                Label("\(profileManager.crystals) 💎", systemImage: "sparkles")
                                    .font(.system(size: 10).bold())
                                    .foregroundColor(.orange)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white.opacity(0.02))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(profileManager.currentElement.primaryColor.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    // MARK: - HealthKit Status / Connect
                    if !healthManager.isAuthorized {
                        Button(action: {
                            healthManager.requestAuthorization()
                        }) {
                            HStack {
                                Image(systemName: "heart.text.square.fill")
                                    .foregroundColor(.red)
                                Text("CONNECT APPLE HEALTH APP")
                                    .font(.custom("Orbitron-Bold", size: 12).bold())
                                    .foregroundColor(.white)
                                    .tracking(1)
                                Spacer()
                                Image(systemName: "link")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.red.opacity(0.15))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal)
                        }
                    }
                    
                    // MARK: - Energy Activity Gauges
                    VStack(alignment: .leading, spacing: 14) {
                        Text("ELSAITHER ENERGY CORE")
                            .font(.custom("Orbitron-Bold", size: 12).bold())
                            .foregroundColor(.gray)
                            .tracking(2)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            metricGauge(
                                title: "Steps Taken",
                                current: healthManager.todaySteps,
                                target: 10000.0,
                                unit: "steps",
                                icon: "figure.walk"
                            )
                            
                            metricGauge(
                                title: "Active Energy",
                                current: healthManager.todayCalories,
                                target: 500.0,
                                unit: "kcal",
                                icon: "flame"
                            )
                            
                            metricGauge(
                                title: "Training Time",
                                current: healthManager.activeMinutes,
                                target: 30.0,
                                unit: "mins",
                                icon: "stopwatch"
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Psych-Adaptive Section
                    VStack(alignment: .leading, spacing: 14) {
                        Text("ORACLE TACTICAL HUD")
                            .font(.custom("Orbitron-Bold", size: 12).bold())
                            .foregroundColor(.gray)
                            .tracking(2)
                            .padding(.horizontal)
                        
                        let profile = profileManager.cognitiveProfile ?? .neurotypical
                        
                        switch profile {
                        case .adhd:
                            adhdHud()
                        case .autistic:
                            autisticHud()
                        case .audhd:
                            audhdHud()
                        case .neurotypical:
                            neurotypicalHud()
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            // Start idle animation loop
            withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                spriteBobbingOffset = -4
            }
            healthManager.fetchTodayData()
        }
    }
    
    // MARK: - Gauges Helper
    private func metricGauge(title: String, current: Double, target: Double, unit: String, icon: String) -> some View {
        let percentage = min(current / target, 1.0)
        let percentStr = String(format: "%.1f%%", percentage * 100)
        
        return VStack(alignment: .leading, spacing: 4) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.custom("Exo2-Bold", size: 13))
                    .foregroundColor(.white)
                Spacer()
                Text("\(Int(current)) / \(Int(target)) \(unit) (\(percentStr))")
                    .font(.system(size: 11))
                    .foregroundColor(profileManager.currentElement.primaryColor)
            }
            
            ProgressView(value: percentage, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: profileManager.currentElement.primaryColor))
        }
        .padding()
        .background(Color.white.opacity(0.02))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - ADHD Widget (Dopamine & Timers)
    @ViewBuilder
    private func adhdHud() -> some View {
        VStack(spacing: 12) {
            // Focus Timer widget
            VStack {
                HStack {
                    Image(systemName: "timer")
                        .foregroundColor(.orange)
                    Text("5-MIN FOCUS BURST TIMER")
                        .font(.custom("Orbitron-Bold", size: 12).bold())
                        .foregroundColor(.white)
                    Spacer()
                    Text(timerString)
                        .font(.custom("Orbitron-Bold", size: 14).bold())
                        .foregroundColor(.orange)
                }
                
                HStack(spacing: 15) {
                    Button(action: {
                        toggleSprintTimer()
                    }) {
                        Text(sprintTimerActive ? "PAUSE" : "START FOCUS BURST")
                            .font(.custom("Orbitron-Bold", size: 10).bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color.orange))
                    }
                    
                    Button(action: {
                        resetSprintTimer()
                    }) {
                        Text("RESET")
                            .font(.custom("Orbitron-Bold", size: 10).bold())
                            .foregroundColor(.gray)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                    }
                }
                .padding(.top, 5)
            }
            .padding()
            .background(Color.white.opacity(0.02))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // ADHD Vibe Card
            VStack(alignment: .leading, spacing: 8) {
                Text("⚔️ NOVELTY BEAST ACTIVE")
                    .font(.custom("Orbitron-Bold", size: 11).bold())
                    .foregroundColor(.orange)
                Text("Today's workout multiplier is active. If training feels heavy, switch workouts immediately or check the Dopamine Menu in the Quest Board. Low-friction starts only!")
                    .font(.custom("Exo2-Regular", size: 11))
                    .foregroundColor(.white.opacity(0.75))
            }
            .padding()
            .background(Color.orange.opacity(0.08))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    // MARK: - Autistic Widget (Checklist & Analytics)
    @ViewBuilder
    private func autisticHud() -> some View {
        VStack(spacing: 12) {
            // Structured Checklist
            VStack(alignment: .leading, spacing: 10) {
                Text("DAILY FITNESS PERFORMANCE CHECKLIST")
                    .font(.custom("Orbitron-Bold", size: 11).bold())
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                checklistRow(label: "Steps Quota (10k steps)", completed: healthManager.todaySteps >= 10000.0)
                checklistRow(label: "Active Calories Burned (500 kcal)", completed: healthManager.todayCalories >= 500.0)
                checklistRow(label: "Completed Today's Active Minutes (30m)", completed: healthManager.activeMinutes >= 30.0)
                checklistRow(label: "Nourishing Healthy Rations Logged", completed: profileManager.healthyMealsLoggedToday > 0)
            }
            .padding()
            .background(Color.white.opacity(0.02))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Detailed stats block
            VStack(alignment: .leading, spacing: 8) {
                Text("📊 SYSTEM METRIC LOGS")
                    .font(.custom("Orbitron-Bold", size: 11).bold())
                    .foregroundColor(profileManager.currentElement.primaryColor)
                
                let completionRate = (min(healthManager.todaySteps / 10000.0, 1.0) + min(healthManager.todayCalories / 500.0, 1.0) + min(healthManager.activeMinutes / 30.0, 1.0)) / 3.0 * 100
                Text("Calculated Daily Completion: \(String(format: "%.2f%%", completionRate))")
                    .font(.custom("Exo2-Medium", size: 11))
                    .foregroundColor(.white)
                
                Text("Training frequency matches physical parameters exactly. Consistent execution keeps performance high.")
                    .font(.custom("Exo2-Regular", size: 10))
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white.opacity(0.02))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    private func checklistRow(label: String, completed: Bool) -> some View {
        HStack {
            Image(systemName: completed ? "checkmark.square.fill" : "square")
                .foregroundColor(completed ? .green : .gray)
            Text(label)
                .font(.custom("Exo2-Medium", size: 12))
                .foregroundColor(completed ? .white : .gray)
            Spacer()
        }
    }
    
    // MARK: - AuDHD Widget (Wildcards & Sprints)
    @ViewBuilder
    private func audhdHud() -> some View {
        VStack(spacing: 12) {
            // Wildcard task
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(.purple)
                    Text("DAILY WILDCARD CHALLENGE")
                        .font(.custom("Orbitron-Bold", size: 11).bold())
                        .foregroundColor(.white)
                }
                
                Text("Need flexibility today? Swap your workout type. If the default Quest is too demanding, you are fully authorized to substitute a quick 10-minute walk or a Dopamine Menu burst.")
                    .font(.custom("Exo2-Regular", size: 11))
                    .foregroundColor(.white.opacity(0.85))
                    .lineSpacing(3)
            }
            .padding()
            .background(Color.purple.opacity(0.06))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.purple.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal)
            
            // Check list overview
            autisticHud()
        }
    }
    
    // MARK: - Neurotypical Widget (Habit Loops)
    @ViewBuilder
    private func neurotypicalHud() -> some View {
        VStack(spacing: 12) {
            // Habit Stacking Log
            VStack(alignment: .leading, spacing: 8) {
                Text("HABIT STACKING REINFORCEMENT")
                    .font(.custom("Orbitron-Bold", size: 11).bold())
                    .foregroundColor(.white)
                
                Text("• Immediately after my morning routine, I will check the Quest Board.")
                    .font(.custom("Exo2-Medium", size: 11))
                    .foregroundColor(.white.opacity(0.8))
                
                Text("• When I arrive home, I will log my healthy meal checklist.")
                    .font(.custom("Exo2-Medium", size: 11))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .background(Color.white.opacity(0.02))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Goals Summary
            VStack(alignment: .leading, spacing: 8) {
                Text("🎯 CURRENT CAMPAIGN OBJECTIVES")
                    .font(.custom("Orbitron-Bold", size: 11).bold())
                    .foregroundColor(profileManager.currentElement.primaryColor)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top) {
                        Text("Calisthenics:")
                            .font(.custom("Exo2-Bold", size: 11))
                            .foregroundColor(.gray)
                        Text(profileManager.calisthenicsGoal)
                            .font(.custom("Exo2-Medium", size: 11))
                            .foregroundColor(.white)
                    }
                    
                    HStack(alignment: .top) {
                        Text("Lifting:")
                            .font(.custom("Exo2-Bold", size: 11))
                            .foregroundColor(.gray)
                        Text(profileManager.liftingGoal)
                            .font(.custom("Exo2-Medium", size: 11))
                            .foregroundColor(.white)
                    }
                    
                    HStack(alignment: .top) {
                        Text("Custom:")
                            .font(.custom("Exo2-Bold", size: 11))
                            .foregroundColor(.gray)
                        Text(profileManager.customGoal)
                            .font(.custom("Exo2-Medium", size: 11))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.02))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    // MARK: - Sprint Timer Control
    private func toggleSprintTimer() {
        sprintTimerActive.toggle()
        if sprintTimerActive {
            runSprintTimer()
        }
    }
    
    private func resetSprintTimer() {
        sprintTimerActive = false
        sprintTimeRemaining = 300
    }
    
    private func runSprintTimer() {
        guard sprintTimerActive else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.sprintTimerActive && self.sprintTimeRemaining > 0 {
                self.sprintTimeRemaining -= 1
                self.runSprintTimer()
            } else if self.sprintTimeRemaining == 0 {
                self.sprintTimerActive = false
                // Award Crystals for completion
                self.profileManager.earnCrystals(10)
                self.profileManager.addXP(20)
                self.sprintTimeRemaining = 300
            }
        }
    }
}

// MARK: - Retro Pixel Sprite Renderer View
struct PixelSpriteView: View {
    let grid: [[Int]]
    let skin: Color
    let hair: Color
    let eye: Color
    let outfit: Color
    let aura: Color
    let pixelSize: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<16, id: \.self) { r in
                HStack(spacing: 0) {
                    ForEach(0..<16, id: \.self) { c in
                        let val = grid[r][c]
                        Rectangle()
                            .fill(colorForValue(val))
                            .frame(width: pixelSize, height: pixelSize)
                    }
                }
            }
        }
    }
    
    private func colorForValue(_ val: Int) -> Color {
        switch val {
        case 1: return skin
        case 2: return hair
        case 3: return eye
        case 4: return outfit
        case 5: return aura
        default: return Color.clear
        }
    }
}
