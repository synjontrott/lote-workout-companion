import 'package:flutter_test/flutter_test.dart';
import 'package:lote_workout_companion/models/lote_models.dart';

/// Persistence correctness: quests and history entries survive a
/// toJson -> fromJson round-trip, and quest decoding is null-safe.
void main() {
  group('LotEQuest serialization', () {
    test('round-trips through toJson/fromJson preserving fields', () {
      final quest = LotEQuest(
        id: 'q1',
        title: 'Blazing Speed Patrol',
        questDescription: 'Complete a 15-minute run.',
        workoutType: WorkoutCategory.cardio,
        difficultyRoll: 12,
        rewardXP: 60,
        rewardCrystals: 20,
        statReward: StatType.dexterity,
        statValue: 1,
        cadence: QuestCadence.daily,
        progressCount: 0,
        targetCount: 1,
        requiredMinutes: 15.0,
      );

      final restored = LotEQuest.fromJson(quest.toJson());

      expect(restored.id, quest.id);
      expect(restored.title, quest.title);
      expect(restored.workoutType, quest.workoutType);
      expect(restored.statReward, quest.statReward);
      expect(restored.cadence, quest.cadence);
      expect(restored.targetCount, quest.targetCount);
      expect(restored.requiredMinutes, 15.0);
    });

    test('fromJson falls back to safe defaults on an empty map', () {
      final quest = LotEQuest.fromJson(<String, dynamic>{});
      expect(quest.id, '');
      expect(quest.workoutType, WorkoutCategory.cardio);
      expect(quest.statReward, StatType.strength);
      expect(quest.cadence, QuestCadence.daily);
      expect(quest.requiredMinutes, 0.0);
    });
  });

  group('WeightEntry / PREntry serialization (happy path)', () {
    test('WeightEntry round-trips date and weight', () {
      final entry = WeightEntry(date: DateTime(2026, 1, 15), weight: 82.5);
      final restored = WeightEntry.fromJson(entry.toJson());
      expect(restored.weight, 82.5);
      expect(restored.date, DateTime(2026, 1, 15));
    });

    test('PREntry round-trips date and value', () {
      final entry = PREntry(date: DateTime(2026, 1, 15), value: 135.0);
      final restored = PREntry.fromJson(entry.toJson());
      expect(restored.value, 135.0);
      expect(restored.date, DateTime(2026, 1, 15));
    });
  });
}
