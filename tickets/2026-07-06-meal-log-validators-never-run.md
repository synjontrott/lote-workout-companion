---
title: "Meal-log form validators are dead code — empty/invalid meals log successfully"
status: done
severity: low
category: "Nutrition & Health"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

The macro-field validators ("Invalid" for null/negative) never fire; a completely
empty form logs a zero-value "Healthy Rations" meal that still increments the
healthy-meal count, logs a nutrition workout session, and advances nutrition
quests.

## Repro

Open LOG HEALTHY RATIONS, leave everything blank, tap LOG RATION → a 0/0/0/0 meal
is logged and quest progress advances.

## Root cause

`nutrition_view.dart:1108-1154` (LOG RATION `onPressed`) parses each field with
`?? 0` and pops without ever calling `_formKey.currentState!.validate()`, so the
`Form`/`_formKey` validators are inert.

## Suggested fix

Guard the handler with `if (!_formKey.currentState!.validate()) return;` before
parsing/logging.
