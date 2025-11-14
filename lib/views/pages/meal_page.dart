import 'package:carte_app/data/constants.dart';
import 'package:carte_app/data/mocks.dart';
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
            order: mockAllergens,
            label: "Detected allergens",
            height: 180,
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

