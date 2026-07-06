---
title: "Custom-workout confirmation understates rewards when a weight vest is used"
status: open
severity: medium
category: "Workouts & Quests"
created: 2026-07-06
completed:
---

## Symptom

When the user enters a weight-vest value and taps RECORD, the confirmation
dialog shows the base (un-multiplied) XP/Crystals (e.g. "+25 XP, +10 Crystals")
even though the vest bonus was actually applied and more was granted. The reward
is correct; only the displayed number is wrong, which reads as "the vest bonus
didn't count."

## Repro

Custom Training Telemetry → LOG WORKOUT → difficulty Medium, Weight Vest = 50 →
RECORD. Actual award (via `logCustomWorkout`, line 3471) = 50 XP / 20 Crystals;
the dialog says "+25 XP, +10 Crystals."

## Root cause

`quest_board_view.dart` — the RECORD handler reads the vest field for the real
award (3479-3482), then clears `_customWorkoutWeightVestController` at `:3493`.
The message recompute at `:3520-3524` re-reads the now-empty controller
(`double.tryParse("") ?? 0.0` → 0.0), so the `if (vestWeightLbs > 0)` multiplier
block (3525-3529) never runs for the displayed message.

## Suggested fix

Capture `vestWeightLbs` into a local variable once, before clearing the
controllers, and reuse it for both the award and the message.
