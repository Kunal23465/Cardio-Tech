import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0B8FAC);
  static const Color secondary = Color(0xFF64C7A6);
  static const Color background = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF333333);
}

const double borderRadiusValue = 12;

ThemeData appTheme() {
  return ThemeData(
    fontFamily: 'Jost',
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
    ),

    // New TextTheme names
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.textDark),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textDark),
    ),

    // Input decoration theme
    // inputDecorationTheme: InputDecorationTheme(
    //   filled: true,
    //   fillColor: Colors.white,
    //   contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    //   floatingLabelBehavior: FloatingLabelBehavior.auto,

    //   labelStyle: const TextStyle(
    //     color: Colors.black,
    //     backgroundColor: Colors.white,
    //   ),
    //   hintStyle: const TextStyle(color: Colors.grey),

    //   enabledBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(borderRadiusValue),
    //     borderSide: const BorderSide(color: Colors.transparent),
    //   ),
    //   focusedBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(borderRadiusValue),
    //     borderSide: BorderSide(color: AppColors.primary),
    //   ),
    // ),

    // Cursor theme
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withOpacity(0.3),
      selectionHandleColor: AppColors.primary,
    ),
  );
}
