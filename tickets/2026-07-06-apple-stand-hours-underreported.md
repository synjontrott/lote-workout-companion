---
title: "Apple Stand metric under-reports vs. the Watch Stand ring"
status: done
severity: medium
category: "Dynamic Health Metrics"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

The app's stand-hours value (shown against `standHoursGoal`, default 10) reads
far lower than the user's Apple Watch Stand ring, so the goal is effectively
unreachable for normal users. (Distinct from the already-fixed
seconds-vs-minutes bug — this is a units-of-measure mismatch.)

## Repro

With APPLE_STAND_TIME data, stand a total of ~2 hours across 12 different hours →
Apple ring = 12 stand hours, app shows `120 min / 60 = 2.0`.

## Root cause

`health_manager.dart:129` — `APPLE_STAND_TIME` returns total standing *minutes*;
dividing by 60 yields "hours spent standing," a different quantity from Apple's
Stand ring (the count of distinct hours in which you stood ≥1 min). The goal
(10) is expressed in ring "stand hours," so the two never line up.

## Suggested fix

Use the stand-hour count metric (e.g. `HealthDataType.APPLE_STAND_HOUR` if
available in `health ^13.3.1`) instead of `APPLE_STAND_TIME / 60`, or count the
distinct hours that have standing time.
