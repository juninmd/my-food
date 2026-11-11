import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography roles: a characterful display face, a calm body face and a
/// monospaced face for numbers that must line up.
class AppType {
  AppType._();

  static TextStyle display(double size,
          {Color? color, FontWeight weight = FontWeight.w800}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.05,
        letterSpacing: -0.02 * size,
      );

  static TextStyle data(double size,
          {Color? color, FontWeight weight = FontWeight.w700}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        fontWeight: weight,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Small uppercase label with tracking, used as eyebrow above sections.
  static TextStyle label(Color color) => GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
        color: color,
      );

  static TextTheme textTheme(Color body, Color display) {
    final base = GoogleFonts.instrumentSansTextTheme()
        .apply(bodyColor: body, displayColor: display);
    TextStyle? d(TextStyle? s) => s?.merge(GoogleFonts.bricolageGrotesque(
        fontWeight: FontWeight.w800, letterSpacing: -0.5));
    return base.copyWith(
      displayLarge: d(base.displayLarge),
      displayMedium: d(base.displayMedium),
      displaySmall: d(base.displaySmall),
      headlineLarge: d(base.headlineLarge),
      headlineMedium: d(base.headlineMedium),
      headlineSmall: d(base.headlineSmall),
      titleLarge: d(base.titleLarge),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.5),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.5),
    );
  }
}
