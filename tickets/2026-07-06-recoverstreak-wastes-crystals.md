---
title: "recoverStreak() wastes 100 crystals — recovered streak is wiped by next activity"
status: open
severity: high
category: "RPG & Gamification"
created: 2026-07-06
completed:
---

## Symptom

A user spends 100 crystals to recover a broken streak; the very next workout or
quest they complete that day resets the streak to 1, wasting the premium
currency.

## Repro

Streak 10, last active Day 10. Day 11 skipped. Day 12: open app →
`checkNewDayRefresh` sets `_streak=0`, `_previousStreak=10`, but `_lastActiveDate`
stays Day 10. Tap "Recover" → `_streak=11`, `_lastActiveDate` still Day 10.
Complete any quest → `updateStreakOnActivity` computes `diff = 12 - 10 = 2 > 1`
→ `_previousStreak=11`, `_streak=1`. Recovered streak gone. (Doing activity
before recovering is also broken: `_previousStreak` becomes 0, so
`recoverStreak` returns false.)

## Root cause

`user_profile_manager.dart:2523-2533` — `recoverStreak()` updates `_streak` and
`_previousStreak` but never sets `_lastActiveDate`, so the stale date makes the
next `updateStreakOnActivity` treat the streak as freshly broken. Wired at
`dashboard_view.dart:597`.

## Suggested fix

In `recoverStreak()`, add `_lastActiveDate = DateTime.now();` before `_save()`.
