import re

with open('lib/models/lote_models.dart', 'r') as f:
    content = f.read()

advanced_goal_enum = """
enum AdvancedWorkoutGoal {
  none,
  handstand,
  muscleUp,
  dragonFlag,
  pistolSquat,
  frontLever,
}

class WorkoutProgression {
  final AdvancedWorkoutGoal goal;
  final String title;
  final String description;
  final List<String> prerequisiteWorkoutIds;

  const WorkoutProgression({
    required this.goal,
    required this.title,
    required this.description,
    required this.prerequisiteWorkoutIds,
  });

  static const List<WorkoutProgression> all = [
    WorkoutProgression(
      goal: AdvancedWorkoutGoal.handstand,
      title: "Handstand Mastery",
      description: "Master the free-standing handstand.",
      prerequisiteWorkoutIds: [
        "pike_pushups_foundation",
        "wall_walk_handstand_hold_foundation",
        "wall_handstand_pushups_foundation",
        "freestanding_handstand_attempts_foundation"
      ],
    ),
    WorkoutProgression(
      goal: AdvancedWorkoutGoal.muscleUp,
      title: "Muscle Up",
      description: "The ultimate upper body pull and push combination.",
      prerequisiteWorkoutIds: [
        "pullups_foundation",
        "straight_bar_dips_foundation",
        "explosive_pullups_foundation",
        "muscle_up_negatives_foundation"
      ],
    ),
    WorkoutProgression(
      goal: AdvancedWorkoutGoal.dragonFlag,
      title: "Dragon Flag",
      description: "Bruce Lee's legendary core test.",
      prerequisiteWorkoutIds: [
        "lying_leg_raises_foundation",
        "hollow_body_hold_foundation",
        "dragon_flag_negatives_foundation",
        "full_dragon_flag_foundation"
      ],
    ),
    WorkoutProgression(
      goal: AdvancedWorkoutGoal.pistolSquat,
      title: "Pistol Squat",
      description: "The ultimate single-leg strength test.",
      prerequisiteWorkoutIds: [
        "bulgarian_split_squats_foundation",
        "assisted_pistol_squats_foundation",
        "pistol_squat_negatives_foundation",
        "full_pistol_squat_foundation"
      ],
    ),
    WorkoutProgression(
      goal: AdvancedWorkoutGoal.frontLever,
      title: "Front Lever",
      description: "A gravity-defying display of back and core strength.",
      prerequisiteWorkoutIds: [
        "tuck_front_lever_foundation",
        "advanced_tuck_front_lever_foundation",
        "straddle_front_lever_foundation",
        "full_front_lever_foundation"
      ],
    ),
  ];
}

class SuggestedWorkout {"""

content = content.replace('class SuggestedWorkout {', advanced_goal_enum)

with open('lib/models/lote_models.dart', 'w') as f:
    f.write(content)
