import 'dart:ui';

class DSFontSize {
  static const double displayLarge = 24;
  static const double displayMedium = 20;
  static const double displaySmall = 24;
  static const double headlineLarge = 16;
  static const double headlineMedium = 14;
  static const double titleLarge = 16;
  static const double titleMedium = 14;
  static const double titleSmall = 10;
  static const double bodyLarge = 16;
  static const double bodyMedium = 14;
  static const double bodySmall = 12;
}

class DSFontLineHeight {
  static const double displayLarge = 36;
  static const double displayMedium = 24;
  static const double displaySmall = 32;
  static const double headlineLarge = 20;
  static const double headlineMedium = 18;
  static const double titleLarge = 24;
  static const double titleMedium = 20;
  static const double titleSmall = 10;
  static const double bodyLarge = 22;
  static const double bodyMedium = 18;
  static const double bodySmall = 14;
}

class DSFontHeight {
  static const double displayLarge =
      DSFontLineHeight.displayLarge / DSFontSize.displayLarge;
  static const double displayMedium =
      DSFontLineHeight.displayMedium / DSFontSize.displayMedium;
  static const double displaySmall =
      DSFontLineHeight.displaySmall / DSFontSize.displaySmall;
  static const double headlineLarge =
      DSFontLineHeight.headlineLarge / DSFontSize.headlineLarge;
  static const double headlineMedium =
      DSFontLineHeight.headlineMedium / DSFontSize.headlineMedium;
  static const double titleLarge =
      DSFontLineHeight.titleLarge / DSFontSize.titleLarge;
  static const double titleMedium =
      DSFontLineHeight.titleMedium / DSFontSize.titleMedium;
  static const double titleSmall =
      DSFontLineHeight.titleSmall / DSFontSize.titleSmall;
  static const double bodyLarge =
      DSFontLineHeight.bodyLarge / DSFontSize.bodyLarge;
  static const double bodyMedium =
      DSFontLineHeight.bodyMedium / DSFontSize.bodyMedium;
  static const double bodySmall =
      DSFontLineHeight.bodySmall / DSFontSize.bodySmall;
}

extension DSFontWeight on FontWeight {
  static const light = FontWeight.w300;
  static const regular = FontWeight.w400;
  static const semiBold = FontWeight.w600;
  static const bold = FontWeight.w700;
}
