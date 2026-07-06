---
title: "Metric onboarding silently corrupts all body metrics, goals, and PRs"
status: open
severity: high
category: "Psychological Profiles & Onboarding"
created: 2026-07-06
completed:
---

## Symptom

A user who completes onboarding with the unit toggle set to METRIC ends up with
wildly wrong height/weight/measurements/goal-weight/distance/PRs everywhere in
the app.

## Repro

On the Identity/Vessel step flip the toggle to METRIC, enter e.g. height 178
(cm), weight 80 (kg) → COMMENCE. Storage is imperial-canonical, so Settings then
re-displays height as `178 * 2.54 = 452 cm` and weight as
`80 * 0.45359 = 36.3 kg`.

## Root cause

`psych_evaluation_view.dart:108-134` (`_confirmProfile`) writes
`double.tryParse(...)` straight into `profile.height/weight/chest/arms/waist/
hips/legs`, `startWeight/goalWeight/distanceGoal`, and the PR map with **no
`_useImperial` conversion branch** — unlike Settings' `_saveDoubleField` /
`_savePRField`, which divide by `0.45359237` / `2.54` / `1.609344` for metric
input before storing (verified at settings_view.dart:1745-1817).

## Suggested fix

In `_confirmProfile`, when `!_useImperial`, convert before storing (weight and
PR-weight `/0.45359237`, lengths `/2.54`, distance `/1.609344`), mirroring
`_saveDoubleField`/`_savePRField`.
