import 'package:carte_app/data/constants.dart';
import 'package:flutter/material.dart';

class WidgetTextInput extends StatelessWidget {
  const WidgetTextInput({
    super.key,
    required this.controller,
    required this.inputName,
    required this.hintText,
  });

  final String inputName;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    const bg = KColors.baseBg;
    const primary = Color(0xFF659AB9);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          inputName,
          style: TextStyle(fontSize: 18, color: Color(0xFF1E1E1E)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: bg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF9C9898),
                width: 0.8,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primary, width: 1.2),
            ),
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
