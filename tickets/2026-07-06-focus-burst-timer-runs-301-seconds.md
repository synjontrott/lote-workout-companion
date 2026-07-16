---
title: "Focus-burst timer runs ~301 seconds and sits at 00:00 for a second"
status: done
severity: low
category: "UI & Rendering"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

The "5-MIN FOCUS BURST" displays 00:00 for about one full second before
completing, and the XP/Crystal reward + snackbar fire ~1 second late.

## Repro

ADHD/AuDHD profile → Dashboard → START FOCUS BURST → watch it hit 00:00; the
reward doesn't fire until one extra tick later.

## Root cause

`dashboard_view.dart:104-131` (`_toggleSprintTimer`) — the periodic callback
decrements while `_sprintTimeRemaining > 0` (300→…→0 over 300 ticks, display
reaching 00:00), then needs one additional tick to hit the `else` branch that
cancels/awards. That's 301 ticks total.

## Suggested fix

Award/reset when the value is about to reach 0 (e.g. check
`_sprintTimeRemaining <= 1` after decrement, or complete in the same tick that
sets it to 0).
