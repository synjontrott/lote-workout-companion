import SwiftUI

struct NutritionView: View {
    @ObservedObject var profileManager: UserProfileManager
    @State private var showingMealLog = false
    
    // Dynamic targets
    var calorieTarget: Double { profileManager.targetCalories }
    var proteinTarget: Double { profileManager.targetProtein }
    var carbsTarget: Double { profileManager.targetCarbs }
    var fatsTarget: Double { profileManager.targetFats }
    var sugarLimit: Double { profileManager.targetSugar }
    
    // Helper colors
    var bgColor1: Color { Color(hex: "#090d16") ?? .black }
    var bgColor2: Color { Color(hex: "#020408") ?? .black }
    var modalBgColor: Color { Color(hex: "#0c0c0c") ?? .black }
    
    var todayMeals: [MealEntry] {
        profileManager.loggedMeals.filter { Calendar.current.isDateInToday($0.date) }
    }
    
    var totalCalories: Double { todayMeals.reduce(0) { $0 + $1.calories } }
    var totalProtein: Double { todayMeals.reduce(0) { $0 + $1.protein } }
    var totalCarbs: Double { todayMeals.reduce(0) { $0 + $1.carbs } }
    var totalFats: Double { todayMeals.reduce(0) { $0 + $1.fats } }
    var totalSugar: Double { todayMeals.reduce(0) { $0 + $1.sugar } }
    
    var calorieProgress: CGFloat {
        let pct = totalCalories / calorieTarget
        return CGFloat(min(max(pct, 0.0), 1.0))
    }
    
    var body: some View {
        ZStack {
            // Futuristic dark gradient background
            LinearGradient(
                gradient: Gradient(colors: [bgColor1, bgColor2]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    calorieTelemetryRing
                    
                    fuelSplitCard
                    
                    hydrationCard
                    
                    logRationButton
                    
                    rationsLogList
                }
            }
            
            // Log Meal Overlay Dialog
            if showingMealLog {
                MealLogModalView(
                    profileManager: profileManager,
                    isPresented: $showingMealLog,
                    modalBgColor: modalBgColor
                )
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
    
    // Hydration Panel component
    private var hydrationCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "drop.fill")
                    .foregroundColor(Color(hex: "#00E5FF") ?? .blue)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("HYDRATION TELEMETRY")
                        .font(.custom("Orbitron-Bold", size: 13).bold())
                        .foregroundColor(.white)
                        .tracking(1)
                    Text("Electrolyte & cellular fluid levels")
                        .font(.custom("Exo2-Regular", size: 10))
                        .foregroundColor(.gray)
                }
                Spacer()
                
                HStack(spacing: 8) {
                    Text("Goal:")
                        .font(.custom("Exo2-Bold", size: 11))
                        .foregroundColor(.gray)
                    if profileManager.useImperialUnits {
                        Text(String(format: "%.0f oz", profileManager.waterIntakeGoalOz))
                            .font(.custom("Orbitron-Bold", size: 12))
                            .foregroundColor(.white)
                        
                        Stepper("", value: $profileManager.waterIntakeGoalOz, in: 32.0...320.0, step: 8.0)
                            .labelsHidden()
                            .scaleEffect(0.8)
                    } else {
                        Text(String(format: "%.1f L", profileManager.waterIntakeGoal))
                            .font(.custom("Orbitron-Bold", size: 12))
                            .foregroundColor(.white)
                        
                        Stepper("", value: $profileManager.waterIntakeGoal, in: 1.0...10.0, step: 0.5)
                            .labelsHidden()
                            .scaleEffect(0.8)
                    }
                }
            }
            
