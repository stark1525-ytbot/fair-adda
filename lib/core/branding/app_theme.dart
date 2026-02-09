import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class FairAddaTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundBlack,
      primaryColor: AppColors.fairRed,
      
      // Text Styling
      textTheme: TextTheme(
        displayLarge: GoogleFonts.rajdhani(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.accentWhite),
        headlineMedium: GoogleFonts.rajdhani(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.accentWhite),
        bodyLarge: GoogleFonts.roboto(fontSize: 16, color: AppColors.accentWhite),
        bodyMedium: GoogleFonts.roboto(fontSize: 14, color: AppColors.textGrey),
      ),

      // Input Decoration (Login/Forms)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceBlack,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.fairRed)),
        labelStyle: const TextStyle(color: AppColors.textGrey),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.fairRed,
          foregroundColor: AppColors.accentWhite,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.rajdhani(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        color: AppColors.cardGrey,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      
      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontFamily: 'Rajdhani', fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.fairRed),
        iconTheme: IconThemeData(color: AppColors.accentWhite),
      ),
    );
  }
}