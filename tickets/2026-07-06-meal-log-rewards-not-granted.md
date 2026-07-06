---
title: "Meal-log dialog promises XP/Crystals/stat that are never granted"
status: open
severity: medium
category: "Nutrition & Health"
created: 2026-07-06
completed:
---

## Symptom

After logging a meal, the dialog says "Logged healthy rations! +15 XP, +10
Crystals, and +1 Constitution gained from nutrition sync." but the user actually
receives 0 XP, 0 Crystals, and 0 stat points.

## Repro

Quest Board → meal-log flow → fill anything → "LOG RATION" → dialog claims +15
XP / +10 Crystals / +1 CON, but the Dashboard crystal/XP counters don't change.

## Root cause

`quest_board_view.dart:1838-1842` shows the reward message, but
`logDetailedMeal` (`user_profile_manager.dart:2065`) only adds a `MealEntry`,
bumps `_healthyMealsLoggedToday`, and calls `logWorkout(WorkoutCategory.
nutrition)`. `logWorkout` (`:1928`) never calls `addXP`/`earnCrystals`/
`_stats.increase`; it creates a session and calls `evaluateQuestsCompletion`,
which only fills `progressCount` (rewards still require the CLAIM button).

## Suggested fix

Either grant the stated rewards inside `logDetailedMeal`
(`addXP(15); earnCrystals(10); _stats.increase(StatType.constitution, 1);`) or
change the dialog copy to not promise immediate rewards.
