import 'package:carte_app/data/api/allergen_api.dart';
import 'package:carte_app/data/api/api_service.dart';
import 'package:carte_app/data/api/food_api.dart';
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
  bool _submitting = false;

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
            child: _submitting
                ? const Center(child: CircularProgressIndicator())
                : WidgetButton(onSubmit: _onPressed, label: 'Add'),
          ),
        ),
      ],
    );
  }

  Future<void> _onPressed() async {
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

    final user = currentUserNotifier.value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login primeiro.')),
      );
      return;
    }

    final allergenIds = _allergens
        .where((a) => selected.contains(a.id))
        .map((a) => a.numericId)
        .where((id) => id != null && id > 0)
        .cast<int>()
        .toList();

    setState(() => _submitting = true);

    try {
      await FoodApi(ApiService()).createFood(
        userId: user.id,
        description: name,
        allergenIds: allergenIds,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$name" salvo com sucesso!')),
      );
      nameController.clear();
      selectedAllergens.value = {};
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ${e.statusCode}')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro de conexão: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
