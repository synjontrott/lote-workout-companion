//
//  QuestBoardView.swift
//  LotE Workout Companion
//
//  Created by Antigravity on 6/23/26.
//

import SwiftUI

struct DopamineItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let xp: Int
    let crystals: Int
}

struct QuestBoardView: View {
    @ObservedObject var profileManager: UserProfileManager
    @ObservedObject var healthManager: HealthKitManager
    @State private var selectedQuest: LotEQuest?
    @State private var selectedCadence: QuestCadence = .daily
    
    // Dopamine confirmation modal states
    @State private var selectedDopamineItem: DopamineItem? = nil
    
    // Detailed meal log modal states
    @State private var showingMealLog = false
    @State private var mealName = ""
    @State private var mealCalories = ""
    @State private var mealProtein = ""
    @State private var mealCarbs = ""
    @State private var mealFats = ""
    @State private var mealSugar = ""
    
    // Suggested Workout Tailoring states
    @State private var tailGender: String = "Male"
    @State private var tailAge: String = "30"
    @State private var tailWeight: String = "170"
    @State private var tailEquipment: String = "Bodyweight Only"
    @State private var tailDifficulty: String = "Medium"
    @State private var tailMuscleGroup: MuscleGroup = .chest
    
    // Action outcome popup states
    @State private var finalOutcomeText: String = ""
    @State private var showOutcomeAlert: Bool = false
    @State private var wasSuccessful: Bool = false
    @State private var showingWorkoutCompleteConfirmation: Bool = false
    @State private var workoutPendingCompletion: SuggestedWorkout? = nil
    
    // Tailored Dopamine Menu (dynamic based on element and selected focuses)
    var tailoredDopamineMenu: [DopamineItem] {
        var menu: [DopamineItem] = []
        let element = profileManager.currentElement.name
        
        let adj: String
        switch element {
        case "Fire": adj = "Flame"
        case "Water": adj = "Tidal"
        case "Earth": adj = "Terra"
        case "Air": adj = "Zephyr"
        case "Lightning": adj = "Volt"
        case "Metal": adj = "Iron"
        case "Ice": adj = "Frost"
        case "Bone": adj = "Marrow"
        case "Gas": adj = "Vapor"
        case "Laser": adj = "Photon"
        case "Zero Space": adj = "Void"
        case "Darki": adj = "Umbral"
        case "Death": adj = "Decay"
        case "Knife": adj = "Razor"
        case "Poison": adj = "Toxic"
        case "Shadow": adj = "Phantom"
        default: adj = "Astral"
        }
        
        let focuses = profileManager.selectedFocuses.isEmpty ? [.calisthenics, .cardio] : profileManager.selectedFocuses
        
        for focus in focuses {
            switch focus {
            case .calisthenics:
                menu.append(DopamineItem(name: "\(adj) Defiance (10 Pushups)", icon: "figure.walk", xp: 15, crystals: 5))
                menu.append(DopamineItem(name: "\(adj) Lever (15 Sec hollow hold)", icon: "shield.fill", xp: 15, crystals: 5))
            case .lifting:
                menu.append(DopamineItem(name: "\(adj) Load (15 body squats)", icon: "figure.strengthtraining.functional", xp: 15, crystals: 5))
                menu.append(DopamineItem(name: "\(adj) Press (10 overhead arm raises)", icon: "figure.strengthtraining.functional", xp: 15, crystals: 5))
            case .cardio:
                menu.append(DopamineItem(name: "\(adj) Dash (30 High knees)", icon: "bolt.fill", xp: 15, crystals: 5))
                menu.append(DopamineItem(name: "\(adj) Jog (1 Min walk in place)", icon: "figure.run", xp: 20, crystals: 6))
            case .flexibility:
                menu.append(DopamineItem(name: "\(adj) Alignment (30 Sec toe stretch)", icon: "figure.flexibility", xp: 15, crystals: 5))
                menu.append(DopamineItem(name: "\(adj) Flow (1 Min ankle mobility)", icon: "figure.flexibility", xp: 10, crystals: 3))
            case .cutting:
                menu.append(DopamineItem(name: "\(adj) Cleanse (Drink a glass of cold water)", icon: "drop.fill", xp: 10, crystals: 3))
            case .bulking:
                menu.append(DopamineItem(name: "\(adj) Nourish (Protein snack log)", icon: "fork.knife", xp: 10, crystals: 3))
            }
        }
        
        if menu.count < 3 {
            menu.append(DopamineItem(name: "\(adj) Focus (30 Sec deep breathing)", icon: "brain.headprofile", xp: 10, crystals: 3))
        }
        
        return Array(menu.prefix(5))
    }
    
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
                    
