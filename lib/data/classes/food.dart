import 'allergen.dart';

class Food {
  final String description;
  final Allergen allergen;

  const Food({required this.description, required this.allergen});

  factory Food.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('description') || !json.containsKey('allergen')) {
      throw const FormatException('Campos obrigatórios ausentes em Food');
    }

    final allergenJson = json['allergen'] as Map<String, dynamic>;
    final allergen = Allergen.fromJson(allergenJson);

    return Food(description: json['description'] as String, allergen: allergen);
  }

  Map<String, dynamic> toJson() => {
    'description': description,
    'allergen': allergen.toJson(),
  };

  Food copyWith({String? description, Allergen? allergen}) {
    return Food(
      description: description ?? this.description,
      allergen: allergen ?? this.allergen,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Food &&
      other.description == description &&
      other.allergen == allergen;

  @override
  int get hashCode => Object.hash(description, allergen);
}

Map<Allergen, List<Food>> groupFoodsByAllergen(List<Food> foods) {
  final Map<Allergen, List<Food>> grouped = {};

  for (final food in foods) {
    grouped.putIfAbsent(food.allergen, () => []).add(food);
  }

  return grouped;
}
