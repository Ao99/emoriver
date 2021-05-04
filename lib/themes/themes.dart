import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:animations/animations.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData buildTheme() {
    final base = ThemeData.dark();
    return ThemeData(
      appBarTheme: AppBarTheme(brightness: Brightness.dark, elevation: 0),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ThemeColors.buttonColor,
        hoverColor: ThemeColors.buttonHoverColor,
      ),
      scaffoldBackgroundColor: ThemeColors.primaryBackground,
      primaryColor: ThemeColors.primaryBackground,
      focusColor: ThemeColors.focusColor,
      textTheme: _buildTextTheme(base.textTheme),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          color: ThemeColors.gray,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: ThemeColors.inputBackground,
        focusedBorder: InputBorder.none,
      ),
      visualDensity: VisualDensity.standard,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          for (var type in TargetPlatform.values)
            type: SharedAxisPageTransitionsBuilder(
              fillColor: ThemeColors.primaryBackground,
              transitionType: SharedAxisTransitionType.scaled,
            ),
        },
      ),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base
        .copyWith(
      bodyText2: GoogleFonts.robotoCondensed(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: _letterSpacingOrNone(0.5),
      ),
      bodyText1: GoogleFonts.eczar(
        fontSize: 40,
        fontWeight: FontWeight.w400,
        letterSpacing: _letterSpacingOrNone(1.4),
      ),
      button: GoogleFonts.robotoCondensed(
        fontWeight: FontWeight.w700,
        letterSpacing: _letterSpacingOrNone(2.8),
      ),
      headline5: GoogleFonts.eczar(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        letterSpacing: _letterSpacingOrNone(1.4),
      ),
    )
        .apply(
      displayColor: Colors.white,
      bodyColor: Colors.white,
    );
  }

  /// Using letter spacing in Flutter for Web can cause a performance drop,
  /// see https://github.com/flutter/flutter/issues/51234.
  static double _letterSpacingOrNone(double letterSpacing) =>
      kIsWeb ? 0.0 : letterSpacing;
}