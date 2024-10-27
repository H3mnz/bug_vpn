import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData theme = ThemeData(
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.green,
      error: AppColors.red,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(kToolbarHeight * 2, kToolbarHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(width: 2, color: Colors.grey.shade400),
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        for (final platform in TargetPlatform.values) ...{platform: const FadeUpwardsPageTransitionsBuilder()},
      },
    ),
  );
}
