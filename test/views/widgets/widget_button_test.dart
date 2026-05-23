import 'package:carte_app/data/constants.dart';
import 'package:carte_app/views/widgets/widget_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps [child] in the minimum scaffold required for ElevatedButton and
/// ScaffoldMessenger to work correctly inside tests.
Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  group('WidgetButton', () {
    testWidgets('renders an ElevatedButton', (tester) async {
      await tester.pumpWidget(_wrap(WidgetButton(onSubmit: () {})));

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('displays the label "Add"', (tester) async {
      await tester.pumpWidget(_wrap(WidgetButton(onSubmit: () {})));

      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('stretches to full width', (tester) async {
      await tester.pumpWidget(_wrap(WidgetButton(onSubmit: () {})));

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(SizedBox),
        ).first,
      );

      expect(sizedBox.width, double.infinity);
      expect(sizedBox.height, 56);
    });

    testWidgets('has the correct background colour', (tester) async {
      await tester.pumpWidget(_wrap(WidgetButton(onSubmit: () {})));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final style = button.style!.backgroundColor!
          .resolve({}) as Color;

      expect(style, KColors.mediumBlue);
    });

    testWidgets('shows a SnackBar when tapped', (tester) async {
      await tester.pumpWidget(_wrap(WidgetButton(onSubmit: () {})));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // schedule SnackBar animation
      await tester.pump(const Duration(milliseconds: 300)); // finish animation

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Food added (dummy action).'), findsOneWidget);
    });
  });
}
