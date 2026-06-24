//
//  SettingsView.swift
//  LotE Workout Companion
//
//  Created by Antigravity on 6/23/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var profileManager: UserProfileManager
    @ObservedObject var healthManager: HealthKitManager
    
    // Sheet presentation triggers
    @State private var showingElementSelect = false
    @State private var showingSpriteCreate = false
    
    // Simulation state values
    @State private var mockSteps: String = "1000"
    @State private var mockCalories: String = "150"
    @State private var mockMinutes: String = "15"
    @State private var showSimulationNotice = false
    
    var body: some View {
        ZStack {
            Color(hex: "#050505")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 22) {
                    // Header
                    VStack(spacing: 6) {
                        Text("ORACLE SYSTEMS PANEL")
                            .font(.custom("Orbitron-Bold", size: 22).bold())
                            .foregroundColor(.white)
                            .tracking(3)
                        
                        Text("Configure interface parameters and objectives")
                            .font(.custom("Exo2-Medium", size: 13))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 25)
                    
                    // Character details form
                    VStack(alignment: .leading, spacing: 15) {
                        Text("IDENTITY CONFIGURATION")
                            .font(.custom("Orbitron-Bold", size: 13).bold())
                            .foregroundColor(.gray)
                            .tracking(2)
                        
                        VStack(spacing: 12) {
                            // Character Name Input
                            VStack(alignment: .leading, spacing: 6) {
                                Text("WARRIOR NAME")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                TextField("Enter Name", text: $profileManager.characterName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .foregroundColor(.black)
                            }
                            
                            // Short Term Goal Input
                            VStack(alignment: .leading, spacing: 6) {
                                Text("SHORT TERM TRAINING GOAL")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                TextField("e.g. 5,000 steps daily", text: $profileManager.shortTermGoal)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .foregroundColor(.black)
                            }
                            
                            // Long Term Goal Input
                            VStack(alignment: .leading, spacing: 6) {
                                Text("LONG TERM TRAINING GOAL")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                TextField("e.g. Run 5k in under 25 mins", text: $profileManager.longTermGoal)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .foregroundColor(.black)
                            }
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
                    
                    // Customize triggers
                    VStack(alignment: .leading, spacing: 14) {
                        Text("SOVEREIGN ADJUSTMENTS")
                            .font(.custom("Orbitron-Bold", size: 13).bold())
                            .foregroundColor(.gray)
                            .tracking(2)
                            .padding(.horizontal)
                        
                        VStack(spacing: 10) {
                            // Element select sheet
                            Button(action: {
                                showingElementSelect = true
                            }) {
                                HStack {
                                    Image(systemName: "flame.fill")
                                        .foregroundColor(profileManager.currentElement.primaryColor)
                                    Text("Tune Element Channels")
                                        .font(.custom("Exo2-Bold", size: 14))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white.opacity(0.02))
                                .cornerRadius(10)
                            }
                            
                            // Character sprite creator sheet
                            Button(action: {
                                showingSpriteCreate = true
                            }) {
                                HStack {
                                    Image(systemName: "person.crop.artframe")
                                        .foregroundColor(profileManager.currentElement.primaryColor)
                                    Text("Re-Forge Character Sprite")
                                        .font(.custom("Exo2-Bold", size: 14))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white.opacity(0.02))
                                .cornerRadius(10)
                            }
                            
                            // Reset psych eval
                            Button(action: {
                                profileManager.hasCompletedInitialQuiz = false
                                profileManager.cognitiveProfile = nil
                            }) {
                                HStack {
                                    Image(systemName: "brain.headprofile")
                                        .foregroundColor(.orange)
                                    Text("Recalibrate Psychological Profile")
                                        .font(.custom("Exo2-Bold", size: 14))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "arrow.counterclockwise")
                                        .foregroundColor(.orange)
                                }
                                .padding()
                                .background(Color.white.opacity(0.02))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Mock Health Simulator (Crucial for test builds)
                    VStack(alignment: .leading, spacing: 14) {
                        Text("SIMULATED ENERGY CORE")
                            .font(.custom("Orbitron-Bold", size: 13).bold())
                            .foregroundColor(.orange)
                            .tracking(2)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            Text("Inject mock workouts/activity loops to test character XP level gains:")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 10) {
                                VStack(alignment: .leading) {
                                    Text("Steps")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                    TextField("", text: $mockSteps)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .foregroundColor(.black)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Calories")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                    TextField("", text: $mockCalories)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .foregroundColor(.black)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Minutes")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                    TextField("", text: $mockMinutes)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Button(action: {
                                runActivitySimulation()
                            }) {
                                Text("INJECT PHYSICAL ACTIVITY")
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
                        .padding()
                        .background(Color.orange.opacity(0.03))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showingElementSelect) {
            ElementSelectionView(profileManager: profileManager)
        }
        .sheet(isPresented: $showingSpriteCreate) {
            CharacterCreatorView(profileManager: profileManager)
        }
        .alert(isPresented: $showSimulationNotice) {
            Alert(
                title: Text("Oracle Sync Complete"),
                message: Text("Successfully injected physical energy: \(mockSteps) steps, \(mockCalories) kcal, \(mockMinutes) mins of exercise time. Recalculated level gains (+100 XP, +30 Crystals)."),
                dismissButton: .default(Text("Acknowledge"))
            )
        }
    }
    
    private func runActivitySimulation() {
        let steps = Double(mockSteps) ?? 1000.0
        let calories = Double(mockCalories) ?? 150.0
        let minutes = Double(mockMinutes) ?? 15.0
        
        healthManager.simulateActivity(steps: steps, calories: calories, minutes: minutes)
        profileManager.addXP(100)
        profileManager.earnCrystals(30)
        
        showSimulationNotice = true
    }
}
