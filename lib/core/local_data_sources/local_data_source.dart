enum LocalDataSourceKeys {
  accessToken,
  supabaseUser,
  refreshToken,
}

abstract class LocalDataSource {

  Future<String?> getStringData({required String key});
  Future<List<String>?> getStringListData({required String key});
  Future<bool?> getBoolData({required String key});

  Future<void> setData<T>({
    required String key,
    required T value,
  });

  Future<void>? clear();
}
