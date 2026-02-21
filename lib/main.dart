import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root of the application
  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style for a cleaner look
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'My Food',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('pt'), // Portuguese
      ],
      theme: _buildThemeData(),
      home: const HomePage(),
    );
  }

  ThemeData _buildThemeData() {
    // Medical/Modern Clean Theme v2
    final baseTextTheme = GoogleFonts.poppinsTextTheme();
    // Updated Palette: Deeper Teal for authority, softer background
    const primaryColor = Color(0xFF00796B); // Teal 700
    const secondaryColor = Color(0xFF4DB6AC); // Teal 300
    const surfaceColor = Colors.white;
    const backgroundColor = Color(0xFFF5F7FA);

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.poppins().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSurface: const Color(0xFF263238), // Blue Grey 900
        surfaceContainerHighest: const Color(0xFFECEFF1), // Blue Grey 50
        error: const Color(0xFFD32F2F), // Red 700
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: baseTextTheme.apply(
        bodyColor: const Color(0xFF37474F), // Blue Grey 800
        displayColor: const Color(0xFF263238),
      ).copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, letterSpacing: -1.0),
        displayMedium: baseTextTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: -0.5),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, height: 1.5),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF263238),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: Color(0xFF263238)),
      ),
      cardTheme: CardThemeData(
        elevation: 2, // Reduced from 8 for a cleaner, flatter modern look
        shadowColor: Colors.black.withValues(alpha: 0.05),
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Slightly less round
          side: BorderSide(color: Colors.grey.withValues(alpha: 0.1), width: 1), // Subtle border
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Tighter vertical margin
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryColor.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFFB0BEC5), // Blue Grey 200
        type: BottomNavigationBarType.fixed,
        elevation: 8, // Add distinct shadow for bottom nav
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFEEEEEE),
        thickness: 1,
      ),
    );
  }
}
