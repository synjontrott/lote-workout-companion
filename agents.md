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

