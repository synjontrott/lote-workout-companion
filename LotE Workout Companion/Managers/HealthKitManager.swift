//
//  HealthKitManager.swift
//  LotE Workout Companion
//
//  Created by Antigravity on 6/23/26.
//

import Foundation
import HealthKit
import SwiftUI
import Combine

@MainActor
public class HealthKitManager: ObservableObject {
    @Published public var isAuthorized: Bool = false
    @Published public var todaySteps: Double = 0.0
    @Published public var todayCalories: Double = 0.0
    @Published public var activeMinutes: Double = 0.0
    @Published public var recentWorkouts: [HKWorkout] = []
    
    private var healthStore: HKHealthStore?
    
    public init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    public func requestAuthorization() {
        guard let healthStore = healthStore else { return }
        
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKWorkoutType.workoutType()
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                self.isAuthorized = success
                if success {
                    self.fetchTodayData()
                }
            }
        }
    }
    
    public func fetchTodayData() {
        guard let healthStore = healthStore else { return }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        // Fetch Steps
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let stepQuery = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            let sum = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
            DispatchQueue.main.async {
                self.todaySteps = sum
            }
        }
        healthStore.execute(stepQuery)
        
        // Fetch Calories
        guard let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        let calorieQuery = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            let sum = result?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0.0
            DispatchQueue.main.async {
                self.todayCalories = sum
            }
        }
        healthStore.execute(calorieQuery)
        
        // Fetch Active Exercise Time
        if let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) {
            let exerciseQuery = HKStatisticsQuery(quantityType: exerciseType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                let sum = result?.sumQuantity()?.doubleValue(for: HKUnit.minute()) ?? 0.0
                DispatchQueue.main.async {
                    self.activeMinutes = sum
                }
            }
            healthStore.execute(exerciseQuery)
        }
        
        // Fetch Workouts
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let workoutQuery = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: 10, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let workouts = samples as? [HKWorkout] else { return }
            DispatchQueue.main.async {
                self.recentWorkouts = workouts
            }
        }
        healthStore.execute(workoutQuery)
    }
    
    // Fallback Mock System: For manual entries if HealthKit is not allowed or supported
    public func simulateActivity(steps: Double, calories: Double, minutes: Double) {
        self.todaySteps += steps
        self.todayCalories += calories
        self.activeMinutes += minutes
    }
}
