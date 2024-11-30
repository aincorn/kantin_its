import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTheme {
  static ThemeData getAppTheme() {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: AppColors.primaryColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
        displayLarge: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.black45),
      ),
    );
  }

  // Method to return a gradient that can be used in pages
  static BoxDecoration getGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFFFEF8E9),  // Replace hex color with 0xFF prefixed to make it a valid Color object
          Color(0xFFEDD7B5),
          Color(0xFFF0C39B)
        ],
        stops: [0.22, 0.58, 1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  static BoxDecoration getLinearGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFFFFFFFF),  // Replace hex color with 0xFF prefixed to make it a valid Color object
          Color(0xFFFEF8E9),
        ],
        stops: [0,1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }
}