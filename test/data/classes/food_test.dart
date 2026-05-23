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

  const bread = Food(
    description: 'Pão integral',
    allergens: [glutenAllergen],
  );

  // Retorna JSON no formato legado (allergen singular — compatibilidade)
  Map<String, dynamic> allergenJson() => {
        'id': 'gluten',
        'description': 'Glúten',
        'iconName': 'restaurant',
        'colorHash': '#E57373',
      };

  // Formato legado: allergen singular aninhado
  Map<String, dynamic> foodJsonLegacy({String description = 'Pão integral'}) =>
      {
        'description': description,
        'allergen': allergenJson(),
      };

  // Formato novo: allergens como lista
  Map<String, dynamic> foodJsonNew({String description = 'Pão integral'}) => {
        'description': description,
        'allergens': [allergenJson()],
      };

  // ── fromJson ──────────────────────────────────────────────────────────────

  group('Food.fromJson', () {
    test('parses description and nested allergen list (new format)', () {
      final result = Food.fromJson(foodJsonNew());

      expect(result.description, 'Pão integral');
      expect(result.allergens, hasLength(1));
      expect(result.allergens.first.id, 'gluten');
    });

    test('parses description and single allergen (legacy format)', () {
      final result = Food.fromJson(foodJsonLegacy());

      expect(result.description, 'Pão integral');
      expect(result.allergens, hasLength(1));
      expect(result.allergens.first.id, 'gluten');
    });

    test('returns empty allergens when neither allergen nor allergens present', () {
      final result = Food.fromJson({'description': 'Água'});

      expect(result.description, 'Água');
      expect(result.allergens, isEmpty);
    });

    test('throws FormatException when "description" is missing', () {
      final json = foodJsonNew()..remove('description');

      expect(() => Food.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('propagates FormatException from Allergen when allergen fields missing', () {
      final badAllergen = allergenJson()..remove('id');
      final json = {'description': 'Pão integral', 'allergens': [badAllergen]};

      expect(() => Food.fromJson(json), throwsA(isA<FormatException>()));
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────

  group('Food.toJson', () {
    test('serialises description and allergens list', () {
      final json = bread.toJson();

      expect(json['description'], 'Pão integral');
      expect((json['allergens'] as List).first['id'], 'gluten');
    });

    test('round-trip fromJson→toJson→fromJson preserves values (new format)', () {
      final first = Food.fromJson(foodJsonNew());
      final second = Food.fromJson(first.toJson());

      expect(second.description, first.description);
      expect(second.allergens.first.id, first.allergens.first.id);
    });
  });

  // ── primaryAllergen ───────────────────────────────────────────────────────

  group('Food.primaryAllergen', () {
    test('returns first allergen when list is not empty', () {
      expect(bread.primaryAllergen, equals(glutenAllergen));
    });

    test('returns null when allergens list is empty', () {
      const noAllergen = Food(description: 'Água', allergens: []);
      expect(noAllergen.primaryAllergen, isNull);
    });
  });

  // ── copyWith ──────────────────────────────────────────────────────────────

  group('Food.copyWith', () {
    test('overrides description only', () {
      final copy = bread.copyWith(description: 'Macarrão');

      expect(copy.description, 'Macarrão');
      expect(copy.allergens, bread.allergens);
    });

    test('overrides allergens only', () {
      final copy = bread.copyWith(allergens: [milkAllergen]);

      expect(copy.description, bread.description);
      expect(copy.allergens, [milkAllergen]);
    });

    test('returns equivalent object when nothing is overridden', () {
      final copy = bread.copyWith();

      expect(copy.description, bread.description);
      expect(copy.allergens, bread.allergens);
    });
  });

  // ── equality & hashCode ───────────────────────────────────────────────────

  group('Food equality', () {
    test('same description and allergens → equal', () {
      const a = Food(description: 'Pão integral', allergens: [glutenAllergen]);
      const b = Food(description: 'Pão integral', allergens: [glutenAllergen]);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('different description → not equal', () {
      const a = Food(description: 'Pão integral', allergens: [glutenAllergen]);
      const b = Food(description: 'Macarrão', allergens: [glutenAllergen]);

      expect(a, isNot(equals(b)));
    });

    test('different allergens → not equal', () {
      const a = Food(description: 'Café', allergens: [glutenAllergen]);
      const b = Food(description: 'Café', allergens: [milkAllergen]);

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
      const pasta =
          Food(description: 'Macarrão', allergens: [glutenAllergen]);
      const result = [bread, pasta];

      final grouped = groupFoodsByAllergen(result);

      expect(grouped.keys, hasLength(1));
      expect(grouped[glutenAllergen], containsAll([bread, pasta]));
    });

    test('creates separate entries for different allergens', () {
      const milk =
          Food(description: 'Café com leite', allergens: [milkAllergen]);
      final foods = [bread, milk];

      final grouped = groupFoodsByAllergen(foods);

      expect(grouped.keys, hasLength(2));
      expect(grouped[glutenAllergen], contains(bread));
      expect(grouped[milkAllergen], contains(milk));
    });

    test('food with multiple allergens appears in multiple groups', () {
      const combo = Food(
          description: 'Pão com manteiga',
          allergens: [glutenAllergen, milkAllergen]);
      final grouped = groupFoodsByAllergen([combo]);

      expect(grouped.keys, hasLength(2));
      expect(grouped[glutenAllergen], contains(combo));
      expect(grouped[milkAllergen], contains(combo));
    });

    test('food with no allergens does not appear in any group', () {
      const plain = Food(description: 'Água', allergens: []);
      final grouped = groupFoodsByAllergen([plain]);

      expect(grouped, isEmpty);
    });

    test('single food produces a map with one entry containing one item', () {
      final grouped = groupFoodsByAllergen([bread]);

      expect(grouped.keys, hasLength(1));
      expect(grouped[glutenAllergen], hasLength(1));
    });
  });
}