                    // Segmented Picker for Quest Cadence
                    Picker("Quest Cadence", selection: $selectedCadence) {
                        ForEach(QuestCadence.allCases, id: \.self) { cadence in
                            Text(cadence.rawValue).tag(cadence)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // ADHD / AuDHD Dopamine Menu Section
                    dopamineMenuSection
                    
                    // Selected Quests List
                    campaignsListSection
                    
                    // Nutrition Board
                    nutritionSection
                    
                    // Suggested Workouts Board
                    suggestedWorkoutsSection
                }
                .padding(.bottom, 40)
            }
            
            // Quest Details Modal Overlay
            questDetailModal
            
            // Dopamine Confirmation Overlay
            dopamineConfirmationModal
            
            // Meal Log Form Modal Overlay
            mealLogModal
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        .alert(isPresented: $showOutcomeAlert) {
            Alert(
                title: Text(wasSuccessful ? "QUEST SUCCESS! 🎉" : "NOTIFICATION ⚔️"),
                message: Text(finalOutcomeText),
                dismissButton: .default(Text("OK")) {
                    selectedQuest = nil
                }
            )
        }
    }
    
    // MARK: - Subviews Helper Components
    
    @ViewBuilder
    private var dopamineMenuSection: some View {
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
                        ForEach(tailoredDopamineMenu) { item in
                            Button(action: {
                                selectedDopamineItem = item
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
    }
    
    @ViewBuilder
    private var campaignsListSection: some View {
        let currentQuests: [LotEQuest] = {
            switch selectedCadence {
            case .daily: return profileManager.dailyQuests
            case .monthly: return profileManager.monthlyQuests
            case .yearly: return profileManager.yearlyQuests
            }
        }()
        
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("\(selectedCadence.rawValue.uppercased()) WARRIOR CAMPAIGNS")
                    .font(.custom("Orbitron-Bold", size: 13).bold())
                    .foregroundColor(.gray)
                    .tracking(2)
                
                Spacer()
                
                if selectedCadence == .daily {
                    Button(action: {
                        profileManager.logRestDay()
                        finalOutcomeText = "Rest Day logged successfully! Your consecutive workout streak has been preserved and your muscles recovered."
                        wasSuccessful = true
                        showOutcomeAlert = true
                    }) {
                        Label("REST DAY", systemImage: "bed.double.fill")
                            .font(.custom("Orbitron-Bold", size: 10).bold())
                            .foregroundColor(.cyan)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(Color.cyan.opacity(0.15))
                            .cornerRadius(6)
                    }
                }
            }
            .padding(.horizontal)
            
            ForEach(currentQuests) { quest in
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
                                Text("\(quest.progressCount)/\(quest.targetCount)")
                                    .font(.custom("Orbitron-Bold", size: 11).bold())
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
    }
    
    @ViewBuilder
    private var nutritionSection: some View {
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
                    showingMealLog = true
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
    
    @ViewBuilder
    private var questDetailModal: some View {
        if let quest = selectedQuest {
            QuestDetailView(
                quest: quest,
                profileManager: profileManager,
                healthManager: healthManager,
                selectedQuest: $selectedQuest,
                finalOutcomeText: $finalOutcomeText,
                wasSuccessful: $wasSuccessful,
                showOutcomeAlert: $showOutcomeAlert
            )
        }
    }
    
    @ViewBuilder
    private var dopamineConfirmationModal: some View {
        if let dopamineItem = selectedDopamineItem {
            ZStack {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedDopamineItem = nil
                    }
                
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "bolt.heart.fill")
                            .foregroundColor(.orange)
                        Text("DOPAMINE BOOST CHALLENGE")
                            .font(.custom("Orbitron-Bold", size: 14).bold())
                            .foregroundColor(.white)
                            .tracking(1)
                    }
                    
                    Text("Perform the following action:")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    Text(dopamineItem.name)
                        .font(.custom("Exo2-Bold", size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(10)
                    
                    VStack(spacing: 4) {
                        Text("REWARDS")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .tracking(1)
                        Text("+\(dopamineItem.xp) XP  /  +\(dopamineItem.crystals) Crystals 💎")
                            .font(.custom("Orbitron-Bold", size: 12).bold())
                            .foregroundColor(.orange)
                    }
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            selectedDopamineItem = nil
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
                            profileManager.addXP(dopamineItem.xp)
                            profileManager.earnCrystals(dopamineItem.crystals)
                            finalOutcomeText = "Momentum gained! You earned \(dopamineItem.xp) XP and \(dopamineItem.crystals) Crystals instantly. Keep it up!"
                            wasSuccessful = true
                            selectedDopamineItem = nil
                            showOutcomeAlert = true
                        }) {
                            Text("I DID IT!")
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
                    .padding(.horizontal)
                }
                .padding(25)
                .frame(width: 310)
                .background(Color(hex: "#0c0c0c"))
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.orange.opacity(0.4), lineWidth: 1.5)
                )
                .transition(.scale)
            }
        }
    }
    
    @ViewBuilder
    private var mealLogModal: some View {
        if showingMealLog {
            ZStack {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingMealLog = false
                    }
                
                VStack(spacing: 15) {
                    Text("LOG HEALTHY RATIONS")
                        .font(.custom("Orbitron-Bold", size: 16).bold())
                        .foregroundColor(.white)
                        .tracking(2)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("RATION NAME")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        TextField("e.g. Chicken breast and broccoli", text: $mealName)
                            .padding(10)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CALORIES")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            TextField("kcal", text: $mealCalories)
                                .keyboardType(.numberPad)
                                .padding(10)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("PROTEIN")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            TextField("grams", text: $mealProtein)
                                .keyboardType(.numberPad)
                                .padding(10)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CARBS")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            TextField("grams", text: $mealCarbs)
                                .keyboardType(.numberPad)
                                .padding(10)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("FATS")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            TextField("grams", text: $mealFats)
                                .keyboardType(.numberPad)
                                .padding(10)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("SUGAR")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        TextField("grams", text: $mealSugar)
                            .keyboardType(.numberPad)
                            .padding(10)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            showingMealLog = false
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
                            let cal = Double(mealCalories) ?? 0
                            let prot = Double(mealProtein) ?? 0
                            let carb = Double(mealCarbs) ?? 0
                            let fat = Double(mealFats) ?? 0
                            let sug = Double(mealSugar) ?? 0
                            
                            profileManager.logDetailedMeal(
                                name: mealName.isEmpty ? "Healthy Rations" : mealName,
                                calories: cal,
                                protein: prot,
                                carbs: carb,
                                fats: fat,
                                sugar: sug
                            )
                            
                            finalOutcomeText = "Rations logged! +15 XP, +10 Crystals, and +1 Constitution gained from nutrition sync."
                            wasSuccessful = true
                            showingMealLog = false
                            showOutcomeAlert = true
                            
                            // Reset text fields
                            mealName = ""
                            mealCalories = ""
                            mealProtein = ""
                            mealCarbs = ""
                            mealFats = ""
                            mealSugar = ""
                        }) {
                            Text("LOG RATION")
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
    }
    
    // MARK: - Helpers
    private func getQuestIndex(id: UUID, cadence: QuestCadence) -> Int? {
        switch cadence {
        case .daily: return profileManager.dailyQuests.firstIndex(where: { $0.id == id })
        case .monthly: return profileManager.monthlyQuests.firstIndex(where: { $0.id == id })
        case .yearly: return profileManager.yearlyQuests.firstIndex(where: { $0.id == id })
        }
    }
    
    private func getQuestAt(index: Int, cadence: QuestCadence) -> LotEQuest {
        switch cadence {
        case .daily: return profileManager.dailyQuests[index]
        case .monthly: return profileManager.monthlyQuests[index]
        case .yearly: return profileManager.yearlyQuests[index]
        }
    }
    
    private func iconForWorkoutType(_ type: WorkoutCategory) -> String {
        switch type {
        case .cardio: return "figure.run"
        case .strength: return "figure.strengthtraining.functional"
        case .flexibility: return "figure.flexibility"
        case .nutrition: return "fork.knife"
        case .meditation: return "brain.headprofile"
        }
    }
    
    @ViewBuilder
    private var suggestedWorkoutsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("TAILORED SUGGESTED WORKOUTS")
                .font(.custom("Orbitron-Bold", size: 13).bold())
                .foregroundColor(.gray)
                .tracking(2)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                // Tailoring inputs card
                VStack(alignment: .leading, spacing: 12) {
                    Text("TAILORING PARAMETERS")
                        .font(.custom("Orbitron-Bold", size: 10).bold())
                        .foregroundColor(profileManager.currentElement.primaryColor)
                        .tracking(1)
                    
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("GENDER")
                                .font(.system(size: 9).bold())
                                .foregroundColor(.gray)
                            Picker("Gender", selection: $tailGender) {
                                Text("Male").tag("Male")
                                Text("Female").tag("Female")
                                Text("Other").tag("Other")
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.vertical, 2)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(6)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("AGE")
                                .font(.system(size: 9).bold())
                                .foregroundColor(.gray)
                            TextField("Age", text: $tailAge)
                                .keyboardType(.numberPad)
                                .font(.system(size: 11))
                                .padding(6)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(6)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("WEIGHT (LBS)")
                                .font(.system(size: 9).bold())
                                .foregroundColor(.gray)
                            TextField("Weight", text: $tailWeight)
                                .keyboardType(.numberPad)
                                .font(.system(size: 11))
                                .padding(6)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(6)
                                .foregroundColor(.white)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("EQUIPMENT")
                            .font(.system(size: 9).bold())
                            .foregroundColor(.gray)
                        Picker("Equipment", selection: $tailEquipment) {
                            Text("Bodyweight Only").tag("Bodyweight Only")
                            Text("Dumbbells").tag("Dumbbells")
                            Text("Pull-up Bar").tag("Pull-up Bar")
                            Text("Full Gym").tag("Full Gym")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(6)
                    }
                    
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("DIFFICULTY")
                                .font(.system(size: 9).bold())
                                .foregroundColor(.gray)
                            Picker("Difficulty", selection: $tailDifficulty) {
                                Text("Easy").tag("Easy")
                                Text("Medium").tag("Medium")
                                Text("Hard").tag("Hard")
                                Text("Legend").tag("Legend")
                                Text("Master").tag("Master")
                            }
                            .pickerStyle(MenuPickerStyle())
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(6)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("MUSCLE GROUP")
                                .font(.system(size: 9).bold())
                                .foregroundColor(.gray)
                            Picker("Muscle Group", selection: $tailMuscleGroup) {
                                ForEach(MuscleGroup.allCases, id: \.self) { mg in
                                    Text(mg.rawValue).tag(mg)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(6)
                        }
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
                
                // Workouts list
                let filtered = SuggestedWorkout.allWorkouts.filter { w in
                    w.muscleGroup == tailMuscleGroup &&
                    w.difficulty.lowercased() == tailDifficulty.lowercased() &&
                    (w.equipment.lowercased().replacingOccurrences(of: "-", with: "").contains(tailEquipment.lowercased().replacingOccurrences(of: "-", with: "")) || tailEquipment == "Full Gym")
                }
                
                let workoutsToShow = filtered.isEmpty ? [generateDynamicSuggestedWorkout(muscleGroup: tailMuscleGroup, difficulty: tailDifficulty, equipment: tailEquipment)] : filtered
                
                ForEach(workoutsToShow) { workout in
                    VStack(alignment: .leading, spacing: 10) {
                        let tailored = tailorWorkout(workout)
                        HStack {
                                Text(workout.name)
                                    .font(.custom("Exo2-Bold", size: 14))
                                    .foregroundColor(.white)
                                Spacer()
                                Text(workout.difficulty.uppercased())
                                    .font(.custom("Orbitron-Bold", size: 9).bold())
                                    .foregroundColor(profileManager.currentElement.primaryColor)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(profileManager.currentElement.primaryColor.opacity(0.15))
                                    .cornerRadius(4)
                            }
                            
                            Text(workout.description)
                                .font(.custom("Exo2-Regular", size: 11))
                                .foregroundColor(.white.opacity(0.75))
                            
                            HStack(spacing: 15) {
                                Label("\(tailored.sets) Sets", systemImage: "repeat")
                                Label(tailored.reps, systemImage: "figure.walk")
                            }
                            .font(.system(size: 10).bold())
                            .foregroundColor(.orange)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("INSTRUCTIONS:")
                                    .font(.system(size: 9).bold())
                                    .foregroundColor(.gray)
                                ForEach(workout.instructions, id: \.self) { inst in
                                    Group {
                                        if inst.hasPrefix("TARGET MUSCLES:") {
                                            HStack(alignment: .top, spacing: 6) {
                                                Image(systemName: "figure.strengthtraining.functional")
                                                    .font(.system(size: 9))
                                                    .foregroundColor(.orange)
                                                Text(inst)
                                                    .font(.custom("Exo2-Bold", size: 10))
                                                    .foregroundColor(.orange)
                                            }
                                            .padding(.vertical, 2)
                                        } else if inst.hasPrefix("SETUP & WIDTH:") {
                                            HStack(alignment: .top, spacing: 6) {
                                                Image(systemName: "arrow.left.and.right")
                                                    .font(.system(size: 9))
                                                    .foregroundColor(.cyan)
                                                Text(inst)
                                                    .font(.custom("Exo2-Bold", size: 10))
                                                    .foregroundColor(.cyan)
                                            }
                                            .padding(.vertical, 2)
                                        } else if inst.hasPrefix("DIFFICULTY KEY:") {
                                            HStack(alignment: .top, spacing: 6) {
                                                Image(systemName: "gauge.medium")
                                                    .font(.system(size: 9))
                                                    .foregroundColor(.yellow)
                                                Text(inst)
                                                    .font(.custom("Exo2-Bold", size: 10))
                                                    .foregroundColor(.yellow)
                                            }
                                            .padding(.vertical, 2)
                                        } else {
                                            HStack(alignment: .top, spacing: 4) {
                                                Text("•")
                                                    .foregroundColor(profileManager.currentElement.primaryColor)
                                                Text(inst)
                                                    .font(.custom("Exo2-Regular", size: 10))
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Button(action: {
                                workoutPendingCompletion = workout
                                showingWorkoutCompleteConfirmation = true
                            }) {
                                Text("COMPLETE WORKOUT")
                                    .font(.custom("Orbitron-Bold", size: 10).bold())
                                    .foregroundColor(.white)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(profileManager.currentElement.primaryColor)
                                    )
                            }
                            .alert(isPresented: $showingWorkoutCompleteConfirmation) {
                                Alert(
                                    title: Text("COMPLETE WORKOUT?"),
                                    message: Text("Are you sure you have completed '\(workoutPendingCompletion?.name ?? "")'? This will reward you with XP, Crystals, and advance your goals."),
                                    primaryButton: .default(Text("YES, LOG IT")) {
                                        if let workout = workoutPendingCompletion {
                                            profileManager.addXP(20)
                                            profileManager.earnCrystals(10)
                                            profileManager.logWorkout(category: workout.category)
                                            finalOutcomeText = "Workout complete! You conquered \(workout.name) and gained +20 XP, +10 Crystals, and forged your character attributes."
                                            wasSuccessful = true
                                            showOutcomeAlert = true
                                        }
                                    },
                                    secondaryButton: .cancel()
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
            }
            .padding(.bottom, 20)
        }
    
    private func tailorWorkout(_ workout: SuggestedWorkout) -> (sets: Int, reps: String) {
        let ageVal = Int(tailAge) ?? 30
        let weightVal = Double(tailWeight) ?? 170.0
        
        var setsMultiplier = 1.0
        var repsMultiplier = 1.0
        
        if ageVal > 50 {
            setsMultiplier = 0.8
            repsMultiplier = 0.8
        } else if ageVal < 22 {
            setsMultiplier = 1.2
            repsMultiplier = 1.1
        }
        
        if weightVal > 220.0 && workout.equipment == "Bodyweight Only" {
            repsMultiplier *= 0.85
        }
        
        if tailGender == "Female" {
            repsMultiplier *= 0.95
        }
        
        let finalSets = max(1, Int(round(Double(workout.sets) * setsMultiplier)))
        
        let repStr = workout.reps
        var finalReps = repStr
        if let firstNumStr = repStr.components(separatedBy: CharacterSet.decimalDigits.inverted).filter({ !$0.isEmpty }).first,
           let num = Double(firstNumStr) {
            let adjustedNum = max(1, Int(round(num * repsMultiplier)))
            finalReps = repStr.replacingOccurrences(of: firstNumStr, with: "\(adjustedNum)")
        }
        
        return (finalSets, finalReps)
    }
    
    private func generateDynamicSuggestedWorkout(muscleGroup: MuscleGroup, difficulty: String, equipment: String) -> SuggestedWorkout {
        let name = "\(difficulty) Custom \(muscleGroup.rawValue) Builder"
        let description = "Target the \(muscleGroup.rawValue) using \(equipment)."
        let instructions = [
            "Perform dynamic warm up.",
            "Perform compound sets targeting \(muscleGroup.rawValue).",
            "Adjust weight or resistance based on \(equipment).",
            "Rest 60-90 seconds between sets."
        ]
        let reps = difficulty == "Easy" ? "8-10 reps" : difficulty == "Medium" ? "10-12 reps" : "12-15 reps"
        let sets = difficulty == "Easy" ? 3 : difficulty == "Medium" ? 4 : 5
        
        return SuggestedWorkout(
            name: name,
            muscleGroup: muscleGroup,
            difficulty: difficulty,
            equipment: equipment,
            description: description,
            instructions: instructions,
            sets: sets,
            reps: reps
        )
    }
}


struct QuestDetailView: View {
    let quest: LotEQuest
    @ObservedObject var profileManager: UserProfileManager
    @ObservedObject var healthManager: HealthKitManager
    @Binding var selectedQuest: LotEQuest?
    @Binding var finalOutcomeText: String
    @Binding var wasSuccessful: Bool
    @Binding var showOutcomeAlert: Bool
    
    private var statRewardAbbreviation: String {
        return quest.statReward.rawValue.prefix(3).uppercased()
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    selectedQuest = nil
                }
            
            VStack(spacing: 20) {
                Text(quest.title.uppercased())
                    .font(.custom("Orbitron-Bold", size: 18).bold())
                    .foregroundColor(.white)
                    .tracking(2)
                    .multilineTextAlignment(.center)
                
                Text(quest.questDescription)
                    .font(.custom("Exo2-Medium", size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Progress bar or count
                VStack(spacing: 8) {
                    HStack {
                        Text("Progress:")
                            .font(.custom("Exo2-Medium", size: 12))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(quest.progressCount) / \(quest.targetCount)")
                            .font(.custom("Orbitron-Bold", size: 13).bold())
                            .foregroundColor(profileManager.currentElement.primaryColor)
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(profileManager.currentElement.primaryColor)
                                .frame(width: geo.size.width * CGFloat(quest.progressRatio), height: 8)
                        }
                    }
                    .frame(height: 8)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                // Rewards section
                HStack(spacing: 15) {
                    VStack {
                        Text("XP")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text("+\(quest.rewardXP)")
                            .font(.custom("Orbitron-Bold", size: 14).bold())
                            .foregroundColor(.orange)
                    }
                    VStack {
                        Text("Crystals")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text("+\(quest.rewardCrystals)")
                            .font(.custom("Orbitron-Bold", size: 14).bold())
                            .foregroundColor(.yellow)
                    }
                    VStack {
                        Text("Attribute")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text("+\(quest.statValue) \(statRewardAbbreviation)")
                            .font(.custom("Orbitron-Bold", size: 14).bold())
                            .foregroundColor(.cyan)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.02))
                .cornerRadius(10)
                
                actionSection
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
    
    @ViewBuilder
    private var actionSection: some View {
        if quest.isCompleted {
            Text("Campaign Achieved")
                .font(.custom("Exo2-Bold", size: 14))
                .foregroundColor(.green)
                .padding(.vertical, 8)
        } else if quest.progressCount >= quest.targetCount {
            Button(action: {
                let success = profileManager.completeQuest(quest)
                if success {
                    finalOutcomeText = "Quest complete! You successfully claimed \(quest.rewardXP) XP, \(quest.rewardCrystals) Crystals, and +\(quest.statValue) to \(quest.statReward.rawValue)!"
                    wasSuccessful = true
                    showOutcomeAlert = true
                }
                selectedQuest = nil
            }) {
                Text("CLAIM QUEST REWARDS")
                    .font(.custom("Orbitron-Bold", size: 12).bold())
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.green)
                    )
            }
        } else {
            VStack(spacing: 10) {
                Button(action: {
                    profileManager.logWorkout(category: quest.workoutType)
                    if let idx = getQuestIndex(id: quest.id, cadence: quest.cadence) {
                        selectedQuest = getQuestAt(index: idx, cadence: quest.cadence)
                    }
                }) {
                    HStack {
                        Image(systemName: "pencil.and.outline")
                            .foregroundColor(.white)
                        Text("Log Session Manually")
                            .foregroundColor(.white)
                    }
                    .font(.custom("Orbitron-Bold", size: 12).bold())
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(profileManager.currentElement.primaryColor)
                    )
                }
                
                Button(action: {
                    healthManager.requestAuthorization()
                    healthManager.fetchTodayData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        profileManager.syncQuestsWithHealthData(
                            todaySteps: healthManager.todaySteps,
                            activeMinutes: healthManager.activeMinutes,
                            recentWorkouts: healthManager.recentWorkouts
                        )
                        if let idx = getQuestIndex(id: quest.id, cadence: quest.cadence) {
                            selectedQuest = getQuestAt(index: idx, cadence: quest.cadence)
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "heart.text.square.fill")
                            .foregroundColor(.white)
                        Text("Sync from HealthKit")
                            .foregroundColor(.white)
                    }
                    .font(.custom("Orbitron-Bold", size: 12).bold())
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(profileManager.currentElement.primaryColor, lineWidth: 1.5)
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func getQuestIndex(id: UUID, cadence: QuestCadence) -> Int? {
        switch cadence {
        case .daily: return profileManager.dailyQuests.firstIndex(where: { $0.id == id })
        case .monthly: return profileManager.monthlyQuests.firstIndex(where: { $0.id == id })
        case .yearly: return profileManager.yearlyQuests.firstIndex(where: { $0.id == id })
        }
    }
    
    private func getQuestAt(index: Int, cadence: QuestCadence) -> LotEQuest {
        switch cadence {
        case .daily: return profileManager.dailyQuests[index]
        case .monthly: return profileManager.monthlyQuests[index]
        case .yearly: return profileManager.yearlyQuests[index]
        }
    }
}
