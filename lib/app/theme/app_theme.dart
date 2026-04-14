import 'package:flutter/material.dart';
import 'package:mgw_eva/core/constants/ui_tokens.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    const primaryColor = Color(0xFF159A9C);
    const secondaryColor = Color(0xFFB86A00);
    const surfaceColor = Color(0xFFF3F6F8);
    const surfaceContainerColor = Color(0xFFFFFFFF);
    const outlineColor = Color(0xFFD2DCE3);
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ).copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: surfaceColor,
          surfaceContainerHighest: surfaceContainerColor,
          outlineVariant: outlineColor,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surfaceColor,
      canvasColor: const Color(0xFFEAF0F4),
      visualDensity: VisualDensity.standard,
      textTheme: Typography.blackMountainView.copyWith(
        headlineMedium: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          height: 1.05,
        ),
        titleMedium: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      cardTheme: const CardThemeData(
        color: surfaceContainerColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(UiTokens.cardRadius)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: surfaceColor,
        foregroundColor: Color(0xFF11181F),
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 68,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        disabledColor: const Color(0xFFF1F4F7),
        selectedColor: primaryColor.withAlpha(24),
        secondarySelectedColor: primaryColor.withAlpha(24),
        side: BorderSide(color: outlineColor.withAlpha(160)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: const TextStyle(color: Color(0xFF6E7F8D)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: outlineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E2A34),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        contentTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      dividerColor: outlineColor,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primaryColor.withAlpha(30),
        elevation: 0,
        height: 74,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
          final isSelected = states.contains(WidgetState.selected);

          return TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? const Color(0xFF10161D)
                : const Color(0xFF5C6C79),
          );
        }),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF11181F)),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData get darkTheme {
    const primaryColor = Color(0xFF27D3C3);
    const secondaryColor = Color(0xFFFFB84D);
    const surfaceColor = Color(0xFF10161D);
    const surfaceContainerColor = Color(0xFF17212B);
    const outlineColor = Color(0xFF2A3743);
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ).copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: surfaceColor,
          surfaceContainerHighest: surfaceContainerColor,
          outlineVariant: outlineColor,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surfaceColor,
      canvasColor: const Color(0xFF0D1319),
      visualDensity: VisualDensity.standard,
      textTheme: Typography.whiteMountainView.copyWith(
        headlineMedium: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          height: 1.05,
        ),
        titleMedium: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      cardTheme: const CardThemeData(
        color: surfaceContainerColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(UiTokens.cardRadius)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 68,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceContainerColor,
        disabledColor: surfaceContainerColor,
        selectedColor: primaryColor.withAlpha(32),
        secondarySelectedColor: primaryColor.withAlpha(32),
        side: BorderSide(color: outlineColor.withAlpha(115)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerColor.withAlpha(185),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: const TextStyle(color: Color(0xFF8193A3)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: outlineColor.withAlpha(70)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A242E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        contentTextStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      dividerColor: outlineColor,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF131C25),
        indicatorColor: primaryColor.withAlpha(46),
        elevation: 0,
        height: 74,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
          final isSelected = states.contains(WidgetState.selected);

          return TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
