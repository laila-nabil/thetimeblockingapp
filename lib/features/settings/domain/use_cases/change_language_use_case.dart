import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../../../../core/localization/localization.dart';

class ChangeLanguageUseCase {
  final Localization localization;

  ChangeLanguageUseCase(this.localization);

  Future<void> call(ChangeLanguageParams params) {
    return localization.setLocale(params.context, params.locale);
  }

}


class ChangeLanguageParams{
  final Locale locale;
  final BuildContext context;

  ChangeLanguageParams({required this.locale, required this.context});
}