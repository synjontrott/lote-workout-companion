---
title: "Monthly quest reset compares only the month number, ignoring the year"
status: done
severity: low
category: "Workouts & Quests"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

A lapsed user who returns after ~12 months (same calendar month — realistic for
New-Year fitness users) keeps last year's monthly quests and monthly-challenge
progress instead of getting fresh ones.

## Repro

Last refresh Jan 15 2025; open app Jan 20 2026 → enters the new-day block, but
`_lastRefreshDate!.month (1) == now.month (1)` → monthly quests and
`_monthlyChallengeProgress` are not reset.

## Root cause

`user_profile_manager.dart:2414` — `if (_lastRefreshDate!.month != now.month)`
tests only `.month`, so a same-month/different-year gap is missed. Both
`_monthlyChallengeProgress = 0.0` and monthly quest regeneration live inside
this block.

## Suggested fix

Trigger the monthly reset when month OR year differs:
`if (_lastRefreshDate!.month != now.month || _lastRefreshDate!.year != now.year)`.
