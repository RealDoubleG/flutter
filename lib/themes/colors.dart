import 'package:flutter/material.dart';

class ThemeColors {
  static const Color primaryColorLight = Color(0xFF885FE4);
  static const Color primaryColorDark = Color(0XFF1D1D20);
  static const Color secundaryColorLight = Color(0XFFFFFFFF);
  static const Color terciaryColorLight = Color(0xFFF3F3F3);
  static const Color secundaryColorDark = Color(0xFF151519);
  static const Color terciaryColorDark = Color(0xFF313136);
  static const Color inputBorder = Color(0xFFD4D4D4);
}

class AppColors {
  static Color primaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? ThemeColors.primaryColorLight
        : ThemeColors.primaryColorDark;
  }

  static Color secundaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? ThemeColors.secundaryColorLight
        : ThemeColors.secundaryColorDark;
  }

  static Color terciaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? ThemeColors.terciaryColorLight
        : ThemeColors.terciaryColorDark;
  }

  static Color inputBorder() {
    return ThemeColors.inputBorder;
  }
}
