import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/features/settings/presentation/bloc/settings_bloc.dart';

import 'app_colors.dart';

/// Dark mode extension
extension DarkMode on BuildContext {
  bool get isDarkMode {
    return BlocProvider.of<SettingsBloc>(this).state.themeMode == ThemeMode.dark;
  }
}

ThemeData appTheme(bool isDarkMode) => ThemeData(
    useMaterial3: true,
    dividerTheme: DividerThemeData(
      color: isDarkMode ? AppColors.grey(100) : AppColors.grey(700),
      thickness: 0.1
    ),
    drawerTheme: DrawerThemeData(
      shape:  const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero
      ),
      elevation: isDarkMode?  2 : 10,
        shadowColor: isDarkMode ? AppColors.grey(50).withOpacity(0.2) : AppColors.grey()),
    colorScheme: ColorScheme(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primary: AppColors.primary(isDarkMode),
      onPrimary: AppColors.white,
      secondary: AppColors.secondary(isDarkMode),
      onSecondary: AppColors.primary(isDarkMode),
      error: AppColors.error(),
      onError: isDarkMode ? AppColors.black : AppColors.white,
      surface: AppColors.background(isDarkMode),
      onSurface: AppColors.text(isDarkMode),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.background(isDarkMode),
      shadowColor: isDarkMode
          ? AppColors.grey(50).withOpacity(0.2)
          : AppColors.grey(500),
      elevation: isDarkMode
          ? 0.5
          : null,
      surfaceTintColor: AppColors.background(isDarkMode),
    ),
    chipTheme: const ChipThemeData(
      side: BorderSide.none,
      elevation: 1,
      padding: EdgeInsets.zero,
    ));
