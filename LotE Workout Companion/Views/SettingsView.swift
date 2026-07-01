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
    @State private var showingResetConfirmation = false
    
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
                                metricSettingField(label: profileManager.useImperialUnits ? "HEIGHT (IN)" : "HEIGHT (CM)", text: doubleBinding(for: \.height))
                                metricSettingField(label: profileManager.useImperialUnits ? "CURRENT WEIGHT (LBS)" : "CURRENT WEIGHT (KG)", text: doubleBinding(for: \.weight))
                            }
                            
                            HStack(spacing: 12) {
                                metricSettingField(label: profileManager.useImperialUnits ? "START WEIGHT (LBS)" : "START WEIGHT (KG)", text: doubleBinding(for: \.startWeight))
                                metricSettingField(label: profileManager.useImperialUnits ? "GOAL WEIGHT (LBS)" : "GOAL WEIGHT (KG)", text: doubleBinding(for: \.goalWeight))
                            }
                            
                            HStack(spacing: 12) {
                                metricSettingField(label: profileManager.useImperialUnits ? "CHEST (IN)" : "CHEST (CM)", text: doubleBinding(for: \.chest))
                                metricSettingField(label: profileManager.useImperialUnits ? "ARMS (IN)" : "ARMS (CM)", text: doubleBinding(for: \.arms))
                            }
                            
                            HStack(spacing: 12) {
                                metricSettingField(label: profileManager.useImperialUnits ? "WAIST (IN)" : "WAIST (CM)", text: doubleBinding(for: \.waist))
                                metricSettingField(label: profileManager.useImperialUnits ? "HIPS (IN)" : "HIPS (CM)", text: doubleBinding(for: \.hips))
                            }
                            
                            HStack(spacing: 12) {
                                metricSettingField(label: profileManager.useImperialUnits ? "LEGS (IN)" : "LEGS (CM)", text: doubleBinding(for: \.legs))
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
                                metricSettingField(label: profileManager.useImperialUnits ? "DAILY CARDIO GOAL (MILES)" : "DAILY CARDIO GOAL (KM)", text: doubleBinding(for: \.distanceGoal))
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
                    
                    // Feast & Bio-Fuel Targets Card
                    VStack(alignment: .leading, spacing: 15) {
                        Text("FEAST & BIO-FUEL TELEMETRY GOALS")
                            .font(.custom("Orbitron-Bold", size: 13).bold())
                            .foregroundColor(.gray)
                            .tracking(2)
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                metricSettingField(label: "CALORIE INTAKE (KCAL)", text: doubleBinding(for: \.targetCalories))
                                metricSettingField(label: "PROTEIN TARGET (G)", text: doubleBinding(for: \.targetProtein))
                            }
                            HStack(spacing: 12) {
                                metricSettingField(label: "CARBS TARGET (G)", text: doubleBinding(for: \.targetCarbs))
                                metricSettingField(label: "FATS TARGET (G)", text: doubleBinding(for: \.targetFats))
                            }
                            HStack(spacing: 12) {
                                metricSettingField(label: "SUGAR LIMIT (G)", text: doubleBinding(for: \.targetSugar))
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
                    
                    // Personal Records (PRs) Card
                    VStack(alignment: .leading, spacing: 15) {
                        Text("WARRIOR PERSONAL RECORDS (PRs)")
                            .font(.custom("Orbitron-Bold", size: 13).bold())
                            .foregroundColor(.gray)
                            .tracking(2)
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                metricSettingField(label: "PULLUPS PR (REPS)", text: prBinding(forKey: "Pullups"))
                                metricSettingField(label: "PUSHUPS PR (REPS)", text: prBinding(forKey: "Pushups"))
                            }
                            HStack(spacing: 12) {
                                metricSettingField(label: "SQUATS PR (REPS)", text: prBinding(forKey: "Squats"))
                                metricSettingField(label: "DIPS PR (REPS)", text: prBinding(forKey: "Dips"))
                            }
                            HStack(spacing: 12) {
                                metricSettingField(label: profileManager.useImperialUnits ? "RUN PR (MILES)" : "RUN PR (KM)", text: prCardioBinding(forKey: "Run (Miles)"))
                                metricSettingField(label: "HANDSTAND HOLD (SEC)", text: prBinding(forKey: "Handstand Hold (Sec)"))
                            }
                            HStack(spacing: 12) {
                                metricSettingField(label: profileManager.useImperialUnits ? "BENCH PRESS (LBS)" : "BENCH PRESS (KG)", text: prWeightBinding(forKey: "Bench Press"))
                                metricSettingField(label: profileManager.useImperialUnits ? "DEADLIFT (LBS)" : "DEADLIFT (KG)", text: prWeightBinding(forKey: "Deadlift"))
                            }
                            HStack(spacing: 12) {
                                metricSettingField(label: profileManager.useImperialUnits ? "BARBELL SQUAT (LBS)" : "BARBELL SQUAT (KG)", text: prWeightBinding(forKey: "Barbell Squat"))
                                metricSettingField(label: profileManager.useImperialUnits ? "OVERHEAD PRESS (LBS)" : "OVERHEAD PRESS (KG)", text: prWeightBinding(forKey: "Overhead Press"))
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
                             
                             // Unit System Selector
                             VStack(alignment: .leading, spacing: 6) {
                                 Text("SYSTEM MEASUREMENT UNITS")
                                     .font(.caption2)
                                     .foregroundColor(.gray)
                                 
                                 Picker("Measurement Units", selection: $profileManager.useImperialUnits) {
                                     Text("Metric (Liters, KG, CM)").tag(false)
                                     Text("Imperial (Ounces, LBS, IN)").tag(true)
                                 }
                                 .pickerStyle(SegmentedPickerStyle())
                                 .padding(.vertical, 4)
                             }
                             
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
                                showingResetConfirmation = true
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
         .alert(isPresented: $showingResetConfirmation) {
             Alert(
                 title: Text("RESET ALL PROGRESS?"),
                 message: Text("This will permanently erase all your stats, character customizations, logged workouts, and level progress. This action cannot be undone."),
                 primaryButton: .destructive(Text("RESET EVERYTHING")) {
                     profileManager.resetProgress()
                 },
                 secondaryButton: .cancel()
             )
         }
    }
     
     private func doubleBinding(for keyPath: ReferenceWritableKeyPath<UserProfileManager, Double>) -> Binding<String> {
         Binding<String>(
             get: {
                 var val = profileManager[keyPath: keyPath]
                 if !profileManager.useImperialUnits {
                     if keyPath == \.weight || keyPath == \.startWeight || keyPath == \.goalWeight {
                         val = val * 0.45359237
                     } else if keyPath == \.distanceGoal {
                         val = val * 1.609344
                     } else if keyPath == \.height || keyPath == \.chest || keyPath == \.arms || keyPath == \.waist || keyPath == \.hips || keyPath == \.legs {
                         val = val * 2.54
                     }
                 }
                 return val == 0.0 ? "" : String(format: "%.1f", val)
             },
             set: { newValue in
                 if var doubleVal = Double(newValue) {
                     if !profileManager.useImperialUnits {
                         if keyPath == \.weight || keyPath == \.startWeight || keyPath == \.goalWeight {
                             doubleVal = doubleVal / 0.45359237
                         } else if keyPath == \.distanceGoal {
                             doubleVal = doubleVal / 1.609344
                         } else if keyPath == \.height || keyPath == \.chest || keyPath == \.arms || keyPath == \.waist || keyPath == \.hips || keyPath == \.legs {
                             doubleVal = doubleVal / 2.54
                         }
                     }
                     profileManager[keyPath: keyPath] = doubleVal
                 }
             }
         )
     }
     
     private func prBinding(forKey key: String) -> Binding<String> {
         Binding<String>(
             get: {
                 if let val = profileManager.personalRecords[key] {
                     return String(format: "%.0f", val)
                 }
                 return ""
             },
             set: { newVal in
                 if let doubleVal = Double(newVal) {
                     profileManager.logPR(key: key, value: doubleVal)
                 }
             }
         )
     }
     
     private func prWeightBinding(forKey key: String) -> Binding<String> {
         Binding<String>(
             get: {
                 if var val = profileManager.personalRecords[key] {
                     if !profileManager.useImperialUnits {
                         val = val * 0.45359237
                     }
                     return String(format: "%.0f", val)
                 }
                 return ""
             },
             set: { newVal in
                 if var doubleVal = Double(newVal) {
                     if !profileManager.useImperialUnits {
                         doubleVal = doubleVal / 0.45359237
                     }
                     profileManager.logPR(key: key, value: doubleVal)
                 }
             }
         )
     }
     
     private func prCardioBinding(forKey key: String) -> Binding<String> {
         Binding<String>(
             get: {
                 if var val = profileManager.personalRecords[key] {
                     if !profileManager.useImperialUnits {
                         val = val * 1.609344
                     }
                     return String(format: "%.1f", val)
                 }
                 return ""
             },
             set: { newVal in
                 if var doubleVal = Double(newVal) {
                     if !profileManager.useImperialUnits {
                         doubleVal = doubleVal / 1.609344
                     }
                     profileManager.logPR(key: key, value: doubleVal)
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
