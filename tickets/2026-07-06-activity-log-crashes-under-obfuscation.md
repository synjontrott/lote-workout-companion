---
title: "Activity Log crashes in obfuscated release builds (runtimeType.toString check)"
status: done
severity: medium
category: "UI & Rendering"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

In a release build compiled with `--obfuscate` (standard for shipped Flutter
apps), tapping the character cockpit to open the Activity Log crashes with
`NoSuchMethodError`. Works in default (non-obfuscated) builds, so it can slip
through local testing.

## Repro

Build with obfuscation → Dashboard → tap the character card → every entry takes
the meal branch and reads `item.name`/`item.calories` on a `WorkoutSession`
(which has `type`/`durationMinutes`) → crash.

## Root cause

`dashboard_view.dart:2770` (inside `showActivityHistory`) discriminates entry
type with `item.runtimeType.toString() == 'WorkoutSession'`. Obfuscation
minifies the class name, so the check is always false.

## Suggested fix

Replace with `if (item is WorkoutSession)` (type-check, not string compare).
