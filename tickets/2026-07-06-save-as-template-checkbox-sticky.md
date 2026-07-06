---
title: "\"Save as template\" checkbox never resets, silently re-saving every later meal"
status: open
severity: medium
category: "Nutrition & Health"
created: 2026-07-06
completed:
---

## Symptom

After a user checks "Save as Quick Meal template" once, every subsequent meal
they log is also saved as a Quick-Log template, spamming the "QUICK LOG MEALS"
chip row with unwanted duplicates until app restart.

## Repro

Log a meal with "Save as Quick Meal template" checked → open the dialog again:
the checkbox is still checked, and logging any new meal calls `saveMealTemplate`
again even though the user didn't opt in.

## Root cause

`nutrition_view.dart:24` — `_saveAsTemplate` is a persistent State field.
`_showMealLogDialog` resets `_mealName…_mealSugar` (798-804) but not
`_saveAsTemplate`; the LOG RATION handler (1144-1150) likewise resets the meal
strings but leaves `_saveAsTemplate` true.

## Suggested fix

Set `_saveAsTemplate = false;` at the top of `_showMealLogDialog` (and after
logging).
