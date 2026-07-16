---
title: "Nutrition macro progress bar divides by zero when a macro target is 0"
status: done
severity: medium
category: "Nutrition & Health"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

If a user sets a macro target (protein/carbs/fats/sugar) to 0 in Settings and
has nothing logged yet, the Nutrition screen produces an out-of-range progress
value — a `LinearProgressIndicator` assertion failure in debug, undefined bar
rendering in release.

## Repro

Settings → set PROTEIN TARGET to `0` (no min validation) → open Nutrition before
logging any protein. `progress = (0 / 0).clamp(0.0, 1.0)` produces `NaN`
(NaN comparisons are false, so clamp returns NaN), fed to
`LinearProgressIndicator(value: ...)`.

## Root cause

`nutrition_view.dart:757` (`_buildMacroProgressBar`) divides without a
`target > 0` guard — unlike the calorie ring (line 58), which is guarded. The
Settings target setters accept 0.

## Suggested fix

`final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;`
(and/or add a minimum-value validator on the macro-target inputs).
