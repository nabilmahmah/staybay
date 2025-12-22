import 'package:flutter/material.dart';

class AppColors {
  // Light
  static const Color primaryBlue = Color(0xFF013893);
  static const Color backgroundColor = Colors.white;
  static const Color outlineColor = Color(0xFFCCCCCC);
  static const Color secondaryText = Color(0xFF808080);
  static const Color primaryText = Colors.black87;
  static const Color errorRed = Colors.red;

  // Dark
  static const Color darkPrimaryBlue = Color(0xFF6366F1);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOutlineColor = Color(0xFF424242);
  static const Color darkSecondaryText = Color(0xFFAAAAAA);
}

class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;

  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusExtraLarge = 32.0;

  static const double buttonHeight = 56.0;

  static const double fontSizeTitle = 28.0;
  static const double fontSizeSubtitle = 18.0;
  static const double fontSizeLabel = 14.0;
  static const double fontSizeButton = 18.0;
}

class AppStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: AppSizes.fontSizeTitle,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  static const TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: AppSizes.fontSizeLabel,
    color: AppColors.primaryText,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: AppSizes.fontSizeButton,
    fontWeight: FontWeight.bold,
  );
}
class AppTheme {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.primaryBlue,
        error: AppColors.errorRed,
        surface: AppColors.backgroundColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        iconTheme: IconThemeData(color: AppColors.primaryText),
        elevation: 0,
        centerTitle: true,
      ),

      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSizes.paddingMedium,
          horizontal: AppSizes.paddingLarge,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(
            color: AppColors.outlineColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(
            color: AppColors.outlineColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 2.0),
        ),
        labelStyle: AppStyles.labelStyle.copyWith(
          color: AppColors.secondaryText,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: AppStyles.labelStyle.copyWith(
          color: AppColors.secondaryText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          ),
          textStyle: AppStyles.buttonTextStyle,
          elevation: 5,
        ),
      ),
      useMaterial3: true,
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.darkPrimaryBlue,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimaryBlue,
        secondary: AppColors.darkPrimaryBlue,
        surface: AppColors.darkSurface,
        onSurface: Colors.white,
        onSurfaceVariant: AppColors.darkSecondaryText,
        error: AppColors.errorRed,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),

      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSizes.paddingMedium,
          horizontal: AppSizes.paddingLarge,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(
            color: AppColors.darkOutlineColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(
            color: AppColors.darkOutlineColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          borderSide: const BorderSide(
            color: AppColors.darkPrimaryBlue,
            width: 2,
          ),
        ),
        hintStyle: AppStyles.labelStyle.copyWith(
          color: AppColors.darkSecondaryText,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimaryBlue,
          foregroundColor: AppColors.darkSurface,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          ),
          textStyle: AppStyles.buttonTextStyle.copyWith(
            color: AppColors.darkSurface,
          ),
          elevation: 5,
        ),
      ),

      useMaterial3: true,
    );
  }
}

