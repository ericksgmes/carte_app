import 'package:carte_app/data/constants.dart';
import 'package:carte_app/views/widgets/widget_horizontal_bar.dart';
import 'package:flutter/material.dart';

class WidgetPageTitle extends StatelessWidget {
  const WidgetPageTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: KFont.fontSizeMain,
              fontFamily: KFont.fontFamilyMain,
              color: Colors.black,
            ),
          ),
        ),
        WidgetHorizontalBar(primaryColor: KColors.primaryColor),
        const SizedBox(height: 28),
      ],
    );
  }
}
