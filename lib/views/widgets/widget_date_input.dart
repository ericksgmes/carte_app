import 'package:carte_app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WidgetDateInput extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onChanged;

  const WidgetDateInput({
    super.key,
    required this.label,
    this.initialDate,
    this.onChanged,
  });

  @override
  State<WidgetDateInput> createState() => _WidgetDateInputState();
}

class _WidgetDateInputState extends State<WidgetDateInput> {
  final controller = TextEditingController();
  DateTime? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate;
    if (_selected != null) {
      controller.text = _formatDate(_selected!);
    }
  }

  @override
  void didUpdateWidget(covariant WidgetDateInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialDate != oldWidget.initialDate) {
      _selected = widget.initialDate;
      if (_selected != null) {
        controller.text = _formatDate(_selected!);
      } else {
        controller.clear();
      }
    }
  }

  String _formatDate(DateTime d) {
    return DateFormat('dd.MM.yyyy').format(d);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selected ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        // mantém o tema claro do app
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: KColors.mediumBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      _selected = picked;
      controller.text = _formatDate(picked);
    });

    widget.onChanged?.call(picked);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: KFont.fontSizeLabel,
            fontFamily: KFont.fontFamilyContentMedium,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: _pickDate,
          decoration: InputDecoration(
            filled: true,
            fillColor: KColors.baseBg,
            hintText: "Select date",
            suffixIcon: const Icon(Icons.calendar_today),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            hintStyle: const TextStyle(
              fontFamily: KFont.fontFamilyContentMedium,
              fontSize: KFont.fontSizeContent,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black26),
            ),
          ),
        ),
      ],
    );
  }
}
