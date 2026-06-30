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
                                    .padding(10)
                                    .background(Color.white.opacity(0.04))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            }
                            
                            // Home Planet Input
                            VStack(alignment: .leading, spacing: 6) {
                                Text("HOME PLANET")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                TextField("Enter Home Planet", text: $profileManager.homePlanet)
                                    .padding(10)
                                    .background(Color.white.opacity(0.04))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
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
                    
                    // Training Focuses Card
                    VStack(alignment: .leading, spacing: 15) {
                        Text("TRAINING GOALS & FOCUSES")
                            .font(.custom("Orbitron-Bold", size: 13).bold())
                            .foregroundColor(.gray)
                            .tracking(2)
                        
                        VStack(spacing: 12) {
                            ForEach(TrainingFocus.allCases, id: \.self) { focus in
                                let isSelected = profileManager.selectedFocuses.contains(focus)
                                Button(action: {
                                    if isSelected {
                                        profileManager.selectedFocuses.removeAll { $0 == focus }
                                    } else {
                                        profileManager.selectedFocuses.append(focus)
                                    }
                                }) {
                                    HStack {
                                        Text(focus.rawValue)
                                            .font(.custom("Exo2-Bold", size: 14))
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(isSelected ? profileManager.currentElement.primaryColor : .gray)
                                    }
                                    .padding(.vertical, 8)
                                }
                                .buttonStyle(PlainButtonStyle())
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
                    
                    // Body Metrics Card
                    VStack(alignment: .leading, spacing: 15) {
                        Text("BODY METRICS TRACKING")
                            .font(.custom("Orbitron-Bold", size: 13).bold())
                            .foregroundColor(.gray)
                            .tracking(2)
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                metricSettingField(label: "HEIGHT (INCHES)", text: doubleBinding(for: \.height))
                                metricSettingField(label: "CURRENT WEIGHT (LBS)", text: doubleBinding(for: \.weight))
                            }
                            
                            HStack(spacing: 12) {
                                metricSettingField(label: "START WEIGHT (LBS)", text: doubleBinding(for: \.startWeight))
                                metricSettingField(label: "GOAL WEIGHT (LBS)", text: doubleBinding(for: \.goalWeight))
                            }
                            
                            HStack(spacing: 12) {
                                metricSettingField(label: "CHEST (INCHES)", text: doubleBinding(for: \.chest))
                                metricSettingField(label: "ARMS (INCHES)", text: doubleBinding(for: \.arms))
                            }
                            
                            HStack(spacing: 12) {
                                metricSettingField(label: "WAIST (INCHES)", text: doubleBinding(for: \.waist))
                                metricSettingField(label: "HIPS (INCHES)", text: doubleBinding(for: \.hips))
                            }
                            
                            HStack(spacing: 12) {
                                metricSettingField(label: "LEGS (INCHES)", text: doubleBinding(for: \.legs))
                                Spacer()
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
                    
                    // Daily Target Goals Card
                    VStack(alignment: .leading, spacing: 15) {
                        Text("DAILY TARGET GOALS")
                            .font(.custom("Orbitron-Bold", size: 13).bold())
                            .foregroundColor(.gray)
                            .tracking(2)
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                metricSettingField(label: "STEPS GOAL", text: doubleBinding(for: \.stepsGoal))
                                metricSettingField(label: "CALORIE GOAL (KCAL)", text: doubleBinding(for: \.caloriesGoal))
                            }
                            HStack(spacing: 12) {
                                metricSettingField(label: "ACTIVE TIME GOAL (MINS)", text: doubleBinding(for: \.activeMinutesGoal))
                                metricSettingField(label: "STAND TIME GOAL (HOURS)", text: doubleBinding(for: \.standHoursGoal))
                            }
                            HStack(spacing: 12) {
                                metricSettingField(label: "DAILY CARDIO GOAL (MILES)", text: doubleBinding(for: \.distanceGoal))
                                Spacer()
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
                    
                    // Sovereign Adjustments Card
                    VStack(alignment: .leading, spacing: 15) {
                        Text("SOVEREIGN ADJUSTMENTS")
                            .font(.custom("Orbitron-Bold", size: 13).bold())
                            .foregroundColor(.gray)
                            .tracking(2)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            // Element Theme Selector Button
                            Button(action: {
                                showingElementSelect = true
                            }) {
                                HStack {
                                    Image(systemName: "flame.fill")
                                        .foregroundColor(profileManager.currentElement.primaryColor)
                                    Text("Choose Element Theme")
                                        .font(.custom("Exo2-Bold", size: 14))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text(profileManager.currentElement.name)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Divider().background(Color.white.opacity(0.1))
                            
                            // Cognitive Profile Picker
                            VStack(alignment: .leading, spacing: 6) {
                                Text("MOTIVATIONAL MINDSET PROFILE")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                
                                Picker("Mindset Profile", selection: Binding(
                                    get: { profileManager.cognitiveProfile ?? .neurotypical },
                                    set: { profileManager.cognitiveProfile = $0 }
                                )) {
                                    ForEach(CognitiveProfile.allCases, id: \.self) { cp in
                                        Text(cp == .neurotypical ? "Neurotypical" : (cp == .adhd ? "ADHD" : (cp == .autistic ? "Autism" : "AuDHD")))
                                            .tag(cp)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.vertical, 4)
                            }
                            
                            Divider().background(Color.white.opacity(0.1))
                            
                            // Notification Frequency Picker
                            VStack(alignment: .leading, spacing: 6) {
                                Text("NOTIFICATION REMINDER FREQUENCY")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                
                                Picker("Notification Frequency", selection: $profileManager.notificationFrequency) {
                                    ForEach(["Off", "Low", "Medium", "High"], id: \.self) { freq in
                                        Text(freq).tag(freq)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.vertical, 4)
                            }
                            
                            Divider().background(Color.white.opacity(0.1))
                            
                            // Character Sprite Reforge Button
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
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(PlainButtonStyle())
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
                            
                            // Reset All Progress
                            Button(action: {
                                profileManager.resetProgress()
                            }) {
                                HStack {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.red)
                                    Text("Reset All Progress (Clean Slate)")
                                        .font(.custom("Exo2-Bold", size: 14))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                }
                                .padding()
                                .background(Color.white.opacity(0.02))
                                .cornerRadius(10)
                            }
                            .padding(.horizontal)
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
        .sheet(isPresented: $showingElementSelect) {
            ElementSelectionView(profileManager: profileManager)
        }
        .sheet(isPresented: $showingSpriteCreate) {
            CharacterCreatorView(profileManager: profileManager)
        }
    }
     
     private func doubleBinding(for keyPath: ReferenceWritableKeyPath<UserProfileManager, Double>) -> Binding<String> {
         Binding<String>(
             get: {
                 let val = profileManager[keyPath: keyPath]
                 return val == 0.0 ? "" : String(format: "%.1f", val)
             },
             set: { newValue in
                 if let doubleVal = Double(newValue) {
                     profileManager[keyPath: keyPath] = doubleVal
                 }
             }
         )
     }
     
     private func metricSettingField(label: String, text: Binding<String>) -> some View {
         VStack(alignment: .leading, spacing: 4) {
             Text(label)
                 .font(.caption2)
                 .foregroundColor(.gray)
             TextField("", text: text)
                 .keyboardType(.decimalPad)
                 .padding(10)
                 .background(Color.white.opacity(0.04))
                 .cornerRadius(8)
                 .foregroundColor(.white)
                 .overlay(
                     RoundedRectangle(cornerRadius: 8)
                         .stroke(Color.white.opacity(0.1), lineWidth: 1)
                 )
         }
     }
}
