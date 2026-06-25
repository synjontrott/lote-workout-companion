//
//  PsychEvaluationView.swift
//  LotE Workout Companion
//
//  Created by Antigravity on 6/23/26.
//

import SwiftUI

struct PsychQuestion {
    let text: String
    let options: [PsychOption]
}

struct PsychOption {
    let text: String
    let adhdWeight: Int
    let autisticWeight: Int
    let audhdWeight: Int
    let ntWeight: Int
}

struct PsychEvaluationView: View {
    @ObservedObject var profileManager: UserProfileManager
    @State private var currentQuestionIndex: Int = 0
    @State private var answers: [Int] = [] // Index of option chosen per question
    
    // Accumulators for profiling
    @State private var adhdScore = 0
    @State private var autisticScore = 0
    @State private var audhdScore = 0
    @State private var ntScore = 0
    @State private var evaluationComplete = false
    @State private var calculatedProfile: CognitiveProfile = .neurotypical
    
    // Multi-step onboarding phases after evaluation
    @State private var onboardingStep = 0
    @State private var tempSelectedFocuses: Set<TrainingFocus> = [.calisthenics, .cardio, .cutting]
    @State private var inputHeight: String = "70.0"
    @State private var inputWeight: String = "160.0"
    @State private var inputChest: String = "38.0"
    @State private var inputArms: String = "13.0"
    @State private var inputWaist: String = "32.0"
    @State private var inputHips: String = "40.0"
    @State private var inputLegs: String = "22.0"
    
