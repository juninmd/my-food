import 'package:flutter/material.dart';

/// WebDiet Pulse color tokens.
///
/// Macro colors are data colors: protein, carbs and fat keep the same hue
/// everywhere (orbit, plates, DNA bars) so color alone carries meaning.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  final Color paper;
  final Color surface;
  final Color sunk;
  final Color ink;
  final Color ink2;
  final Color line;
  final Color mint;
  final Color mintSoft;
  final Color protein;
  final Color carbs;
  final Color fat;
  final Color water;

  const AppTokens({
    required this.paper,
    required this.surface,
    required this.sunk,
    required this.ink,
    required this.ink2,
    required this.line,
    required this.mint,
    required this.mintSoft,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.water,
  });

  static const light = AppTokens(
    paper: Color(0xFFEAF1EC),
    surface: Color(0xFFFFFFFF),
    sunk: Color(0xFFF3F7F4),
    ink: Color(0xFF0F241D),
    ink2: Color(0xFF4B6158),
    line: Color(0xFFD3DFD8),
    mint: Color(0xFF00A884),
    mintSoft: Color(0xFFD2F4E8),
    protein: Color(0xFFEE5A45),
    carbs: Color(0xFFE2A21F),
    fat: Color(0xFF7A5FE0),
    water: Color(0xFF2B93E6),
  );

  static const dark = AppTokens(
    paper: Color(0xFF08120F),
    surface: Color(0xFF111F1A),
    sunk: Color(0xFF0C1814),
    ink: Color(0xFFE4EFEA),
    ink2: Color(0xFF93AAA1),
    line: Color(0xFF21342D),
    mint: Color(0xFF2FE0B0),
    mintSoft: Color(0xFF123A30),
    protein: Color(0xFFFF7A66),
    carbs: Color(0xFFF4BA45),
    fat: Color(0xFF9C86FF),
    water: Color(0xFF55B0FF),
  );

  /// Tokens of the current theme, falling back to [light] when a test or
  /// a bare MaterialApp did not register the extension.
  static AppTokens of(BuildContext context) =>
      Theme.of(context).extension<AppTokens>() ?? light;

  /// Soft two-layer elevation used by cards that stand apart from the page.
  List<BoxShadow> get shadow => [
        BoxShadow(
          color: ink.withValues(alpha: 0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10),
          blurRadius: 28,
          spreadRadius: -12,
          offset: const Offset(0, 12),
        ),
      ];

  /// Card decoration shared by every surface card.
  BoxDecoration card({double radius = 26, Color? color}) => BoxDecoration(
        color: color ?? surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow,
      );

  @override
  AppTokens copyWith({Color? mint}) => this;

  @override
  AppTokens lerp(AppTokens? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppTokens(
      paper: l(paper, other.paper),
      surface: l(surface, other.surface),
      sunk: l(sunk, other.sunk),
      ink: l(ink, other.ink),
      ink2: l(ink2, other.ink2),
      line: l(line, other.line),
      mint: l(mint, other.mint),
      mintSoft: l(mintSoft, other.mintSoft),
      protein: l(protein, other.protein),
      carbs: l(carbs, other.carbs),
      fat: l(fat, other.fat),
      water: l(water, other.water),
    );
  }
}
