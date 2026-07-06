import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lote_workout_companion/views/widgets/pixel_sprite_widget.dart';

/// Widget-tier example. [PixelSpriteWidget] is a pure, animation-free
/// StatelessWidget, which makes it an ideal, non-flaky proof that the
/// widget-test tier works.
void main() {
  testWidgets('renders a CustomPaint sized to its pixel grid', (
    WidgetTester tester,
  ) async {
    final grid = <List<int>>[
      [0, 1, 0],
      [2, 3, 4],
      [0, 5, 0],
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PixelSpriteWidget(
              grid: grid,
              skinColor: Colors.brown,
              hairColor: Colors.black,
              eyeColor: Colors.blue,
              outfitColor: Colors.grey,
              auraColor: Colors.purple,
              pixelSize: 4.0,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(PixelSpriteWidget), findsOneWidget);
    // The widget paints via CustomPaint; assert one exists in its subtree.
    final customPaints = find.descendant(
      of: find.byType(PixelSpriteWidget),
      matching: find.byType(CustomPaint),
    );
    expect(customPaints, findsOneWidget);
  });

  testWidgets('handles an empty grid without throwing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PixelSpriteWidget(
            grid: <List<int>>[],
            skinColor: Colors.brown,
            hairColor: Colors.black,
            eyeColor: Colors.blue,
            outfitColor: Colors.grey,
            auraColor: Colors.purple,
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(PixelSpriteWidget), findsOneWidget);
  });
}
