enum LocalDataSourceKeys {
  accessToken,
  supabaseUser,
  refreshToken,
  workspaces,
  spaces,
  selectedWorkspace,
  selectedSpace
}

abstract class LocalDataSource {
  Future<void> init();

  Future<String?> getData({required String key});

  Future<void> setData<T>({
    required String key,
    required T value,
  });

  Future<bool> clear();
}
