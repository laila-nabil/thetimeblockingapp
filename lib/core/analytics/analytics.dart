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
  onBoardingStep4CopyLink, onBoardingStep2Demo, onBoardingStep3Demo, onBoardingStep4Demo
}

abstract class Analytics {

  Future<void> initialize();

  Future<void> logAppOpen();

  Future<void> logEvent(String eventName);

  Future<void> setCurrentScreen(String screenName);
}
