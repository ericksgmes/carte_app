import 'package:flutter/material.dart';
import 'package:carte_app/data/classes/food.dart';
import 'package:carte_app/data/classes/allergen.dart';

class WidgetAllergensList extends StatelessWidget {
  final List<Food> foods;
  final List<Allergen>? order;

  const WidgetAllergensList({
    super.key,
    required this.foods,
    this.order,
  });

  IconData _resolveIcon(String name) {
    const map = {
      'egg': Icons.egg,
      'milk': Icons.local_cafe,
      'gluten': Icons.restaurant,
      'peanut': Icons.no_food,
      'fish': Icons.set_meal, // ajuste conforme seu set
      'help_outline': Icons.help_outline,
    };
    return map[name] ?? Icons.help_outline;
  }

  Map<Allergen, List<Food>> _groupFoodsByAllergen(List<Food> foods) {
    final Map<Allergen, List<Food>> grouped = {};
    for (final f in foods) {
      grouped.putIfAbsent(f.allergen, () => []).add(f);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupFoodsByAllergen(foods);

    // Determina a ordem de renderização dos grupos
    final allergensInOrder = order ??
        grouped.keys.toList()
          ..sort((a, b) => a.description.compareTo(b.description));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final allergen in allergensInOrder)
          if ((grouped[allergen] ?? const <Food>[]).isNotEmpty)
            _AllergenGroup(
              allergen: allergen,
              items: grouped[allergen]!,
              resolveIcon: _resolveIcon,
            ),
      ],
    );
  }
}

/// Um grupo (ícone + lista de foods + divisórias), como no print.
class _AllergenGroup extends StatelessWidget {
  final Allergen allergen;
  final List<Food> items;
  final IconData Function(String) resolveIcon;

  const _AllergenGroup({
    required this.allergen,
    required this.items,
    required this.resolveIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ícone do alérgeno
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: allergen.color.withOpacity(0.2), // caixa suave
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    resolveIcon(allergen.iconName),
                    size: 22,
                    color: allergen.color, // ícone na cor do alérgeno
                  ),
                ),
                const SizedBox(width: 12),
                // Descrição da comida
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      items[i].description,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
            // Linha divisória entre itens (não após o último)
            if (i != items.length - 1)
              Container(
                height: 3,
                margin: const EdgeInsets.only(left: 56, top: 10, bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFBFD7ED),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
