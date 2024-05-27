import 'package:flutter/widgets.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';

import '../../../../core/analytics/analytics.dart';
import '../../../../core/localization/localization.dart';

class ChangeLanguageUseCase {
  final Localization localization;

  ChangeLanguageUseCase(this.localization);

  Future<void> call(ChangeLanguageParams params) {
    serviceLocator<Analytics>().logEvent(AnalyticsEvents.changeLanguage.name,
        parameters: {
          AnalyticsEventParameter.language.name: params.locale.languageCode
        });

    return localization.setLocale(params.context, params.locale);
  }
}

class ChangeLanguageParams {
  final Locale locale;
  final BuildContext context;

  ChangeLanguageParams({required this.locale, required this.context});
}
