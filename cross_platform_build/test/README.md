# Test harness

A deliberately **light** harness built on the Flutter SDK's built-in
`flutter_test` — no extra test dependencies, no mocking framework, no
`integration_test` (yet). See the "Engineering Standards & Definition of Done"
section in the repo-root `agents.md` for the rules every change must follow.

## Run

From `cross_platform_build/`:

```sh
flutter analyze
flutter test
```

## Layout

| Path                | Tier    | What it covers                                           |
| ------------------- | ------- | -------------------------------------------------------- |
| `test/models/`      | Unit    | Pure logic in `lib/models/` — quest generation, the 160-workout matrix, JSON round-trips. Fast, deterministic, no I/O. |
| `test/managers/`    | Unit    | `ChangeNotifier` behavior in `lib/managers/`, against faked persistence. |
| `test/widgets/`     | Widget  | Single-widget rendering with `flutter_test`.             |
| `test/regressions/` | Backlog | `skip:`-marked tests encoding **known, unfixed** bugs.   |
| `test/helpers/`     | Support | Shared setup: fake prefs, provider wrapper, font config. |

## Fakes, not mocks

- **Persistence** — `SharedPreferences.setMockInitialValues(...)` (via
  `seedPrefs` / `loadedProfileManager` in `helpers/test_helpers.dart`).
- **Device data** — `HealthManager.simulateActivity(...)`.
- Reach for constructor **dependency injection** before adding any mocking
  package.

## The regressions folder

`test/regressions/known_bugs_test.dart` is an executable backlog. Each test
encodes the *correct* behavior for a defect found in the Jul 2026 audit and is
marked `skip:` so CI stays green. **When you fix a bug, delete its `skip:`
argument** — the test becomes a permanent regression guard. Don't delete these.

## Deferred: end-to-end tests

True end-to-end coverage (`integration_test`, driving the app on a
device/simulator/browser) is a planned future tier. It is intentionally not set
up yet — add it when a real end-to-end flow needs coverage.
