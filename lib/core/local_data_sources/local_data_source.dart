enum LocalDataSourceKeys { clickUpAccessToken, clickUpUser, clickUpWorkspaces }

abstract class LocalDataSource {
  Future<void> init();

  Future<Object?> getData({required String key});

  Future<void> setData<T>({
    required String key,
    required T value,
  });
}
