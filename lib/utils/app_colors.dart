import 'package:flutter/material.dart';

/// SafeLeaf Color System — 60-30-10 Rule
class AppColors {
  // ─── 60% — Base (Backgrounds, Cards, Surfaces) ────────────────
  static const background   = Color(0xFFF7FBF4); // Soft white-green
  static const surface      = Color(0xFFFFFFFF); // Pure white cards
  static const surfaceBorder= Color(0xFFD5E8D4); // Subtle borders

  // ─── 30% — Primary (App bar, Buttons, Headings, Text) ─────────
  static const primary      = Color(0xFF2D6A4F); // Forest green
  static const primaryDark  = Color(0xFF1B4332); // Deep green text
  static const primaryLight = Color(0xFF95D5B2); // Muted light green

  // ─── 10% — Accent (FAB, Icons, Highlights, Active states) ────
  static const accent       = Color(0xFF52B788); // Leaf green

  // ─── Status Colors ─────────────────────────────────────────────
  static const danger       = Color(0xFFE74C3C); // Red for errors/expiry
  static const warning      = Color(0xFFF39C12); // Orange for warnings
  static const safe         = Color(0xFF27AE60); // Green for valid/safe
}