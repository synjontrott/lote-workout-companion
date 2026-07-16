---
title: "Leaked TextEditingControllers (age field, custom-workout weight vest)"
status: done
severity: low
category: "UI & Rendering"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

Two `TextEditingController`s are never disposed, leaking a controller each time
their view is torn down.

## Repro

- Enter and leave the onboarding/psych-evaluation view repeatedly.
- Navigate into and out of the Quest Board repeatedly.

Every other controller in these classes is disposed; these two are skipped.

## Root cause

- `psych_evaluation_view.dart:68` — `_ageController` is created but omitted from
  `dispose()` (88-104).
- `quest_board_view.dart:43-44` — `_customWorkoutWeightVestController` is
  declared but skipped in `dispose()` (70-85), which disposes the duration
  controller then jumps to the search controller.

## Suggested fix

Add `_ageController.dispose();` and `_customWorkoutWeightVestController.
dispose();` to the respective `dispose()` overrides.