    let questions: [PsychQuestion] = [
        PsychQuestion(text: "How do you feel about long-term workout routines?", options: [
            PsychOption(text: "I thrive when I have a fixed, structured schedule that repeats exactly every week.", adhdWeight: 0, autisticWeight: 3, audhdWeight: 1, ntWeight: 1),
            PsychOption(text: "I need constant variety. Repeating the same workout twice makes me lose focus immediately.", adhdWeight: 3, autisticWeight: 0, audhdWeight: 1, ntWeight: 0),
            PsychOption(text: "I like having a structured schedule, but I need flexible wildcard options within it to stay motivated.", adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 1),
            PsychOption(text: "A standard, progressive routine works well for me to build healthy habits.", adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3)
        ]),
        PsychQuestion(text: "When starting a workout, what is your biggest executive barrier?", options: [
            PsychOption(text: "Starting is incredibly hard unless there is immediate novelty or a high-energy reward.", adhdWeight: 3, autisticWeight: 0, audhdWeight: 2, ntWeight: 0),
            PsychOption(text: "Any unexpected disruption in my day's timeline completely derails my training momentum.", adhdWeight: 0, autisticWeight: 3, audhdWeight: 1, ntWeight: 0),
            PsychOption(text: "I get overwhelmed by choices, but I also push back when I feel 'forced' to follow a rigid script.", adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 0),
            PsychOption(text: "Just building the regular habit and pushing through the initial resistance.", adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3)
        ]),
        PsychQuestion(text: "How do you prefer to review your fitness achievements?", options: [
            PsychOption(text: "Detailed graphs, precise calorie and step counts, and complete database logs.", adhdWeight: 0, autisticWeight: 3, audhdWeight: 1, ntWeight: 1),
            PsychOption(text: "Gamified level-ups, crystal drops, virtual dice rolls, and custom pixel-art rewards.", adhdWeight: 3, autisticWeight: 0, audhdWeight: 1, ntWeight: 0),
            PsychOption(text: "A hybrid: detailed analytics for security, but game-like drops to keep things exciting.", adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 1),
            PsychOption(text: "Simple daily streaks and progressive, long-term milestones.", adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3)
        ]),
        PsychQuestion(text: "How does the training environment's sensory layout affect you?", options: [
            PsychOption(text: "Loud music, bright lights, or crowds easily exhaust me. I need a controlled, quiet space.", adhdWeight: 0, autisticWeight: 3, audhdWeight: 2, ntWeight: 0),
            PsychOption(text: "I get under-stimulated. I need high-energy music, podcasts, or screens to distract my mind.", adhdWeight: 3, autisticWeight: 0, audhdWeight: 1, ntWeight: 1),
            PsychOption(text: "I need active stimulation (music) but easily get overloaded if the environment is chaotic.", adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 0),
            PsychOption(text: "I can tune out gym noise and focus on my workout without much issue.", adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3)
        ]),
        PsychQuestion(text: "What style of workout instruction works best for you?", options: [
            PsychOption(text: "Literal, direct, step-by-step guides with logical explanations of the biology/science.", adhdWeight: 0, autisticWeight: 3, audhdWeight: 1, ntWeight: 1),
            PsychOption(text: "Story-driven roleplaying quests where my exercise represents patrolling or battling beasties.", adhdWeight: 3, autisticWeight: 0, audhdWeight: 2, ntWeight: 0),
            PsychOption(text: "Clear options where I have autonomy to pick between 3 distinct paths.", adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 1),
            PsychOption(text: "Practical guides that display correct form and progressive difficulty reps.", adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3)
        ]),
        PsychQuestion(text: "What happens when you miss a planned training day?", options: [
            PsychOption(text: "I feel intense distress or guilt. The routine is broken, and it's very hard to restart.", adhdWeight: 0, autisticWeight: 3, audhdWeight: 2, ntWeight: 0),
            PsychOption(text: "I completely lose track of the goal and get swept up in a new, hyper-focused interest.", adhdWeight: 3, autisticWeight: 0, audhdWeight: 1, ntWeight: 0),
            PsychOption(text: "I experience rule-break anxiety but also struggle to re-engage due to executive burnout.", adhdWeight: 1, autisticWeight: 2, audhdWeight: 3, ntWeight: 0),
            PsychOption(text: "I view it as a minor setback and aim to stack the habit back up tomorrow.", adhdWeight: 0, autisticWeight: 0, audhdWeight: 0, ntWeight: 3)
        ]),
        PsychQuestion(text: "How do you approach your daily dietary habits?", options: [
            PsychOption(text: "I eat the same comfortable, predictable meals regularly (comfortable safe foods).", adhdWeight: 0, autisticWeight: 3, audhdWeight: 2, ntWeight: 0),
            PsychOption(text: "I crave intense variety in flavors, textures, and spices. Repetitive food bores me.", adhdWeight: 3, autisticWeight: 0, audhdWeight: 1, ntWeight: 1),
            PsychOption(text: "I have standard safe foods, but I occasionally need highly intense spice/sensory variety.", adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 0),
            PsychOption(text: "I plan my meals based on balanced, standard nutritional guidelines.", adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3)
        ]),
        PsychQuestion(text: "When exercising, how does your attention flow operate?", options: [
            PsychOption(text: "I hyper-focus on my movement, count, or metrics, completely zoning out external sounds.", adhdWeight: 1, autisticWeight: 3, audhdWeight: 2, ntWeight: 1),
            PsychOption(text: "My mind drifts constantly. I need to be playing mental games or listening to engaging podcasts.", adhdWeight: 3, autisticWeight: 0, audhdWeight: 1, ntWeight: 0),
            PsychOption(text: "My focus shifts rapidly unless I am in a state of high interest or gamified pressure.", adhdWeight: 2, autisticWeight: 1, audhdWeight: 3, ntWeight: 0),
            PsychOption(text: "I maintain steady, standard focus on finishing my workout sets.", adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3)
        ]),
        PsychQuestion(text: "How do you manage short and long-term goal setting?", options: [
            PsychOption(text: "I need a structured, long-term path clearly detailed with timelines and checklists.", adhdWeight: 0, autisticWeight: 3, audhdWeight: 1, ntWeight: 1),
            PsychOption(text: "I need immediate micro-goals (what I'm doing in the next 5 minutes) or I lose interest.", adhdWeight: 3, autisticWeight: 0, audhdWeight: 2, ntWeight: 0),
            PsychOption(text: "I need structured goals, but they must be modular so I can swap them based on my daily energy.", adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 1),
            PsychOption(text: "I work best with classic monthly targets and simple habits.", adhdWeight: 0, autisticWeight: 1, audhdWeight: 0, ntWeight: 3)
        ]),
        PsychQuestion(text: "How do you react to sudden, unexpected changes in your environment?", options: [
            PsychOption(text: "I feel very stressed. I need preparation time, warnings, and direct routines.", adhdWeight: 0, autisticWeight: 3, audhdWeight: 2, ntWeight: 0),
            PsychOption(text: "I welcome changes; they provide a stimulating sensory reboot.", adhdWeight: 3, autisticWeight: 0, audhdWeight: 1, ntWeight: 1),
            PsychOption(text: "It triggers demand avoidance, but I can adapt if I am given autonomy over options.", adhdWeight: 1, autisticWeight: 1, audhdWeight: 3, ntWeight: 0),
            PsychOption(text: "I adjust relatively easily without major cognitive stress.", adhdWeight: 0, autisticWeight: 0, audhdWeight: 0, ntWeight: 3)
        ])
    ]
    
