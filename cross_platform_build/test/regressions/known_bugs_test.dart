import 'package:flutter_test/flutter_test.dart';
import 'package:lote_workout_companion/models/lote_models.dart';

/// Executable backlog of KNOWN, unfixed defects surfaced by the Jul 2026
/// codebase audit. Each test encodes the *correct* behaviour and is marked
/// `skip:` so CI stays green until the fix lands.
///
/// When you fix an underlying bug: remove the `skip:` argument. The test then
/// becomes a permanent regression guard. Do NOT delete these — un-skip them.
void main() {
  group('KNOWN BUG: generateQuests never sets requiredMinutes', () {
    // Audit 4562 (CRITICAL): every time-gated daily quest ships with
    // requiredMinutes == 0.0, so the completion check `duration >= 0` is
    // always true and quests auto-complete with zero activity.
    // Fix: pass requiredMinutes into the LotEQuest() built inside
    // generateQuests() (lib/models/lote_models.dart, daily branch ~line 1448).
    test('time-gated daily quests require a positive number of minutes', () {
      final quests = generateQuests(
        'Fire',
        const [
          TrainingFocus.cardio,
          TrainingFocus.calisthenics,
          TrainingFocus.lifting,
          TrainingFocus.flexibility,
        ],
        QuestCadence.daily,
      );

      final timeGated = quests.where((q) =>
          q.workoutType == WorkoutCategory.cardio ||
          q.workoutType == WorkoutCategory.strength ||
          q.workoutType == WorkoutCategory.flexibility);

      expect(timeGated, isNotEmpty);
      for (final q in timeGated) {
        expect(q.requiredMinutes, greaterThan(0),
            reason: 'Quest "${q.title}" auto-completes because '
                'requiredMinutes is ${q.requiredMinutes}');
      }
    }, /* FIXED Jul 2, 2026: generateQuests now sets requiredMinutes per type */);
  });

  group('KNOWN BUG: history entry fromJson wipes data on malformed records', () {
    // Audit 4567: WeightEntry/PREntry.fromJson use `(json[x] as num)` and
    // `DateTime.parse` with no null-guards, so a single corrupt record throws
    // and the caller's list-level try/catch discards the ENTIRE history.
    // Fix: null-harden both factories (lib/models/lote_models.dart ~L960/L4291)
    // and/or skip bad entries when decoding the list.
    test('WeightEntry.fromJson tolerates a missing weight', () {
      expect(
        () => WeightEntry.fromJson({'date': '2026-01-01T00:00:00.000'}),
        returnsNormally,
      );
    }, /* FIXED Jul 3, 2026: WeightEntry.fromJson is now null-safe */);

    test('PREntry.fromJson tolerates a missing date', () {
      expect(
        () => PREntry.fromJson({'value': 135.0}),
        returnsNormally,
      );
    }, /* FIXED Jul 3, 2026: PREntry.fromJson is now null-safe */);
  });

  group('KNOWN BUG: confirming the onboarding profile wipes progress', () {
    // Audit 4545: psych_evaluation_view._confirmProfile() calls
    // profile.resetProgress(), which zeroes level/XP/crystals/streak/PRs.
    // Re-running the quiz from Settings therefore destroys an existing
    // player's account.
    //
    // This needs a widget test that drives PsychEvaluationView and asserts a
    // returning user's progress is preserved. Tracked here as backlog.
    // See lib/views/psych_evaluation_view.dart:126.
    test('re-confirming a profile preserves earned progress', () {
      // Placeholder — implement once the confirm flow no longer resets, or
      // once the reset is gated to first-time onboarding only.
    }, skip: 'KNOWN BUG (audit 4545): _confirmProfile calls resetProgress()');
  });
}
