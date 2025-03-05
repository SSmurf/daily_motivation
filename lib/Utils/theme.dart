import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightBackground = Colors.white;
  static const Color lightBackgroundOverlay = Color(0xF5FFFFFF);
  static const Color lightAccent1 = Color(0xFFA7C7E7);
  static const Color lightAccent2 = Color(0xFFF7A8A8);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkBackgroundOverlay = Color(0xE6121212);
  static const Color darkAccent1 = Color(0xFF4C91F7);
  static const Color darkAccent2 = Color(0xFF8A2BE2);

  // Common Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textPrimaryDark = Color(0xFFEEEEEE);
  static const Color textSecondaryDark = Color(0xFFAAAAAA);

  // Card and Surface Colors
  static const Color cardLight = Color(0xFFF5F5F5);
  static const Color cardDark = Color(0xFF1E1E1E);

  // Create Light Theme
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: lightAccent1,
        secondary: lightAccent2,
        surface: cardLight,
        error: Colors.red.shade300,
      ),
      scaffoldBackgroundColor: lightBackground,
      cardColor: cardLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.light().textTheme.copyWith(
          displayLarge: const TextStyle(color: textPrimary),
          displayMedium: const TextStyle(color: textPrimary),
          displaySmall: const TextStyle(color: textPrimary),
          headlineLarge: const TextStyle(color: textPrimary),
          headlineMedium: const TextStyle(color: textPrimary),
          headlineSmall: const TextStyle(color: textPrimary),
          titleLarge: const TextStyle(color: textPrimary),
          titleMedium: const TextStyle(color: textPrimary),
          titleSmall: const TextStyle(color: textPrimary),
          bodyLarge: const TextStyle(color: textPrimary),
          bodyMedium: const TextStyle(color: textSecondary),
          bodySmall: const TextStyle(color: textSecondary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightAccent1,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      cardTheme: CardTheme(
        color: cardLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFFE0E0E0), thickness: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return lightAccent1;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return lightAccent1.withValues(alpha: 0.5);
          }
          return Colors.grey.withValues(alpha: 0.3);
        }),
      ),
      dialogTheme: DialogThemeData(backgroundColor: lightBackgroundOverlay),
    );
  }

  // Create Dark Theme
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: darkAccent1,
        secondary: darkAccent2,
        surface: cardDark,
        error: Colors.red.shade300,
      ),
      scaffoldBackgroundColor: darkBackground,
      cardColor: cardDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: textPrimaryDark,
        elevation: 0,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme.copyWith(
          displayLarge: const TextStyle(color: textPrimaryDark),
          displayMedium: const TextStyle(color: textPrimaryDark),
          displaySmall: const TextStyle(color: textPrimaryDark),
          headlineLarge: const TextStyle(color: textPrimaryDark),
          headlineMedium: const TextStyle(color: textPrimaryDark),
          headlineSmall: const TextStyle(color: textPrimaryDark),
          titleLarge: const TextStyle(color: textPrimaryDark),
          titleMedium: const TextStyle(color: textPrimaryDark),
          titleSmall: const TextStyle(color: textPrimaryDark),
          bodyLarge: const TextStyle(color: textPrimaryDark),
          bodyMedium: const TextStyle(color: textSecondaryDark),
          bodySmall: const TextStyle(color: textSecondaryDark),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkAccent1,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      cardTheme: CardTheme(
        color: cardDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFF333333), thickness: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return darkAccent1;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return darkAccent1.withValues(alpha: 0.5);
          }
          return Colors.grey.withValues(alpha: 0.3);
        }),
      ),
      dialogTheme: DialogThemeData(backgroundColor: darkBackgroundOverlay),
    );
  }
}
