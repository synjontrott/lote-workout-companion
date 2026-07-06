---
title: "Fix stand goal tracking (60x too slow)"
status: done
category: "Workouts & Quests"
created: 2026-07-02
completed: 2026-07-06
---

## Description

Stand Goal Tracking: Fix stand goal tracking (currently too slow; double check
what it's actually doing).

## Technical Notes

In `health_manager.dart` line 125, it divides `totalStand` by `3600.0`, assuming
seconds, but Apple Stand Time is in minutes. This causes it to track 60x slower.
Needs to be divided by `60.0` instead.
