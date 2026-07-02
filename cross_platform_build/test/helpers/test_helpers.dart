import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lote_workout_companion/managers/health_manager.dart';
import 'package:lote_workout_companion/managers/user_profile_manager.dart';

/// Shared setup for the widget/manager tests.
///
/// The harness is deliberately "light": it uses only the SDK's built-in
/// `flutter_test` plus fakes — no mocking framework, no `integration_test`.
///  - Persistence is faked with [SharedPreferences.setMockInitialValues].
///  - Device data is faked with [HealthManager.simulateActivity].
///  - Google Fonts runtime fetching is disabled so widget tests never touch
///    the network (which would make them slow and flaky).

/// Call once at the top of a test file's `main()` when the test touches
/// `SharedPreferences` or renders widgets.
void configureTestEnvironment() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
}

/// Seed `SharedPreferences` with [values] (empty by default) so managers that
/// call `SharedPreferences.getInstance()` read a clean, controlled store.
void seedPrefs([Map<String, Object> values = const {}]) {
  SharedPreferences.setMockInitialValues(values);
}

/// Build a [UserProfileManager] and wait for its async `_load()` to settle, so
/// tests observe a fully-initialised manager. The constructor kicks off an
/// un-awaited `_load()`; without this drain, assertions can race the load.
Future<UserProfileManager> loadedProfileManager([
  Map<String, Object> prefs = const {},
]) async {
  seedPrefs(prefs);
  final manager = UserProfileManager();
  await pumpEventQueue();
  return manager;
}

/// Wrap [child] in the same provider scope the real app uses, so widgets that
/// read [UserProfileManager] / [HealthManager] via `Provider` work in tests.
Widget wrapWithProviders({
  required Widget child,
  required UserProfileManager profile,
  required HealthManager health,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProfileManager>.value(value: profile),
      ChangeNotifierProvider<HealthManager>.value(value: health),
    ],
    child: MaterialApp(home: child),
  );
}
