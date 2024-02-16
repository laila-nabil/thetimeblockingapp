import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../../../../core/localization/localization.dart';

class ChangeLanguageUseCase implements UseCase<Unit,ChangeLanguageParams>{
  final Localization localization;

  ChangeLanguageUseCase(this.localization);
  @override
  Future<Either<Failure, Unit>?> call(ChangeLanguageParams params) async{
    localization.setLocale(params.context, params.locale);
    return const Right(unit);
  }

}


class ChangeLanguageParams{
  final Locale locale;
  final BuildContext context;

  ChangeLanguageParams({required this.locale, required this.context});
}