import 'package:flutter/material.dart';

class AppTheme {

  // =============================
  // COLOR PALETTE
  // =============================

  static const Color primary = Color(0xFFB89261);

  /// Light Mode
  static const Color bgLight = Color(0xFFF2F2F2);
  static const Color textLight = Color(0xFF171511);
  static const Color borderLight = Color(0xFFE1DCD6);

  /// Dark Mode
  static const Color bgDark = Color(0xFF1D1915);
  static const Color textDark = Color(0xFFFBFAF9);
  static const Color borderDark = Color(0xFF3A352E);

  // =============================
  // LIGHT THEME
  // =============================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      scaffoldBackgroundColor: bgLight,

      colorScheme: const ColorScheme.light(
        primary: primary,
        surface: Colors.white,
        onSurface: textLight,
        outline: borderLight,
        onPrimary: Colors.white,
      ),

      // -------------------------
      // APP BAR
      // -------------------------
      appBarTheme: const AppBarTheme(
        backgroundColor: bgLight,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: false,
      ),

      // -------------------------
      // CARD
      // -------------------------
      cardTheme:  const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),

      // -------------------------
      // DIVIDER
      // -------------------------
      dividerTheme: const DividerThemeData(
        thickness: 0.6,
        space: 1,
        color: borderLight,
      ),

      // -------------------------
      // TYPOGRAPHY
      // -------------------------
      textTheme: const TextTheme(

        /// ARTICLE TITLE
        headlineLarge: TextStyle(
          fontFamily: 'Lora',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: textLight,
        ),

        headlineMedium: TextStyle(
          fontFamily: 'Lora',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.25,
          color: textLight,
        ),

        /// BODY TEXT
        bodyLarge: TextStyle(
          fontFamily: 'WorkSans',
          fontSize: 20,
          height: 1.45,
          color: textLight,
        ),

        bodyMedium: TextStyle(
          fontFamily: 'WorkSans',
          fontSize: 16,
          height: 1.45,
          color: textLight,
        ),

        /// UI / META TEXT
        labelLarge: TextStyle(
          fontFamily: 'WorkSans',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),

        labelMedium: TextStyle(
          fontFamily: 'WorkSans',
          fontSize: 12,
          color: textLight,
        ),
      ),

      // -------------------------
      // INPUT FIELDS
      // -------------------------
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(16),

        hintStyle: TextStyle(
          fontSize: 14,
          color: Color(0xFF847562),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: borderLight),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: primary),
        ),
      ),
    );
  }

  // =============================
  // DARK THEME
  // =============================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      scaffoldBackgroundColor: bgDark,

      colorScheme: const ColorScheme.dark(
        primary: primary,
        surface: Color(0xFF24201C),
        onSurface: textDark,
        outline: borderDark,
        onPrimary: Colors.black,
      ),

      // -------------------------
      // APP BAR
      // -------------------------
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
      ),

      // -------------------------
      // CARD
      // -------------------------
      cardTheme: const CardThemeData(
        color: Color(0xFF24201C),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),

      // -------------------------
      // DIVIDER
      // -------------------------
      dividerTheme: const DividerThemeData(
        thickness: 0.6,
        space: 1,
        color: borderDark,
      ),

      // -------------------------
      // TYPOGRAPHY
      // -------------------------
      textTheme: const TextTheme(

        /// ARTICLE TITLE
        headlineLarge: TextStyle(
          fontFamily: 'Lora',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: textDark,
        ),

        headlineMedium: TextStyle(
          fontFamily: 'Lora',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.25,
          color: textDark,
        ),

        /// BODY TEXT
        bodyLarge: TextStyle(
          fontFamily: 'WorkSans',
          fontSize: 20,
          height: 1.45,
          color: textDark,
        ),

        bodyMedium: TextStyle(
          fontFamily: 'WorkSans',
          fontSize: 16,
          height: 1.45,
          color: textDark,
        ),

        /// UI / META
        labelLarge: TextStyle(
          fontFamily: 'WorkSans',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),

        labelMedium: TextStyle(
          fontFamily: 'WorkSans',
          fontSize: 12,
          color: textDark,
        ),
      ),

      // -------------------------
      // INPUT FIELDS
      // -------------------------
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF2A2621),
        contentPadding: EdgeInsets.all(16),

        hintStyle: TextStyle(
          fontSize: 14,
          color: Color(0xFF847562),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: borderDark),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: primary),
        ),
      ),
    );
  }
}