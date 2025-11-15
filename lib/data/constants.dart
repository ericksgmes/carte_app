import 'package:flutter/material.dart';

class KConstants {
  static const String isDarkMode = 'isDarkMode';
}

class KColors {
  static const Color baseBg = Color(0xFFFFFBEF);
  static const Color mediumBlue = Color(0xFF659AB9);
  static const Color darkBlue = Color(0xFF1F3A5F);
  static const Color lightBlue = Color(0xFFBFD7ED);
  static const Color darkGray = Color(0xFF1E1E1E);
}

class KFont {
  static const String fontFamilyTitle = 'Montaga';
  static const String fontFamilyContent = 'Montserrat';
  static const String fontFamilyContentMedium = 'Montserrat_Medium';
  static const String fontFamilyButton = 'Montserrat_Bold';
  static const double fontSizeTitle = 34;
  static const double fontSizeLabel = 18;
  static const double fontSizeContent = 16;
  static const double fontSizeButton = 20;
}

class KTextStyle {
  static const TextStyle titleBoldTeal = TextStyle(
    color: Colors.teal,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
}
