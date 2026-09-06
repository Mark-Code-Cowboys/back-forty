import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';

/// Placeholder palette seeded from the app's accent; hand-tune with a
/// full ColorScheme (see Table Encore) when real brand art lands.
abstract final class AppTheme {
  static const _accent = Color(0xFF6B4F2A);

  static const _tokens = CcThemeTokens(seed: _accent);

  static ThemeData light() => ccLightTheme(_tokens);

  static ThemeData dark() => ccDarkTheme(_tokens);
}
