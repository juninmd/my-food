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
    // WebDiet Inspired Modern Clean Theme
    final baseTextTheme = GoogleFonts.nunitoTextTheme();

    // Updated Palette: WebDiet Aesthetic - Soft, approachable, clinical
    const primaryColor = Color(0xFF00A86B); // Jade/Mint Green - WebDiet style
    const secondaryColor = Color(0xFF5AC18E); // Soft Mint
    const surfaceColor = Colors.white;
    const backgroundColor = Color(0xFFF8F9FA); // Very light gray background

    return ThemeData(
      useMaterial3: true,
      fontFamily:
          GoogleFonts.nunito().fontFamily, // More rounded, friendly font
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSurface: const Color(0xFF2D3748), // Dark Gray for high contrast text
        surfaceContainerHighest: const Color(0xFFEDF2F7), // Light Gray
        error: const Color(0xFFE53E3E), // Red
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: baseTextTheme
          .apply(
            bodyColor: const Color(0xFF4A5568), // Gray 600
            displayColor: const Color(0xFF2D3748),
          )
          .copyWith(
            displayLarge: baseTextTheme.displayLarge
                ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1.0),
            displayMedium: baseTextTheme.displayMedium
                ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
            headlineLarge: baseTextTheme.headlineLarge
                ?.copyWith(fontWeight: FontWeight.w700),
            headlineMedium: baseTextTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.w700),
            titleLarge: baseTextTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w800), // Bolder titles
            bodyLarge: baseTextTheme.bodyLarge?.copyWith(
                fontSize: 16, height: 1.5, fontWeight: FontWeight.w500),
            bodyMedium: baseTextTheme.bodyMedium?.copyWith(
                fontSize: 14, height: 1.5, fontWeight: FontWeight.w500),
          ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF2D3748),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: Color(0xFF2D3748)),
      ),
      cardTheme: CardThemeData(
        elevation: 0, // Flat design
        shadowColor: Colors.black.withOpacity(0.04),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Even rounder corners
          side: BorderSide(
              color: Colors.grey.shade100,
              width: 1.5), // Slightly more visible border
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle:
            TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
      ),
      iconTheme: IconThemeData(
        color: Colors.grey.shade800,
      ),
    );
  }
}
