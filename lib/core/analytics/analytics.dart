enum AnalyticsEvents {
  onBoardingStep1ConnectClickup,
  onBoardingStep1Start,
  onBoardingStep1Demo,
  onBoardingStep2Back,
  onBoardingStep2Next,
  onBoardingStep2Skip,
  onBoardingStep3Back,
  onBoardingStep3Next,
  onBoardingStep3Skip,
  onBoardingStep4Connect,
  onBoardingStep4CopyLink,
  onBoardingStep2Demo,
  onBoardingStep3Demo,
  onBoardingStep4Demo,
  addTask,
  editTask,
  deleteTask,
  createList,
  editList,
  deleteList,
  createFolder,
  editFolder,
  deleteFolder,
  createTag,
  editTag,
  deleteTag,
  changeLanguage,
}

abstract class Analytics {
  Future<void> initialize();

  Future<void> logAppOpen();

  Future<void> logEvent(String eventName, {Map<String, Object?>? parameters});

  Future<void> setCurrentScreen(String screenName);

  Future<void> setUserId(String userId);
}
