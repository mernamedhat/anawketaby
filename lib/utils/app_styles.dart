import 'package:flutter/material.dart';

class AppStyles {
  static const String GE_SS_UNIQUE = "GE SS Unique";
  static const String RAKKAS = "Rakkas";
  static const String TAJAWAL = "Tajawal";

  static const Color PRIMARY_COLOR = Color(0xFF003867);
  static const Color SECONDARY_COLOR = Color(0xFFB02B1A);
  static const Color THIRD_COLOR = Color(0xFF00941E);
  static const Color SELECTION_COLOR = Color(0xFF0062B5);

  static const Color PRIMARY_COLOR_DARK = Color(0xFF002D53);
  static const Color SECONDARY_COLOR_DARK = Color(0xFF8D1809);
  static const Color THIRD_COLOR_DARK = Color(0xFF005411);
  static const Color SELECTION_COLOR_DARK = Color(0xFF004178);

  static const Color TEXT_PRIMARY_COLOR = Colors.white;
  static const Color TEXT_SECONDARY_COLOR = Colors.black;
  static const Color TEXT_THIRD_COLOR = Color(0xFF707070);

  static const Color TEXT_FIELD_HINT_COLOR = Color.fromARGB(255, 170, 178, 188);
  static const Color TEXT_FIELD_BACKGROUND_COLOR =
      Color.fromRGBO(0, 56, 103, .1);

  static const Color INACTIVE_COLOR = Color.fromRGBO(181, 204, 213, 1.0);

  static const Color BACKGROUND_COLOR = Color.fromRGBO(0, 56, 103, .4);

  static const Map<int, Color> _color = {
    50: Color.fromRGBO(0, 56, 103, .1),
    100: Color.fromRGBO(0, 56, 103, .2),
    200: Color.fromRGBO(0, 56, 103, .3),
    300: Color.fromRGBO(0, 56, 103, .4),
    400: Color.fromRGBO(0, 56, 103, .5),
    500: Color.fromRGBO(0, 56, 103, .6),
    600: Color.fromRGBO(0, 56, 103, .7),
    700: Color.fromRGBO(0, 56, 103, .8),
    800: Color.fromRGBO(0, 56, 103, .9),
    900: Color.fromRGBO(0, 56, 103, 1),
  };

  static const MaterialColor APP_MATERIAL_COLOR =
      MaterialColor(0xFF003867, _color);
}
