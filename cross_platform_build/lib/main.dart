import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'managers/user_profile_manager.dart';
import 'managers/health_manager.dart';
import 'models/lote_models.dart';
import 'views/psych_evaluation_view.dart';
import 'views/dashboard_view.dart';
import 'views/quest_board_view.dart';
import 'views/nutrition_view.dart';
import 'views/character_stats_view.dart';
import 'views/settings_view.dart';
import 'views/shop_view.dart';
import 'views/widgets/pixel_sprite_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProfileManager()),
        ChangeNotifierProvider(create: (_) => HealthManager()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LotE Workout Companion',
      theme: ThemeData.dark(),
      home: const MainHomeWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainHomeWrapper extends StatefulWidget {
  const MainHomeWrapper({super.key});

  @override
  State<MainHomeWrapper> createState() => _MainHomeWrapperState();
}

class _MainHomeWrapperState extends State<MainHomeWrapper> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    DashboardView(),
    QuestBoardView(),
    NutritionView(),
    CharacterStatsView(),
    ShopView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfileManager>(context);

    // Show a loading screen while profile loads from SharedPreferences
    if (!profile.isLoaded) {
      return const Scaffold(
        backgroundColor: Color(0xFF020617),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // If initial quiz is not completed, enforce evaluation view
    if (!profile.hasCompletedInitialQuiz) {
      return const PsychEvaluationView();
    }

    final themeColor = profile.currentElement.primaryColor;
    final skin = hexToColor(profile.sprite.skinColorHex);
    final hair = hexToColor(profile.sprite.hairColorHex);
    final outfit = hexToColor(profile.sprite.outfitColorHex);
    final eye = profile.currentElement.primaryColor;
    final aura = () {
      if (profile.equippedAura != "None") {
        switch (profile.equippedAura) {
          case "Glitch Aura": return const Color(0xFF00F0FF);
          case "Phoenix Flare": return Colors.orange;
          case "Abyssal Mist": return const Color(0xFF880E4F);
          case "Lightning Spark": return Colors.yellow;
          default: return profile.currentElement.accentColor;
        }
      } else {
        return profile.currentElement.accentColor;
      }
    }();

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: SafeArea(
        child: Column(
          children: [
            // Persistent RPG HUD Header
            GestureDetector(
              onTap: () {
                showActivityHistory(context, profile);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0F0F),
                  border: Border(
                    bottom: BorderSide(
                      color: themeColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeColor.withOpacity(0.1),
                      border: Border.all(color: themeColor.withOpacity(0.3), width: 1),
                    ),
                    child: ClipOval(
                      child: Transform.scale(
                        scale: 1.7,
                        child: PixelSpriteWidget(
                          grid: profile.sprite.pixelGrid,
                          skinColor: skin,
                          hairColor: hair,
                          eyeColor: eye,
                          outfitColor: outfit,
                          auraColor: aura,
                          pixelSize: 0.15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              profile.characterName.toUpperCase(),
                              style: GoogleFonts.orbitron(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              "LV. ${profile.currentLevel}",
                              style: GoogleFonts.orbitron(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Builder(
                          builder: (context) {
                            final nextLevelXP = profile.requiredXPForLevel(profile.currentLevel);
                            final progress = (profile.currentXP / nextLevelXP).clamp(0.0, 1.0);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.white.withOpacity(0.05),
                                    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                                    minHeight: 5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      profile.currentTier.dynamicDisplayName(profile.currentElement.name).toUpperCase(),
                                      style: TextStyle(fontSize: 7, color: themeColor, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${profile.currentXP} / ${nextLevelXP} XP",
                                      style: const TextStyle(fontSize: 7, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("💎", style: TextStyle(fontSize: 11)),
                        const SizedBox(width: 4),
                        Text(
                          "${profile.crystals}",
                          style: GoogleFonts.orbitron(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
            // Selected page view
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _views,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF0F0F0F),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: themeColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 9),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.terminal),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: "Quests",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "Feast Log",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.badge),
            label: "Warrior Sheet",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Armory",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: "Systems HUD",
          ),
        ],
      ),
    );
  }
}
