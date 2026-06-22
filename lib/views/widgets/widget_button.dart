import 'package:carte_app/data/constants.dart';
import 'package:flutter/material.dart';

class WidgetButton extends StatelessWidget {
  final VoidCallback onSubmit;
  final String label;

  const WidgetButton({
    super.key,
    required this.onSubmit,
    this.label = 'Save',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: KColors.mediumBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        onPressed: onSubmit,
        child: Text(
          label,
          style: const TextStyle(
            color: KColors.baseBg,
            fontSize: KFont.fontSizeButton,
            fontFamily: KFont.fontFamilyButton,
          ),
        ),
      ),
    );
  }
}
