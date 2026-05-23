import 'package:carte_app/data/classes/allergen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ── Fixtures ──────────────────────────────────────────────────────────────

  const baseJson = {
    'id': 'gluten',
    'description': 'Glúten',
    'iconName': 'restaurant',
    'colorHash': '#E57373',
  };

  const allergen = Allergen(
    id: 'gluten',
    description: 'Glúten',
    iconName: 'restaurant',
    color: Color(0xFFE57373),
  );

  // ── fromJson ──────────────────────────────────────────────────────────────

  group('Allergen.fromJson', () {
    test('parses all fields correctly', () {
      final result = Allergen.fromJson(baseJson);

      expect(result.id, 'gluten');
      expect(result.description, 'Glúten');
      expect(result.iconName, 'restaurant');
      expect(result.color, const Color(0xFFE57373));
    });

    test('defaults iconName to "help_outline" when absent', () {
      final json = {...baseJson}..remove('iconName');

      final result = Allergen.fromJson(json);

      expect(result.iconName, 'help_outline');
    });

    test('defaults color to black when colorHash is absent', () {
      final json = {...baseJson}..remove('colorHash');

      final result = Allergen.fromJson(json);

      expect(result.color, const Color(0xFF000000));
    });

    test('throws FormatException when "id" is missing', () {
      final json = {...baseJson}..remove('id');

      expect(() => Allergen.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when "description" is missing', () {
      final json = {...baseJson}..remove('description');

      expect(() => Allergen.fromJson(json), throwsA(isA<FormatException>()));
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────

  group('Allergen.toJson', () {
    test('serialises all fields', () {
      final json = allergen.toJson();

      expect(json['id'], 'gluten');
      expect(json['description'], 'Glúten');
      expect(json['iconName'], 'restaurant');
      expect(json['colorHash'], '#E57373'); // alpha stripped, # kept
    });

    test('round-trip fromJson→toJson→fromJson preserves values', () {
      final first = Allergen.fromJson(baseJson);
      final json = first.toJson();
      final second = Allergen.fromJson(json);

      expect(second.id, first.id);
      expect(second.description, first.description);
      expect(second.iconName, first.iconName);
      expect(second.color, first.color);
    });
  });

  // ── copyWith ──────────────────────────────────────────────────────────────

  group('Allergen.copyWith', () {
    test('overrides only the specified fields', () {
      final copy = allergen.copyWith(description: 'Gluten (modified)');

      expect(copy.id, allergen.id);
      expect(copy.description, 'Gluten (modified)');
      expect(copy.iconName, allergen.iconName);
      expect(copy.color, allergen.color);
    });

    test('returns equal object when no fields are overridden', () {
      final copy = allergen.copyWith();

      expect(copy.id, allergen.id);
      expect(copy.description, allergen.description);
    });

    test('can override every field', () {
      final copy = allergen.copyWith(
        id: 'milk',
        description: 'Leite',
        iconName: 'local_cafe',
        color: const Color(0xFF64B5F6),
      );

      expect(copy.id, 'milk');
      expect(copy.description, 'Leite');
      expect(copy.iconName, 'local_cafe');
      expect(copy.color, const Color(0xFF64B5F6));
    });
  });

  // ── equality & hashCode ───────────────────────────────────────────────────

  group('Allergen equality', () {
    test('two allergens with the same id are equal', () {
      const a = Allergen(id: 'egg', description: 'Ovo', iconName: 'egg', color: Colors.yellow);
      const b = Allergen(id: 'egg', description: 'Different', iconName: 'other', color: Colors.red);

      expect(a, equals(b));
    });

    test('allergens with different ids are not equal', () {
      const a = Allergen(id: 'egg', description: 'Ovo', iconName: 'egg', color: Colors.yellow);
      const b = Allergen(id: 'milk', description: 'Leite', iconName: 'local_cafe', color: Colors.blue);

      expect(a, isNot(equals(b)));
    });

    test('hashCode is based on id', () {
      const a = Allergen(id: 'soy', description: 'A', iconName: 'x', color: Colors.green);
      const b = Allergen(id: 'soy', description: 'B', iconName: 'y', color: Colors.red);

      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
