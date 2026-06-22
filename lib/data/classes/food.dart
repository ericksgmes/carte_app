import 'allergen.dart';

class Food {
  final int? id;
  final String description;
  final List<Allergen> allergens;

  const Food({this.id, required this.description, required this.allergens});

  /// Conveniência: retorna o primeiro alérgeno ou null.
  Allergen? get primaryAllergen =>
      allergens.isNotEmpty ? allergens.first : null;

  factory Food.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('description')) {
      throw const FormatException('Campos obrigatórios ausentes em Food');
    }

    final List<Allergen> allergens;

    if (json.containsKey('allergens') && json['allergens'] is List) {
      allergens = (json['allergens'] as List)
          .map((e) => Allergen.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (json.containsKey('allergen') && json['allergen'] is Map) {
      allergens = [Allergen.fromJson(json['allergen'] as Map<String, dynamic>)];
    } else {
      allergens = [];
    }

    return Food(
      id: json['id'] as int?,
      description: json['description'] as String,
      allergens: allergens,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'allergens': allergens.map((a) => a.toJson()).toList(),
      };

  Food copyWith({int? id, String? description, List<Allergen>? allergens}) {
    return Food(
      id: id ?? this.id,
      description: description ?? this.description,
      allergens: allergens ?? this.allergens,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Food &&
      other.id == id &&
      other.description == description &&
      _listEquals(other.allergens, allergens);

  @override
  int get hashCode => Object.hash(id, description, Object.hashAll(allergens));
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

Map<Allergen, List<Food>> groupFoodsByAllergen(List<Food> foods) {
  final Map<Allergen, List<Food>> grouped = {};

  for (final food in foods) {
    for (final allergen in food.allergens) {
      grouped.putIfAbsent(allergen, () => []).add(food);
    }
    // Se não tem alérgenos, não aparece em nenhum grupo
  }

  return grouped;
}
