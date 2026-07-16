---
title: "Reset All Progress leaves identity/customizations intact and injects fake PRs"
status: done
severity: high
category: "Data & Persistence"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

The Settings "Reset All Progress (Clean Slate)" dialog promises to "permanently
erase all your stats, character customizations, logged workouts, and level
progress." It does not. Character customizations and identity survive the reset,
and the reset repopulates personal records with fabricated data. This is the
customer-reported "resets don't work as expected."

## Repro

Settings → Reset All Progress → RESET EVERYTHING. Observe:
- Sprite, `characterName`, `age`, `homePlanet`, height/weight/measurements,
  weight/distance/water goals, selected element, cognitive profile, and
  `hasCompletedInitialQuiz` all remain unchanged.
- Personal records come back as hardcoded values (Pullups 5, Pushups 20, …) and
  `_prHistory` shows entries fake-dated "3 days ago" the user never logged.
- Monthly/yearly quests still show their pre-reset progress.

## Root cause

`user_profile_manager.dart:2326` `resetProgress()` clears level/XP/crystals/
streak/stats/badges/shop/meals/sessions/measurement+weight history, but never
clears `_sprite`, `characterName`, `age`, `homePlanet`, body measurements,
`startWeight`/`goalWeight`/`distanceGoal`/`waterIntakeGoal`,
`selectedElementIndex`, `cognitiveProfile`, `selectedFocuses`, or
`hasCompletedInitialQuiz`. It overwrites `_personalRecords` and `_prHistory`
with hardcoded defaults dated `DateTime.now() - 3 days` (2353-2378) instead of
clearing them, and calls only `regenerateDailyQuests()` — leaving
`_monthlyQuests`/`_yearlyQuests` progress stale.

## Suggested fix

Decide the intended semantics and make the dialog copy match. For a true clean
slate: also reset identity/customization/goal fields (or split into "Reset
progress" vs "Reset everything"), clear PRs rather than injecting fabricated
history, and regenerate monthly/yearly quests. Add a test asserting the reset
clears every field the dialog claims.
