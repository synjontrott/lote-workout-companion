import SwiftUI

struct PsychEvaluationView: View {
    @ObservedObject var profileManager: UserProfileManager
    
    // Onboarding Steps:
    // 0: Identity (Name, Planet, Element Theme)
    // 1: Mindset (Motivational Profile, Training Focuses)
    // 2: Vessel (Body Metrics)
    @State private var onboardingStep = 0
    
    // Step 0 states
    @State private var tempName: String = "Warrior"
    @State private var tempPlanet: String = "Warrion"
    @State private var tempElementIdx: Int = 0
    
    // Step 1 states
    @State private var selectedProfile: CognitiveProfile = .neurotypical
    @State private var tempSelectedFocuses: Set<TrainingFocus> = [.calisthenics, .cardio, .cutting]
    
    // Step 2 states
    @State private var inputHeight: String = "70.0"
    @State private var inputWeight: String = "160.0"
    @State private var inputChest: String = "38.0"
    @State private var inputArms: String = "13.0"
    @State private var inputWaist: String = "32.0"
    @State private var inputHips: String = "40.0"
    @State private var inputLegs: String = "22.0"

    private let profileTypes: [CognitiveProfile] = [.neurotypical, .adhd, .autistic, .audhd]

    @ViewBuilder
    private var ambientGlows: some View {
        let accentColor = UserProfileManager.availableElements[tempElementIdx].primaryColor
        VStack {
            HStack {
                Circle()
                    .fill(accentColor.opacity(0.15))
                    .frame(width: 250, height: 250)
                    .blur(radius: 80)
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                Circle()
                    .fill(Color.purple.opacity(0.12))
                    .frame(width: 300, height: 300)
                    .blur(radius: 90)
            }
        }
        .ignoresSafeArea()
    }

