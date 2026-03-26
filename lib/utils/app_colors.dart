import 'package:flutter/material.dart';

/// A theme-aware color palette. Resolves dark vs light colors based on
/// the current [Brightness] from [Theme.of(context)].
///
/// Usage:
///   final c = AppColors.of(context);
///   Container(color: c.card, ...)
class AppColors {
  final bool isDark;
  AppColors._(this.isDark);

  factory AppColors.of(BuildContext context) =>
      AppColors._(Theme.of(context).brightness == Brightness.dark);

  // ── Backgrounds ─────────────────────────────────────────────────────────────
  Color get scaffold => isDark ? const Color(0xFF0A0A0A) : Colors.white;
  Color get appBar   => isDark ? const Color(0xFF0D0D0D) : Colors.white;
  Color get card     => isDark ? const Color(0xFF141414) : Colors.white;
  Color get input    => isDark ? const Color(0xFF161616) : const Color(0xFFF0F0F0);
  Color get innerBg  => isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF5F5F5);
  Color get listBg   => isDark ? const Color(0xFF181818) : const Color(0xFFEEEEEE);

  // ── Borders ──────────────────────────────────────────────────────────────────
  Color get border       => isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE8E8E8);
  Color get subtleBorder => isDark ? const Color(0xFF2A2A2A) : const Color(0xFFDDDDDD);

  // ── Text ─────────────────────────────────────────────────────────────────────
  Color get primaryText       => isDark ? const Color(0xFFF0F0F0) : const Color(0xFF111111);
  Color get secondaryText     => isDark ? const Color(0xFF888888) : const Color(0xFF666666);
  Color get mutedText         => isDark ? const Color(0xFF555555) : const Color(0xFF888888);
  Color get dimText           => isDark ? const Color(0xFF444444) : const Color(0xFFAAAAAA);
  Color get semesterNumText   => isDark ? const Color(0xFF333333) : const Color(0xFFCCCCCC);
  Color get yearHeaderText    => isDark ? const Color(0xFF444444) : const Color(0xFF999999);

  // ── Icon backgrounds ────────────────────────────────────────────────────────
  Color get notifButtonBg     => isDark ? const Color(0xFF161616) : const Color(0xFFF0F0F0);
  Color get notifButtonBorder => isDark ? const Color(0xFF222222) : const Color(0xFFDDDDDD);

  // ── Brand (fixed) ────────────────────────────────────────────────────────────
  static const Color brand          = Color(0xFF1DB954);
  static const Color brandSecondary = Color(0xFF1DB987);

  // ── Accent (fixed) ───────────────────────────────────────────────────────────
  static const Color orange = Color(0xFFFFA500);
  static const Color teal   = Color(0xFF00D9A3);
  static const Color errorRed = Color(0xFFFF4757);
}