            let progress = min(max(profileManager.todayWaterIntake / profileManager.waterIntakeGoal, 0.0), 1.0)
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    if profileManager.useImperialUnits {
                        Text(String(format: "%.0f oz Logged", profileManager.todayWaterIntakeOz))
                            .font(.custom("Exo2-Bold", size: 12))
                            .foregroundColor(.white)
                    } else {
                        Text(String(format: "%.2f Liters Logged", profileManager.todayWaterIntake))
                            .font(.custom("Exo2-Bold", size: 12))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text(String(format: "%.0f%%", progress * 100))
                        .font(.custom("Orbitron-Bold", size: 12))
                        .foregroundColor(Color(hex: "#00E5FF") ?? .cyan)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.08))
                            .frame(height: 8)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#00A3FF") ?? .blue, Color(hex: "#00E5FF") ?? .cyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * CGFloat(progress), height: 8)
                    }
                }
                .frame(height: 8)
            }
            
            HStack(spacing: 12) {
                if profileManager.useImperialUnits {
                    Button(action: {
                        if profileManager.todayWaterIntakeOz >= 8.0 {
                            profileManager.todayWaterIntakeOz -= 8.0
                            profileManager.evaluateQuestsCompletion()
                        }
                    }) {
                        Text("-8 oz")
                            .font(.custom("Orbitron-Bold", size: 10).bold())
                            .foregroundColor(.gray)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color.white.opacity(0.05)))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        profileManager.todayWaterIntakeOz += 8.0
                        profileManager.evaluateQuestsCompletion()
                    }) {
                        Text("+8 oz")
                            .font(.custom("Orbitron-Bold", size: 10).bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color(hex: "#00A3FF")?.opacity(0.2) ?? Color.blue.opacity(0.2)))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        profileManager.todayWaterIntakeOz += 16.0
                        profileManager.evaluateQuestsCompletion()
                    }) {
                        Text("+16 oz")
                            .font(.custom("Orbitron-Bold", size: 10).bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color(hex: "#00E5FF")?.opacity(0.3) ?? Color.cyan.opacity(0.3)))
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: {
                        if profileManager.todayWaterIntake >= 0.25 {
                            profileManager.todayWaterIntake -= 0.25
                            profileManager.evaluateQuestsCompletion()
                        }
                    }) {
                        Text("-0.25 L")
                            .font(.custom("Orbitron-Bold", size: 10).bold())
                            .foregroundColor(.gray)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color.white.opacity(0.05)))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        profileManager.todayWaterIntake += 0.25
                        profileManager.evaluateQuestsCompletion()
                    }) {
                        Text("+0.25 L")
                            .font(.custom("Orbitron-Bold", size: 10).bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color(hex: "#00A3FF")?.opacity(0.2) ?? Color.blue.opacity(0.2)))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        profileManager.todayWaterIntake += 0.5
                        profileManager.evaluateQuestsCompletion()
                    }) {
                        Text("+0.5 L")
                            .font(.custom("Orbitron-Bold", size: 10).bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color(hex: "#00E5FF")?.opacity(0.3) ?? Color.cyan.opacity(0.3)))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.02))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#00E5FF")?.opacity(0.15) ?? Color.blue.opacity(0.15), lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
    }
    
    // Header component
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("BIO-FUEL TELEMETRY")
                .font(.custom("Orbitron-Bold", size: 22).bold())
                .foregroundColor(.white)
                .tracking(3)
            
            Text("Monitor caloric input and metabolic fuel ratios")
                .font(.custom("Exo2-Regular", size: 12))
                .foregroundColor(.gray)
        }
        .padding(.top, 16)
    }
    
    // Ring progress component
    private var calorieTelemetryRing: some View {
        ZStack {
            // Outer glowing aura
            Circle()
                .fill(profileManager.currentElement.primaryColor.opacity(0.04))
                .frame(width: 170, height: 170)
                .blur(radius: 10)
            
            // Background track
            Circle()
                .stroke(Color.white.opacity(0.03), lineWidth: 12)
                .frame(width: 150, height: 150)
            
            // Calorie progress circle
            Circle()
                .trim(from: 0.0, to: calorieProgress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            profileManager.currentElement.primaryColor,
                            profileManager.currentElement.accentColor,
                            profileManager.currentElement.primaryColor
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: 150, height: 150)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeOut, value: totalCalories)
            
            // Center readout
            VStack(spacing: 2) {
                Text("\(Int(totalCalories))")
                    .font(.custom("Orbitron-Bold", size: 30).bold())
                    .foregroundColor(.white)
                
                Text("/ \(Int(calorieTarget)) KCAL")
                    .font(.custom("Orbitron-Bold", size: 10).bold())
                    .foregroundColor(.gray)
                    .tracking(1)
                
                Text("\(Int((totalCalories / calorieTarget) * 100))% FUELED")
                    .font(.custom("Exo2-Bold", size: 9).bold())
                    .foregroundColor(profileManager.currentElement.primaryColor)
                    .padding(.top, 4)
            }
        }
        .frame(height: 180)
    }
    
    // Macro split card component
    private var fuelSplitCard: some View {
        VStack(spacing: 16) {
            Text("ELEMENTAL FUEL SPLIT")
                .font(.custom("Orbitron-Bold", size: 11).bold())
                .foregroundColor(.gray)
                .tracking(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Protein (Orange / Fire)
            MacroRow(
                label: "PROTEIN CORE",
                current: totalProtein,
                target: proteinTarget,
                unit: "g",
                barColor: .orange,
                systemIcon: "figure.strengthtraining.functional"
            )
            
            // Carbs (Cyan / Air)
            MacroRow(
                label: "CARBON INTAKE",
                current: totalCarbs,
                target: carbsTarget,
                unit: "g",
                barColor: .cyan,
                systemIcon: "leaf.fill"
            )
            
            // Fats (Yellow / Lightning)
            MacroRow(
                label: "LIPID SHIELD",
                current: totalFats,
                target: fatsTarget,
                unit: "g",
                barColor: .yellow,
                systemIcon: "shield.fill"
            )
            
            // Sugar (Red warning line)
            MacroRow(
                label: "GLUCOSE LIMIT",
                current: totalSugar,
                target: sugarLimit,
                unit: "g",
                barColor: .red,
                systemIcon: "exclamationmark.triangle.fill"
            )
        }
        .padding()
        .background(Color.white.opacity(0.02))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    // Button component
    private var logRationButton: some View {
        Button(action: {
            showingMealLog = true
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("LOG HEALTHY RATIONS")
            }
            .font(.custom("Orbitron-Bold", size: 13).bold())
            .foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(profileManager.currentElement.primaryColor)
            )
            .shadow(color: profileManager.currentElement.primaryColor.opacity(0.3), radius: 6)
        }
        .padding(.horizontal)
    }
    
    // Log component list
    private var rationsLogList: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("TODAY'S RATIONS LOG")
                .font(.custom("Orbitron-Bold", size: 11).bold())
                .foregroundColor(.gray)
                .tracking(2)
                .padding(.horizontal)
            
            if todayMeals.isEmpty {
                VStack(spacing: 8) {
                    Text("No bio-fuel logged today.")
                        .font(.custom("Exo2-Medium", size: 13))
                        .foregroundColor(.gray)
                    
                    Text("Sync your healthy eating to boost constitution attributes.")
                        .font(.custom("Exo2-Regular", size: 11))
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(Color.white.opacity(0.01))
                .cornerRadius(12)
                .padding(.horizontal)
            } else {
                ForEach(todayMeals) { meal in
                    RationRow(meal: meal, themeColor: profileManager.currentElement.primaryColor) {
                        deleteMeal(meal)
                    }
                }
            }
        }
        .padding(.bottom, 30)
    }
    
    private func deleteMeal(_ meal: MealEntry) {
        profileManager.deleteDetailedMeal(id: meal.id)
    }
}