    var body: some View {
        ZStack {
            Color(hex: "#020617")!
                .ignoresSafeArea()
            
            ambientGlows
            
            VStack {
                // Header Progress Indicator
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { step in
                        Circle()
                            .fill(step <= onboardingStep ? UserProfileManager.availableElements[tempElementIdx].primaryColor : Color.white.opacity(0.15))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 25) {
                        if onboardingStep == 0 {
                            identityScreen
                        } else if onboardingStep == 1 {
                            mindsetScreen
                        } else {
                            vesselScreen
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
    }

    // MARK: - Step 0: Identity Screen
    private var identityScreen: some View {
        let themeColor = UserProfileManager.availableElements[tempElementIdx].primaryColor
        return VStack(spacing: 24) {
            VStack(spacing: 6) {
                Text("WARRIOR ORIGINS")
                    .font(.custom("Orbitron-Bold", size: 22).bold())
                    .foregroundColor(.white)
                    .tracking(3)
                Text("Phase 1: Define your name, planet, and element alignment")
                    .font(.custom("Exo2-Medium", size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 16) {
                // Name
                VStack(alignment: .leading, spacing: 6) {
                    Text("CHARACTER NAME")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .tracking(1)
                    TextField("Enter Name", text: $tempName)
                        .padding(12)
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .font(.custom("Orbitron-Bold", size: 14))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
                }
                
                // Planet
                VStack(alignment: .leading, spacing: 6) {
                    Text("HOME PLANET")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .tracking(1)
                    TextField("Enter Planet", text: $tempPlanet)
                        .padding(12)
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .font(.custom("Orbitron-Bold", size: 14))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
                }
            }
            .padding(.horizontal, 20)
            
            // Element Alignments
            VStack(alignment: .leading, spacing: 12) {
                Text("SELECT ELEMENTAL ALIGNMENT")
                    .font(.custom("Orbitron-Bold", size: 12).bold())
                    .foregroundColor(.gray)
                    .tracking(2)
                    .padding(.horizontal, 20)
                
                ForEach(0..<UserProfileManager.availableElements.count, id: \.self) { idx in
                    let el = UserProfileManager.availableElements[idx]
                    let isSelected = tempElementIdx == idx
                    let elIcon: String = {
                        switch el.name {
                        case "Fire": return "🔥"
                        case "Water": return "💧"
                        case "Earth": return "🪨"
                        case "Air": return "💨"
                        default: return "✨"
                        }
                    }()
                    Button(action: {
                        withAnimation {
                            tempElementIdx = idx
                        }
                    }) {
                        HStack(spacing: 12) {
                            Text(elIcon)
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(el.name.uppercased())
                                    .font(.custom("Orbitron-Bold", size: 14).bold())
                                    .foregroundColor(.white)
                                Text(el.description)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                                .foregroundColor(isSelected ? el.primaryColor : .gray)
                        }
                        .padding()
                        .background(Color.white.opacity(isSelected ? 0.08 : 0.02))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? el.primaryColor.opacity(0.4) : Color.white.opacity(0.05), lineWidth: 1.5)
                        )
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            Button(action: {
                withAnimation {
                    onboardingStep = 1
                }
            }) {
                Text("NEXT PHASE")
                    .font(.custom("Orbitron-Bold", size: 14).bold())
                    .foregroundColor(.black)
                    .tracking(2)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(themeColor)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }

    // MARK: - Step 1: Mindset Screen
    private var mindsetScreen: some View {
        let themeColor = UserProfileManager.availableElements[tempElementIdx].primaryColor
        return VStack(spacing: 24) {
            VStack(spacing: 6) {
                Text("COGNITIVE ARCHETYPE")
                    .font(.custom("Orbitron-Bold", size: 22).bold())
                    .foregroundColor(.white)
                    .tracking(3)
                Text("Phase 2: Select motivational mindset & targets")
                    .font(.custom("Exo2-Medium", size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.top, 10)
            
            // Profiles Choice
            VStack(alignment: .leading, spacing: 12) {
                Text("CHOOSE MOTIVATIONAL MINDSET")
                    .font(.custom("Orbitron-Bold", size: 12).bold())
                    .foregroundColor(.gray)
                    .tracking(2)
                    .padding(.horizontal, 20)
                
                ForEach(profileTypes, id: \.self) { cp in
                    let isSelected = selectedProfile == cp
                    Button(action: {
                        withAnimation {
                            selectedProfile = cp
                        }
                    }) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(cp == .neurotypical ? "Neurotypical" : (cp == .adhd ? "ADHD" : (cp == .autistic ? "Autism" : "AuDHD")))
                                    .font(.custom("Orbitron-Bold", size: 14).bold())
                                    .foregroundColor(.white)
                                Spacer()
                                Text(cp.title)
                                    .font(.caption2)
                                    .foregroundColor(themeColor)
                                    .tracking(1)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(themeColor.opacity(0.12))
                                    .cornerRadius(4)
                            }
                            Text(cp.description)
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(2)
                        }
                        .padding()
                        .background(Color.white.opacity(isSelected ? 0.08 : 0.02))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? themeColor.opacity(0.4) : Color.white.opacity(0.05), lineWidth: 1.5)
                        )
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            // Focuses Selector
            VStack(alignment: .leading, spacing: 12) {
                Text("SELECT TRAINING OBJECTIVES")
                    .font(.custom("Orbitron-Bold", size: 12).bold())
                    .foregroundColor(.gray)
                    .tracking(2)
                    .padding(.horizontal, 20)
                
                ForEach(TrainingFocus.allCases, id: \.self) { focus in
                    let isSelected = tempSelectedFocuses.contains(focus)
                    Button(action: {
                        if isSelected {
                            tempSelectedFocuses.remove(focus)
                        } else {
                            tempSelectedFocuses.insert(focus)
                        }
                    }) {
                        HStack {
                            Text(focus.rawValue)
                                .font(.custom("Exo2-Bold", size: 14))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(isSelected ? themeColor : .gray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.02))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(isSelected ? themeColor.opacity(0.3) : Color.white.opacity(0.05), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            HStack(spacing: 12) {
                Button(action: {
                    withAnimation {
                        onboardingStep = 0
                    }
                }) {
                    Text("BACK")
                        .font(.custom("Orbitron-Bold", size: 14).bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.2), lineWidth: 1))
                }
                
                Button(action: {
                    withAnimation {
                        onboardingStep = 2
                    }
                }) {
                    Text("NEXT PHASE")
                        .font(.custom("Orbitron-Bold", size: 14).bold())
                        .foregroundColor(.black)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(themeColor))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }

    // MARK: - Step 2: Vessel Screen
    private var vesselScreen: some View {
        let themeColor = UserProfileManager.availableElements[tempElementIdx].primaryColor
        return VStack(spacing: 24) {
            VStack(spacing: 6) {
                Text("THE PHYSICAL VESSEL")
                    .font(.custom("Orbitron-Bold", size: 22).bold())
                    .foregroundColor(.white)
                    .tracking(3)
                Text("Phase 3: Input initial body metrics to track progress")
                    .font(.custom("Exo2-Medium", size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.top, 10)
            
            VStack(spacing: 16) {
                HStack(spacing: 15) {
                    metricInputField(label: "HEIGHT (INCHES)", text: $inputHeight)
                    metricInputField(label: "WEIGHT (LBS)", text: $inputWeight)
                }
                
                HStack(spacing: 15) {
                    metricInputField(label: "CHEST (INCHES)", text: $inputChest)
                    metricInputField(label: "ARMS (INCHES)", text: $inputArms)
                }
                
                HStack(spacing: 15) {
                    metricInputField(label: "WAIST (INCHES)", text: $inputWaist)
                    metricInputField(label: "HIPS (INCHES)", text: $inputHips)
                }
                
                metricInputField(label: "LEGS (INCHES)", text: $inputLegs)
            }
            .padding(.horizontal, 20)
            
            HStack(spacing: 12) {
                Button(action: {
                    withAnimation {
                        onboardingStep = 1
                    }
                }) {
                    Text("BACK")
                        .font(.custom("Orbitron-Bold", size: 14).bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.2), lineWidth: 1))
                }
                
                Button(action: {
                    confirmProfile()
                }) {
                    Text("COMMENCE TRAINING")
                        .font(.custom("Orbitron-Bold", size: 14).bold())
                        .foregroundColor(.black)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(themeColor))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }

    private func metricInputField(label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
                .tracking(1)
            
            TextField("", text: text)
                .keyboardType(.decimalPad)
                .padding(12)
                .background(Color.white.opacity(0.03))
                .cornerRadius(10)
                .foregroundColor(.white)
                .font(.custom("Orbitron-Bold", size: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        }
    }

    private func confirmProfile() {
        profileManager.characterName = tempName
        profileManager.homePlanet = tempPlanet
        profileManager.selectedElementIndex = tempElementIdx
        profileManager.cognitiveProfile = selectedProfile
        profileManager.selectedFocuses = Array(tempSelectedFocuses)
        profileManager.height = Double(inputHeight) ?? 70.0
        profileManager.weight = Double(inputWeight) ?? 160.0
        profileManager.chest = Double(inputChest) ?? 38.0
        profileManager.arms = Double(inputArms) ?? 13.0
        profileManager.waist = Double(inputWaist) ?? 32.0
        profileManager.hips = Double(inputHips) ?? 40.0
        profileManager.legs = Double(inputLegs) ?? 22.0
        profileManager.resetProgress()
        profileManager.hasCompletedInitialQuiz = true
    }
}
