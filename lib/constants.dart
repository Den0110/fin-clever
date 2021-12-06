import 'package:flutter/material.dart';

class FinColor {
  static const MaterialColor mainColor = MaterialColor(
    0xFF08E0C2,
    <int, Color>{
      50: Color(0xFF08E0C2),
      100: Color(0xFF08E0C2),
      200: Color(0xFF08E0C2),
      300: Color(0xFF08E0C2),
      400: Color(0xFF08E0C2),
      500: Color(0xFF08E0C2),
      600: Color(0xFF08E0C2),
      700: Color(0xFF08E0C2),
      800: Color(0xFF08E0C2),
      900: Color(0xFF08E0C2),
    },
  );

  static const Color lightBlue = Color(0xFF04EBFA);
  static const Color darkBlue = Color(0xFF03314B);
  static const Color green = Color(0xFF34AA44);
  static const Color red = Color(0xFFE6492D);
  static const Color secondaryText = Color(0x66222222);
  static const Color iconBg = Color(0x1A000000);

  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[lightBlue, mainColor],
  );
}

class FinFont {
  static const light = TextStyle(fontWeight: FontWeight.w300);
  static const regular = TextStyle(fontWeight: FontWeight.w400);
  static const medium = TextStyle(fontWeight: FontWeight.w600);
  static const semibold = TextStyle(fontWeight: FontWeight.w700);
  static const bold = TextStyle(fontWeight: FontWeight.w800);
  static const extraBold = TextStyle(fontWeight: FontWeight.w900);
}

class FinDimen {
  static const vertical = 8.0;
  static const horizontal = 16.0;
  static const statusBarHeight = 36.0;

  static const buttonPadding = 64.0;
}
