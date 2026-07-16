---
title: "Cognitive quiz completion dialog reports the wrong archetype name"
status: done
severity: medium
category: "Psychological Profiles & Onboarding"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

After finishing the cognitive assessment quiz, the "ASSESSMENT COMPLETE" popup
tells the user they belong to the wrong archetype (e.g. an autistic result is
announced as "Vanguard", the neurotypical nickname). The saved profile is
correct — only the message is wrong — but it undermines trust in the quiz.

## Repro

Take the quiz answering mostly option 2 (index 1 → autistic). Dialog says
"Vanguard (Autistic)", but everywhere else autistic = "Revenant"
(settings_view.dart:1149-1158, this file's manual picker 550-556).

## Root cause

`psych_evaluation_view.dart:1256-1265` (`_showMindsetQuizCompleteDialog`) — the
nickname map is scrambled: `autistic→"Vanguard"`, `audhd→"Revenant"`,
`neurotypical→"Warrior"`. Correct mapping: neurotypical=Vanguard, adhd=Hunter,
autistic=Revenant, audhd=Warrior. Only adhd="Hunter" is right. The saved
`_selectedProfile` from `_calculateMindsetQuizResult` is correct.

## Suggested fix

Fix the map: `adhd→"Hunter (ADHD)"`, `autistic→"Revenant (Autistic)"`,
`audhd→"Warrior (AuDHD)"`, `neurotypical→"Vanguard (Neurotypical)"`.
