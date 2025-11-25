enum LocalDataSourceKeys {
  accessToken,
  supabaseUser,
  refreshToken,
  themeMode,
}

abstract class LocalDataSource {

  Future<int?> getIntData({required String key});
  Future<String?> getStringData({required String key});
  Future<List<String>?> getStringListData({required String key});
  Future<bool?> getBoolData({required String key});

  Future<void> setData<T>({
    required String key,
    required T value,
  });

  Future<void> setIntData({
    required String key,
    required int value,
  });

  Future<void>? clear();
}
