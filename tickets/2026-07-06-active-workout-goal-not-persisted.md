---
title: "Advanced workout goal is saved but never loaded — resets to none on restart"
status: open
severity: medium
category: "Data & Persistence"
created: 2026-07-06
completed:
---

## Symptom

The user's chosen advanced workout goal silently reverts to `none` after
restarting the app, and subsequent quest regeneration no longer reflects the
goal.

## Repro

Set an advanced workout goal → close app → reopen. `activeWorkoutGoal` returns
`none`; the next day-refresh runs `generateQuests(... activeGoal: none)`.

## Root cause

`user_profile_manager.dart:1383` writes key `lote_workout_goal`, but `_load()`
(982-1344) never reads it — `_activeWorkoutGoal` is never assigned on load and
keeps its default (`:31`). It is also serialized with `.toString()`
("AdvancedWorkoutGoal.x") rather than `.name`, so a loader must match that
format.

## Suggested fix

Save with `_activeWorkoutGoal.name`; in `_load()` add
`_activeWorkoutGoal = AdvancedWorkoutGoal.values.firstWhere((e) => e.name ==
prefs.getString('lote_workout_goal'), orElse: () => AdvancedWorkoutGoal.none);`.
