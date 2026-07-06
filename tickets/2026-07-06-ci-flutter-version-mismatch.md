---
title: "Flutter CI pinned to a Dart SDK older than pubspec requires — pub get fails"
status: done
severity: high
category: "Build & CI"
created: 2026-07-06
completed: 2026-07-06
---

## Symptom

Every push to `main` fails CI at the "Install dependencies" step, so analyze and
tests never run and the pipeline gives no real signal. Failing since at least the
"Clean routine flow time text" commit.

## Repro

Push anything to `main` → GitHub Actions "Flutter CI" → the `flutter pub get`
step fails:

```
The current Dart SDK version is 3.8.1.
Because lote_workout_companion requires SDK version ^3.12.2, version solving failed.
* Try using the Flutter SDK version: 3.44.5.
```

## Root cause

`.github/workflows/flutter-ci.yml:23` pins `flutter-version: '3.32.2'`, which
bundles Dart `3.8.1`. `cross_platform_build/pubspec.yaml` requires Dart
`^3.12.2`, so dependency resolution fails before analyze/test. The pinned CI
toolchain drifted behind the SDK constraint the app now needs.

## Suggested fix

Bump `flutter-version` in the workflow to a release whose bundled Dart satisfies
`^3.12.2` (pub suggests `3.44.5`). Consider pinning by a constraint or using
`channel: stable` without a hard version so it tracks forward, and keep the CI
Flutter version in step with `pubspec.yaml`'s SDK constraint.

## Notes

Fix applied by bumping the workflow to `3.44.5`. This only unblocks dependency
resolution; `flutter analyze --no-fatal-infos` and `flutter test` then run for
real and may surface further issues to triage separately.
