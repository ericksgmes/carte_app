import 'package:carte_app/data/api/allergen_api.dart';
import 'package:carte_app/data/api/api_service.dart';
import 'package:carte_app/data/classes/allergen.dart';
import 'package:carte_app/data/constants.dart';
import 'package:carte_app/data/mocks.dart';
import 'package:carte_app/data/notifiers.dart';
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
  List<Allergen> _allergens = [];

  @override
  void initState() {
    super.initState();
    _loadAllergens();
  }

  Future<void> _loadAllergens() async {
    try {
      final api = AllergenApi(ApiService());
      final list = await api.fetchAll();
      if (!mounted) return;
      setState(() => _allergens = list);
    } catch (_) {
      if (!mounted) return;
      setState(() => _allergens = mockAllergens);
    }
  }

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
                const WidgetPageTitle(title: 'Food'),
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
                _allergens.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : WidgetAllergenPill(allergens: _allergens),
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
            child: WidgetButton(onSubmit: () => _onPressed(context)),
          ),
        ),
      ],
    );
  }

  void _onPressed(BuildContext context) {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o nome do alimento.')),
      );
      return;
    }

    final selected = selectedAllergens.value;
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione pelo menos um alérgeno.')),
      );
      return;
    }

    // O Food criado aqui pode ser usado pelo MealPage via estado global
    // Por ora, exibe confirmação — a integração com POST /api/meals
    // é feita na MealPage ao submeter a refeição completa.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alimento "$name" adicionado à refeição.')),
    );
    nameController.clear();
    selectedAllergens.value = {};
  }
}
