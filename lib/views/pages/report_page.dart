import 'package:carte_app/data/api/api_service.dart';
import 'package:carte_app/data/api/report_api.dart';
import 'package:carte_app/data/constants.dart';
import 'package:carte_app/data/notifiers.dart';
import 'package:carte_app/views/widgets/widget_date_input.dart';
import 'package:carte_app/views/widgets/widget_page_title.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime? fromDate;
  DateTime? toDate;
  bool _loading = false;
  bool _exportLoading = false;
  ReportResult? _result;
  String? _error;

  Future<void> _generateReport() async {
    final user = currentUserNotifier.value;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Faça login primeiro.')));
      return;
    }

    setState(() {
      _loading = true;
      _result = null;
      _error = null;
    });

    try {
      final api = ReportApi(ApiService());
      final result = await api.getReport(
        userId: user.id,
        from: fromDate,
        to: toDate,
      );
      if (!mounted) return;
      setState(() => _result = result);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Erro ${e.statusCode}');
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Erro de conexão: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _exportReport() async {
    final user = currentUserNotifier.value;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Faça login primeiro.')));
      return;
    }

    setState(() => _exportLoading = true);

    try {
      final api = ReportApi(ApiService());
      final bytes = await api.exportReport(
        userId: user.id,
        from: fromDate,
        to: toDate,
      );
      await Printing.sharePdf(bytes: bytes, filename: 'carte-report.pdf');
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ${e.statusCode} ao exportar.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao exportar: $e')),
      );
    } finally {
      if (mounted) setState(() => _exportLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const WidgetPageTitle(title: 'Report'),
          const SizedBox(height: 32),

          WidgetDateInput(
            label: 'From',
            initialDate: fromDate,
            onChanged: (date) => setState(() => fromDate = date),
          ),
          const SizedBox(height: 24),

          WidgetDateInput(
            label: 'To',
            initialDate: toDate,
            onChanged: (date) => setState(() => toDate = date),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _RangeButton(
                  label: '7 days',
                  onTap: () {
                    setState(() {
                      toDate = DateTime.now();
                      fromDate =
                          DateTime.now().subtract(const Duration(days: 7));
                    });
                  },
                ),
              ),
              Expanded(
                child: _RangeButton(
                  label: '30 days',
                  onTap: () {
                    setState(() {
                      toDate = DateTime.now();
                      fromDate =
                          DateTime.now().subtract(const Duration(days: 30));
                    });
                  },
                ),
              ),
              Expanded(
                child: _RangeButton(
                  label: '90 days',
                  onTap: () {
                    setState(() {
                      toDate = DateTime.now();
                      fromDate =
                          DateTime.now().subtract(const Duration(days: 90));
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // GENERATE BUTTON
          SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: KColors.mediumBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: _loading ? null : _generateReport,
              child: _loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Generate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: KFont.fontSizeButton,
                        fontFamily: KFont.fontFamilyButton,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 32),

          // RESULTADO
          if (_error != null)
            Text(_error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center),

          if (_result != null) _buildSummary(_result!),

          const SizedBox(height: 32),

          // EXPORT BUTTON
          SizedBox(
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: KColors.darkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: _exportLoading ? null : _exportReport,
              child: _exportLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Export PDF',
                      style: TextStyle(
                        color: Colors.white,
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

  Widget _buildSummary(ReportResult result) {
    final topAllergens = result.allergenFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5Allergens = topAllergens.take(5).toList();

    final topSymptoms = result.symptomFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5Symptoms = topSymptoms.take(5).toList();

    final mealLabel =
        result.mealCount == 1 ? '1 meal logged' : '${result.mealCount} meals logged';
    final pairCount = result.pairs.length;
    final correlationLabel = pairCount == 0
        ? 'No symptom correlations found'
        : pairCount == 1
            ? '1 symptom correlation found'
            : '$pairCount symptom correlations found';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: KColors.mediumBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: KFont.fontFamilyContentMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            mealLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: KFont.fontFamilyContent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            correlationLabel,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontFamily: KFont.fontFamilyContent,
            ),
          ),
          const SizedBox(height: 18),

          if (top5Symptoms.isNotEmpty) ...[
            const Text(
              'Symptoms correlated',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: KFont.fontFamilyContentMedium,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: top5Symptoms
                  .map((e) => _AllergenChip(
                        label: '${e.key} (×${e.value})',
                        color: Colors.orange.shade100,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 18),
          ],

          if (top5Allergens.isNotEmpty) ...[
            const Text(
              'Top allergens',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: KFont.fontFamilyContentMedium,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: top5Allergens
                  .map((e) => _AllergenChip(label: e.key))
                  .toList(),
            ),
          ] else
            const Text(
              'No allergens found in the selected period.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
        ],
      ),
    );
  }
}

// --------------------------------------------
// RANGE BUTTON WIDGET
// --------------------------------------------
class _RangeButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _RangeButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFAED1DF),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: KFont.fontFamilyButton,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------
// ALLERGEN CHIP
// --------------------------------------------
class _AllergenChip extends StatelessWidget {
  final String label;
  final Color? color;

  const _AllergenChip({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: KFont.fontFamilyContentMedium,
          color: Colors.black87,
          fontSize: 13,
        ),
      ),
    );
  }
}
