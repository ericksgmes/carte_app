import 'package:flutter/material.dart';

class WidgetNavbar extends StatelessWidget {
  const WidgetNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black12),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.home_outlined),
          Icon(Icons.search),
          Icon(Icons.add_box_outlined),
          Icon(Icons.person_outline),
        ],
      ),
    );
  }
}
