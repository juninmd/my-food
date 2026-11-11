import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';

/// Material themes built from [AppTokens], one per brightness.
class AppTheme {
  AppTheme._();

  static ThemeData buildThemeData() =>
      _build(AppTokens.light, Brightness.light);

  static ThemeData buildDarkThemeData() =>
      _build(AppTokens.dark, Brightness.dark);

  static ThemeData _build(AppTokens t, Brightness b) {
    final isDark = b == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: t.mint,
      brightness: b,
      primary: t.mint,
      onPrimary: isDark ? t.paper : Colors.white,
      secondary: t.ink,
      onSecondary: t.paper,
      surface: t.surface,
      onSurface: t.ink,
      onSurfaceVariant: t.ink2,
      surfaceContainerHighest: t.sunk,
      outline: t.line,
      outlineVariant: t.line,
      error: t.protein,
    );
    final radius16 = BorderRadius.circular(16);

    return ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: scheme,
      extensions: [t],
      scaffoldBackgroundColor: t.paper,
      canvasColor: t.paper,
      dividerColor: t.line,
      textTheme: AppType.textTheme(t.ink2, t.ink),
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: t.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppType.display(22, color: t.ink),
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: t.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.sunk,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: radius16, borderSide: BorderSide(color: t.line)),
        enabledBorder: OutlineInputBorder(
            borderRadius: radius16, borderSide: BorderSide(color: t.line)),
        focusedBorder: OutlineInputBorder(
            borderRadius: radius16,
            borderSide: BorderSide(color: t.mint, width: 2)),
        labelStyle: TextStyle(color: t.ink2),
        hintStyle: TextStyle(color: t.ink2.withValues(alpha: 0.7)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: t.ink,
          foregroundColor: t.paper,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: radius16),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: t.mintSoft,
          foregroundColor: t.mint,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: t.mint,
        foregroundColor: isDark ? t.paper : Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: t.ink,
        contentTextStyle:
            TextStyle(color: t.paper, fontWeight: FontWeight.w500),
        actionTextColor: isDark ? t.mint : t.mintSoft,
        shape: RoundedRectangleBorder(borderRadius: radius16),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: t.line,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: t.mint,
        inactiveTrackColor: t.sunk,
        thumbColor: t.mint,
        overlayColor: t.mint.withValues(alpha: 0.12),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? t.mint : null),
      ),
    );
  }
}
