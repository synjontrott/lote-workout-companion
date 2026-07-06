---
title: "Hydration daily quest is never generated; waterGoal/prs params are dead"
status: open
severity: medium
category: "Workouts & Quests"
created: 2026-07-06
completed:
---

## Symptom

No water/hydration daily quest is ever produced, even though the manager is
wired to complete one. The hydration feature is silently absent.

## Repro

Set a water goal → inspect generated daily quests → none are hydration; the
hydration completion path never triggers.

## Root cause

`lote_models.dart:1985-1987` — `generateQuests` declares `prs` and `waterGoal`
parameters that are never referenced in the generation body (2155-2345); only
the two declaration lines match. The manager's completion branch
`user_profile_manager.dart:1909-1915` keys on quest titles/descriptions
containing "water"/"hydration", so it is dead code that can never fire.

## Suggested fix

Actually generate a hydration daily quest that uses `waterGoal` (so the existing
completion branch works), or remove the unused params if hydration quests are
intentionally dropped.
