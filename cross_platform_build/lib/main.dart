import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'managers/user_profile_manager.dart';
import 'managers/health_manager.dart';
import 'views/psych_evaluation_view.dart';
import 'views/dashboard_view.dart';
import 'views/quest_board_view.dart';
import 'views/character_stats_view.dart';
import 'views/settings_view.dart';

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
      title: 'Legends of the Elsaither Workout Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF050505),
        primaryColor: const Color(0xFFFF1616),
      ),
      home: const MainHomeWrapper(),
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
    CharacterStatsView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfileManager>(context);

    // If initial quiz is not completed, enforce evaluation view
    if (!profile.hasCompletedInitialQuiz) {
      return const PsychEvaluationView();
    }

    final accentColor = profile.currentElement.primaryColor;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
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
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
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
            icon: Icon(Icons.badge),
            label: "Warrior Sheet",
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
