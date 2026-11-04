import 'package:flutter/cupertino.dart';

/// Colour roles of «Денежно» for one brightness. See docs/design-system.md.
@immutable
final class Palette {
  const Palette({
    required this.background,
    required this.surface,
    required this.surface2,
    required this.separator,
    required this.text,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentSoft,
    required this.warning,
    required this.warningSoft,
    required this.negative,
    required this.negativeSoft,
    required this.heroStart,
    required this.heroEnd,
    required this.gold,
    required this.shadow,
  });

  final Color background;
  final Color surface;
  final Color surface2;
  final Color separator;
  final Color text;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color accentSoft;
  final Color warning;
  final Color warningSoft;
  final Color negative;
  final Color negativeSoft;
  final Color heroStart;
  final Color heroEnd;
  final Color gold;

  /// Card shadow; transparent in dark mode.
  final Color shadow;

  static const light = Palette(
    background: Color(0xFFF2F4F1),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFF7F8F6),
    separator: Color(0x1A0F1A14),
    text: Color(0xFF0F1A14),
    textSecondary: Color(0xFF5E6A63),
    textTertiary: Color(0xFF8C968F),
    accent: Color(0xFF0E7A55),
    accentSoft: Color(0x1A0E7A55),
    warning: Color(0xFFB7791F),
    warningSoft: Color(0xFFFFF4DE),
    negative: Color(0xFFD64545),
    negativeSoft: Color(0x1AD64545),
    heroStart: Color(0xFF0F8A5F),
    heroEnd: Color(0xFF075A3F),
    gold: Color(0xFFE6B64C),
    shadow: Color(0x0D0F1A14),
  );

  static const dark = Palette(
    background: Color(0xFF0A0D0B),
    surface: Color(0xFF161A18),
    surface2: Color(0xFF1F2421),
    separator: Color(0x22FFFFFF),
    text: Color(0xFFF1F4F2),
    textSecondary: Color(0xFF9AA49E),
    textTertiary: Color(0xFF6B756F),
    accent: Color(0xFF34C98B),
    accentSoft: Color(0x2634C98B),
    warning: Color(0xFFF2B33D),
    warningSoft: Color(0xFF2A2414),
    negative: Color(0xFFFF6B6B),
    negativeSoft: Color(0x26FF6B6B),
    heroStart: Color(0xFF0F7A55),
    heroEnd: Color(0xFF06402C),
    gold: Color(0xFFE6B64C),
    shadow: Color(0x00000000),
  );

  /// The palette for the brightness the app is actually showing (the app's
  /// own theme choice wins over the system setting).
  static Palette of(BuildContext context) {
    final brightness =
        CupertinoTheme.maybeBrightnessOf(context) ??
        MediaQuery.platformBrightnessOf(context);
    return brightness == Brightness.dark ? dark : light;
  }
}

/// Spacing scale (4-pt grid) and radii.
abstract final class Space {
  static const xs = 4.0;
  static const s = 8.0;
  static const m = 12.0;
  static const l = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const radius = 18.0;
  static const radiusSmall = 12.0;
}

/// Text styles. Money always uses tabular figures so digits do not jump.
abstract final class AppText {
  static const _tabular = [FontFeature.tabularFigures()];

  static TextStyle hero(Color color) => TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    height: 1.1,
    color: color,
    fontFeatures: _tabular,
  );
  static TextStyle title(Color color) => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: color,
  );
  static TextStyle headline(Color color) =>
      TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: color);
  static TextStyle body(Color color) =>
      TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: color);
  static TextStyle secondary(Color color) =>
      TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: color);
  static TextStyle caption(Color color) =>
      TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color);
  static TextStyle amount(Color color, {double size = 17}) => TextStyle(
    fontSize: size,
    fontWeight: FontWeight.w600,
    color: color,
    fontFeatures: _tabular,
  );
}

/// Cupertino theme built from the palettes; [brightness] null = follow iOS.
CupertinoThemeData appTheme(Brightness? brightness) => CupertinoThemeData(
  brightness: brightness,
  primaryColor: CupertinoDynamicColor.withBrightness(
    color: Palette.light.accent,
    darkColor: Palette.dark.accent,
  ),
  scaffoldBackgroundColor: CupertinoDynamicColor.withBrightness(
    color: Palette.light.background,
    darkColor: Palette.dark.background,
  ),
  barBackgroundColor: CupertinoDynamicColor.withBrightness(
    color: Palette.light.background.withValues(alpha: 0.92),
    darkColor: Palette.dark.background.withValues(alpha: 0.92),
  ),
);
