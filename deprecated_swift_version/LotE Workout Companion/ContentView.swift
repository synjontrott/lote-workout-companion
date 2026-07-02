//
//  ContentView.swift
//  LotE Workout Companion
//
//  Created by Antigravity on 6/23/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var profileManager = UserProfileManager()
    @StateObject private var healthManager = HealthKitManager()
    
    // Set custom tab item styling
    init() {
        UITabBar.appearance().backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        ZStack {
            if !profileManager.hasCompletedInitialQuiz {
                PsychEvaluationView(profileManager: profileManager)
                    .transition(.slide)
            } else {
                TabView {
                    // TAB 1: Dashboard
                    NavigationView {
                        DashboardView(profileManager: profileManager, healthManager: healthManager)
                            .navigationBarHidden(true)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Label("Dashboard", systemImage: "terminal.fill")
                    }
                    
                    // TAB 2: Quests
                    NavigationView {
                        QuestBoardView(profileManager: profileManager, healthManager: healthManager)
                            .navigationBarHidden(true)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Label("Quests", systemImage: "shield.fill")
                    }
                    
                    // TAB 3: Feast Log (Nutrition)
                    NavigationView {
                        NutritionView(profileManager: profileManager)
                            .navigationBarHidden(true)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Label("Feast Log", systemImage: "leaf.fill")
                    }
                    
                    // TAB 4: D&D Character Sheets
                    NavigationView {
                        CharacterStatsView(profileManager: profileManager)
                            .navigationBarHidden(true)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Label("Warrior Sheet", systemImage: "person.text.rectangle.fill")
                    }
                    
                    // TAB 4: Armory Shop
                    NavigationView {
                        ShopView(profileManager: profileManager)
                            .navigationBarHidden(true)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Label("Armory", systemImage: "cart.fill")
                    }
                    
                    // TAB 5: Systems Settings & Simulator
                    NavigationView {
                        SettingsView(profileManager: profileManager, healthManager: healthManager)
                            .navigationBarHidden(true)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Label("Systems HUD", systemImage: "slider.horizontal.3")
                    }
                }
                .accentColor(profileManager.currentElement.primaryColor)
                .preferredColorScheme(.dark)
            }
        }
        .animation(.easeInOut, value: profileManager.hasCompletedInitialQuiz)
    }
}

#Preview {
    ContentView()
}
