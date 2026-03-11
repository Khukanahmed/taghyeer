import 'package:flutter/material.dart';
import 'package:taghyeer/core/const/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.buttonColor,
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.buttonColor,
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  );
}
