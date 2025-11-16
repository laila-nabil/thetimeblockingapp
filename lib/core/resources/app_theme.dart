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
      color: AppColors.grey(isDarkMode,700),
      thickness: 0.1
    ),
    drawerTheme: DrawerThemeData(
      shape:  const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero
      ),
      elevation: 10,
        shadowColor: isDarkMode
            ? AppColors.white(false)
            : AppColors.grey(isDarkMode)),
    colorScheme: ColorScheme(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.white(false),
      secondary: AppColors.secondary(isDarkMode),
      onSecondary: AppColors.primary,
      error: AppColors.error(isDarkMode),
      onError: AppColors.white(isDarkMode),
      surface: AppColors.background(isDarkMode),
      onSurface: AppColors.text(isDarkMode),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.background(isDarkMode),
      shadowColor: AppColors.grey(isDarkMode,500),
      surfaceTintColor: AppColors.background(isDarkMode),
    ),
    chipTheme: const ChipThemeData(
      side: BorderSide.none,
      elevation: 1,
      padding: EdgeInsets.zero,
    ));
