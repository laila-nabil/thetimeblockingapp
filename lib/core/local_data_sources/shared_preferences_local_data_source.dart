import 'package:shared_preferences/shared_preferences.dart';
import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';

class SharedPrefLocalDataSource implements LocalDataSource {
  static late SharedPreferences _sharedPreferences;

  @override
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Future<Object?> getData({required String key}) async {
    await init();
    return _sharedPreferences.get(key);
  }

  @override
  Future<bool> setData<T>({required String key, required T value}) async {
    await init();
    if (value is int) return await _sharedPreferences.setInt(key, value);
    if (value is bool) return await _sharedPreferences.setBool(key, value);
    if (value is double) return await _sharedPreferences.setDouble(key, value);

    return await _sharedPreferences.setString(key, value.toString());
  }
}
