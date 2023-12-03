import 'package:riada/gen/fonts.gen.dart';
import 'package:riada/src/design_system/ds_color.dart';
import 'package:riada/src/design_system/ds_font.dart';
import 'package:riada/src/design_system/ds_spacing.dart';
import 'package:flutter/material.dart';

ThemeData dsTheme() {
  return ThemeData(
    primaryColor: DSColor.primary100,
    colorScheme: ColorScheme(
      primary: DSColor.primary100,
      onPrimary: Colors.white,
      secondary: DSColor.primary100,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: DSColor.primary100,
      onBackground: Colors.white,
      surface: DSColor.primary100,
      onSurface: DSColor.primary100,
      brightness: Brightness.light,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: FontFamily.poppins,
        height: DSFontHeight.displayLarge,
        fontSize: DSFontSize.displayLarge,
        fontWeight: DSFontWeight.bold,
        color: DSColor.neutral100,
      ),
      displayMedium: TextStyle(
        fontFamily: FontFamily.poppins,
        height: DSFontHeight.displayMedium,
        fontSize: DSFontSize.displayMedium,
        fontWeight: DSFontWeight.bold,
        color: DSColor.neutral100,
      ),
      displaySmall: TextStyle(
        fontFamily: FontFamily.poppins,
        height: DSFontHeight.displaySmall,
        fontSize: DSFontSize.displaySmall,
        fontWeight: DSFontWeight.light,
        color: DSColor.neutral100,
      ),
      headlineLarge: TextStyle(
        fontFamily: FontFamily.poppins,
        height: DSFontHeight.headlineLarge,
        fontSize: DSFontSize.headlineLarge,
        fontWeight: DSFontWeight.semiBold,
        color: DSColor.neutral100,
      ),
      headlineMedium: TextStyle(
        fontFamily: FontFamily.poppins,
        height: DSFontHeight.headlineMedium,
        fontSize: DSFontSize.headlineMedium,
        fontWeight: DSFontWeight.semiBold,
        color: DSColor.neutral100,
      ),
      titleLarge: TextStyle(
        fontFamily: FontFamily.poppins,
        height: DSFontHeight.titleLarge,
        fontSize: DSFontSize.titleLarge,
        fontWeight: DSFontWeight.bold,
        color: DSColor.neutral100,
      ),
      titleMedium: TextStyle(
        fontFamily: FontFamily.raleway,
        height: DSFontHeight.titleMedium,
        fontSize: DSFontSize.titleMedium,
        fontWeight: DSFontWeight.regular,
        color: DSColor.neutral100,
      ),
      titleSmall: TextStyle(
        fontFamily: FontFamily.poppins,
        height: DSFontHeight.titleSmall,
        fontSize: DSFontSize.titleSmall,
        fontWeight: DSFontWeight.regular,
        color: DSColor.neutral100,
      ),
      bodyLarge: TextStyle(
        fontFamily: FontFamily.poppins,
        height: DSFontHeight.bodyLarge,
        fontSize: DSFontSize.bodyLarge,
        fontWeight: DSFontWeight.regular,
        color: DSColor.neutral100,
      ),
      bodyMedium: TextStyle(
        fontFamily: FontFamily.poppins,
        height: DSFontHeight.bodyMedium,
        fontSize: DSFontSize.bodyMedium,
        fontWeight: DSFontWeight.regular,
        color: DSColor.neutral100,
      ),
      bodySmall: TextStyle(
        fontFamily: FontFamily.poppins,
        height: DSFontHeight.bodySmall,
        fontSize: DSFontSize.bodySmall,
        fontWeight: DSFontWeight.regular,
        color: DSColor.neutral100,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.only(
          left: DSSpacing.sizeS,
          right: DSSpacing.sizeS,
          top: DSSpacing.sizeXxs,
          bottom: DSSpacing.sizeXxs,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.only(
          left: DSSpacing.sizeS,
          right: DSSpacing.sizeS,
          top: DSSpacing.sizeXxs,
          bottom: DSSpacing.sizeXxs,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData(color: DSColor.neutral100),
      titleTextStyle: TextStyle(
        fontFamily: FontFamily.poppins,
        height: DSFontHeight.titleLarge,
        fontSize: DSFontSize.titleLarge,
        fontWeight: DSFontWeight.semiBold,
        color: DSColor.neutral100,
      ),
    ),
  );
}
