import 'package:carte_app/data/constants.dart';
import 'package:carte_app/data/mocks.dart';
import 'package:carte_app/views/widgets/widget_allergen_pill.dart';
import 'package:carte_app/views/widgets/widget_button.dart';
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
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    fontSize: KFont.fontSizeLabel,
                    fontFamily: KFont.fontFamilyContentMedium,
                  ),
                ),
                const SizedBox(height: 12),
                WidgetAllergenPill(allergens: mockAllergens),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 24, right: 24),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: WidgetButton(onSubmit: () => onPressed(context)),
          ),
        ),
      ],
    );
  }

  void onPressed(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Food added.')));
  }
}
