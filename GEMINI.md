# LotE Workout Companion - Agent Guidelines

## Project Overview
This project implements the **Legends of the Elsaither Workout Companion**, a premium fitness companion with D&D RPG gamification based on the LotE (Legends of the Elements) Universe. The app is implemented in two codebases:
1. **SwiftUI (Native iOS)** inside `LotE Workout Companion/`
2. **Flutter (Cross-Platform)** inside `cross_platform_build/`

## Core Architecture & Pillars
1. **HealthKit / Device Sync**: Retrieves steps, active energy (calories), active minutes (training time), and stand hours from the user's device/health app.
2. **RPG Progression**: User advances attributes (STR, DEX, CON, INT, WIS, CHA) and levels up from Recruit to Legend based on completed quests.
3. **Lore-Themed UI**: Adapts the background glow, primary accent colors, and custom element sprites dynamically depending on the selected LotE Element.
4. **Clinical Psychology Engine**: Determines user motivational profile (ADHD, Autistic, AuDHD, Neurotypical) to tailor the dashboards, quest delivery, and check-ins.

---

## The 4 Psychological Motivation Profiles

### ⚡ 1. ADHD Profile (Dopamine-Driven)
- **Mechanics**: High-novelty, immediate-reward.
- **UI/UX Widgets**:
  - **Dopamine Menu**: Quick 5-minute movement bursts (e.g. "Flame Dash" - 20 jumping jacks) with a clear instruction and confirmation modal.
  - **Variable Loot**: Randomly drops crystals or items upon completion.

### 🧩 2. Autistic Profile (Data-Driven Structure)
- **Mechanics**: Predictable routine, detailed statistics.
- **UI/UX Widgets**:
  - **Daily Fitness Performance Checklist**: Strict progress checking of daily quotas (Steps, Active Energy, Training Time, Stand Hours, Sugar Intake).
  - **Deep-Dive Analytics**: Advanced progression graphs showing exact metrics and stat curves.

### 🌀 3. AuDHD Profile (Structured Flexibility)
- **Mechanics**: Structured framework with flexible choices (combats demand avoidance).
- **UI/UX Widgets**:
  - **Wildcard Routines**: Flexible daily tasks (e.g., "Cardio Slot: Run or Cycle?").
  - **Optional Side Quests**: Bonus XP challenges that do not break streaks if skipped.

### ⚔️ 4. Neurotypical Profile (Habit Stacking)
- **Mechanics**: Progressive challenge mode, habit loops, classic streaks.
- **UI/UX Widgets**:
  - **Habit Stacking Logs**: Triggers exercise after a daily habit (e.g., "After morning coffee, stretch for 10 mins").

---

## Design System & Theme Mapping
- **Background**: Deep dark space color scheme (`#050505` / `#0a0a0a`).
- **Typography**: 
  - **Headings**: 'Orbitron' (all-caps, bold, tracked).
  - **Body / Labels**: 'Exo 2' / 'Exo2-Regular' (modern, high legibility).
- **Element Theme Colors**:
  - **Fire**: Red (`#FF1616`) / Orange (`#FF5E00`)
  - **Water**: Blue (`#00A3FF`) / Cyan (`#00E5FF`)
  - **Earth**: Green (`#4CAF50`) / Brown (`#795548`)
  - **Air**: Sky Blue (`#A5D6FF`) / White (`#F6F7FC`)
  - **Metal**: Silver (`#B0BEC5`) / Gold (`#FFD700`)
  - **Lightning**: Electric Blue (`#00F0FF`) / Neon Yellow (`#FFEA00`)
  - **Ice**: Frosty Teal (`#26C6DA`) / White (`#E0F7FA`)
  - **Bone**: Ivory (`#EEEEEE`) / Tan (`#D7CCC8`)
  - **Gas**: Mist Green (`#80CBC4`) / Lavender (`#E1BEE7`)
  - **Laser**: Cyber Pink (`#FF007F`) / Purple (`#7B1FA2`)
  - **Zero Space**: Deep Indigo (`#3F51B5`) / Magenta (`#E040FB`)
  - **Knife**: Plasma Blue (`#00E5FF`) / Dark Gray (`#37474F`)
  - **Poison**: Emerald (`#00E6 green`) / Purple (`#AA00FF`)
  - **Darki**: Burgundy (`#880E4F`) / Gold (`#FFB300`)
  - **Shadow**: Charcoal (`#263238`) / Violet (`#311B92`)
  - **Death**: Murky Purple (`#4A148C`) / Decay Gray (`#212121`)

### Sprite Power Flavors
Every character sprite in the dashboard is flanked by a floating power indicator:
- **Parallax Bobbing**: Utilizes opposite vertical bobbing relative to the main sprite to create floating physics.
- **Power Flavors**: 🔥 (Fire), 💧 (Water), 🪨 (Earth), 💨 (Air), ⚡ (Lightning), ⚙️ (Metal), 🧊 (Ice), 🦴 (Bone), 🌫️ (Gas), 🔴 (Laser), 🌀 (Zero Space), 🗡️ (Knife), 🧪 (Poison), 🔮 (Darki), 👻 (Shadow), 💀 (Death).

---

## Implementation Guidelines & Constraints

1. **Quest Adjective Variety**: Keep quest naming varied. Each element has 7 distinct adjectives (e.g. Laser uses *Beam, Photon, Arc, Reactor, Focus, Ray, Laser*). Select distinct adjectives inside loops to prevent name repetition on the same day.
2. **Keyboard Dismissal Toolbar**:
   - **iOS**: Views must be structurally contained inside a `NavigationView` (or `NavigationStack`) with hidden navigation bars so that `ToolbarItemGroup(placement: .keyboard)` Done buttons display correctly.
   - **Flutter**: Wrap number-pad `TextField` widgets with a suffix checkmark button (`Icons.check_circle_outline` or `Icons.check`) to allow keyboard dismissal on iOS devices.
3. **Dumbbell Workout Availability**: Dumbbell workouts must be explicitly defined in the SuggestedWorkout database for both platforms to support tailored resistance workouts.
4. **Metric Consistency**: Ensure the autistic dashboard checklist labels match the terminology of the "Elsaither Energy Core" and "Sugar Intake Tracker" exactly:
   - *Steps Taken*
   - *Active Energy*
   - *Training Time*
   - *Stand Hours*
   - *Sugar Intake*
5. **No Double Quests**: Ensure daily quest generation does not spawn two identical quests (e.g. one calisthenics workout category should map to exactly one quest in a day).
6. **300x300 High-Fidelity Character Sprites**: Character sprites are built on a detailed 300x300 pixel grid with dynamic proportions, natural facial features (slanted eyes placed on columns 134-166, lip lines), distinct hairstyles (spiky, long, mohawk, short crop), and custom physical planet armor structures (aerodynamic wraps for Ninjonia, chest vents/cables for Techno, heavy scale tassets/high neck shroud for Warrion).
7. **Suggested Workouts Muscle Group System**: Workouts are categorized directly by target `MuscleGroup` (Chest, Back, Shoulders, Arms, Core & Abs, Legs & Glutes, Full Body, Cardio & Conditioning) rather than high-level categories, and the `space` restriction has been removed.
8. **160-Workout Complete Matrix**: The static `SuggestedWorkout.allWorkouts` database contains a full 160-workout combination list (8 muscle groups * 5 difficulties * 4 equipment types) of real, detailed exercises, eliminating the need for generic "Custom X Builder" placeholders.
