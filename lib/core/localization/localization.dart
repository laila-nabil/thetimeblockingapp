

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

enum LanguagesEnum { ar, en }

abstract class Localization {
  Locale languagesEnumToLocale(LanguagesEnum language);
  Locale getCurrentLocale(BuildContext context);
  LanguagesEnum? getCurrentLanguagesEnum(BuildContext context);
  String getCurrentLangCode(BuildContext context);
  void setLocale(BuildContext context, Locale selectedLanguage);
  void setLanguage(BuildContext context, LanguagesEnum selectedLanguage);
  String translate(String key);
  bool isRTL(BuildContext context);
  dynamic localizationSetup(Widget app);
  Future<void> ensureInitialized();
}

class LocalizationImpl implements Localization{
  @override
  Locale getCurrentLocale(BuildContext context) {
    return context.locale;
  }

  @override
  bool isRTL(BuildContext context) {
    return Directionality.of(context).toString().toLowerCase().contains('rtl');
  }

  @override
  Locale languagesEnumToLocale(LanguagesEnum language) {
    switch(language){
      case LanguagesEnum.ar:
        return const Locale('ar', 'EG');
      case LanguagesEnum.en:
        return const Locale('en', 'UK');
    }
  }

  @override
  dynamic localizationSetup(Widget app) {
    const assetsPath = 'assets/locales';
    const supportedLocales = [Locale('en', 'UK'), Locale('ar', 'EG')];
    final defaultLocale = supportedLocales[0];
    return EasyLocalization(
        path: assetsPath,
        supportedLocales: supportedLocales,
        startLocale: defaultLocale,
        child: app
    );
  }

  @override
  void setLanguage(BuildContext context, LanguagesEnum selectedLanguage) {
    context.setLocale(languagesEnumToLocale(selectedLanguage));
  }

  @override
  void setLocale(BuildContext context, Locale selectedLanguage) {
    context.setLocale(selectedLanguage);
  }

  @override
  String translate(String key,
      {List<String>? arguments, Map<String, String>? namedArguments}) {
    return key.tr(args:arguments,namedArgs: namedArguments);
  }

  @override
  String getCurrentLangCode(BuildContext context) {
    return context.locale.languageCode;
  }

  @override
  LanguagesEnum? getCurrentLanguagesEnum(BuildContext context) {
    final language = getCurrentLangCode(context);
    switch(language){
      case 'ar':
        return LanguagesEnum.ar;
      case 'en':
        return LanguagesEnum.en;
    }
    return null;
  }

  @override
  Future<void> ensureInitialized() {
    return EasyLocalization.ensureInitialized();
  }

}
