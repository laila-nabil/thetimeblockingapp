class AppAssets {
  static const github = "assets/images/github@2x.png";
  static const twitter = "assets/images/twitter@2x.png";

  static logo(bool isDarkMode) =>
      isDarkMode
          ? "assets/images/logo_dark@2x.png"
          : "assets/images/logo@2x.png";
  static const onBoarding1desktop = "assets/images/onboarding1desktop.png";
  static const onBoarding2desktop = "assets/images/onboarding2desktop.png";
  static const onBoarding3desktop = "assets/images/onboarding3desktop.png";
  static const onBoardingClickupdesktop = "assets/images/onboardingclickupdesktop.png";
  static const onBoarding1mobile = "assets/images/onboarding1mobile.png";
  static const onBoarding2mobile = "assets/images/onboarding2mobile.png";
  static const onBoarding3mobile = "assets/images/onboarding3mobile.png";
  static const onBoardingClickupMobile = "assets/images/onboardingclickup.png";
  static String clickupLogo(bool isDarkMode) =>
      isDarkMode
          ? "assets/images/clickuplogo3.png"
          : "assets/images/clickuplogo1.png";
  static const String clickupLogoMin = "assets/images/clickuplogo2.png";
}
