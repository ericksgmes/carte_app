import 'package:carte_app/data/notifiers.dart';
import 'package:carte_app/views/pages/food_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<bool> _dark = isDarkModeNotifier;
  final ValueNotifier<Set<String>> _selectedAllergens =
      ValueNotifier<Set<String>>({'tree nuts'});

  @override
  void dispose() {
    _dark.dispose();
    _selectedAllergens.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth =
            constraints.maxWidth * MediaQuery.sizeOf(context).width * 0.8;
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
