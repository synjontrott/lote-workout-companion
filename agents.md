# Agent Purpose

This repository contains the Legends of the Elsaither Workout Companion, primarily focused on the Flutter codebase inside `cross_platform_build/`. When working here, my purpose is to check that the code is clean, reliable, and aligned with `GEMINI.md`.

The native SwiftUI app inside `deprecated_swift_version/` has been deprecated and should not receive any new development. I should review the Flutter codebase for build health, runtime safety, persistence correctness, and whether the app actually supports the intended HealthKit/device sync, RPG progression, LotE element theming, profile-specific motivation flows, quest generation rules, keyboard dismissal behavior, workout availability, and metric naming.

Prefer small, well-scoped fixes that preserve the existing architecture. Keep persistence behind manager actions, avoid exposing internals just to satisfy a view, and verify changes with the available Flutter build or analysis tools whenever possible.

---

## Engineering Standards & Definition of Done

Applies to every change in `cross_platform_build/`. Keep fixes small and
well-scoped; preserve the existing Provider / `ChangeNotifier` architecture.

### Definition of Done — all must hold before a change is "done"
- [ ] `flutter analyze` is clean (no new warnings).
- [ ] `dart format .` has been applied.
- [ ] `flutter test` passes.
- [ ] Any change to business logic ships with a **unit test** — write it first (red), then make it pass (green).
- [ ] Any added/changed widget behavior ships with a **widget test**.
- [ ] Views never call `SharedPreferences` or HealthKit directly — persistence and device data stay behind manager actions.
- [ ] No leftover debug `print`/`debugPrint` on production paths; no secrets committed.

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
```

### Active Issue Backlog

**Evaluation report**: `lote-eval-report.html` — comprehensive audit of all views and managers.

**Fix Status (July 3, 2026)**: 20+ fixes applied across 2 sessions. Flutter analyze dropped from 284 → 2 issues.

**Completed high-priority fixes** (see `GEMINI.md` Current Project Status for details):
- Quest farming exploit patched (meal-delete reversal)
- Badge system wired (12/27 badges were unreachable)
- Null-safe fromJson on WeightEntry/PREntry
- Stand-time unit mismatch, weight-goal infinite faucet, PR keystroke spam
- Quest requiredMinutes, nutrition quest completion, monthly challenge reset
- Dashboard NaN guards, imperial unit labels, stat progression (6/6 stats)
- Levels 51-100 tiers added (4 new WarriorTier milestones)
- September challenge rebalanced (250k→150k steps)
- 275 deprecation warnings auto-fixed

**Remaining low-priority items**: overflow-prone dashboard rows, google_fonts bundling, unit rounding drift, state mutation in build(), accessibility, CI/CD, test coverage.

### Master List of Tickets to be Resolved

**Psychological Profiles & Onboarding**
- [ ] Differentiate UI/UX: Make the ADHD, AuDHD, Neurotypical, and Autism interfaces distinctly different and effective.
- [x] Rename the 4 profile types (e.g., Vanguard, Hunter, Warrior, Revenant).
- [ ] Differentiate motivation types and notification text between the 4 profile types.
- [ ] Allow swapping between the 4 profile types.
- [ ] Add a quiz for the 4 types to assist with auto-assignments.
- [x] Initial Quiz Additions: Ask for user's age to pull from that info later.
- [x] Body measurements should be optional for profile creation, not mandatory.
- [x] Make all goal and measurement boxes empty by default if they aren't pulling from HealthKit.
- [x] Identity Configuration: Change the "Home planet" input from a text box to a drop-down selector.

**Notifications & Scheduling**
- [ ] Notification System: Support consistent workout times for Neurotypical/Autistic, and flow schedules (morning/night) for ADHD/AuDHD.
- [ ] Week Tracker: Add a week tracker to input routines on specific days, schedule rest days, and tailor daily notifications accordingly.

**Workouts & Quests**
- [x] Stand Goal Tracking: Fix stand goal tracking (currently too slow; double check what it's actually doing). *Technical Note: In `health_manager.dart` line 125, it divides `totalStand` by 3600.0, assuming seconds, but Apple Stand Time is in minutes. This causes it to track 60x slower. Needs to be divided by 60.0 instead.*
- [x] Rep-Based Quests: Ensure rep-based workout quests (like pushups/squats) are actually reps/sets based, not time based.
- [x] Rename "Tailored suggested workouts" to "Workout Library".
- [ ] Workout Library updates: Needs customizable reps and sets, and needs to pull weight from HealthKit.
- [ ] Routine Creation: Allow users to create routines in the Workout Library (e.g., 1 set/10 rep pike pushup, followed by 2 set/5 reps standard pullups), log them, and complete them multiple times per day (fixes the empty label issue).
- [x] Back Workouts (Bodyweight): Ensure all back workouts in the bodyweight-only category actually require no equipment.
- [x] PRs: Add an "I don't know" option for PRs for those who have never lifted or done pull-ups.
- [ ] Weight Vest/Belt: Add an option to log when/how heavy a user is using a weight vest or weight belt for workouts, and adjust XP and coin accordingly.
- [x] Quests Page: Remove "Healthy food inventory" from the quests page (now handled by the feast log).
- [ ] Workout Goals: Allow users to set a specific advanced workout as a goal (e.g., Handstand, Dragon Flag, Muscle Up).
- [ ] Workout Progressions Engine: Map advanced workouts to a sequence of easier progressive prerequisite workouts (e.g., Pike Pushups -> Wall Handstand -> Handstand).
- [ ] Goal-Oriented Recommendations: Modify the suggested workouts and daily quests to recommend the necessary progressive steps to help the user achieve their active workout goal.

**Nutrition & Health**
- [ ] Feast Log: Allow saving particular meals for easy input (e.g., morning oatmeal custom meal for quick-logging).

**RPG & Gamification**
- [ ] D&D Stats Purpose: Add a purpose for the D&D stats (e.g., mock battles or a minigame involving the character).
- [x] Stat Curve Adjustment: Address the stat improvement curve so stats don't max out by level 10.
- [x] Gender Options: Restrict genders to male and female; remove "other" from suggested workouts.
---

## Qwen 3.6:27b Offloading Workflow

**Purpose**: Offload heavy/repetitive code generation to the user's local Ollama server running `qwen3.6:27b` to save Antigravity credits.

**CRITICAL**: Always set `"think": false` in the API request body. Without this, the model puts everything in a `thinking` field and returns an empty `response`.

**When to use Qwen**:
- Bulk repetitive code (e.g., generating 64 switch cases across 16 elements)
- Mechanical refactors (find-and-replace patterns)
- Game design suggestions (challenge rebalancing, name generation)
- Any task that would require 500+ tokens of boilerplate output

**When NOT to use Qwen**:
- Quick 1-5 line surgical fixes (overhead > savings)
- Fixes requiring deep file context understanding
- `dart fix --apply` can handle it (use that instead)

**Server**: `http://192.168.1.17:11434` — may need user to wake it up if unreachable.

See `GEMINI.md` → "Credit-Saving: Qwen 3.6:27b Offloading via Ollama" for full API pattern.

<!-- Trigger Xcode Cloud Webhook: 2026-07-02T14:20:00-05:00 -->

