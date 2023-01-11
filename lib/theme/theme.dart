import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pass_vault/theme/colors.dart';

class AppTheme {
  static ThemeData bulildLightThme = ThemeData.light().copyWith(
      colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: deepPurple500,
        primaryVariant: purple400,
        secondary: cyan600,
        error: errorRed,
      ),
      primaryColor: deepPurple500,
      scaffoldBackgroundColor: surfaceWhite,
    );
  
  static ThemeData buildDarkTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: purple400,
        primaryVariant: deepPurple500,
        secondary: cyan600,
        error: errorRed,
      ),
      primaryColor: deepPurple500,
    );
  }

  static CupertinoThemeData buildCupertinoTheme() {
    return const CupertinoThemeData(
      primaryColor: deepPurple500,
      primaryContrastingColor: purple400,
      scaffoldBackgroundColor: surfaceWhite,
    );
  }
}