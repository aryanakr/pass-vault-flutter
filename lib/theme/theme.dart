import 'package:flutter/material.dart';
import 'package:pass_vault/theme/colors.dart';

class AppTheme {
  static ThemeData bulildLightThme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: deepPurple500,
        primaryVariant: purple400,
        secondary: cyan600,
        error: errorRed,
      ),
      scaffoldBackgroundColor: surfaceWhite,
    );
  }
  static ThemeData buildDarkTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: purple400,
        primaryVariant: deepPurple500,
        secondary: cyan600,
        error: errorRed,
      ),
    );
  }
}