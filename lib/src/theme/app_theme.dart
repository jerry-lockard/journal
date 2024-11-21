import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

class AppTheme {
  static ThemeData lightTheme(ColorScheme? dynamicColorScheme) {
    final ColorScheme colorScheme = dynamicColorScheme ??
        ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: colorScheme.surface,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  static ThemeData darkTheme(ColorScheme? dynamicColorScheme) {
    final ColorScheme colorScheme = dynamicColorScheme ??
        ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: colorScheme.surface,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }
}
