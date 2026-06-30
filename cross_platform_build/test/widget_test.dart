import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:lote_workout_companion/main.dart';
import 'package:lote_workout_companion/managers/health_manager.dart';
import 'package:lote_workout_companion/managers/user_profile_manager.dart';

void main() {
  testWidgets('LotE app mounts with providers', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProfileManager()),
          ChangeNotifierProvider(create: (_) => HealthManager()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pump();

    expect(find.text('WARRIOR ORIGINS'), findsOneWidget);
    expect(find.text('SELECT ELEMENTAL ALIGNMENT'), findsOneWidget);
  });
}
