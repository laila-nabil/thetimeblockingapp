import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/delete_account_use_case.dart';

import 'package:thetimeblockingapp/features/settings/domain/use_cases/sign_out_use_case.dart';

import '../../../../common/entities/access_token.dart';
import '../../domain/use_cases/change_language_use_case.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ChangeLanguageUseCase _changeLanguageUseCase;

  SettingsBloc(this._changeLanguageUseCase,)
      : super(const SettingsState()) {
    on<SettingsEvent>((event, emit) async {
      if (event is ChangeLanguageEvent) {
        await _changeLanguageUseCase(event.changeLanguageParams);
        emit(SettingsState(
            isLoading: false,
            themeMode: state.themeMode,
            currentLanguage: event.changeLanguageParams.locale));
      } else if (event is ChangeThemeEvent) {
        emit(SettingsState(
            currentLanguage: state.currentLanguage,
            themeMode: event.themeMode));
      }
    });
  }
}
