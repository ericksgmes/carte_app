import 'package:carte_app/data/constants.dart';
import 'package:carte_app/views/widgets/widget_time_input.dart';
import 'package:carte_app/views/widgets/widget_multiline_text_input.dart';
import 'package:carte_app/views/widgets/widget_page_title.dart';
import 'package:flutter/material.dart';

class SymptomPage extends StatefulWidget {
  const SymptomPage({super.key});

  @override
  State<SymptomPage> createState() => _SymptomPageState();
}

class _SymptomPageState extends State<SymptomPage> {
  TimeOfDay? symptomTime;
  final notesCtrl = TextEditingController();

  @override
  void dispose() {
    notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const WidgetPageTitle(title: 'Symptom'),
          const SizedBox(height: 24),

          WidgetTimeInput(
            label: 'What time did it happen?',
            onChanged: (t) => symptomTime = t,
          ),
          const SizedBox(height: 24),
          WidgetMultilineTextInput(
            controller: notesCtrl,
            onMicPressed: () {},
            label: 'Tell us what happened',
            hint: '',
            isThereVoiceInput: false,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: KColors.mediumBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Symptom added (dummy action).'),
                  ),
                );
              },
              child: const Text(
                'Add',
                style: TextStyle(
                  color: KColors.baseBg,
                  fontSize: KFont.fontSizeButton,
                  fontFamily: KFont.fontFamilyButton,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
