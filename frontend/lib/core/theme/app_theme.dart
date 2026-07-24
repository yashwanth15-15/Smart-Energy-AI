import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return _buildTheme();
  }

  static ThemeData get darkTheme {
    return _buildTheme(); // Force the Green theme regardless of system setting
  }

  static ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2E7D32), // Forest Green
        secondary: Color(0xFF43A047), // Emerald
        tertiary: Color(0xFF66BB6A), // Leaf Green
        surface: Colors.white, // White cards
        error: Color(0xFFD32F2F),
        surfaceContainerHighest: Color(0xFFF4F9F4), // Mint White
      ),
      scaffoldBackgroundColor: const Color(0xFFF4F9F4),
      fontFamily: 'Inter',
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF4F9F4),
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Color(0xFF2E7D32)),
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B5E20),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
        headlineSmall: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
        titleLarge: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2E7D32)),
        bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.black87, fontSize: 14),
        bodySmall: TextStyle(color: Colors.black54, fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF2E7D32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}

