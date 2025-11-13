import 'package:flutter/material.dart';
import 'package:carte_app/views/pages/food_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // usa só constraints, sem multiplicar por MediaQuery
        final maxWidth = constraints.maxWidth * 0.8; // ocupa até 80% da largura
        final targetWidth = maxWidth > 440 ? 440.0 : maxWidth;

        return Center(
          child: SizedBox(
            width: targetWidth,
            height: MediaQuery.sizeOf(context).height * 0.9,
            child: const AddFood(),
          ),
        );
      },
    );
  }
}
