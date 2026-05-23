import 'package:carte_app/data/classes/allergen.dart';
import 'package:carte_app/data/notifiers.dart';
import 'package:carte_app/views/widgets/widget_allergen_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Fixtures ───────────────────────────────────────────────────────────────

const _gluten = Allergen(
  id: 'gluten',
  description: 'Glúten',
  iconName: 'restaurant',
  color: Color(0xFFE57373),
);

const _milk = Allergen(
  id: 'milk',
  description: 'Leite / Lactose',
  iconName: 'local_cafe',
  color: Color(0xFF64B5F6),
);

const _egg = Allergen(
  id: 'egg',
  description: 'Ovo',
  iconName: 'egg',
  color: Color(0xFFFFD54F),
);

// ── Helpers ────────────────────────────────────────────────────────────────

Widget _wrap(List<Allergen> allergens) => MaterialApp(
      home: Scaffold(
        body: WidgetAllergenPill(allergens: allergens),
      ),
    );

void main() {
  // Reset global notifier before every test so they stay independent.
  setUp(() {
    selectedAllergens.value = {};
  });

  group('WidgetAllergenPill', () {
    testWidgets('renders one InputChip per allergen', (tester) async {
      await tester.pumpWidget(_wrap([_gluten, _milk, _egg]));

      expect(find.byType(InputChip), findsNWidgets(3));
    });

    testWidgets('shows allergen descriptions as chip labels', (tester) async {
      await tester.pumpWidget(_wrap([_gluten, _milk]));

      expect(find.text('Glúten'), findsOneWidget);
      expect(find.text('Leite / Lactose'), findsOneWidget);
    });

    testWidgets('renders an empty container when allergen list is empty', (tester) async {
      await tester.pumpWidget(_wrap([]));

      expect(find.byType(InputChip), findsNothing);
    });

    testWidgets('tapping an unselected chip adds it to selectedAllergens', (tester) async {
      await tester.pumpWidget(_wrap([_gluten]));

      await tester.tap(find.text('Glúten'));
      await tester.pump();

      expect(selectedAllergens.value, contains('gluten'));
    });

    testWidgets('tapping a selected chip removes it from selectedAllergens', (tester) async {
      selectedAllergens.value = {'gluten'};

      await tester.pumpWidget(_wrap([_gluten]));

      // The delete icon (close) appears when the chip is selected.
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(selectedAllergens.value, isNot(contains('gluten')));
    });

    testWidgets('selected chips appear before unselected ones', (tester) async {
      selectedAllergens.value = {'egg'};

      await tester.pumpWidget(_wrap([_gluten, _milk, _egg]));
      await tester.pump();

      // The first chip in the Wrap should be the selected "Ovo".
      final chips = tester.widgetList<InputChip>(find.byType(InputChip)).toList();
      final firstLabel = (chips.first.label as Text).data;

      expect(firstLabel, 'Ovo');
    });

    testWidgets('multiple allergens can be selected simultaneously', (tester) async {
      await tester.pumpWidget(_wrap([_gluten, _milk]));

      await tester.tap(find.text('Glúten'));
      await tester.pump();
      await tester.tap(find.text('Leite / Lactose'));
      await tester.pump();

      expect(selectedAllergens.value, containsAll(['gluten', 'milk']));
    });
  });
}
