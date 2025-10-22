import 'package:flutter/material.dart';

import '../core/extensions.dart';

ThemeData theme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
    useMaterial3: true,
    fontFamily: 'Montserrat',
    textTheme: context.textTheme
        .apply(bodyColor: Colors.white)
        .copyWith(
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w200,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w200,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w200,
          ),
          headlineSmall: TextStyle(
            fontSize: 18,
            color: Colors.white,
            letterSpacing: 3,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 3,
            fontWeight: FontWeight.w600,
          ),
          headlineLarge: TextStyle(
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 3,
            fontWeight: FontWeight.w600,
          ),
        ),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white),
      hintStyle: TextStyle(color: Colors.white),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 0.5),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 0.5),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 0.5),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 0.5),
      ),
      errorStyle: TextStyle(color: Colors.red),
    ),

    // This controls the actual text input color
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.white,
      selectionHandleColor: Colors.white,
    ),

    // Button themes
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        textStyle: TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        textStyle: TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white),
        textStyle: TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontWeight: FontWeight.w500),
      ),
    ),

    // Date picker theme
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.grey.shade900,
      headerBackgroundColor: Colors.grey.shade800,
      headerForegroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.black;
        }
        return Colors.white;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return Colors.transparent;
      }),
      yearForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.black;
        }
        return Colors.white;
      }),
      yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return Colors.transparent;
      }),
      weekdayStyle: TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.w500,
      ),
      dayStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      yearStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      rangeSelectionOverlayColor: WidgetStateProperty.all(
        Colors.white.withValues(alpha: 0.1),
      ),
      rangeSelectionBackgroundColor: Colors.white.withValues(alpha: 0.1),
      todayForegroundColor: WidgetStateProperty.all(
        Colors.white,
      ),
      todayBackgroundColor: WidgetStateProperty.all(
        Colors.white.withValues(alpha: 0.1),
      ),
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontWeight: FontWeight.w500),
      ),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
  );
}