    @ViewBuilder
    private var ambientGlows: some View {
        VStack {
            HStack {
                Circle()
                    .fill(Color(hex: "#FF1616")!.opacity(0.12))
                    .frame(width: 250, height: 250)
                    .blur(radius: 80)
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                Circle()
                    .fill(Color(hex: "#3F51B5")!.opacity(0.12))
                    .frame(width: 300, height: 300)
                    .blur(radius: 90)
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private var quizContent: some View {
        VStack(spacing: 25) {
            // Title / Header
            VStack(spacing: 8) {
                Text("SOVEREIGN ARCHETYPE TEST")
                    .font(.custom("Orbitron-Bold", size: 22).bold())
                    .foregroundColor(.white)
                    .tracking(3)
                    .multilineTextAlignment(.center)
                
                Text("Phase 1: Cognitive Fitness Evaluation")
                    .font(.custom("Exo2-Medium", size: 14))
                    .foregroundColor(Color(hex: "#FF1616") ?? .red)
                    .tracking(1)
                
                // Progress bar
                ProgressView(value: Double(currentQuestionIndex), total: Double(questions.count))
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "#FF1616") ?? .red))
                    .padding(.horizontal, 40)
                    .padding(.top, 5)
            }
            .padding(.top, 40)
            
            // Question Card
            VStack(spacing: 20) {
                Text("QUESTION \(currentQuestionIndex + 1) OF \(questions.count)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .tracking(2)
                
                Text(questions[currentQuestionIndex].text)
                    .font(.custom("Exo2-Bold", size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(spacing: 12) {
                    ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { idx in
                        let option = questions[currentQuestionIndex].options[idx]
                        Button(action: {
                            selectOption(idx)
                        }) {
                            HStack {
                                Text(option.text)
                                    .font(.custom("Exo2-Regular", size: 14))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.red)
                                    .font(.footnote)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.04))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top, 10)
            }
            .padding(25)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.02))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(hex: "#FF1616")!.opacity(0.2), lineWidth: 1.5)
                    )
            )
            .padding(.horizontal, 20)
            
