import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/models/supabase_user_model.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';
import 'package:thetimeblockingapp/features/auth/data/models/sign_in_result_model.dart';
import '../../../../common/models/access_token_model.dart';
import 'dart:convert';

abstract class SettingsLocalDataSource {
  Future<void> saveThemeMode(ThemeMode themeMode);

  Future<ThemeMode> getThemeMode();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final LocalDataSource localDataSource;

  SettingsLocalDataSourceImpl(this.localDataSource);
 

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) {
    return localDataSource.setData(
        key: LocalDataSourceKeys.themeMode.name, value: themeMode.index.toString());
  }
  

  @override
  Future<ThemeMode> getThemeMode() async {
    var data = await localDataSource.getStringData(
        key: LocalDataSourceKeys.themeMode.name);
    var indexParsed = int.tryParse(data??"");
    if (data == null || indexParsed == null) {
      await saveThemeMode(AppConfig.defaultTheme);
      return AppConfig.defaultTheme;
    }
    return ThemeMode.values[indexParsed];

  }
}
