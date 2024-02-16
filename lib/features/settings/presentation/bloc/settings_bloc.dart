import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';

import '../../domain/use_cases/change_language_use_case.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ChangeLanguageUseCase _changeLanguageUseCase;

  SettingsBloc(this._changeLanguageUseCase)
      : super(SettingsState()) {
    on<SettingsEvent>((event, emit) async {
      if (event is ChangeLanguageEvent) {
        final result = await _changeLanguageUseCase(event.changeLanguageParams);
        result?.fold(
            (l) => null,
            (r) => emit(SettingsState(
                currentLanguage: event.changeLanguageParams.locale)));
      }
    });
  }
}
