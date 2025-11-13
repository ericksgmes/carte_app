import 'package:carte_app/views/pages/meal_page.dart';
import 'package:flutter/material.dart';
import 'package:carte_app/data/notifiers.dart';
import 'package:carte_app/views/pages/food_page.dart';
import 'package:carte_app/views/widgets/widget_navbar.dart';

final List<Widget> pages = [MealPage(), AddFood()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const WidgetNavbar(),
      body: ValueListenableBuilder<int>(
        valueListenable: selectedPageNotifier,
        builder: (context, index, _) {
          // evita index fora dos limites
          if (index < 0 || index >= pages.length) {
            return const Center(child: Text('Página não encontrada'));
          }
          return pages[index];
        },
      ),
    );
  }
}
