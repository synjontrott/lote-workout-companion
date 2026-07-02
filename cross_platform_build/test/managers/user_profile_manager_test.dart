import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

/// Manager-tier tests. These drive real [UserProfileManager] behavior against
/// a faked `SharedPreferences` store (no mocking framework required).
void main() {
  configureTestEnvironment();

  group('UserProfileManager hydration goal rounding (guideline #13)', () {
    test('metric goal snaps to the nearest 0.5 litres', () async {
      final m = await loadedProfileManager();

      m.waterIntakeGoal = 3.3;
      expect(m.waterIntakeGoal, 3.5);

      m.waterIntakeGoal = 3.2;
      expect(m.waterIntakeGoal, 3.0);
    });

    test('metric goal never drops below 0.5 litres', () async {
      final m = await loadedProfileManager();

      m.waterIntakeGoal = 0.1;
      expect(m.waterIntakeGoal, 0.5);
    });

    test('imperial goal snaps to the nearest 8 oz', () async {
      final m = await loadedProfileManager();

      m.waterIntakeGoalOz = 60; // -> 64 oz
      expect(m.waterIntakeGoalOz, 64.0);
    });
  });

  group('UserProfileManager streak recovery', () {
    test('spends 100 crystals and restores previous streak + 1', () async {
      final m = await loadedProfileManager();
      m.previousStreak = 5;
      m.crystals = 150;

      final recovered = m.recoverStreak();

      expect(recovered, isTrue);
      expect(m.streak, 6);
      expect(m.crystals, 50);
      expect(m.previousStreak, 0);
    });

    test('fails and spends nothing when the player cannot afford it', () async {
      final m = await loadedProfileManager();
      m.previousStreak = 5;
      m.crystals = 50;

      expect(m.recoverStreak(), isFalse);
      expect(m.crystals, 50);
      expect(m.streak, isNot(6));
    });

    test('fails when there is no previous streak to recover', () async {
      final m = await loadedProfileManager();
      m.previousStreak = 0;
      m.crystals = 500;

      expect(m.recoverStreak(), isFalse);
      expect(m.crystals, 500);
    });
  });
}
