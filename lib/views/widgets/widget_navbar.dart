import 'package:flutter/material.dart';
import 'package:carte_app/data/notifiers.dart';

class WidgetNavbar extends StatelessWidget {
  const WidgetNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, index, _) {
        return Container(
          height: 72,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.black12),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavIcon(
                icon: Icons.dinner_dining_outlined,
                selected: index == 0,
                onTap: () => selectedPageNotifier.value = 0,
              ),
              _NavIcon(
                icon: Icons.search,
                selected: index == 1,
                onTap: () => selectedPageNotifier.value = 1,
              ),
              _NavIcon(
                icon: Icons.lunch_dining_outlined,
                selected: index == 2,
                onTap: () => selectedPageNotifier.value = 2,
              ),
              _NavIcon(
                icon: Icons.person_outline,
                selected: index == 3,
                onTap: () => selectedPageNotifier.value = 3,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF659AB9) : Colors.black54;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Icon(icon, color: color, size: 28),
    );
  }
}
