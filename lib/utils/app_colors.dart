import 'package:flutter/material.dart';

/// SafeLeaf Color System — 60-30-10 Rule
class AppColors {
  // ─── 60% — Base (Backgrounds, Cards, Surfaces) ────────────────
  static const background    = Color(0xFFF7FBF4);
  static const surface       = Color(0xFFFFFFFF);
  static const surfaceBorder = Color(0xFFD5E8D4);

  // ─── 30% — Primary (App bar, Buttons, Headings, Text) ─────────
  static const primary       = Color(0xFF2D6A4F);
  static const primaryDark   = Color(0xFF1B4332);
  static const primaryLight  = Color(0xFF95D5B2);

  // ─── 10% — Accent (FAB, Icons, Highlights, Active states) ────
  static const accent        = Color(0xFF52B788);

  // ─── Status Colors ─────────────────────────────────────────────
  static const danger        = Color(0xFFE74C3C);
  static const warning       = Color(0xFFF39C12);
  static const safe          = Color(0xFF27AE60);

  // ─── Card-specific colors ──────────────────────────────────────
  static const cardBackground = Color(0xFFFAFCF9);
  static const cardBorder     = Color(0xFFE8F0EB);
  static const iconBackground = Color(0xFFE8F3ED);
  static const textSecondary  = Color(0xFF7A9D8F);
  static const titleDark      = Color(0xFF1B4332);

  // ─── Toggle-specific colors ────────────────────────────────────
  static const toggleBackground   = Color(0x1FFFFFFF);
  static const toggleBorder       = Color(0x3DFFFFFF);
  static const toggleThumb        = Color(0xFFFFFFFF);
  static const toggleActiveText   = Color(0xFF1B1B1B);
  static const toggleInactiveText = Color(0xFFFFFFFF);
}