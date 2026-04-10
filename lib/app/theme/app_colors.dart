import 'package:flutter/material.dart';

/// Dark-first color tokens for ProxDroid (Material 3).
///
/// Primary accent evokes Proxmox VE’s warm orange while keeping surfaces neutral.
abstract final class AppColors {
  // --- Dark (default) ---
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);
  static const Color darkPrimary = Color(0xFFE67E22);
  static const Color darkOnPrimary = Color(0xFF1A0E00);
  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkOutline = Color(0xFF938F99);
  static const Color darkOnSurface = Color(0xFFE6E1E5);

  // --- Light ---
  static const Color lightBackground = Color(0xFFFFFBFF);
  static const Color lightSurface = Color(0xFFFFFBFF);
  static const Color lightSurfaceVariant = Color(0xFFE7E0EC);
  static const Color lightPrimary = Color(0xFFB85C00);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFBA1A1A);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightOutline = Color(0xFF79747E);
  static const Color lightOnSurface = Color(0xFF1C1B1F);
}
