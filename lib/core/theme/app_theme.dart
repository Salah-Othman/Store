import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF102A43);   
  static const Color secondaryColor = Color(0xFFC5A059); 
  static const Color tertiaryColor = Color(0xFF334E68);  
  static const Color neutralColor = Color(0xFFF5F7FA); 
  static const Color whiteColor = Colors.white; 
  static const Color error = Color(0xFFD32F2F); 
  static const Color success = Color(0xFF388E3C);  

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: neutralColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: Colors.white,
      ),

      // العناوين (Headline) بنوع Noto Serif
      textTheme: TextTheme(
        displayLarge: GoogleFonts.notoSerif(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        headlineMedium: GoogleFonts.notoSerif(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        // نصوص الجسم (Body) بنوع Manrope
        bodyLarge: GoogleFonts.manrope(
          fontSize: 16,
          color: tertiaryColor,
        ),
        bodyMedium: GoogleFonts.manrope(
          fontSize: 14,
          color: tertiaryColor,
        ),
        labelLarge: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // شكل الزراير (Primary & Outlined)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.manrope(fontWeight: FontWeight.bold),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // شكل الـ Search Bar والـ Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD1D9E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD1D9E0)),
        ),
        prefixIconColor: tertiaryColor,
        hintStyle: GoogleFonts.manrope(color: Colors.grey),
      ),
    );
  }
}