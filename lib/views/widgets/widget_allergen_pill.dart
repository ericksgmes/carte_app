import 'package:carte_app/data/classes/allergen.dart';
import 'package:carte_app/data/constants.dart';
import 'package:carte_app/data/notifiers.dart';
import 'package:carte_app/views/widgets/widget_allergen_box.dart';
import 'package:flutter/material.dart';

class WidgetAllergenPill extends StatefulWidget {
  const WidgetAllergenPill({super.key, required this.allergens});

  final List<Allergen> allergens;

  @override
  State<WidgetAllergenPill> createState() => _WidgetAllergenPillState();
}

class _WidgetAllergenPillState extends State<WidgetAllergenPill> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: KColors.baseBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF9C9898)),
      ),
      constraints: const BoxConstraints(maxHeight: 200),
      child: ValueListenableBuilder<Set<String>>(
        valueListenable: selectedAllergens,
        builder: (context, selected, _) {
          final sorted = List<Allergen>.from(widget.allergens);

          sorted.sort((a, b) {
            final aSelected = selected.contains(a.id);
            final bSelected = selected.contains(b.id);

            if (aSelected && !bSelected) return -1;
            if (!aSelected && bSelected) return 1;

            return a.description.compareTo(b.description);
          });

          return SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sorted.map((allergen) {
                final id = allergen.id;
                final isSelected = selected.contains(id);

                return InputChip(
                  showCheckmark: false,
                  avatar: Icon(
                    resolveIcon(allergen.id),
                    size: 20,
                    color: isSelected ? Colors.black : Colors.grey[700],
                  ),
                  label: Text(
                    allergen.description,
                    style: TextStyle(
                      color: Colors.black.withValues(
                        alpha: isSelected ? 1.0 : 0.7,
                      ),
                      fontFamily: KFont.fontFamilyContentMedium,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w700,
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
                          selectedAllergens.value = {...selected}..remove(id);
                        }
                      : null,
                  onSelected: (v) {
                    final newSet = {...selected};
                    if (v) {
                      newSet.add(id);
                    } else {
                      newSet.remove(id);
                    }
                    selectedAllergens.value = newSet;
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
