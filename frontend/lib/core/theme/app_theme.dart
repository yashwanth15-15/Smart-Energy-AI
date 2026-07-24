import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2E7D32),
        secondary: Color(0xFF43A047),
        tertiary: Color(0xFF66BB6A),
        surface: Colors.white,
        error: Color(0xFFD32F2F),
        surfaceContainerHighest: Color(0xFFF4F9F4),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1A1A1A),
      ),
      scaffoldBackgroundColor: const Color(0xFFF4F9F4),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineMedium: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
        headlineSmall: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
        titleLarge: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2E7D32)),
        bodyLarge: const TextStyle(color: Colors.black87, fontSize: 16),
        bodyMedium: const TextStyle(color: Colors.black87, fontSize: 14),
        bodySmall: const TextStyle(color: Colors.black54, fontSize: 12),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF4F9F4),
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Color(0xFF2E7D32)),
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
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
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF66BB6A),
        secondary: Color(0xFF81C784),
        tertiary: Color(0xFFA5D6A7),
        surface: Color(0xFF1E1E1E),
        error: Color(0xFFEF5350),
        surfaceContainerHighest: Color(0xFF121212),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        headlineMedium: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF81C784)),
        headlineSmall: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF81C784)),
        titleLarge: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF66BB6A)),
        bodyLarge: const TextStyle(color: Colors.white70, fontSize: 16),
        bodyMedium: const TextStyle(color: Colors.white70, fontSize: 14),
        bodySmall: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Color(0xFF66BB6A)),
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF81C784)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF66BB6A),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
