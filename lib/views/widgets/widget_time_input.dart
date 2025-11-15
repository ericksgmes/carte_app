import 'package:carte_app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WidgetTimeInput extends StatefulWidget {
  final String label;
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay>? onChanged;

  const WidgetTimeInput({
    super.key,
    required this.label,
    this.initialTime,
    this.onChanged,
  });

  @override
  State<WidgetTimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<WidgetTimeInput> {
  final controller = TextEditingController();
  TimeOfDay? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialTime ?? TimeOfDay.now();
    controller.text = _formatTime(_selected!);
  }

  String _formatTime(TimeOfDay t) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    return DateFormat.jm().format(dt);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selected ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      _selected = picked;
      controller.text = _formatTime(picked);
    });

    widget.onChanged?.call(picked);
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
          onTap: _pickTime,
          decoration: InputDecoration(
            filled: true,
            fillColor: KColors.baseBg,
            hintText: "Select time",
            suffixIcon: const Icon(Icons.access_time),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            hintStyle: TextStyle(
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
