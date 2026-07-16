---
title: "Day rollover past midnight doesn't refresh the UI (missing notifyListeners)"
status: done
severity: medium
category: "Data & Persistence"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

When a new day rolls over while the app stays resident (left open past midnight,
or resumed without a cold start), daily quests regenerate and water/meals-today
reset internally, but the dashboard keeps showing yesterday's completed quests
and stale water total until some other event triggers a rebuild.

## Repro

Keep app on the dashboard across midnight → the post-frame `checkNewDayRefresh()`
resets `_todayWaterIntake`, regenerates `_dailyQuests`, calls `_save()` but not
`notifyListeners()` → UI unchanged.

## Root cause

`user_profile_manager.dart:2386-2455` — the day-change branch persists via
`_save()` (ends ~2448-2450) but never calls `notifyListeners()`; only the
`_load()` caller happens to notify afterward. Called at runtime from
`dashboard_view.dart:150`. The date guard makes repeat calls no-ops, so
notifying is loop-safe.

## Suggested fix

Add `notifyListeners();` after `_save();` inside the day-change branch (~2450).
