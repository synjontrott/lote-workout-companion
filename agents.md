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
- A comprehensive evaluation report has been compiled in `lote-eval-report.html`. This document and the user's newly reported requirements in `GEMINI.md` serve as the source of truth for upcoming fixes and features.

<!-- Trigger Xcode Cloud Webhook: 2026-07-02T14:07:07-05:00 -->

