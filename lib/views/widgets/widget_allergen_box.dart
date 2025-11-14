import 'package:carte_app/views/widgets/widget_horizontal_bar.dart';
import 'package:flutter/material.dart';
import 'package:carte_app/data/classes/food.dart';
import 'package:carte_app/data/classes/allergen.dart';
import 'package:carte_app/data/constants.dart';

class WidgetAllergensBox extends StatelessWidget {
  final List<Food> foods;
  final List<Allergen>? order;

  final String label;
  final String hintWhenEmpty;
  final double height;

  const WidgetAllergensBox({
    super.key,
    required this.foods,
    this.order,
    this.label = "Detected allergens",
    this.hintWhenEmpty = "No allergens detected for this meal.",
    this.height = 180, // ajuste aqui o “tamanho etc”
  });

  @override
  Widget build(BuildContext context) {
    // final TextStyle labelStyle = TextStyle(
    //   fontFamily: KFont.fontFamilyContentMedium,
    //   fontSize: 16,
    // );

    return widgetList(foods);
  }
}

Map<Allergen, List<Food>> _groupFoodsByAllergen(List<Food> foods) {
  final Map<Allergen, List<Food>> grouped = {};
  for (final f in foods) {
    grouped.putIfAbsent(f.allergen, () => []).add(f);
  }
  return grouped;
}

IconData resolveIcon(String? name) {
  if (name == null) return Icons.help_outline;

  const map = <String, IconData>{
    'egg': Icons.egg,
    'milk': Icons.local_cafe,
    'gluten': Icons.restaurant,
    'peanut': Icons.no_food,
    'fish': Icons.set_meal,
    'grain': Icons.grain,
    'soy': Icons.soup_kitchen,
    'shellfish': Icons.lunch_dining,
    'tree_nut': Icons.nature,
    'sesame': Icons.bakery_dining,
  };

  return map[name] ?? Icons.help_outline;
}

Widget widgetList(List<Food> foods) {
  final grouped = _groupFoodsByAllergen(foods);
  final entries = grouped.entries.toList();

  return Container(
    height: 200,
    decoration: BoxDecoration(
      color: KColors.baseBg,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.black12),
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            _AllergenRow(allergen: entries[i].key, foods: entries[i].value),
            if (i != entries.length - 1) ...[
              const SizedBox(height: 14),
              WidgetHorizontalBar(
                primaryColor: KColors.mediumBlue,
                opacity: 120,
                height: 2,
                bottomPadding: 0,
              ),
              const SizedBox(height: 14),
            ],
          ],
        ],
      ),
    ),
  );
}

class _AllergenRow extends StatelessWidget {
  final Allergen allergen;
  final List<Food> foods;

  const _AllergenRow({required this.allergen, required this.foods});

  @override
  Widget build(BuildContext context) {
    final text = foods.map((f) => f.description).join(', ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: allergen.color.withAlpha(50),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            resolveIcon(allergen.id),
            color: allergen.color,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: KFont.fontSizeContent,
              fontFamily: KFont.fontFamilyContentMedium,
            ),
          ),
        ),
      ],
    );
  }
}
