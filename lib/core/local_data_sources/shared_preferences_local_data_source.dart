import 'package:shared_preferences/shared_preferences.dart';
import 'package:thetimeblockingapp/core/error/exceptions.dart';
import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';

class SharedPrefLocalDataSource implements LocalDataSource {
  static late SharedPreferences _sharedPreferences;

  @override
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Future<Object> getData({required String key}) async {
    await init();
    final result = _sharedPreferences.get(key);
    if (result !=null) {
      return result;
    }
    throw(EmptyCacheException());
  }

  @override
  Future<void> setData<T>({required String key, required T value}) async {
    await init();
    bool? result;
    if (value is int) result = await _sharedPreferences.setInt(key, value);
    if (value is bool) result =  await _sharedPreferences.setBool(key, value);
    if (value is double) result =  await _sharedPreferences.setDouble(key, value);

    result = await  _sharedPreferences.setString(key, value.toString());
    if(result != true){
      throw(FailedCachingException());
    }
  }
}
