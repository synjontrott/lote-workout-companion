---
title: "Yoga/mobility library workouts are categorized as Strength"
status: done
severity: low
category: "Workouts & Quests"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

Logging a stretch/mobility exercise from the Workout Library credits a Strength
quest instead of Flexibility. No library workout ever counts toward flexibility.

## Repro

Workout Library → log "Downward Dog Flow" → the Strength daily/monthly/yearly
quests advance; the Flexibility quest does not.

## Root cause

`lote_models.dart:2700-2709` — the `SuggestedWorkout.category` getter returns
`WorkoutCategory.strength` for every non-cardio muscle group, including
`MuscleGroup.fullBody`, which is what mobility exercises ("Downward Dog Flow",
"Cobra Stretch Flow", "World's Greatest Stretch", etc. at 4691-4770) use. There
is no flexibility muscle group, so stretching content is mislabeled and
`logWorkout(workout.category)` records a Strength session. (Flexibility quests
are still completable via the quest's own log button, so this is a mis-credit,
not a hard block.)

## Suggested fix

Introduce a flexibility categorization (e.g. a `MuscleGroup.flexibility` or a
per-workout category override) so mobility workouts map to
`WorkoutCategory.flexibility`.
