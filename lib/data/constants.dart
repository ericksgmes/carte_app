import 'package:flutter/material.dart';

class KConstants {
  static const String isDarkMode = 'isDarkMode';
}

class KColors {
  static const Color baseBg = Color(0xFFFFFBEF);
  static const Color mediumBlue = Color(0xFF659AB9);
  static const Color darkBlue = Color(0xFF1F3A5F);
  static const Color lightBlue = Color(0xFFBFD7ED);
}

class KFont {
  static const String fontFamilyTitle = 'Montaga';
  static const String fontFamilyContent = 'Montserrat';
  static const String fontFamilyContentBold = 'Montserrat_Bold';
  static const String fontFamilyButton = 'Montserrat_Bold';
  static const double fontSizeTitle = 32;
  static const double fontSizeLabel = 16;
  static const double fontSizeContent = 14;
  static const double fontSizeButton = 18;
}

class KTextStyle {
  static const TextStyle titleBoldTeal = TextStyle(
    color: Colors.teal,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
}
