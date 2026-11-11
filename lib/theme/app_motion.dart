import 'package:flutter/widgets.dart';

/// Named motion tokens of WebDiet Pulse.
///
/// Every animated widget takes its duration from here through [of], so the
/// platform "reduce motion" setting turns all of them off in one place.
class AppMotion {
  AppMotion._();

  /// Rings drawing themselves (orbit, gauge).
  static const breathe = Duration(milliseconds: 1300);

  /// Sheets, navigation indicator, presses.
  static const spring = Duration(milliseconds: 550);

  /// Items entering a list; each item waits [cascadeStep] more.
  static const cascade = Duration(milliseconds: 450);
  static const cascadeStep = Duration(milliseconds: 40);

  /// Surprise Me slot spin and the number of name swaps it shows.
  static const slot = Duration(milliseconds: 900);
  static const slotTicks = 12;

  /// One water wave cycle.
  static const wave = Duration(milliseconds: 3200);

  /// Checkbox tick and strike-through.
  static const tick = Duration(milliseconds: 300);

  /// Page switch between tabs.
  static const page = Duration(milliseconds: 380);

  static const decel = Cubic(0.16, 1, 0.3, 1);
  static const springCurve = Cubic(0.2, 1.25, 0.35, 1);

  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// [d], or zero when the user asked the system to reduce motion.
  static Duration of(BuildContext context, Duration d) =>
      reduced(context) ? Duration.zero : d;
}