            // Back Button
            if currentQuestionIndex > 0 {
                Button(action: {
                    goBack()
                }) {
                    Text("Go Back")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .underline()
                }
            }
        }
    }
    
    @ViewBuilder
    private var revealScreen: some View {
        VStack(spacing: 30) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "#FF1616"))
                .shadow(color: Color(hex: "#FF1616")!, radius: 10)
                .padding(.top, 45)
            
            VStack(spacing: 8) {
                Text("DESTINY AWAKENED")
                    .font(.custom("Orbitron-Bold", size: 26).bold())
                    .foregroundColor(.white)
                    .tracking(5)
                
                Text("Your elemental mind type is calibrated.")
                    .font(.custom("Exo2-Regular", size: 15))
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                Text(calculatedProfile.title)
                    .font(.custom("Orbitron-Bold", size: 20).bold())
                    .foregroundColor(Color(hex: "#FF1616"))
                    .tracking(2)
                
                Text(calculatedProfile.description)
                    .font(.custom("Exo2-Regular", size: 15))
                    .foregroundColor(.white.opacity(0.85))
                    .lineSpacing(6)
            }
            .padding(25)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.03))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(hex: "#FF1616")!.opacity(0.3), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 20)
            
            Button(action: {
                withAnimation {
                    onboardingStep = 1
                }
            }) {
                Text("CONTINUE TO GOALS")
                    .font(.custom("Orbitron-Bold", size: 16).bold())
                    .foregroundColor(.white)
                    .tracking(2)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#FF1616")!)
                            .shadow(color: Color(hex: "#FF1616")!.opacity(0.4), radius: 8)
                    )
            }
            .padding(.top, 10)
        }
    }
    
    @ViewBuilder
    private var focusSelectionScreen: some View {
        VStack(spacing: 30) {
            VStack(spacing: 8) {
                Text("TRAINING FOCUSES")
                    .font(.custom("Orbitron-Bold", size: 24).bold())
                    .foregroundColor(.white)
                    .tracking(4)
                    .padding(.top, 40)
                
                Text("Select your primary training focus objectives.")
                    .font(.custom("Exo2-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 12) {
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
                            VStack(alignment: .leading, spacing: 4) {
                                Text(focus.rawValue)
                                    .font(.custom("Exo2-Bold", size: 16))
                                    .foregroundColor(.white)
                                
                                let desc: String = {
                                    switch focus {
                                    case .calisthenics: return "Gravity-defying pull-ups, push-ups, and dips."
                                    case .lifting: return "Forge raw muscle with squat, bench, and deadlifts."
                                    case .bulking: return "Build structural mass and dense weight support."
                                    case .cutting: return "Deficit conditioning to burn off excess layers."
                                    case .flexibility: return "Flexible joint flow and muscle lengthening."
                                    case .cardio: return "Conditioning, endurance walks, and swift runs."
                                    }
                                }()
                                Text(desc)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(isSelected ? Color(hex: "#FF1616") : .gray)
                                .font(.title3)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isSelected ? Color(hex: "#FF1616")!.opacity(0.08) : Color.white.opacity(0.02))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(isSelected ? Color(hex: "#FF1616")! : Color.white.opacity(0.1), lineWidth: isSelected ? 1.5 : 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            
            Button(action: {
                withAnimation {
                    onboardingStep = 2
                }
            }) {
                Text("CONTINUE TO METRICS")
                    .font(.custom("Orbitron-Bold", size: 16).bold())
                    .foregroundColor(.white)
                    .tracking(2)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#FF1616")!)
                            .shadow(color: Color(hex: "#FF1616")!.opacity(0.4), radius: 8)
                    )
            }
            .disabled(tempSelectedFocuses.isEmpty)
            .opacity(tempSelectedFocuses.isEmpty ? 0.5 : 1.0)
        }
    }
    
    @ViewBuilder
    private var metricsScreen: some View {
        VStack(spacing: 30) {
            VStack(spacing: 8) {
                Text("INITIAL BODY METRICS")
                    .font(.custom("Orbitron-Bold", size: 24).bold())
                    .foregroundColor(.white)
                    .tracking(4)
                    .padding(.top, 40)
                
                Text("Input your starting numbers to log precise progress.")
                    .font(.custom("Exo2-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            
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
            
            Button(action: {
                confirmProfile()
            }) {
                Text("COMMENCE TRAINING")
                    .font(.custom("Orbitron-Bold", size: 16).bold())
                    .foregroundColor(.white)
                    .tracking(2)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#FF1616")!)
                            .shadow(color: Color(hex: "#FF1616")!.opacity(0.4), radius: 8)
                    )
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Dark futuristic background
            Color(hex: "#050505")
                .ignoresSafeArea()
            
            // Subtle ambient glows
            ambientGlows
            
            ScrollView {
                VStack(spacing: 25) {
                    if !evaluationComplete {
                        quizContent
                    } else {
                        if onboardingStep == 0 {
                            revealScreen
                        } else if onboardingStep == 1 {
                            focusSelectionScreen
                        } else {
                            metricsScreen
                        }
                    }
                }
                .padding(.bottom, 40)
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
    }
    // MARK: - Metric Input Component Helper
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
    
    // MARK: - Quiz Logic
    private func selectOption(_ index: Int) {
        answers.append(index)
        let option = questions[currentQuestionIndex].options[index]
        
        // Sum weights
        adhdScore += option.adhdWeight
        autisticScore += option.autisticWeight
        audhdScore += option.audhdWeight
        ntScore += option.ntWeight
        
        if currentQuestionIndex < questions.count - 1 {
            withAnimation(.easeInOut) {
                currentQuestionIndex += 1
            }
        } else {
            calculateProfileResult()
        }
    }
    
    private func goBack() {
        guard !answers.isEmpty else { return }
        let lastAnswerIndex = answers.removeLast()
        let option = questions[currentQuestionIndex - 1].options[lastAnswerIndex]
        
        // Subtract weights
        adhdScore -= option.adhdWeight
        autisticScore -= option.autisticWeight
        audhdScore -= option.audhdWeight
        ntScore -= option.ntWeight
        
        withAnimation(.easeInOut) {
            currentQuestionIndex -= 1
        }
    }
    
    private func calculateProfileResult() {
        // Find highest weight
        let maxWeight = max(adhdScore, autisticScore, audhdScore, ntScore)
        
        if maxWeight == adhdScore {
            calculatedProfile = .adhd
        } else if maxWeight == autisticScore {
            calculatedProfile = .autistic
        } else if maxWeight == audhdScore {
            calculatedProfile = .audhd
        } else {
            calculatedProfile = .neurotypical
        }
        
        // If ADHD and Autistic are both very high, defaults to AuDHD
        if adhdScore > 10 && autisticScore > 10 {
            calculatedProfile = .audhd
        }
        
        withAnimation(.easeInOut) {
            evaluationComplete = true
        }
    }
    
    private func confirmProfile() {
        profileManager.cognitiveProfile = calculatedProfile
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
