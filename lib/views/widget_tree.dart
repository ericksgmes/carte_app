import 'package:carte_app/data/notifiers.dart';
import 'package:carte_app/views/pages/food_page.dart';
import 'package:carte_app/views/pages/home_page.dart';
import 'package:carte_app/views/widgets/widget_navbar.dart';
import 'package:flutter/material.dart';

List<Widget> pages = [HomePage()];

// return MaterialApp(
//               debugShowCheckedModeBanner: false,
//               theme: ThemeData(
//                 brightness: isDark ? Brightness.dark : Brightness.light,
//                 scaffoldBackgroundColor:
//                     isDark ? Colors.black : baseBg,
//                 fontFamily: 'Montserrat',
//                 appBarTheme: AppBarTheme(
//                   backgroundColor:
//                       isDark ? Colors.black : baseBg,
//                   elevation: 0,
//                   iconTheme: IconThemeData(
//                     color: isDark ? Colors.white : Colors.black,
//                   ),
//                 ),
//               ),

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [/* toggle dark, etc. */],
      ),
      bottomNavigationBar: const WidgetNavbar(),
      body: ValueListenableBuilder<int>(
        valueListenable: selectedPageNotifier,
        builder: (context, index, _) {
          switch (index) {
            case 0:
            default:
              return const AddFood(); // sem Scaffold aqui
          }
        },
      ),
    );
  }
}
