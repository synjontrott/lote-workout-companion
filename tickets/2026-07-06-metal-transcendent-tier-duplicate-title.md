---
title: "Metal element shows \"Forge Master\" at both level 35 and level 100"
status: done
severity: low
category: "RPG & Gamification"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

A Metal-element warrior who reaches Transcendent (level 100) sees the title
"Forge Master" — identical to the Master tier (level 35). The ultimate rank
feels unrewarding and looks like a bug.

## Repro

Element = Metal; compare the tier name at Master (L35) vs Transcendent (L100) —
both read "Forge Master".

## Root cause

`lote_models.dart:259` and `:269` — in `dynamicDisplayName`, the `'Metal'`
branch returns `"Forge Master"` for both `WarriorTier.master` and
`WarriorTier.transcendent`. Metal is the only element with a duplicate tier name.

## Suggested fix

Give `transcendent` a unique name, e.g. `return "Eternal Forge";`. Consider a
test asserting all tier names are unique per element.
