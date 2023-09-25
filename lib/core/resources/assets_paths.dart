
class AppAssets {

  static const String appLogo = 'assets/splash_screen_icon.png';
  static const String iconRain = 'assets/dashboard_icons/rain.svg';
  static const String iconSunrise = 'assets/dashboard_icons/sunrise.svg';
  static const String iconSunset = 'assets/dashboard_icons/sunset.svg';
  static const String iconWind = 'assets/dashboard_icons/wind.svg';
  static const String iconWind2 = 'assets/dashboard_icons/wind_2.svg';

  static const String icon3dPath = 'assets/weather_3d';

  static const String localeAr = 'assets/locales/ar-EG.json';
  static const String localeEn = 'assets/locales/en-UK.json';
  static const String visualCrossingFolder = 'assets/VisualCrossingFolder';
  static const String iconsPath = icon3dPath;

  static String getIconPath(num? weatherCode, bool? isDay) {
    String isDayString = (isDay??true) ? 'd' : 'n';
    if (weatherCode == 0 || weatherCode == 1) {
      return 'assets/weather_3d/01$isDayString.png';
    } else if (weatherCode == 2 || weatherCode == 3) {
      return 'assets/weather_3d/50$isDayString.png';
    } else if (weatherCode == 45 || weatherCode == 48) {
      return 'assets/weather_3d/02$isDayString.png';
    } else if (weatherCode == 51 || weatherCode == 61) {
      return 'assets/weather_3d/09$isDayString.png';
    } else if (weatherCode == 53 ||
        weatherCode == 63 ||
        weatherCode == 55 ||
        weatherCode == 65 ||
        weatherCode == 80 ||
        weatherCode == 81 ||
        weatherCode == 82) {
      return 'assets/weather_3d/10$isDayString.png';
    } else if (weatherCode == 56 ||
        weatherCode == 57 ||
        weatherCode == 66 ||
        weatherCode == 67 ||
        weatherCode == 71 ||
        weatherCode == 73 ||
        weatherCode == 75 ||
        weatherCode == 77 ||
        weatherCode == 85 ||
        weatherCode == 85) {
      return 'assets/weather_3d/13$isDayString.png';
    } else if (weatherCode == 95 || weatherCode == 96 || weatherCode == 99) {
      return 'assets/weather_3d/11$isDayString.png';
    }

    return 'assets/weather_3d/01$isDayString.png';
  }

  static const String github = "assets/links_icons/github2.png";
  static const String googlePlay = "assets/links_icons/google-play.png";
  static const String link = "assets/links_icons/link.png";
  static const String linkedin = "assets/links_icons/linkedin.png";
  static const String twitter = "assets/links_icons/twitter.png";
}
