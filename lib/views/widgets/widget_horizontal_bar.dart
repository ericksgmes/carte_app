import 'package:flutter/material.dart';

class WidgetHorizontalBar extends StatelessWidget {
  const WidgetHorizontalBar({
    super.key,
    required this.primaryColor,
    this.opacity = 255,
    this.height = 4,
    this.bottomPadding = 24
  });

  final Color primaryColor;
  final int opacity;
  final double height;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, bottomPadding),
      child: Container(
        height: 4,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor.withAlpha(opacity),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    );
  }
}
