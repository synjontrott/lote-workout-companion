# Agent Purpose

This repository contains the Legends of the Elsaither Workout Companion, primarily focused on the Flutter codebase inside `cross_platform_build/`. When working here, my purpose is to check that the code is clean, reliable, and aligned with `GEMINI.md`.

The native SwiftUI app inside `deprecated_swift_version/` has been deprecated and should not receive any new development. I should review the Flutter codebase for build health, runtime safety, persistence correctness, and whether the app actually supports the intended HealthKit/device sync, RPG progression, LotE element theming, profile-specific motivation flows, quest generation rules, keyboard dismissal behavior, workout availability, and metric naming.

Prefer small, well-scoped fixes that preserve the existing architecture. Keep persistence behind manager actions, avoid exposing internals just to satisfy a view, and verify changes with the available Flutter build or analysis tools whenever possible.

<!-- Trigger Xcode Cloud Webhook: 2026-07-02T09:32:00-05:00 -->


