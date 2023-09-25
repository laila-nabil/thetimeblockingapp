abstract class LocalDataSource {
  Future<void> init();

  Future<Object?> getData({required String key});

  Future<bool> setData<T>({
    required String key,
    required T value,
  });
}
