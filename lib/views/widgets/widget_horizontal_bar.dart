import 'package:flutter/material.dart';

class WidgetHorizontalBar extends StatelessWidget {
  const WidgetHorizontalBar({super.key, required this.primaryColor});

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 24),
      child: Container(
        height: 4,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    );
  }
}
