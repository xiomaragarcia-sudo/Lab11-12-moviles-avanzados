import 'package:flutter/cupertino.dart';

/// Paleta de colores de la app (morado como en el diseño).
class AppColors {
  static const primary = Color(0xFF5B47D6);
  static const primaryLight = Color(0xFFEDE9FE);
  static const background = Color(0xFFF2F2F7); // gris de fondo de iOS
  static const card = CupertinoColors.white;
  static const border = Color(0xFFE4E4EC);
  static const text = Color(0xFF1C1C28);
  static const textMuted = Color(0xFF6B6B7B);
  static const placeholder = Color(0xFFA0A0AE);
  static const success = Color(0xFF2E9E5B);
  static const successBg = Color(0xFFE6F6EC);
  static const danger = Color(0xFFE5484D);
  static const dangerBg = Color(0xFFFDECEC);
}

/// TEMA GLOBAL de la aplicación (CupertinoThemeData).
class AppTheme {
  static const double radius = 14;

  /// Inter: fuente muy parecida a San Francisco (la del iPhone).
  static const String fuente = 'Inter';

  static const CupertinoThemeData theme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    primaryContrastingColor: CupertinoColors.white,
    scaffoldBackgroundColor: AppColors.background,
    barBackgroundColor: AppColors.primary,
    textTheme: CupertinoTextThemeData(
      primaryColor: AppColors.primary,
      textStyle: TextStyle(
        fontFamily: fuente,
        fontSize: 16,
        color: AppColors.text,
        letterSpacing: -0.3,
      ),
      actionTextStyle: TextStyle(
        fontFamily: fuente,
        fontSize: 17,
        color: AppColors.primary,
        letterSpacing: -0.3,
      ),
      navTitleTextStyle: TextStyle(
        fontFamily: fuente,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: CupertinoColors.white,
        letterSpacing: -0.3,
      ),
      navActionTextStyle: TextStyle(
        fontFamily: fuente,
        fontSize: 17,
        color: CupertinoColors.white,
      ),
    ),
  );
}
