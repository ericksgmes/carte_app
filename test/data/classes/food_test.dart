import 'package:carte_app/data/classes/allergen.dart';
import 'package:carte_app/data/classes/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ── Fixtures ──────────────────────────────────────────────────────────────

  const glutenAllergen = Allergen(
    id: 'gluten',
    description: 'Glúten',
    iconName: 'restaurant',
    color: Color(0xFFE57373),
  );

  const milkAllergen = Allergen(
    id: 'milk',
    description: 'Leite',
    iconName: 'local_cafe',
    color: Color(0xFF64B5F6),
  );

  const bread = Food(description: 'Pão integral', allergen: glutenAllergen);

  // Returns a fresh deep copy each call so mutation in one test can't bleed
  // into another (e.g. the test that removes 'id' from the allergen map).
  Map<String, dynamic> allergenJson() => {
        'id': 'gluten',
        'description': 'Glúten',
        'iconName': 'restaurant',
        'colorHash': '#E57373',
      };

  Map<String, dynamic> foodJson({String description = 'Pão integral'}) => {
        'description': description,
        'allergen': allergenJson(),
      };

  // ── fromJson ──────────────────────────────────────────────────────────────

  group('Food.fromJson', () {
    test('parses description and nested allergen', () {
      final result = Food.fromJson(foodJson());

      expect(result.description, 'Pão integral');
      expect(result.allergen.id, 'gluten');
      expect(result.allergen.description, 'Glúten');
    });

    test('throws FormatException when "description" is missing', () {
      final json = foodJson()..remove('description');

      expect(() => Food.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when "allergen" is missing', () {
      final json = foodJson()..remove('allergen');

      expect(() => Food.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('propagates FormatException from Allergen when allergen fields missing', () {
      final badAllergen = allergenJson()..remove('id');
      final json = {'description': 'Pão integral', 'allergen': badAllergen};

      expect(() => Food.fromJson(json), throwsA(isA<FormatException>()));
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────

  group('Food.toJson', () {
    test('serialises description and nested allergen', () {
      final json = bread.toJson();

      expect(json['description'], 'Pão integral');
      expect((json['allergen'] as Map)['id'], 'gluten');
    });

    test('round-trip fromJson→toJson→fromJson preserves values', () {
      final first = Food.fromJson(foodJson());
      final second = Food.fromJson(first.toJson());

      expect(second.description, first.description);
      expect(second.allergen.id, first.allergen.id);
    });
  });

  // ── copyWith ──────────────────────────────────────────────────────────────

  group('Food.copyWith', () {
    test('overrides description only', () {
      final copy = bread.copyWith(description: 'Macarrão');

      expect(copy.description, 'Macarrão');
      expect(copy.allergen, glutenAllergen);
    });

    test('overrides allergen only', () {
      final copy = bread.copyWith(allergen: milkAllergen);

      expect(copy.description, bread.description);
      expect(copy.allergen, milkAllergen);
    });

    test('returns equivalent object when nothing is overridden', () {
      final copy = bread.copyWith();

      expect(copy.description, bread.description);
      expect(copy.allergen, bread.allergen);
    });
  });

  // ── equality & hashCode ───────────────────────────────────────────────────

  group('Food equality', () {
    test('same description and allergen → equal', () {
      const a = Food(description: 'Pão integral', allergen: glutenAllergen);
      const b = Food(description: 'Pão integral', allergen: glutenAllergen);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('different description → not equal', () {
      const a = Food(description: 'Pão integral', allergen: glutenAllergen);
      const b = Food(description: 'Macarrão', allergen: glutenAllergen);

      expect(a, isNot(equals(b)));
    });

    test('different allergen → not equal', () {
      const a = Food(description: 'Café', allergen: glutenAllergen);
      const b = Food(description: 'Café', allergen: milkAllergen);

      expect(a, isNot(equals(b)));
    });
  });

  // ── groupFoodsByAllergen ──────────────────────────────────────────────────

  group('groupFoodsByAllergen', () {
    test('returns empty map for empty list', () {
      final result = groupFoodsByAllergen([]);

      expect(result, isEmpty);
    });

    test('groups foods with the same allergen together', () {
      const pasta = Food(description: 'Macarrão', allergen: glutenAllergen);
      const result = [bread, pasta];

      final grouped = groupFoodsByAllergen(result);

      expect(grouped.keys, hasLength(1));
      expect(grouped[glutenAllergen], containsAll([bread, pasta]));
    });

    test('creates separate entries for different allergens', () {
      const milk = Food(description: 'Café com leite', allergen: milkAllergen);
      final foods = [bread, milk];

      final grouped = groupFoodsByAllergen(foods);

      expect(grouped.keys, hasLength(2));
      expect(grouped[glutenAllergen], contains(bread));
      expect(grouped[milkAllergen], contains(milk));
    });

    test('preserves insertion order within each group', () {
      const pasta = Food(description: 'Macarrão', allergen: glutenAllergen);
      final foods = [bread, pasta];

      final grouped = groupFoodsByAllergen(foods);

      expect(grouped[glutenAllergen]!.first.description, 'Pão integral');
      expect(grouped[glutenAllergen]!.last.description, 'Macarrão');
    });

    test('single food produces a map with one entry containing one item', () {
      final grouped = groupFoodsByAllergen([bread]);

      expect(grouped.keys, hasLength(1));
      expect(grouped[glutenAllergen], hasLength(1));
    });
  });
}
