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
                    DashboardView(profileManager: profileManager, healthManager: healthManager)
                        .tabItem {
                            Label("Dashboard", systemImage: "terminal.fill")
                        }
                    
                    // TAB 2: Quests
                    QuestBoardView(profileManager: profileManager)
                        .tabItem {
                            Label("Quests", systemImage: "shield.fill")
                        }
                    
                    // TAB 3: D&D Character Sheets
                    CharacterStatsView(profileManager: profileManager)
                        .tabItem {
                            Label("Warrior Sheet", systemImage: "person.text.rectangle.fill")
                        }
                    
                    // TAB 4: Systems Settings & Simulator
                    SettingsView(profileManager: profileManager, healthManager: healthManager)
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
