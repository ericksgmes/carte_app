import 'package:carte_app/data/constants.dart';
import 'package:carte_app/views/widgets/widget_date_input.dart';
import 'package:carte_app/views/widgets/widget_page_title.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime? fromDate;
  DateTime? toDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const WidgetPageTitle(title: 'Report'),
          const SizedBox(height: 32),

          // FROM input
          WidgetDateInput(
            label: 'From',
            initialDate: fromDate,
            onChanged: (date) => setState(() => fromDate = date),
          ),
          const SizedBox(height: 24),

          // TO input
          WidgetDateInput(
            label: 'To',
            initialDate: toDate,
            onChanged: (date) => setState(() => toDate = date),
          ),
          const SizedBox(height: 24),

          // RANGE BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RangeButton(
                label: '7 days',
                onTap: () {
                  setState(() {
                    toDate = DateTime.now();
                    fromDate = DateTime.now().subtract(const Duration(days: 7));
                  });
                },
              ),
              _RangeButton(
                label: '30 days',
                onTap: () {
                  setState(() {
                    toDate = DateTime.now();
                    fromDate = DateTime.now().subtract(
                      const Duration(days: 30),
                    );
                  });
                },
              ),
              _RangeButton(
                label: '90 days',
                onTap: () {
                  setState(() {
                    toDate = DateTime.now();
                    fromDate = DateTime.now().subtract(
                      const Duration(days: 90),
                    );
                  });
                },
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Generating report...')),
                );
              },
              child: const Text(
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

          // RESULT BOX
          Container(
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

                const Text(
                  '57 meals logged',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: KFont.fontFamilyContent,
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Top occurrences',
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
                  children: const [
                    _TagChip(label: 'gluten'),
                    _TagChip(label: 'shellfish'),
                    _TagChip(label: 'peanuts'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // EXPORT BUTTON
          SizedBox(
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: KColors.mediumBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text(
                'Export',
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

// --------------------------------------------
// RANGE BUTTON WIDGET
// --------------------------------------------
class _RangeButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _RangeButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
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
      ),
    );
  }
}

// --------------------------------------------
// TAG CHIP (gluten, shellfish, peanuts)
// --------------------------------------------
class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.link, size: 16, color: Colors.black54),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: KFont.fontFamilyContentMedium,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
