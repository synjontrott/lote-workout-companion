import 'package:flutter_test/flutter_test.dart';
import 'package:lote_workout_companion/models/lote_models.dart';

/// Guards GEMINI.md guideline #8: the static workout database must be a
/// complete, unique workout matrix. The original 8 muscle groups each have
/// 5 difficulties x 4 equipment types = 160 workouts. The flexibility muscle
/// group adds 5 bodyweight-only entries (one per difficulty), for 165 total.
void main() {
  const difficulties = {'Easy', 'Medium', 'Hard', 'Legend', 'Master'};
  const equipment = {'Bodyweight Only', 'Dumbbells', 'Full Gym', 'Pull-up Bar'};

  /// The 7 muscle groups that form the full 5x4 matrix.
  /// fullBody lost 5 bodyweight slots to flexibility.
  const matrixGroups = [
    MuscleGroup.chest,
    MuscleGroup.back,
    MuscleGroup.shoulders,
    MuscleGroup.arms,
    MuscleGroup.core,
    MuscleGroup.legs,
    MuscleGroup.cardio,
  ];

  group('SuggestedWorkout.allWorkouts matrix', () {
    final workouts = SuggestedWorkout.allWorkouts;

    test('contains the expected workout count', () {
      expect(MuscleGroup.values.length, 9);
      // 7 full-matrix groups × 20 + fullBody 15 + flexibility 5 = 160
      expect(workouts.length, 160);
    });

    test(
      'every (muscleGroup, difficulty, equipment) combination is unique',
      () {
        final combos = workouts
            .map((w) => '${w.muscleGroup.name}|${w.difficulty}|${w.equipment}')
            .toSet();
        expect(
          combos.length,
          workouts.length,
          reason: 'Duplicate workout combinations found',
        );
      },
    );

    test(
      'covers every muscle group x difficulty x equipment for the 8 matrix groups',
      () {
        for (final mg in matrixGroups) {
          for (final d in difficulties) {
            for (final e in equipment) {
              final matches = workouts.where(
                (w) =>
                    w.muscleGroup == mg &&
                    w.difficulty == d &&
                    w.equipment == e,
              );
              expect(
                matches.length,
                1,
                reason: 'Expected exactly one workout for ${mg.name}/$d/$e',
              );
            }
          }
        }
      },
    );

    test('flexibility group has one bodyweight entry per difficulty', () {
      for (final d in difficulties) {
        final matches = workouts.where(
          (w) =>
              w.muscleGroup == MuscleGroup.flexibility &&
              w.difficulty == d &&
              w.equipment == 'Bodyweight Only',
        );
        expect(
          matches.length,
          1,
          reason: 'Expected one flexibility workout at $d/Bodyweight Only',
        );
      }
    });

    test('uses only the canonical difficulty and equipment labels', () {
      expect(workouts.map((w) => w.difficulty).toSet(), difficulties);
      expect(workouts.map((w) => w.equipment).toSet(), equipment);
    });

    test('every workout has a unique id and non-empty details', () {
      expect(workouts.map((w) => w.id).toSet().length, workouts.length);
      for (final w in workouts) {
        expect(w.name.trim(), isNotEmpty);
        expect(w.instructions, isNotEmpty);
      }
    });
  });
}
