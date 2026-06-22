import 'package:carte_app/data/api/api_service.dart';
import 'package:carte_app/data/api/food_api.dart';
import 'package:carte_app/data/api/meal_api.dart';
import 'package:carte_app/data/classes/food.dart';
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

  List<Food> _userFoods = [];
  List<Food> _matchedFoods = [];
  List<Food> _closestFoods = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadFoods();
    mealCtrl.addListener(_updateMatches);
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

  Future<void> _loadFoods() async {
    final user = currentUserNotifier.value;
    if (user == null) return;
    try {
      final foods = await FoodApi(ApiService()).fetchByUserId(user.id);
      if (!mounted) return;
      setState(() => _userFoods = foods);
      _updateMatches();
    } catch (_) {}
  }

  void _updateMatches() {
    final text = mealCtrl.text.toLowerCase();
    if (text.isEmpty) {
      setState(() {
        _matchedFoods = [];
        _closestFoods = [];
      });
      return;
    }

    final matched = _userFoods
        .where((f) => text.contains(f.description.toLowerCase()))
        .toList();

    List<Food> closest = [];
    if (matched.isEmpty) {
      closest = _computeClosest(text);
    }

    setState(() {
      _matchedFoods = matched;
      _closestFoods = closest;
    });
  }

  // Retorna a food com maior sobreposição de palavras com o texto digitado.
  // Ignora palavras com ≤ 2 caracteres para evitar falsos positivos ("de", "e").
  List<Food> _computeClosest(String text) {
    final inputWords = text
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 2)
        .toSet();

    if (inputWords.isEmpty) return [];

    Food? best;
    int bestScore = 0;

    for (final food in _userFoods) {
      final foodWords =
          food.description.toLowerCase().split(RegExp(r'\s+'));
      final score =
          foodWords.where((w) => inputWords.contains(w)).length;
      if (score > bestScore) {
        bestScore = score;
        best = food;
      }
    }

    return best != null ? [best] : [];
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
    mealCtrl.removeListener(_updateMatches);
    mealCtrl.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final user = currentUserNotifier.value;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Faça login primeiro.')));
      return;
    }

    final description = mealCtrl.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Descreva os alimentos da refeição.')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      final api = MealApi(ApiService());
      await api.createMeal(
        userId: user.id,
        date: DateTime.now(),
        description: description,
      );

      if (!mounted) return;
      mealCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Refeição registrada com sucesso!')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      final msg = e.statusCode == 422
          ? 'Nenhum alimento cadastrado corresponde à descrição.'
          : 'Erro ${e.statusCode}';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
                const SizedBox(height: 16),
                if (_matchedFoods.isNotEmpty) ...[
                  widgetList(_matchedFoods),
                  const SizedBox(height: 16),
                ] else if (_closestFoods.isNotEmpty) ...[
                  const Text(
                    'Sugestão mais próxima',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Opacity(
                    opacity: 0.6,
                    child: widgetList(_closestFoods),
                  ),
                  const SizedBox(height: 16),
                ],
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
                : WidgetButton(onSubmit: _onSubmit, label: 'Log'),
          ),
        ),
      ],
    );
  }
}
