---
title: "Monthly/yearly quest progress double-counts on manual Log Session → Claim"
status: done
severity: medium
category: "Workouts & Quests"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

Completing a single daily quest via the manual path advances the matching
monthly and yearly quests by 2 instead of 1, so those quests finish twice as
fast (progression/reward inflation).

## Repro

Quest board → "Log Session Manually" (`logWorkout(category)` → monthly/yearly
+1), then "Claim Quest Rewards" (`completeQuest` → `_incrementMonthlyAndYearly
Progress` → monthly/yearly +1 again). One workout ⇒ +2 monthly/yearly progress.
The health-sync path only adds +1, confirming the inconsistency.

## Root cause

`user_profile_manager.dart:1958-1971` (`logWorkout` inline increment) and
`:1785 → 1837-1852` (`completeQuest` → `_incrementMonthlyAndYearlyProgress`)
both increment the same-category monthly/yearly quests for a single logged
workout. UI at `quest_board_view.dart:1127` then `:1082`.

## Suggested fix

Make one path the single source of truth — remove the inline monthly/yearly
increment from `logWorkout`/`logCustomWorkout`, letting `completeQuest` be the
only incrementer (or vice-versa).
