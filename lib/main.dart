import 'package:flutter/material.dart';
import 'package:carte_app/data/notifiers.dart';
import 'package:carte_app/views/widget_tree.dart';

void main() {
  runApp(const CarteApp());
}

class CarteApp extends StatelessWidget {
  const CarteApp({super.key});

  @override
  Widget build(BuildContext context) {
    const baseBg = Color(0xFFFFFBEF);

    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        final theme = ThemeData(
          brightness: isDark ? Brightness.dark : Brightness.light,
          scaffoldBackgroundColor: isDark ? Colors.black : baseBg,
          fontFamily: 'Montserrat',
          appBarTheme: AppBarTheme(
            backgroundColor: isDark ? Colors.black : baseBg,
            elevation: 0,
            iconTheme: IconThemeData(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: const WidgetTree(),
        );
      },
    );
  }
}
