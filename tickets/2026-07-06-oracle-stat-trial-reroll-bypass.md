---
title: "Oracle Stat Trials: DC/stat check bypassed by dismissing failed rolls"
status: done
severity: medium
category: "RPG & Gamification"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

A player can guarantee all 3 daily trial successes (and the 5-crystal reward
each) regardless of their stat modifier, defeating the DC mechanic.

## Repro

Trials tab → ROLL a trial → if it shows TRIAL FAILED, tap outside the dialog
(barrier) instead of CONTINUE → the attempt is not counted → ROLL again → repeat
until success → tap CONTINUE. Yields 3 guaranteed rewarded successes/day.

## Root cause

`character_stats_view.dart:631` (dialog) / `:692-698` (record on CONTINUE only) —
the infinite-farm patch (commit 079e00e) added a `trialsCompletedToday >= 3`
guard and `recordTrialCompleted()`, but the reward dialog is shown with
`showDialog` and no `barrierDismissible: false`. Only CONTINUE calls
`recordTrialCompleted()`; a barrier dismiss neither records the attempt nor
grants a reward, so failed rolls can be re-tried freely. The daily cap of 3 still
holds, so this is a mechanic bypass, not an unbounded farm.

## Suggested fix

Pass `barrierDismissible: false` to the `showDialog`, and/or call
`recordTrialCompleted()` at roll time (right after the guard) rather than on
CONTINUE.
