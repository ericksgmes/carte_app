import 'package:carte_app/data/classes/allergens.dart';
import 'package:carte_app/data/constants.dart';
import 'package:carte_app/data/notifiers.dart';
import 'package:flutter/material.dart';

class WidgetAllergenController extends StatefulWidget {
  const WidgetAllergenController({super.key});

  @override
  State<WidgetAllergenController> createState() =>
      _WidgetAllergenControllerState();
}

class _WidgetAllergenControllerState extends State<WidgetAllergenController> {
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _ensureLoaded();
  }

  Future<void> _ensureLoaded() async {
    // Se já carregou antes, não chama de novo
    if (allergensNotifier.value.isNotEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final api = Allergens(baseUrl: 'https://sua-api.com');
      final items = await api.fetchAllergens();
      if (mounted) {
        allergensNotifier.value = items;
      }
    } catch (e) {
      if (mounted) {
        _error = 'Error loading allergens';
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (_loading && allergensNotifier.value.isEmpty) {
    //   return const Padding(
    //     padding: EdgeInsets.all(12),
    //     child: CircularProgressIndicator(),
    //   );
    // }

    // if (_error != null && allergensNotifier.value.isEmpty) {
    //   return Padding(
    //     padding: const EdgeInsets.all(12),
    //     child: Text(_error!, style: const TextStyle(color: Colors.red)),
    //   );
    // }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: KColors.baseBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF9C9898), width: 0.8),
      ),
      constraints: const BoxConstraints(maxHeight: 200),
      child: ValueListenableBuilder<List<String>>(
        valueListenable: allergensNotifier,
        builder: (context, allergens, _) {
          final allergens = [
            'gluten',
            'crustaceans',
            'eggs',
            'fish',
            'peanuts',
            'soy',
            'milk',
            'tree nuts',
            'celery',
            'mustard',
            'sesame',
            'sulphites',
            'lupin',
            'molluscs',
            'strawberry',
            'kiwi',
            'banana',
            'apple',
            'corn',
            'beef',
            'chicken',
            'pork',
            'shellfish',
            'honey',
            'cocoa',
          ];

          return ValueListenableBuilder<Set<String>>(
            valueListenable: selectedAllergens,
            builder: (context, selected, __) {
              // Clona e ordena a lista
              final sorted = List<String>.from(allergens);
              sorted.sort((a, b) {
                final aSelected = selected.contains(a);
                final bSelected = selected.contains(b);

                // selecionados primeiro
                if (aSelected && !bSelected) return -1;
                if (!aSelected && bSelected) return 1;

                // ordem alfabética dentro do grupo
                return a.compareTo(b);
              });

              return Scrollbar(
                thumbVisibility: true,
                radius: const Radius.circular(10),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: sorted.map((a) {
                      final isSelected = selected.contains(a);

                      return InputChip(
                        avatar: Icon(
                          _iconForAllergen(a),
                          size: 18,
                          color: isSelected ? Colors.black : Colors.grey[700],
                        ),
                        label: Text(
                          a,
                          style: TextStyle(
                            color: Colors.black.withValues(
                              alpha: isSelected ? 1.0 : 0.7,
                            ),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFFB3F9BB),
                        backgroundColor: KColors.baseBg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF228F35)
                                : Colors.black.withValues(alpha: 0.2),
                          ),
                        ),
                        deleteIcon: isSelected
                            ? const Icon(Icons.close, size: 18)
                            : null,
                        onDeleted: isSelected
                            ? () {
                                selectedAllergens.value = {...selected}
                                  ..remove(a);
                              }
                            : null,
                        onSelected: (v) {
                          final newSet = {...selected};
                          if (v) {
                            newSet.add(a);
                          } else {
                            newSet.remove(a);
                          }
                          selectedAllergens.value = newSet;
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

IconData _iconForAllergen(String a) {
  switch (a) {
    case 'tree nuts':
      return Icons.eco_outlined;
    case 'gluten':
      return Icons.spa_outlined;
    case 'fish':
      return Icons.set_meal_outlined;
    case 'dairy':
      return Icons.local_drink_outlined;
    case 'shellfish':
      return Icons.water_damage_outlined;
    case 'peanuts':
      return Icons.grain_outlined;
    case 'soy':
      return Icons.energy_savings_leaf_outlined;
    case 'chicken':
      return Icons.oil_barrel_outlined;
    default:
      return Icons.circle_outlined;
  }
}
