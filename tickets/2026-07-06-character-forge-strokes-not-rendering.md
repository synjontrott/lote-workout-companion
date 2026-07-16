---
title: "Character Forge freehand drawing does not render while you draw"
status: done
severity: high
category: "UI & Rendering"
created: 2026-07-06
completed: 2026-07-16
---

## Symptom

In the Character Forge, dragging/tapping on the pixel canvas appears to do
nothing. Strokes only "pop in" all at once later, after you change a preset
color or tap COMPOSITE PRESETS / CLEAR CANVAS. Reads as a broken editor.

## Repro

Character Forge → pick a brush → draw on the canvas → nothing visibly changes →
change the Skin Tone dropdown → all previously drawn pixels suddenly appear.

## Root cause

`pixel_sprite_widget.dart:99` — `shouldRepaint` compares
`oldDelegate.grid != grid`, i.e. reference (identity) equality on a
`List<List<int>>`. `character_creator_view.dart:155-159` `_handlePaintGesture`
mutates the existing grid in place (`_pixelGrid[row][col] = ...`), so the
reference is unchanged and all `Color` params are value-equal, so `shouldRepaint`
returns false and the paint is skipped. Clear/Composite assign a *new* list,
which is why those paths do repaint.

## Suggested fix

Do a content comparison in `shouldRepaint` (compare cell-by-cell), or have
`_handlePaintGesture` assign a fresh list copy inside `setState` so the reference
changes.
