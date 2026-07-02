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
    
    // Body Measurement logging modal states
    @State private var selectedHistoryType: String = "Weight"
    @State private var showingMeasurementLog = false
    @State private var measureWeight = ""
    @State private var measureChest = ""
    @State private var measureArms = ""
    @State private var measureWaist = ""
    @State private var measureHips = ""
    @State private var measureLegs = ""
    @State private var showingChallengeConfirmation = false
    
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
            // Futuristic cosmic background with neon gradient and orbiting elements glow
            Group {
                if profileManager.equippedBackground == "Neon Cyber Space" {
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "#050B14") ?? .black, Color(hex: "#0A192F") ?? .black]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                } else if profileManager.equippedBackground == "Nebula Starfield" {
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "#0B071E") ?? .black, Color(hex: "#1F1235") ?? .black]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                } else if profileManager.equippedBackground == "Volcanic Core" {
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "#140505") ?? .black, Color(hex: "#2D0A0A") ?? .black]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                } else {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            profileManager.currentElement.primaryColor.opacity(0.15),
                            Color(hex: "#090d16") ?? .black,
                            Color(hex: "#020408") ?? .black
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            .ignoresSafeArea()
            
            // Neon glow orbs
            RadialGradient(
                colors: [profileManager.currentElement.accentColor.opacity(0.1), .clear],
                center: .topTrailing,
                startRadius: 5,
                endRadius: 350
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    characterCockpitView
                    healthKitStatusView
                    energyActivityGauges
                    sugarTrackerCard
                    targetGoalProgressView
                    monthlyChallengeCard
                    psychAdaptiveSection
                }
            }
            
            bodyMeasurementModal
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
        .alert("Log Progress?", isPresented: $showingChallengeConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Log Progress") {
                let challenge = profileManager.activeMonthlyChallenge
                let amount = challenge.targetMetric == "reps" ? 50.0 : (challenge.targetMetric == "Liters" ? 3.0 : 1.0)
                profileManager.advanceMonthlyChallenge(amount: amount)
            }
        } message: {
            let challenge = profileManager.activeMonthlyChallenge
            let amount = challenge.targetMetric == "reps" ? 50.0 : (challenge.targetMetric == "Liters" ? 3.0 : 1.0)
            Text("Confirm adding +\(Int(amount)) \(challenge.targetMetric) toward your \(challenge.monthName) monthly challenge: \"\(challenge.targetDescription)\"?")
        }
    }
    
    // MARK: - Subcomponents to simplify type checking
    
    @ViewBuilder
    private var characterCockpitView: some View {
        HStack(spacing: 20) {
            // Animated Pixel Sprite
            ZStack {
                // Element aura glow
                Circle()
                    .fill(profileManager.currentElement.primaryColor.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .blur(radius: 12)
                
                // Custom Equipped Aura
                let activeAuraColor: Color = {
                    if profileManager.equippedAura != "None" {
                        switch profileManager.equippedAura {
                        case "Glitch Aura": return Color(hex: "#00F0FF") ?? .cyan
                        case "Phoenix Flare": return .orange
                        case "Abyssal Mist": return Color(hex: "#880E4F") ?? .purple
                        case "Lightning Spark": return .yellow
                        default: return profileManager.currentElement.accentColor
                        }
                    } else {
                        return profileManager.currentElement.accentColor
                    }
                }()
                
                if profileManager.equippedAura != "None" {
                    Circle()
                        .fill(activeAuraColor.opacity(0.25))
                        .frame(width: 110, height: 110)
                        .blur(radius: 6)
                }
                
                PixelSpriteView(
                    grid: profileManager.sprite.pixelGrid,
                    skin: skinColor,
                    hair: hairColor,
                    eye: eyeColor,
                    outfit: outfitColor,
                    aura: activeAuraColor,
                    pixelSize: 0.3
                )
                .offset(y: spriteBobbingOffset)
                
                // Element Flavor Sprite (floating power indicator)
                Text({
                    switch profileManager.currentElement.name {
                    case "Fire": return "🔥"
                    case "Water": return "💧"
                    case "Earth": return "🪨"
                    case "Air": return "💨"
                    case "Lightning": return "⚡"
                    case "Metal": return "⚙️"
                    case "Ice": return "🧊"
                    case "Bone": return "🦴"
                    case "Gas": return "🌫️"
                    case "Laser": return "🔴"
                    case "Zero Space": return "🌀"
                    case "Knife": return "🗡️"
                    case "Poison": return "🧪"
                    case "Darki": return "🔮"
                    case "Shadow": return "👻"
                    case "Death": return "💀"
                    default: return "✨"
                    }
                }())
                .font(.system(size: 14))
                .padding(4)
                .background(
                    Circle()
                        .fill(profileManager.currentElement.primaryColor.opacity(0.2))
                        .shadow(color: profileManager.currentElement.primaryColor, radius: 4)
                )
                .offset(x: 35, y: -35)
                .offset(y: -spriteBobbingOffset * 0.7)
                
                // Custom Equipped Frame Overlay
                if profileManager.equippedFrame != "None" {
                    let frameColor: Color = {
                        switch profileManager.equippedFrame {
                        case "Ignis Frame": return .red
                        case "Crystalline Frame": return Color(hex: "#26C6DA") ?? .teal
                        case "Umbral Border": return Color(hex: "#311B92") ?? .purple
                        case "Cyber Grid Frame": return .blue
                        default: return profileManager.currentElement.primaryColor
                        }
                    }()
                    Circle()
                        .stroke(frameColor, lineWidth: 3)
                        .frame(width: 80, height: 80)
                        .shadow(color: frameColor, radius: 4)
                }
                
                elementFlavorSprite
                    .offset(x: 32, y: 32)
                    .offset(y: -spriteBobbingOffset * 0.5)
            }
            .frame(width: 90, height: 90)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Text(profileManager.characterName.uppercased())
                        .font(.custom("Orbitron-Bold", size: 18).bold())
                        .foregroundColor(.white)
                        .tracking(2)
                    
                    if profileManager.equippedTitle != "None" {
                        Text("[\(profileManager.equippedTitle)]")
                            .font(.custom("Orbitron-Bold", size: 10).bold())
                            .foregroundColor(.orange)
                    }
                }
                
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
                
                if profileManager.previousStreak > 0 && profileManager.streak == 0 {
                    Button(action: {
                        let _ = profileManager.recoverStreak()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.clockwise.circle.fill")
                            Text("Recover \(profileManager.previousStreak) Day Streak (100 💎)")
                                .font(.system(size: 9).bold())
                        }
                        .foregroundColor(.orange)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.orange.opacity(0.12))
                        .cornerRadius(6)
                    }
                }
                
                if profileManager.equippedAccessory != "None" {
                    Text("Equipped: \(profileManager.equippedAccessory)")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding()
        .background(
            ZStack {
                Color.white.opacity(0.02)
                if profileManager.equippedBackground != "None" {
                    let colors: [Color] = {
                        switch profileManager.equippedBackground {
                        case "Neon Cyber Space":
                            return [Color(hex: "#0A192F")?.opacity(0.45) ?? .blue, Color(hex: "#172A45")?.opacity(0.2) ?? .cyan]
                        case "Nebula Starfield":
                            return [Color(hex: "#1F1235")?.opacity(0.45) ?? .purple, Color(hex: "#362259")?.opacity(0.2) ?? .indigo]
                        case "Volcanic Core":
                            return [Color(hex: "#2D0A0A")?.opacity(0.45) ?? .red, Color(hex: "#501B1B")?.opacity(0.2) ?? .orange]
                        default:
                            return [profileManager.currentElement.primaryColor.opacity(0.35), Color.clear]
                        }
                    }()
                    LinearGradient(
                        gradient: Gradient(colors: colors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(profileManager.currentElement.primaryColor.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var elementFlavorSprite: some View {
        let elementName = profileManager.currentElement.name
        let primaryColor = profileManager.currentElement.primaryColor
        let accentColor = profileManager.currentElement.accentColor
        
        let iconName = { () -> String in
            switch elementName {
            case "Fire": return "flame.fill"
            case "Water": return "drop.fill"
            case "Earth": return "leaf.fill"
            case "Air": return "wind"
            case "Lightning": return "bolt.fill"
            case "Metal": return "shield.fill"
            case "Ice": return "snowflake"
            case "Bone": return "oval.portrait.bottomhalf.filled"
            case "Gas": return "smoke.fill"
            case "Laser": return "scope"
            case "Zero Space": return "circle.hexagongrid.fill"
            case "Darki": return "crown.fill"
            case "Death": return "skull.fill"
            case "Knife": return "sparkles"
            case "Poison": return "vial.viewfinder"
            case "Shadow": return "moon.fill"
            default: return "sparkles"
            }
        }()
        
        ZStack {
            Circle()
                .fill(Color.black)
                .frame(width: 24, height: 24)
                .shadow(color: primaryColor, radius: 3)
            
            Circle()
                .stroke(LinearGradient(colors: [primaryColor, accentColor], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
                .frame(width: 24, height: 24)
            
            Image(systemName: iconName)
                .font(.system(size: 10).bold())
                .foregroundStyle(
                    LinearGradient(
                        colors: [primaryColor, accentColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .frame(width: 26, height: 26)
        .background(
            Circle()
                .fill(primaryColor.opacity(0.2))
                .blur(radius: 4)
        )
    }
    
    @ViewBuilder
    private var healthKitStatusView: some View {
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
    }
    
    @ViewBuilder
    private var energyActivityGauges: some View {
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
                    target: profileManager.stepsGoal,
                    unit: "steps",
                    icon: "figure.walk"
                )
                
                metricGauge(
                    title: "Active Energy",
                    current: healthManager.todayCalories,
                    target: profileManager.caloriesGoal,
                    unit: "kcal",
                    icon: "flame"
                )
                
                metricGauge(
                    title: "Training Time",
                    current: healthManager.activeMinutes,
                    target: profileManager.activeMinutesGoal,
                    unit: "mins",
                    icon: "stopwatch"
                )
                
                metricGauge(
                    title: "Stand Hours",
                    current: healthManager.todayStandHours,
                    target: profileManager.standHoursGoal,
                    unit: "hours",
                    icon: "figure.stand"
                )
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var sugarTrackerCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("SUGAR INTAKE TRACKER")
                .font(.custom("Orbitron-Bold", size: 12).bold())
                .foregroundColor(.gray)
                .tracking(2)
                .padding(.horizontal)
            
            let loggedSugar = profileManager.todaySugar
            let sugarPercent = min(loggedSugar / 30.0, 1.0)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label("Today's Sugar", systemImage: "carbon.monoxide")
                        .font(.custom("Exo2-Bold", size: 13))
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.1f / 30.0 g", loggedSugar))
                        .font(.system(size: 11))
                        .foregroundColor(loggedSugar > 30.0 ? .red : profileManager.currentElement.primaryColor)
                }
                
                ProgressView(value: sugarPercent, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: loggedSugar > 30.0 ? .red : profileManager.currentElement.primaryColor))
                
                HStack {
                    Text(loggedSugar > 30.0 ? "⚠️ Sugar threshold exceeded!" : "Keep sugar under 30g daily to maintain clean energy flow.")
                        .font(.caption2)
                        .foregroundColor(loggedSugar > 30.0 ? .red : .gray)
                    Spacer()
                }
            }
            .padding()
            .background(Color.white.opacity(0.02))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(loggedSugar > 30.0 ? Color.red.opacity(0.3) : Color.white.opacity(0.06), lineWidth: 1)
            )
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var targetGoalProgressView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("TARGET GOAL PROGRESS")
                .font(.custom("Orbitron-Bold", size: 12).bold())
                .foregroundColor(.gray)
                .tracking(2)
                .padding(.horizontal)
            
            VStack(spacing: 15) {
                weightGoalProgressView
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                distanceGoalProgressView
                
                weightHistoryCardView
                
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.vertical, 8)
                
                bodyMeasurementsLogSectionView
            }
            .padding()
            .background(Color.white.opacity(0.02))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var monthlyChallengeCard: some View {
        let challenge = profileManager.activeMonthlyChallenge
        let themeColor = profileManager.currentElement.primaryColor
        let progressPercent = challenge.targetAmount > 0 ? min(challenge.currentAmount / challenge.targetAmount, 1.0) : 0.0
        
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("MONTHLY CHALLENGE: \(challenge.monthName.uppercased())")
                    .font(.custom("Orbitron-Bold", size: 12).bold())
                    .foregroundColor(themeColor)
                    .tracking(2)
                Spacer()
                Text("🏆 Badge Reward")
                    .font(.custom("Orbitron-Bold", size: 10))
                    .foregroundColor(.orange)
            }
            
            Text(challenge.targetDescription)
                .font(.custom("Exo2-Bold", size: 14))
                .foregroundColor(.white)
            
            VStack(spacing: 6) {
                HStack {
                    Text("\(Int(challenge.currentAmount)) / \(Int(challenge.targetAmount)) \(challenge.targetMetric)")
                        .font(.custom("Exo2-Medium", size: 11))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(Int(progressPercent * 100))%")
                        .font(.custom("Orbitron-Bold", size: 11).bold())
                        .foregroundColor(.white)
                }
                
                // Custom progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.06))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient(colors: [themeColor, themeColor.opacity(0.6)], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * CGFloat(progressPercent))
                    }
                }
                .frame(height: 8)
            }
            
            // Advance progress manual helper
            HStack {
                Text("Auto-advances via quests, or manually log reps/miles:")
                    .font(.system(size: 9))
                    .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    showingChallengeConfirmation = true
                }) {
                    Text("+ Log Progress")
                        .font(.system(size: 9).bold())
                        .foregroundColor(themeColor)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(themeColor.opacity(0.12))
                        .cornerRadius(4)
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.02))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(themeColor.opacity(0.15), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var weightGoalProgressView: some View {
        let isCutting = profileManager.startWeight > profileManager.goalWeight
        let totalDelta = abs(profileManager.startWeight - profileManager.goalWeight)
        let currentDelta = isCutting ? (profileManager.startWeight - profileManager.weight) : (profileManager.weight - profileManager.startWeight)
        let progressPercent = totalDelta > 0 ? max(min(currentDelta / totalDelta, 1.0), 0.0) : 1.0
        
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label("Weight Target Progress", systemImage: "scalemass.fill")
                    .font(.custom("Exo2-Bold", size: 13))
                    .foregroundColor(.white)
                Spacer()
                Text(String(format: "%.1f -> %.1f lbs (Goal: %.1f)", profileManager.startWeight, profileManager.weight, profileManager.goalWeight))
                    .font(.system(size: 11))
                    .foregroundColor(profileManager.currentElement.primaryColor)
            }
            
            ProgressView(value: progressPercent, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: profileManager.currentElement.primaryColor))
            
            HStack {
                Text(String(format: "%.0f%% Achieved", progressPercent * 100))
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
                if profileManager.hasClaimedWeightGoalReward {
                    Text("🏆 Reward Claimed!")
                        .font(.caption2)
                        .foregroundColor(.green)
                } else if progressPercent >= 1.0 {
                    Text("🎉 Goal Hit! Reward Pending...")
                        .font(.caption2)
                        .foregroundColor(.orange)
                } else {
                    let remaining = abs(profileManager.weight - profileManager.goalWeight)
                    Text(String(format: "%.1f lbs to go", remaining))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    @ViewBuilder
    private var distanceGoalProgressView: some View {
        let currentDistance = healthManager.todaySteps / 2000.0
        let distancePercent = profileManager.distanceGoal > 0 ? max(min(currentDistance / profileManager.distanceGoal, 1.0), 0.0) : 1.0
        
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label("Daily Cardio Goal", systemImage: "figure.run")
                    .font(.custom("Exo2-Bold", size: 13))
                    .foregroundColor(.white)
                Spacer()
                Text(String(format: "%.1f / %.1f miles", currentDistance, profileManager.distanceGoal))
                    .font(.system(size: 11))
                    .foregroundColor(profileManager.currentElement.primaryColor)
            }
            
            ProgressView(value: distancePercent, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: profileManager.currentElement.primaryColor))
            
            HStack {
                Text(String(format: "%.0f%% Completed", distancePercent * 100))
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
                if profileManager.hasClaimedDistanceGoalReward {
                    Text("🏆 Daily Reward Claimed! (+30 💎)")
                        .font(.caption2)
                        .foregroundColor(.green)
                } else if distancePercent >= 1.0 {
                    Text("🎉 Goal Achieved! Reward Claimed")
                        .font(.caption2)
                        .foregroundColor(.green)
                        .onAppear {
                            profileManager.checkDistanceGoalProgress(todaySteps: healthManager.todaySteps)
                        }
                } else {
                    let remaining = max(profileManager.distanceGoal - currentDistance, 0.0)
                    Text(String(format: "%.1f miles to go", remaining))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            // Push Challenge Suggestion
            if profileManager.streak >= 3 {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.orange)
                        Text("CHALLENGE RECOMMENDATION")
                            .font(.custom("Orbitron-Bold", size: 10).bold())
                            .foregroundColor(.orange)
                    }
                    Text("You have a \(profileManager.streak)-day activity streak! Push your limits and increase your daily cardio target to \(String(format: "%.1f", profileManager.distanceGoal + 1.0)) miles.")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.85))
                        .lineSpacing(2)
                    
                    Button(action: {
                        profileManager.distanceGoal += 1.0
                        profileManager.hasClaimedDistanceGoalReward = false
                    }) {
                        Text("UP CARDIO GOAL TO \(String(format: "%.1f", profileManager.distanceGoal + 1.0)) MILES")
                            .font(.custom("Orbitron-Bold", size: 9).bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color.orange))
                    }
                }
                .padding(10)
                .background(Color.orange.opacity(0.08))
                .cornerRadius(10)
                .padding(.top, 5)
            }
        }
    }
    
    @ViewBuilder
    private var weightHistoryCardView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(selectedHistoryType == "Weight" ? "Weight History Log" : "\(selectedHistoryType) PR History")
                    .font(.custom("Exo2-Bold", size: 12))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Menu {
                    Button("Weight") { selectedHistoryType = "Weight" }
                    ForEach(["Pullups", "Pushups", "Squats", "Dips", "Bench Press", "Deadlift", "Barbell Squat", "Overhead Press", "Run (Miles)", "Handstand Hold (Sec)"], id: \.self) { prKey in
                        let label: String = {
                            if prKey == "Run (Miles)" {
                                return profileManager.useImperialUnits ? "Run (Miles)" : "Run (KM)"
                            } else if ["Bench Press", "Deadlift", "Barbell Squat", "Overhead Press"].contains(prKey) {
                                return profileManager.useImperialUnits ? "\(prKey) (LBS)" : "\(prKey) (KG)"
                            } else {
                                return prKey
                            }
                        }()
                        Button(label) { selectedHistoryType = prKey }
                    }
                } label: {
                    HStack(spacing: 4) {
                        let displayLabel: String = {
                            if selectedHistoryType == "Weight" { return "Weight" }
                            if selectedHistoryType == "Run (Miles)" { return profileManager.useImperialUnits ? "Run (Miles)" : "Run (KM)" }
                            if ["Bench Press", "Deadlift", "Barbell Squat", "Overhead Press"].contains(selectedHistoryType) {
                                return profileManager.useImperialUnits ? "\(selectedHistoryType) (LBS)" : "\(selectedHistoryType) (KG)"
                            }
                            return selectedHistoryType
                        }()
                        Text(displayLabel)
                            .font(.system(size: 10).bold())
                        Image(systemName: "chevron.down")
                            .font(.system(size: 8))
                    }
                    .foregroundColor(profileManager.currentElement.primaryColor)
                }
            }
            
            if selectedHistoryType == "Weight" {
                WeightHistoryChart(
                    history: profileManager.weightHistory,
                    startWeight: profileManager.startWeight,
                    goalWeight: profileManager.goalWeight,
                    primaryColor: profileManager.currentElement.primaryColor
                )
            } else {
                let points: [(date: Date, value: Double)] = {
                    let historyList = profileManager.prHistory[selectedHistoryType] ?? []
                    return historyList.map { entry in
                        var val = entry.value
                        if !profileManager.useImperialUnits {
                            if ["Bench Press", "Deadlift", "Barbell Squat", "Overhead Press"].contains(selectedHistoryType) {
                                val = val * 0.45359237
                            } else if selectedHistoryType == "Run (Miles)" {
                                val = val * 1.609344
                            }
                        }
                        return (date: entry.date, value: val)
                    }
                }()
                
                ProgressHistoryChart(
                    points: points,
                    primaryColor: profileManager.currentElement.primaryColor
                )
            }
        }
        .padding(.top, 5)
    }
    
    @ViewBuilder
    private var bodyMeasurementsLogSectionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Body Measurements Log")
                    .font(.custom("Exo2-Bold", size: 12))
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
                Button(action: {
                    measureWeight = String(format: "%.1f", profileManager.weight)
                    measureChest = String(format: "%.1f", profileManager.chest)
                    measureArms = String(format: "%.1f", profileManager.arms)
                    measureWaist = String(format: "%.1f", profileManager.waist)
                    measureHips = String(format: "%.1f", profileManager.hips)
                    measureLegs = String(format: "%.1f", profileManager.legs)
                    showingMeasurementLog = true
                }) {
                    Label("Log Metric", systemImage: "ruler.fill")
                        .font(.system(size: 10).bold())
                        .foregroundColor(profileManager.currentElement.primaryColor)
                }
            }
            
            if profileManager.measurementHistory.isEmpty {
                Text("No measurements logged yet. Start measuring year-over-year!")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.vertical, 5)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(profileManager.measurementHistory.reversed()) { entry in
                            VStack(alignment: .leading, spacing: 4) {
                                let formatter: DateFormatter = {
                                    let f = DateFormatter()
                                    f.dateStyle = .short
                                    return f
                                }()
                                Text(formatter.string(from: entry.date))
                                    .font(.system(size: 9).bold())
                                    .foregroundColor(profileManager.currentElement.primaryColor)
                                
                                Text("Weight: \(String(format: "%.1f", entry.weight)) lbs")
                                    .font(.system(size: 9))
                                    .foregroundColor(.white)
                                Text("Chest: \(String(format: "%.1f", entry.chest)) in")
                                    .font(.system(size: 9))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("Arms: \(String(format: "%.1f", entry.arms)) in")
                                    .font(.system(size: 9))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("Waist: \(String(format: "%.1f", entry.waist)) in")
                                    .font(.system(size: 9))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("Hips: \(String(format: "%.1f", entry.hips)) in")
                                    .font(.system(size: 9))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("Legs: \(String(format: "%.1f", entry.legs)) in")
                                    .font(.system(size: 9))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(10)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var psychAdaptiveSection: some View {
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
    
    // MARK: - Gauges Helper
    private func metricGauge(title: String, current: Double, target: Double, unit: String, icon: String) -> some View {
        let percentage = max(min(current / target, 1.0), 0.0)
        let percentStr = String(format: "%.1f%%", percentage * 100)
        let element = profileManager.currentElement
        
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label {
                    Text(title)
                        .font(.custom("Exo2-Bold", size: 13))
                        .foregroundColor(.white)
                } icon: {
                    Image(systemName: icon)
                        .foregroundColor(element.accentColor)
                }
                Spacer()
                HStack(spacing: 4) {
                    Text("\(Int(current))/\(Int(target)) \(unit)")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.8))
                    Text("(\(percentStr))")
                        .font(.custom("Orbitron-Bold", size: 10))
                        .foregroundColor(element.secondaryColor)
                }
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    element.primaryColor,
                                    element.accentColor,
                                    element.secondaryColor
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * CGFloat(percentage), height: 8)
                        .shadow(color: element.primaryColor.opacity(0.6), radius: 4, x: 0, y: 0)
                }
            }
            .frame(height: 8)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.45))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [
                            element.primaryColor.opacity(0.4),
                            element.secondaryColor.opacity(0.12),
                            element.detailColor.opacity(0.03)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
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
                
                checklistRow(label: "Steps Taken (\(Int(healthManager.todaySteps))/\(Int(profileManager.stepsGoal)) steps)", completed: healthManager.todaySteps >= profileManager.stepsGoal)
                checklistRow(label: "Active Energy (\(Int(healthManager.todayCalories))/\(Int(profileManager.caloriesGoal)) kcal)", completed: healthManager.todayCalories >= profileManager.caloriesGoal)
                checklistRow(label: "Training Time (\(Int(healthManager.activeMinutes))/\(Int(profileManager.activeMinutesGoal)) mins)", completed: healthManager.activeMinutes >= profileManager.activeMinutesGoal)
                checklistRow(label: "Stand Hours (\(Int(healthManager.todayStandHours))/\(Int(profileManager.standHoursGoal)) hours)", completed: healthManager.todayStandHours >= profileManager.standHoursGoal)
                checklistRow(label: "Sugar Intake (\(String(format: "%.1f", profileManager.todaySugar))g/30.0g max)", completed: profileManager.todaySugar <= 30.0)
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
                
                let stepsPercent = profileManager.stepsGoal > 0 ? min(healthManager.todaySteps / profileManager.stepsGoal, 1.0) : 1.0
                let caloriesPercent = profileManager.caloriesGoal > 0 ? min(healthManager.todayCalories / profileManager.caloriesGoal, 1.0) : 1.0
                let minutesPercent = profileManager.activeMinutesGoal > 0 ? min(healthManager.activeMinutes / profileManager.activeMinutesGoal, 1.0) : 1.0
                let standPercent = profileManager.standHoursGoal > 0 ? min(healthManager.todayStandHours / profileManager.standHoursGoal, 1.0) : 1.0
                let sugarPercent = profileManager.todaySugar <= 30.0 ? 1.0 : 0.0
                
                let completionRate = (stepsPercent + caloriesPercent + minutesPercent + standPercent + sugarPercent) / 5.0 * 100
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
                        Text("Active Focuses:")
                            .font(.custom("Exo2-Bold", size: 11))
                            .foregroundColor(.gray)
                        Text(profileManager.selectedFocuses.map { $0.rawValue }.joined(separator: ", "))
                            .font(.custom("Exo2-Medium", size: 11))
                            .foregroundColor(.white)
                    }
                    
                    HStack(alignment: .top) {
                        Text("Weight Goal:")
                            .font(.custom("Exo2-Bold", size: 11))
                            .foregroundColor(.gray)
                        Text("\(Int(profileManager.goalWeight)) lbs (Starting from \(Int(profileManager.startWeight)) lbs)")
                            .font(.custom("Exo2-Medium", size: 11))
                            .foregroundColor(.white)
                    }
                    
                    HStack(alignment: .top) {
                        Text("Daily Cardio:")
                            .font(.custom("Exo2-Bold", size: 11))
                            .foregroundColor(.gray)
                        Text(String(format: "%.1f miles", profileManager.distanceGoal))
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
    
    @ViewBuilder
    private var bodyMeasurementModal: some View {
        if showingMeasurementLog {
            ZStack {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingMeasurementLog = false
                    }
                
                VStack(spacing: 15) {
                    Text("LOG BODY METRICS")
                        .font(.custom("Orbitron-Bold", size: 16).bold())
                        .foregroundColor(.white)
                        .tracking(2)
                    
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("WEIGHT (LBS)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            TextField("lbs", text: $measureWeight)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CHEST (INCHES)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            TextField("inches", text: $measureChest)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("ARMS (INCHES)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            TextField("inches", text: $measureArms)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("WAIST (INCHES)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            TextField("inches", text: $measureWaist)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("HIPS (INCHES)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            TextField("inches", text: $measureHips)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("LEGS (INCHES)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            TextField("inches", text: $measureLegs)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            showingMeasurementLog = false
                        }) {
                            Text("Cancel")
                                .font(.custom("Orbitron-Bold", size: 12).bold())
                                .foregroundColor(.gray)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        
                        Button(action: {
                            let w = Double(measureWeight) ?? 0
                            let c = Double(measureChest) ?? 0
                            let a = Double(measureArms) ?? 0
                            let wa = Double(measureWaist) ?? 0
                            let h = Double(measureHips) ?? 0
                            let l = Double(measureLegs) ?? 0
                            
                            profileManager.logBodyMeasurements(weight: w, chest: c, arms: a, waist: wa, hips: h, legs: l)
                            showingMeasurementLog = false
                        }) {
                            Text("LOG METRICS")
                                .font(.custom("Orbitron-Bold", size: 12).bold())
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(profileManager.currentElement.primaryColor)
                                )
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(25)
                .frame(width: 320)
                .background(Color(hex: "#0c0c0c"))
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(profileManager.currentElement.primaryColor.opacity(0.4), lineWidth: 1.5)
                )
                .transition(.scale)
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
        let size = CGFloat(grid.count) * pixelSize
        Canvas { context, sz in
            for r in 0..<grid.count {
                for c in 0..<grid[r].count {
                    let val = grid[r][c]
                    if val != 0 {
                        let color = colorForValue(val)
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

// MARK: - Weight History Chart View
struct WeightHistoryChart: View {
    let history: [WeightEntry]
    let startWeight: Double
    let goalWeight: Double
    let primaryColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            if history.isEmpty {
                Text("No weight records yet.")
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    let weights = history.map { $0.weight }
                    let minW = min(weights.min() ?? 0.0, min(startWeight, goalWeight)) - 5.0
                    let maxW = max(weights.max() ?? 0.0, max(startWeight, goalWeight)) + 5.0
                    let diff = maxW - minW
                    
                    ForEach(history.suffix(7)) { entry in
                        VStack(spacing: 4) {
                            // Weight label
                            Text(String(format: "%.0f", entry.weight))
                                .font(.system(size: 8))
                                .foregroundColor(.white)
                            
                            // Bar or point
                            let heightPercent = diff > 0 ? (entry.weight - minW) / diff : 0.5
                            RoundedRectangle(cornerRadius: 2)
                                .fill(primaryColor)
                                .frame(width: 16, height: CGFloat(heightPercent * 40) + 4)
                            
                            // Date label
                            Text(formatDate(entry.date))
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(height: 70)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
}

struct ProgressHistoryChart: View {
    let points: [(date: Date, value: Double)]
    let primaryColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            if points.isEmpty {
                Text("No log entries yet.")
                    .font(.custom("Exo2-Regular", size: 10))
                    .foregroundColor(.gray)
                    .frame(height: 70)
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    let values = points.map { $0.value }
                    let minVal = (values.min() ?? 0.0) * 0.9
                    let maxVal = (values.max() ?? 0.0) * 1.1
                    let diff = maxVal - minVal
                    
                    ForEach(points.suffix(7), id: \.date) { entry in
                        VStack(spacing: 4) {
                            Text(String(format: "%.1f", entry.value))
                                .font(.system(size: 8))
                                .foregroundColor(.white)
                            
                            let heightPercent = diff > 0 ? (entry.value - minVal) / diff : 0.5
                            RoundedRectangle(cornerRadius: 2)
                                .fill(primaryColor)
                                .frame(width: 16, height: CGFloat(heightPercent * 40) + 4)
                            
                            Text(formatDate(entry.date))
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(height: 70)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
}
