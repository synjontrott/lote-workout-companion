import 'package:flutter_test/flutter_test.dart';
import 'package:lote_workout_companion/models/lote_models.dart';

/// Guards GEMINI.md guideline #1 (adjective variety) and #5 (no double quests):
/// daily generation must produce four distinct quests.
void main() {
  group('generateQuests', () {
    test('daily generation returns 4 unique quests', () {
      final quests = generateQuests('Fire', const [], QuestCadence.daily);

      expect(quests.length, 4);
      expect(quests.map((q) => q.id).toSet().length, 4);
      // Guideline #5: no two identical quests in a day.
      expect(quests.map((q) => q.title).toSet().length, 4,
          reason: 'Duplicate quest titles generated for a single day');
      for (final q in quests) {
        expect(q.cadence, QuestCadence.daily);
      }
    });

    test('respects an explicit focus and backfills to 4 unique quests', () {
      final quests = generateQuests(
        'Water',
        const [TrainingFocus.cardio],
        QuestCadence.daily,
      );

      expect(quests.length, 4);
      expect(quests.map((q) => q.title).toSet().length, 4);
    });

    test('monthly generation returns 2 quests tagged monthly', () {
      final quests = generateQuests('Earth', const [], QuestCadence.monthly);

      expect(quests.length, 2);
      for (final q in quests) {
        expect(q.cadence, QuestCadence.monthly);
      }
    });

    test('an unknown element still produces a full daily quest set', () {
      final quests =
          generateQuests('NotARealElement', const [], QuestCadence.daily);
      expect(quests.length, 4);
    });
  });
}