// MARK: - Macro Row View Component
struct MacroRow: View {
    let label: String
    let current: Double
    let target: Double
    let unit: String
    let barColor: Color
    let systemIcon: String
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Label(label, systemImage: systemIcon)
                    .font(.custom("Orbitron-Bold", size: 9).bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(Int(current)) / \(Int(target)) \(unit)")
                    .font(.system(size: 10).bold())
                    .foregroundColor(barColor)
            }
            
            // Progress Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.03))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(barColor)
                        .frame(width: min(CGFloat(current / target) * geo.size.width, geo.size.width), height: 8)
                        .shadow(color: barColor.opacity(0.4), radius: 3)
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - Ration Row View Component
struct RationRow: View {
    let meal: MealEntry
    let themeColor: Color
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name.uppercased())
                    .font(.custom("Exo2-Bold", size: 13))
                    .foregroundColor(.white)
                
                HStack(spacing: 10) {
                    Text("\(Int(meal.calories)) kcal")
                        .foregroundColor(themeColor)
                    Text("P: \(Int(meal.protein))g")
                    Text("C: \(Int(meal.carbs))g")
                    Text("F: \(Int(meal.fats))g")
                }
                .font(.system(size: 10).bold())
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Delete/Cancel log button
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red.opacity(0.6))
                    .font(.system(size: 16))
            }
        }
        .padding()
        .background(Color.white.opacity(0.02))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.04), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

// MARK: - Meal Log Modal View Component
struct MealLogModalView: View {
    @ObservedObject var profileManager: UserProfileManager
    @Binding var isPresented: Bool
    
    @State private var mealName = ""
    @State private var mealCalories = ""
    @State private var mealProtein = ""
    @State private var mealCarbs = ""
    @State private var mealFats = ""
    @State private var mealSugar = ""
    
    let modalBgColor: Color
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 16) {
                Text("LOG HEALTHY RATIONS")
                    .font(.custom("Orbitron-Bold", size: 15).bold())
                    .foregroundColor(.white)
                    .tracking(2)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("RATION NAME")
                        .font(.system(size: 8).bold())
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
                            .font(.system(size: 8).bold())
                            .foregroundColor(.gray)
                        TextField("kcal", text: $mealCalories)
                            .keyboardType(.numberPad)
                            .padding(10)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("PROTEIN (g)")
                            .font(.system(size: 8).bold())
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
                        Text("CARBS (g)")
                            .font(.system(size: 8).bold())
                            .foregroundColor(.gray)
                        TextField("grams", text: $mealCarbs)
                            .keyboardType(.numberPad)
                            .padding(10)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("FATS (g)")
                            .font(.system(size: 8).bold())
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
                    Text("SUGAR (g)")
                        .font(.system(size: 8).bold())
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
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .font(.custom("Orbitron-Bold", size: 11).bold())
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
                        
                        isPresented = false
                    }) {
                        Text("LOG RATION")
                            .font(.custom("Orbitron-Bold", size: 11).bold())
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
            .frame(width: 300)
            .background(modalBgColor)
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(profileManager.currentElement.primaryColor.opacity(0.4), lineWidth: 1.5)
            )
        }
    }
}
