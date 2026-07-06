---
title: "Advanced Workout Goal progressions reference workout IDs that don't exist"
status: open
severity: high
category: "Workouts & Quests"
created: 2026-07-06
completed:
---

## Symptom

Selecting any Advanced Workout Goal (Handstand, Muscle Up, Dragon Flag, Pistol
Squat, Front Lever) makes the daily "Goal Training" quest always read "Knee
Pushups Foundation" regardless of the chosen goal, and the goal's prerequisite
exercises never surface in the Workout Library. The Workout Goals / Progression
Engine / Goal-Oriented Recommendations features are effectively broken.

## Repro

Set active goal = Handstand → generate daily quests → the goal quest reads "Path
to Handstand: Complete Knee Pushups Foundation (3 sets x 10-12 reps)".

## Root cause

`lote_models.dart:2586-2635` `WorkoutProgression.all` lists
`prerequisiteWorkoutIds` such as `pike_pushups_foundation`,
`hollow_body_hold_foundation`, `bulgarian_split_squats_foundation` that match no
`SuggestedWorkout.id`. The real ids are `pike_pushups_base`, `hollow_body_hold`,
`bulgarian_split_squats`, etc. `generateQuests` (2322-2343) resolves the
prerequisite with `firstWhere(..., orElse: () => allWorkouts.first)`, which
always returns the first workout, `knee_pushups_foundation`. Verified: 0
definitions exist for the referenced `..._foundation` ids.

## Suggested fix

Rename each `prerequisiteWorkoutIds` entry to an existing workout id (or add the
referenced workouts to `allWorkouts`). Add a guard test asserting every
`prerequisiteWorkoutIds` value resolves to a real `SuggestedWorkout.id`.
