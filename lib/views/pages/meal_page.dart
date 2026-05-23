import 'package:carte_app/data/api/allergen_api.dart';
import 'package:carte_app/data/api/api_service.dart';
import 'package:carte_app/data/api/meal_api.dart';
import 'package:carte_app/data/classes/allergen.dart';
import 'package:carte_app/data/classes/food.dart';
import 'package:carte_app/data/mocks.dart';
import 'package:carte_app/data/notifiers.dart';
import 'package:carte_app/views/widgets/widget_allergen_box.dart';
import 'package:carte_app/views/widgets/widget_button.dart';
import 'package:carte_app/views/widgets/widget_multiline_text_input.dart';
import 'package:carte_app/views/widgets/widget_page_title.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  final mealCtrl = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _available = false;
  bool _listening = false;
  bool _submitting = false;

  List<Allergen> _allergens = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadAllergens();
  }

  Future<void> _initSpeech() async {
    final available = await _speech.initialize(
      onStatus: (s) {
        if (!mounted) return;
        setState(() => _listening = s == 'listening');
      },
      onError: (e) {
        debugPrint('STT error: $e');
        if (!mounted) return;
        setState(() => _listening = false);
      },
    );
    if (!mounted) return;
    setState(() => _available = available);
  }

  Future<void> _loadAllergens() async {
    try {
      final api = AllergenApi(ApiService());
      final list = await api.fetchAll();
      if (!mounted) return;
      setState(() => _allergens = list);
    } catch (_) {
      // Fallback para mocks em caso de erro de conexão
      if (!mounted) return;
      setState(() => _allergens = mockAllergens);
    }
  }

  Future<void> _toggleListen() async {
    if (!_available) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reconhecimento de voz indisponível')),
      );
      return;
    }

    if (_listening) {
      await _speech.stop();
      if (!mounted) return;
      setState(() => _listening = false);
      return;
    }

    await _speech.listen(
      onResult: (result) {
        if (!mounted) return;
        mealCtrl.text = result.recognizedWords;
        mealCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: mealCtrl.text.length),
        );
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      listenOptions: stt.SpeechListenOptions(
        cancelOnError: true,
        partialResults: true,
      ),
    );

    if (!mounted) return;
    setState(() => _listening = true);
  }

  @override
  void dispose() {
    mealCtrl.dispose();
    _speech.stop();
    super.dispose();
  }

  /// Constrói a lista de Foods a partir do texto digitado e dos alérgenos selecionados.
  List<Food> _buildFoods() {
    final text = mealCtrl.text.trim();
    if (text.isEmpty) return [];

    // Divide por vírgula ou nova linha — cada item é um alimento separado
    final items = text
        .split(RegExp(r'[,\n]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final selected = selectedAllergens.value;
    final selectedAllergenObjects = _allergens
        .where((a) => selected.contains(a.id))
        .toList();

    return items.map((desc) => Food(
          description: desc,
          allergens: selectedAllergenObjects,
        )).toList();
  }

  Future<void> _onSubmit() async {
    final user = currentUserNotifier.value;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Faça login primeiro.')));
      return;
    }

    final foods = _buildFoods();
    if (foods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Descreva pelo menos um alimento.')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      final api = MealApi(ApiService());
      await api.createMeal(
        userId: user.id,
        date: DateTime.now(),
        foods: foods,
      );

      if (!mounted) return;
      mealCtrl.clear();
      selectedAllergens.value = {};
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Refeição registrada com sucesso!')),
      );
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

  @override
  Widget build(BuildContext context) {
    // Detecta alérgenos a partir dos alimentos já inseridos
    final foods = _buildFoods();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WidgetPageTitle(title: 'Meal'),
                WidgetMultilineTextInput(
                  controller: mealCtrl,
                  onMicPressed: _toggleListen,
                ),
                const SizedBox(height: 32),

                WidgetAllergensBox(
                  foods: foods,
                  order: _allergens,
                  label: "Detected allergens",
                  height: 180,
                ),
                const SizedBox(height: 32),
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
                : WidgetButton(onSubmit: _onSubmit),
          ),
        ),
      ],
    );
  }
}
