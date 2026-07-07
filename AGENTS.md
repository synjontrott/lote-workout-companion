# LotE Workout Companion — Agent Guidelines

This repository contains the **Legends of the Elsaither Workout Companion**, a
premium fitness companion with D&D RPG gamification set in the LotE (Legends of
the Elements) universe. Active development lives in the Flutter codebase inside
`cross_platform_build/` — it compiles to both **iOS** and **Android** and is the
single source of truth. The native SwiftUI app in `deprecated_swift_version/` is
**deprecated**; do not modify it.

When working here, keep the code clean, reliable, and consistent with these
guidelines: build health, runtime safety, persistence correctness, HealthKit/
device sync, RPG progression, LotE element theming, profile-specific motivation
flows, quest-generation rules, keyboard-dismissal behavior, workout availability,
and metric naming. Prefer small, well-scoped fixes that preserve the existing
Provider / `ChangeNotifier` architecture; keep persistence behind manager
actions; avoid exposing internals just to satisfy a view; and verify changes with
the available Flutter build/analysis tools.

## Agent context files — one canonical source

This file, **`AGENTS.md`**, is the single canonical instruction set. The other
agent context files are **symlinks** to it, so they can never drift:

- **`CLAUDE.md`** → symlink to `AGENTS.md` (Claude Code's native filename).
- **`GEMINI.md`** → symlink to `AGENTS.md` (Gemini CLI's filename).
- Edit **only `AGENTS.md`** — the symlinks follow automatically.
- **"Qwen"** is not a context-file agent here — it's a remote Ollama model
  (`qwen3.6:27b`) called over HTTP for offloading (see "Qwen offloading"); its
  instructions ride in the API prompt, so no `QWEN.md` is needed.

---

## Project Overview

A premium fitness companion with D&D RPG gamification based on the LotE (Legends
of the Elements) universe.

### Core Architecture & Pillars
1. **HealthKit / Device Sync**: Retrieves steps, active energy (calories), active
   minutes (training time), and stand hours from the user's device/health app.
2. **RPG Progression**: User advances attributes (STR, DEX, CON, INT, WIS, CHA)
   and levels up from Recruit to Legend based on completed quests.
3. **Lore-Themed UI**: Adapts background glow, primary accent colors, and custom
   element sprites dynamically depending on the selected LotE Element.
4. **Clinical Psychology Engine**: Determines the user's motivational profile
   (ADHD, Autistic, AuDHD, Neurotypical) to tailor dashboards, quest delivery,
   and check-ins.

---

## The 4 Psychological Motivation Profiles

### ⚡ 1. ADHD Profile (Dopamine-Driven)
- **Mechanics**: High-novelty, immediate-reward.
- **UI/UX Widgets**:
  - **Dopamine Menu**: Quick 5-minute movement bursts (e.g. "Flame Dash" — 20
    jumping jacks) with a clear instruction and confirmation modal.
  - **Variable Loot**: Randomly drops crystals or items upon completion.

### 🧩 2. Autistic Profile (Data-Driven Structure)
- **Mechanics**: Predictable routine, detailed statistics.
- **UI/UX Widgets**:
  - **Daily Fitness Performance Checklist**: Strict progress checking of daily
    quotas (Steps, Active Energy, Training Time, Stand Hours, Sugar Intake).
  - **Deep-Dive Analytics**: Advanced progression graphs showing exact metrics
    and stat curves.

### 🌀 3. AuDHD Profile (Structured Flexibility)
- **Mechanics**: Structured framework with flexible choices (combats demand
  avoidance).
- **UI/UX Widgets**:
  - **Wildcard Routines**: Flexible daily tasks (e.g., "Cardio Slot: Run or
    Cycle?").
  - **Optional Side Quests**: Bonus XP challenges that do not break streaks if
    skipped.

### ⚔️ 4. Neurotypical Profile (Habit Stacking)
- **Mechanics**: Progressive challenge mode, habit loops, classic streaks.
- **UI/UX Widgets**:
  - **Habit Stacking Logs**: Triggers exercise after a daily habit (e.g., "After
    morning coffee, stretch for 10 mins").

---

## Design System & Theme Mapping

- **Background**: Deep dark space color scheme (`#050505` / `#0a0a0a`).
- **Typography**:
  - **Headings**: 'Orbitron' (all-caps, bold, tracked).
  - **Body / Labels**: 'Exo 2' / 'Exo2-Regular' (modern, high legibility).
- **Element Theme Colors**:
  - **Fire**: Red (`#FF1616`) / Orange (`#FF5E00`)
  - **Water**: Blue (`#00A3FF`) / Cyan (`#00E5FF`)
  - **Earth**: Green (`#4CAF50`) / Brown (`#795548`)
  - **Air**: Sky Blue (`#A5D6FF`) / White (`#F6F7FC`)
  - **Metal**: Silver (`#B0BEC5`) / Gold (`#FFD700`)
  - **Lightning**: Electric Blue (`#00F0FF`) / Neon Yellow (`#FFEA00`)
  - **Ice**: Frosty Teal (`#26C6DA`) / White (`#E0F7FA`)
  - **Bone**: Ivory (`#EEEEEE`) / Tan (`#D7CCC8`)
  - **Gas**: Mist Green (`#80CBC4`) / Lavender (`#E1BEE7`)
  - **Laser**: Cyber Pink (`#FF007F`) / Purple (`#7B1FA2`)
  - **Zero Space**: Deep Indigo (`#3F51B5`) / Magenta (`#E040FB`)
  - **Knife**: Plasma Blue (`#00E5FF`) / Dark Gray (`#37474F`)
  - **Poison**: Emerald (`#00E676`) / Purple (`#AA00FF`)
  - **Darki**: Burgundy (`#880E4F`) / Gold (`#FFB300`)
  - **Shadow**: Charcoal (`#263238`) / Violet (`#311B92`)
  - **Death**: Murky Purple (`#4A148C`) / Decay Gray (`#212121`)

### Sprite Power Flavors
Every character sprite in the dashboard is flanked by a floating power indicator:
- **Parallax Bobbing**: Opposite vertical bobbing relative to the main sprite to
  create floating physics.
- **Power Flavors**: 🔥 (Fire), 💧 (Water), 🪨 (Earth), 💨 (Air), ⚡ (Lightning),
  ⚙️ (Metal), 🧊 (Ice), 🦴 (Bone), 🌫️ (Gas), 🔴 (Laser), 🌀 (Zero Space), 🗡️
  (Knife), 🧪 (Poison), 🔮 (Darki), 👻 (Shadow), 💀 (Death).

---

## Engineering Standards & Definition of Done

Applies to every change in `cross_platform_build/`. Keep fixes small and
well-scoped; preserve the existing Provider / `ChangeNotifier` architecture.

### Definition of Done — all must hold before a change is "done"
- [ ] **Every code file is linted and tested** — no code lands unlinted or untested, regardless of language (see "Linting, tests & the pre-commit gate").
- [ ] **Dart:** `flutter analyze` is clean, `dart format .` applied, `flutter test` passes.
- [ ] **Python:** `ruff check .` is clean and `pytest` passes (run from `cross_platform_build/`).
- [ ] Any change to business logic ships with a **unit test** — write it first (red), then make it pass (green).
- [ ] Any added/changed widget behavior ships with a **widget test**.
- [ ] Views never call `SharedPreferences` or HealthKit directly — persistence and device data stay behind manager actions.
- [ ] No leftover debug `print`/`debugPrint` on production paths; no secrets committed.
- [ ] The pre-commit gate passed (not bypassed with `--no-verify`).
- [ ] **After pushing: CI is green** — verify the GitHub Actions run and fix it if red before moving on (see "After pushing: verify CI").

### Linting, tests & the pre-commit gate
**All code files must be linted and tested — this is non-negotiable.** A linter is
required for every code language in the repo, and code must pass both its linter
and its tests before it can be committed.

| Language | Lint | Format | Test | Config |
|----------|------|--------|------|--------|
| Dart (product code — `lib/`, `test/`) | `flutter analyze` | `dart format` | `flutter test` | `cross_platform_build/analysis_options.yaml` (`flutter_lints`) |
| Python (helper / codegen scripts) | `ruff check .` | `ruff format` | `pytest` | `cross_platform_build/pyproject.toml` |

The Python scripts are one-shot Dart transformers, but are held to the same bar:
each exposes a pure `transform(content: str) -> str` and performs file I/O only
under `if __name__ == "__main__":`, with a test in
`cross_platform_build/tests_python/`. New code in any other language must arrive
with a linter wired in and tests.

**Enforcement — the pre-commit gate.** A committed hook at `.githooks/pre-commit`
runs the format/lint/test checks on staged changes and blocks the commit if any
fail. Activate it once per clone (from the repo root):

```sh
git config core.hooksPath .githooks
pip install ruff pytest        # Python side of the gate
```

Do not bypass it with `git commit --no-verify` except in a genuine emergency;
CI is the backstop, not a substitute.

### After pushing: verify CI
Pushing is not "done" until CI is green. After **every** push to `main`, check the
GitHub Actions run and fix it if it failed:

```sh
gh run watch "$(gh run list --workflow flutter-ci.yml --limit 1 --json databaseId -q '.[0].databaseId')" --exit-status
# quick check: gh run list --workflow flutter-ci.yml --limit 1
```

If CI is red, treat it as a P1: diagnose with `gh run view <id> --log-failed` and
push a fix (or revert) before starting other work. **This applies to AI agents
too — any agent that pushes must confirm the resulting CI run passes.**

### Architecture — where code goes
- **`lib/models/`** — data + pure functions (`generateQuests`, `SuggestedWorkout.allWorkouts`, `*.fromJson`/`toJson`). No I/O, no `SharedPreferences`, no widgets. This is the most-tested layer; prefer putting testable logic here.
- **`lib/managers/`** — `ChangeNotifier` state + persistence + business rules. Owns all reads/writes to `SharedPreferences` and `HealthManager`. Expose behavior through methods/getters, not raw internals.
- **`lib/views/`** — presentation only. Read state via `Provider`; call manager methods to mutate. Keep logic (and any I/O) out of `build()`.

### Testing approach — the light harness
Built on the SDK's built-in `flutter_test`; no extra test dependencies. Full
details in `cross_platform_build/test/README.md`.
- **Unit tests** (`test/models/`, `test/managers/`) — pure logic and manager behavior. Prefer testing pure model functions directly.
- **Widget tests** (`test/widgets/`) — render a single widget and assert. Avoid pumping whole animated screens (repeating animations leave pending timers).
- **Fakes, not mocks** — seed persistence with `SharedPreferences.setMockInitialValues`; seed activity with `HealthManager.simulateActivity(...)`. Reach for constructor **dependency injection** before adding any mocking package.
- **Regression backlog** — known, unfixed defects live as `skip:`-marked tests in `test/regressions/` that encode the correct behavior. Un-skip (don't delete) when you fix them.
- **End-to-end / `integration_test`** — a deferred future tier. Documented here, not built yet; add it only when a real device/browser flow needs coverage.

Run everything from `cross_platform_build/`:

```sh
flutter analyze
flutter test
ruff check .        # Python scripts
pytest              # Python script tests
```

---

## Implementation Guidelines & Constraints

1. **Quest Adjective Variety**: Keep quest naming varied. Each element has 7 distinct adjectives (e.g. Laser uses *Beam, Photon, Arc, Reactor, Focus, Ray, Laser*). Select distinct adjectives inside loops to prevent name repetition on the same day.
2. **Keyboard Dismissal Toolbar**:
   - **iOS**: Views must be structurally contained inside a `NavigationView` (or `NavigationStack`) with hidden navigation bars so that `ToolbarItemGroup(placement: .keyboard)` Done buttons display correctly.
   - **Flutter**: Wrap number-pad `TextField` widgets with a suffix checkmark button (`Icons.check_circle_outline` or `Icons.check`) to allow keyboard dismissal on iOS devices.
3. **Dumbbell Workout Availability**: Dumbbell workouts must be explicitly defined in the SuggestedWorkout database for both platforms to support tailored resistance workouts.
4. **Metric Consistency**: Ensure the autistic dashboard checklist labels match the terminology of the "Elsaither Energy Core" and "Sugar Intake Tracker" exactly: *Steps Taken*, *Active Energy*, *Training Time*, *Stand Hours*, *Sugar Intake*.
5. **No Double Quests**: Ensure daily quest generation does not spawn two identical quests (e.g. one calisthenics workout category should map to exactly one quest in a day).
6. **300x300 High-Fidelity Character Sprites**: Character sprites are built on a detailed 300x300 pixel grid with dynamic proportions, natural facial features (slanted eyes placed on columns 134-166, lip lines), distinct hairstyles (spiky, long, mohawk, short crop), and custom physical planet armor structures (aerodynamic wraps for Ninjonia, chest vents/cables for Techno, heavy scale tassets/high neck shroud for Warrion).
7. **Suggested Workouts Muscle Group System**: Workouts are categorized directly by target `MuscleGroup` (Chest, Back, Shoulders, Arms, Core & Abs, Legs & Glutes, Full Body, Cardio & Conditioning) rather than high-level categories, and the `space` restriction has been removed.
8. **160-Workout Complete Matrix**: The static `SuggestedWorkout.allWorkouts` database contains a full 160-workout combination list (8 muscle groups × 5 difficulties × 4 equipment types) of real, detailed exercises, eliminating the need for generic "Custom X Builder" placeholders.
9. **Setup Evaluator Dropdowns**: The planet selection text input is replaced by a dropdown validation list containing the four canonical planets: Ninjonia, Techno, Warrion, and Battacaria.
10. **Setup Element Quiz**: A 6-question psychological trait and color evaluation quiz automatically recommends a starting element alignment.
11. **Custom Workout Logging**: Users can log custom workouts specifying Sets, Reps/Details, Category (Strength, Cardio, Yoga/Flexibility), Duration, and Difficulty. It maps substring names and types to complete active quests and rewards difficulty-scaled XP and Crystals.
12. **Workout Search**: Suggested Workouts has a keyword search bar that searches the entire 160-workout database, reverting to tailored parameters when empty.
13. **Hydration Stepper & Unit Scaling**: Hydration goals increment/decrement by exactly `0.5 Liters` (metric) and `8.0 oz` (imperial) with safe rounding to avoid conversion drift.
14. **Top RPG Stats HUD**: All screens include a top-locked stats bar featuring the custom animated bobbing character avatar, level indicator, XP progress bar, current element alignment, and crystal counter. Touching the level or profile at the top must show the user's activity history.
15. **Custom Workout Inputs**: Allow decimals and seconds in custom workouts (e.g., a 20.5 second plank). Rep-based workouts should not have a time factor.
16. **Weight Tracking**: Pull the current weight from Apple Health and update it automatically in all locations rather than requiring manual entry in multiple places. Save data on update.
17. **Quest Integrations**: Logging a session manually must work on daily quests. Meal quests should automatically update with feast log entries.
18. **Stand Metric**: Track and display 'Stand Hours' rather than 'Stand Minutes'.
19. **Unit Selection**: Ask for Imperial or Metric preference at the very beginning of the onboarding flow.
20. **Dynamic Quests**: Suggested large daily quests should disappear or change once completed.

---

## Tickets

The full ticket backlog lives in the [`tickets/`](tickets/) directory — one
Markdown file per ticket, named `YYYY-MM-DD-slug.md` with YAML frontmatter
(`title`, `status`, `severity`, `category`, `created`, `completed`). See
[`tickets/README.md`](tickets/README.md) for the convention and search recipes.

Add a ticket with `$EDITOR "tickets/$(date +%F)-short-slug.md"` — no index to
update. Find tickets by filename/frontmatter, e.g. `grep -l 'status: open'
tickets/*.md`.

## Project state

Current state lives in living sources, not a dated snapshot here:
- **`tickets/`** — open/closed work items with severity.
- **CI** — `gh run list --workflow flutter-ci.yml`.
- **`lote-eval-report.html`** — the comprehensive codebase audit of all views and
  managers.

---

## Qwen 3.6:27b Offloading (Ollama)

Offload heavy/repetitive code generation to the user's remote Ollama server
running `qwen3.6:27b` to save Antigravity credits.

### Connection
- **Remote server**: `http://192.168.1.17:11434` (user's tower — may require wake-up)
- **Local fallback**: `http://localhost:11434` (has `qwen2.5-coder:7b` only)
- **Model**: `qwen3.6:27b`

### Critical: disable thinking mode
Qwen 3.6 is a thinking model. Without disabling thinking it burns ALL tokens on
its internal `thinking` chain and returns an **empty `response` field**. Always
set `"think": false` in the request body:

```json
{ "think": false, "options": { "num_predict": 4096 } }
```

### Usage pattern
```bash
curl -s -o /tmp/qwen_out.json http://192.168.1.17:11434/api/generate -d '{
  "model": "qwen3.6:27b",
  "prompt": "YOUR PROMPT HERE",
  "stream": false,
  "think": false,
  "options": {"temperature": 0.3, "num_predict": 4096}
}' && python3 -c "
import json
with open('/tmp/qwen_out.json') as f:
    d = json.load(f)
print(d.get('response','EMPTY'))
"
```

### When to use
- Bulk repetitive code (e.g., 64 switch cases across 16 elements), mechanical
  find-and-replace refactors, game-design suggestions (name generation, rebalancing).
- Anything that would require 500+ tokens of boilerplate output.

### When NOT to use
- Quick 1–5 line surgical fixes (overhead > savings).
- Fixes requiring deep, full-file context understanding.
- Anything `dart fix --apply` can handle (use that instead).

### Best practices
- **Run as a background task** and let the system auto-notify on completion — no timers.
- **Give it time**: the 27B model takes 2–5 minutes per response.
- **Fallback**: if unreachable, `curl -s --max-time 5 http://192.168.1.17:11434/` — the user may need to wake the server.
