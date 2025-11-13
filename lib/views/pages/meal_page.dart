import 'package:carte_app/data/classes/allergen.dart';
import 'package:carte_app/data/classes/food.dart';
import 'package:carte_app/data/constants.dart';
import 'package:carte_app/views/widgets/widget_allergen_box.dart';
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
  final nameController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _available = false;
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _available = await _speech.initialize(
      onStatus: (s) => setState(() => _listening = s == 'listening'),
      onError: (e) => debugPrint('STT error: $e'),
    );
    setState(() {});
  }

  Future<void> _toggleListen() async {
    if (!_available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reconhecimento de voz indisponível')),
      );
      return;
    }

    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }

    await _speech.listen(
      onResult: (result) {
        nameController.text = result.recognizedWords;
        nameController.selection = TextSelection.fromPosition(
          TextPosition(offset: nameController.text.length),
        );
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      listenOptions: stt.SpeechListenOptions(
        cancelOnError: true,
        partialResults: true,
      ),
      localeId: null,
      onSoundLevelChange: (level) {},
    );

    setState(() => _listening = true);
  }

  @override
  void dispose() {
    nameController.dispose();
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = KColors.baseBg;
    const primary = KColors.mediumBlue;
    final mealCtrl = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetPageTitle(title: 'Meal'),
          WidgetMultilineTextInput(
            controller: mealCtrl,
            onMicPressed: () => _toggleListen(),
          ),
          const SizedBox(height: 32),

          WidgetAllergensBox(
            foods: mockFoods,
            order: mockAllergens, // opcional pra manter a ordem do mock
            label: "Detected allergens",
            height: 180, // ajuste fino do tamanho
          ),
          const SizedBox(height: 32),

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
                  fontSize: KFont.fontSizeButton,
                  fontFamily: KFont.fontFamilyButton,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final List<Allergen> mockAllergens = [
  Allergen(
    id: 'gluten',
    description: 'Glúten',
    iconName: 'restaurant',
    color: const Color(0xFFE57373), // vermelho claro
  ),
  Allergen(
    id: 'milk',
    description: 'Leite / Lactose',
    iconName: 'local_cafe',
    color: const Color(0xFF64B5F6), // azul claro
  ),
  Allergen(
    id: 'egg',
    description: 'Ovo',
    iconName: 'egg',
    color: const Color(0xFFFFD54F), // amarelo
  ),
  Allergen(
    id: 'peanut',
    description: 'Amendoim',
    iconName: 'no_food',
    color: const Color(0xFFF06292), // rosa
  ),
  Allergen(
    id: 'seafood',
    description: 'Frutos do mar',
    iconName: 'set_meal',
    color: const Color(0xFF4DD0E1), // ciano
  ),
  Allergen(
    id: 'soy',
    description: 'Soja',
    iconName: 'spa',
    color: const Color(0xFFA5D6A7), // verde claro
  ),
  Allergen(
    id: 'nuts',
    description: 'Oleaginosas (castanhas, nozes)',
    iconName: 'eco',
    color: const Color(0xFFBA68C8), // lilás
  ),
  Allergen(
    id: 'fish',
    description: 'Peixe',
    iconName: 'fish',
    color: const Color(0xFF81D4FA), // azul piscina
  ),
  Allergen(
    id: 'wheat',
    description: 'Trigo',
    iconName: 'grass',
    color: const Color(0xFFFFB74D), // laranja
  ),
  Allergen(
    id: 'sesame',
    description: 'Gergelim',
    iconName: 'grain',
    color: const Color(0xFFDCE775), // verde amarelado
  ),
];

final List<Food> mockFoods = [
  // GLÚTEN
  Food(
    description: 'Pão francês com manteiga',
    allergen: mockAllergens.firstWhere((a) => a.id == 'gluten'),
  ),
  Food(
    description: 'Macarrão à bolonhesa',
    allergen: mockAllergens.firstWhere((a) => a.id == 'gluten'),
  ),

  // LEITE / LACTOSE
  Food(
    description: 'Café com leite integral',
    allergen: mockAllergens.firstWhere((a) => a.id == 'milk'),
  ),
  Food(
    description: 'Queijo minas frescal',
    allergen: mockAllergens.firstWhere((a) => a.id == 'milk'),
  ),

  // OVO
  Food(
    description: 'Omelete com tomate e cebola',
    allergen: mockAllergens.firstWhere((a) => a.id == 'egg'),
  ),
  Food(
    description: 'Bolo de cenoura com cobertura de chocolate',
    allergen: mockAllergens.firstWhere((a) => a.id == 'egg'),
  ),

  // AMENDOIM
  Food(
    description: 'Paçoca caseira',
    allergen: mockAllergens.firstWhere((a) => a.id == 'peanut'),
  ),

  // FRUTOS DO MAR
  Food(
    description: 'Camarão ao alho e óleo',
    allergen: mockAllergens.firstWhere((a) => a.id == 'seafood'),
  ),
  Food(
    description: 'Sushi de polvo',
    allergen: mockAllergens.firstWhere((a) => a.id == 'seafood'),
  ),

  // SOJA
  Food(
    description: 'Molho shoyu tradicional',
    allergen: mockAllergens.firstWhere((a) => a.id == 'soy'),
  ),

  // CASTANHAS / NOZES
  Food(
    description: 'Mix de castanhas e nozes',
    allergen: mockAllergens.firstWhere((a) => a.id == 'nuts'),
  ),

  // PEIXE
  Food(
    description: 'Filé de salmão grelhado',
    allergen: mockAllergens.firstWhere((a) => a.id == 'fish'),
  ),

  // TRIGO
  Food(
    description: 'Biscoito de trigo integral',
    allergen: mockAllergens.firstWhere((a) => a.id == 'wheat'),
  ),

  // GERGELIM
  Food(
    description: 'Pão de hambúrguer com gergelim',
    allergen: mockAllergens.firstWhere((a) => a.id == 'sesame'),
  ),
];

IconData iconForAllergen(String id) {
  switch (id.toLowerCase()) {
    case 'gluten':
    case 'wheat':
      return Icons.spa_outlined; // grão/trigo

    case 'milk':
    case 'dairy':
      return Icons.local_drink_outlined; // copo de leite

    case 'egg':
      return Icons.egg_outlined; // ovo

    case 'peanut':
    case 'peanuts':
      return Icons.grain_outlined; // representa leguminosa

    case 'soy':
      return Icons.energy_savings_leaf_outlined; // planta de soja

    case 'seafood':
    case 'shellfish':
      return Icons.water_damage_outlined; // marisco

    case 'fish':
      return Icons.set_meal_outlined; // peixe

    case 'nuts':
    case 'tree nuts':
      return Icons.eco_outlined; // castanhas / nozes

    case 'sesame':
      return Icons.grass_outlined; // semente / gergelim

    default:
      return Icons.circle_outlined; // fallback genérico
  }
}
