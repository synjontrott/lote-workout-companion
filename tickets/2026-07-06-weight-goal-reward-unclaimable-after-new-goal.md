---
title: "Weight-goal reward becomes permanently unclaimable after setting a new goal"
status: open
severity: medium
category: "Nutrition & Health"
created: 2026-07-06
completed:
---

## Symptom

After a user reaches their first weight goal and receives the reward (2000 XP /
1000 crystals / "Weight Target Achieved" badge), setting any new goal weight
will never grant the reward again.

## Repro

Reach goal weight → reward granted, `_hasClaimedWeightGoalReward = true`. Set a
new `goalWeight` (settings_view.dart:478) → reaching the new goal never triggers
the reward branch in `checkWeightGoalProgress`.

## Root cause

`user_profile_manager.dart:441-446` — the `goalWeight` setter resets
`_startWeight = _weight` but leaves `_hasClaimedWeightGoalReward` true. Nothing
else clears it except `resetProgress()`. So `checkWeightGoalProgress`
(1704-1722) skips the reward on all future goals.

## Suggested fix

In the `goalWeight` setter, add `_hasClaimedWeightGoalReward = false;` when the
goal changes.
