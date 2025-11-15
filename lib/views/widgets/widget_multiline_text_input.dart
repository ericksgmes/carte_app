import 'package:carte_app/data/constants.dart';
import 'package:flutter/material.dart';

class WidgetMultilineTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final VoidCallback onMicPressed;
  final bool isThereVoiceInput;
  static void _noop() {}

  const WidgetMultilineTextInput({
    super.key,
    required this.controller,
    this.label = "Describe in simple words\nwhat you’ve eaten",
    this.hint = "Rice, carrots and chicken...",
    this.onMicPressed = _noop,
    this.isThereVoiceInput = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: KFont.fontFamilyContentMedium,
            fontSize: KFont.fontSizeLabel,
          ),
        ),
        const SizedBox(height: 8),

        SingleChildScrollView(
          child: Stack(
            children: [
              TextField(
                controller: controller,
                minLines: 5,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: hint,
                  filled: true,
                  fillColor: KColors.baseBg,
                  contentPadding: const EdgeInsets.fromLTRB(16, 16, 64, 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                ),
                scrollPhysics: BouncingScrollPhysics(),
                style: const TextStyle(
                  fontFamily: KFont.fontFamilyContentMedium,
                  fontSize: KFont.fontSizeContent,
                ),
              ),

              if (isThereVoiceInput)
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Material(
                    color: KColors.mediumBlue,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: onMicPressed,
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.mic, size: 20),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
