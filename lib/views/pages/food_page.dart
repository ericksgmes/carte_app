import 'package:carte_app/data/constants.dart';
import 'package:carte_app/views/widgets/widget_allergen_controller.dart';
import 'package:carte_app/views/widgets/widget_horizontal_bar.dart';
import 'package:carte_app/views/widgets/widget_page_title.dart';
import 'package:carte_app/views/widgets/widget_text_input.dart';
import 'package:flutter/material.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = KColors.baseBg;
    const primary = KColors.primaryColor;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetPageTitle(title: 'Food'),
          WidgetTextInput(
            controller: nameController,
            inputName: 'Name',
            hintText: 'Enter food name',
          ),
          const SizedBox(height: 32),
          const Text(
            'Allergen',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF1E1E1E),
              fontFamily: KFont.fontFamilyContent,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const WidgetAllergenController(),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Food added (dummy action).')),
                );
              },
              child: const Text(
                'Add',
                style: TextStyle(
                  color: bg,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 80), // respiro acima da navbar
        ],
      ),
    );
  }
}
