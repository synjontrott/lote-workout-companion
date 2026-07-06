import 'package:flutter_test/flutter_test.dart';
import 'package:lote_workout_companion/models/lote_models.dart';

void main() {
  group('WarriorTier progression system', () {
    test('has exactly 10 tiers', () {
      expect(WarriorTier.values.length, 10);
    });

    test('tiers are ordered by levelRequired', () {
      final levels = WarriorTier.values.map((t) => t.levelRequired).toList();
      for (int i = 1; i < levels.length; i++) {
        expect(
          levels[i],
          greaterThan(levels[i - 1]),
          reason:
              '${WarriorTier.values[i].name} (Lv${levels[i]}) should be '
              'higher than ${WarriorTier.values[i - 1].name} (Lv${levels[i - 1]})',
        );
      }
    });

    test('every tier has a non-empty displayName', () {
      for (final tier in WarriorTier.values) {
        expect(
          tier.displayName.isNotEmpty,
          true,
          reason: '${tier.name} has empty displayName',
        );
      }
    });

    test('transcendent tier requires level 100', () {
      expect(WarriorTier.transcendent.levelRequired, 100);
    });

    test('recruit tier requires level 1', () {
      expect(WarriorTier.recruit.levelRequired, 1);
    });

    test('every tier has a non-empty description', () {
      for (final tier in WarriorTier.values) {
        expect(
          tier.description.isNotEmpty,
          true,
          reason: '${tier.name} has empty description',
        );
      }
    });

    test('dynamicDisplayName returns element-specific names for Fire', () {
      final fireName = WarriorTier.recruit.dynamicDisplayName('Fire');
      final waterName = WarriorTier.recruit.dynamicDisplayName('Water');
      expect(
        fireName,
        isNot(equals(waterName)),
        reason: 'Fire and Water should have different recruit names',
      );
    });

    test('dynamicDisplayName returns themed names for all 4 new tiers', () {
      for (final tier in [
        WarriorTier.champion,
        WarriorTier.sovereign,
        WarriorTier.mythic,
        WarriorTier.transcendent,
      ]) {
        final fireName = tier.dynamicDisplayName('Fire');
        expect(
          fireName.isNotEmpty,
          true,
          reason: '${tier.name} Fire should have a themed name',
        );
        expect(
          fireName,
          isNot(equals(tier.displayName)),
          reason:
              '${tier.name} Fire name should differ from default displayName',
        );
      }
    });

    test(
      'dynamicDisplayName falls back to displayName for unknown elements',
      () {
        for (final tier in WarriorTier.values) {
          expect(tier.dynamicDisplayName('UnknownElement'), tier.displayName);
        }
      },
    );
  });
}
