import 'package:carte_app/data/api/api_service.dart';
import 'package:carte_app/data/api/symptom_api.dart';
import 'package:carte_app/data/notifiers.dart';
import 'package:carte_app/views/widgets/widget_time_input.dart';
import 'package:carte_app/views/widgets/widget_multiline_text_input.dart';
import 'package:carte_app/views/widgets/widget_page_title.dart';
import 'package:flutter/material.dart';

import '../widgets/widget_button.dart';

class SymptomPage extends StatefulWidget {
  const SymptomPage({super.key});

  @override
  State<SymptomPage> createState() => _SymptomPageState();
}

class _SymptomPageState extends State<SymptomPage> {
  TimeOfDay? symptomTime;
  final notesCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final user = currentUserNotifier.value;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Faça login primeiro.')));
      return;
    }

    final description = notesCtrl.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Descreva o sintoma.')),
      );
      return;
    }

    // Combina data de hoje com o horário selecionado (ou agora)
    final now = DateTime.now();
    final time = symptomTime ?? TimeOfDay.fromDateTime(now);
    final date = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    setState(() => _submitting = true);

    try {
      final api = SymptomApi(ApiService());
      await api.createSymptom(
        userId: user.id,
        description: description,
        date: date,
      );

      if (!mounted) return;
      notesCtrl.clear();
      setState(() => symptomTime = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sintoma registrado com sucesso!')),
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
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const WidgetPageTitle(title: 'Symptom'),
                const SizedBox(height: 24),

                WidgetTimeInput(
                  label: 'What time did it happen?',
                  onChanged: (t) => setState(() => symptomTime = t),
                ),
                const SizedBox(height: 24),
                WidgetMultilineTextInput(
                  controller: notesCtrl,
                  onMicPressed: () {},
                  label: 'Tell us what happened',
                  hint: '',
                  isThereVoiceInput: false,
                ),
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
