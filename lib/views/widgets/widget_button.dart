import 'package:carte_app/data/constants.dart';
import 'package:flutter/material.dart';

class WidgetButton extends StatelessWidget {
  final VoidCallback onSubmit;
  const WidgetButton({super.key, required this.onSubmit});

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
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Food added (dummy action).')),
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
    );
  }
}
