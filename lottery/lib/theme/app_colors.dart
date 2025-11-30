import 'package:flutter/material.dart';

class AppColors {
  // Primary Purple Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF564FD8);
  static const Color primaryLight = Color(0xFF8B85FF);
  static const Color primaryExtraLight = Color(0xFFE6E4FF);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F9FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2D2B6D);
  static const Color textSecondary = Color(0xFF6E6B8F);
  static const Color textDisabled = Color(0xFFA5A3C3);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Gradient
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
  
  static const Gradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryExtraLight, white],
  );
  
  // Shadows
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x1A6C63FF),
    blurRadius: 12,
    offset: Offset(0, 4),
  );
  
  static const BoxShadow buttonShadow = BoxShadow(
    color: Color(0x336C63FF),
    blurRadius: 8,
    offset: Offset(0, 2),
  );
}