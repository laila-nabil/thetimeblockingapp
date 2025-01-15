import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:thetimeblockingapp/core/error/exceptions.dart';
import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

class SharedPrefLocalDataSource implements LocalDataSource {
  SharedPreferencesAsync?  _sharedPreferences;

  void _init() {
    _sharedPreferences = _sharedPreferences ?? SharedPreferencesAsync();
  }

  @override
  Future<String?> getStringData({required String key}) async {
    _init();
    final result = await _sharedPreferences?.getString(key);
    if (result !=null && result!="\"\"") {
      return result.toString();
    }
    throw(EmptyCacheException());
  }


  @override
  Future<bool?> getBoolData({required String key}) async {
    _init();
    final result = await _sharedPreferences?.getBool(key);
    if (result !=null) {
      return result;
    }
    throw(EmptyCacheException());
  }

  @override
  Future<List<String>?> getStringListData({required String key})  async {
    _init();
    final result = await _sharedPreferences?.getStringList(key);
    if (result !=null) {
      return result;
    }
    throw(EmptyCacheException());
  }

  @override
  Future<void> setData<T>({required String key, required T value}) async {
    _init();
    try {
      if (value is int) await _sharedPreferences?.setInt(key, value);
      if (value is bool)  await _sharedPreferences?.setBool(key, value);
      if (value is double)  await _sharedPreferences?.setDouble(key, value);
      await  _sharedPreferences?.setString(key, jsonEncode(value));
    } catch (e) {
      printDebug(e,printLevel: PrintLevel.error);
      throw FailedCachingException();
    }

  }

  @override
  Future<void>? clear() {
    return _sharedPreferences?.clear();
  }
}
