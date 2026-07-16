---
title: "Cardio daily quest stores requiredMinutes=20 but text says 15-minute run"
status: done
severity: low
category: "Workouts & Quests"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

Internal data inconsistency: a generated cardio daily quest's description reads
"Complete a 15-minute run…" while its `requiredMinutes` field is `20.0`. Not a
hard block today, but a latent correctness/consistency bug.

## Repro

Generate daily quests with a cardio focus → inspect the quest: description says
"15-minute", `requiredMinutes` is 20.

## Root cause

`lote_models.dart:2307-2311` sets `requiredMinutes = 20.0` for
`WorkoutCategory.cardio`, while the description/title (`:2233`) and the built-in
default cardio quest `q1` both use 15. Currently masked because
`user_profile_manager.dart:1898` completes on
`cardioDuration >= requiredMinutes || cardioSessions.isNotEmpty`.

## Suggested fix

Make them agree — set the cardio branch to `15.0` (or update the copy to
"20-minute").
