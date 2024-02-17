enum AnalyticsEvents {
  onBoardingStep1ConnectClickup,
  onBoardingStep1Start,
  onBoardingStep2Back,
  onBoardingStep2Next,
  onBoardingStep2Skip,
  onBoardingStep3Back,
  onBoardingStep3Next,
  onBoardingStep3Skip,
  onBoardingStep4Connect,
  onBoardingStep4CopyLink
}

abstract class Analytics {

  Future<void> initialize();

  Future<void> logAppOpen();

  Future<void> logEvent(String eventName);

  Future<void> setCurrentScreen(String screenName);
}
