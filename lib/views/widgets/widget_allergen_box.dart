import 'package:carte_app/views/widgets/widget_allergen_group.dart';
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
    final TextStyle labelStyle = TextStyle(
      fontFamily: KFont.fontFamilyContentMedium,
      fontSize: 16,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 8),

        // Caixa com altura fixa e scroll interno
        Container(
          decoration: BoxDecoration(
            color: KColors.baseBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: height,
              child: Scrollbar(
                radius: const Radius.circular(12),
                thumbVisibility: true,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                  child: foods.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            hintWhenEmpty,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : WidgetAllergensList(foods: foods),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
