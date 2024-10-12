import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/delete_account_use_case.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/report_issue_use_case.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/request_feature_use_case.dart';

import 'package:thetimeblockingapp/features/settings/domain/use_cases/sign_out_use_case.dart';

import '../../../../common/entities/access_token.dart';
import '../../domain/use_cases/change_language_use_case.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ChangeLanguageUseCase _changeLanguageUseCase;
  final RequestFeatureUseCase _requestFeatureUseCase;
  final ReportIssueUseCase _reportIssueUseCase;

  SettingsBloc(this._changeLanguageUseCase, this._requestFeatureUseCase,
      this._reportIssueUseCase,) : super(
      const SettingsState(settingsStateEnum: SettingsStateEnum.initial)) {
    on<SettingsEvent>((event, emit) async {
      if (event is ChangeLanguageEvent) {
        await _changeLanguageUseCase(event.changeLanguageParams);
        emit(state.copyWith(
            themeMode: state.themeMode,
            currentLanguage: event.changeLanguageParams.locale));
      } else if (event is ChangeThemeEvent) {
        emit(state.copyWith(
            currentLanguage: state.currentLanguage,
            themeMode: event.themeMode));
      } else if (event is RequestFeatureEvent) {
        emit(state.copyWith(settingsStateEnum: SettingsStateEnum.loading));
        final result = await _requestFeatureUseCase(event.params);
        result.fold(
            (l) => emit(
                  state.copyWith(
                      settingsStateEnum: SettingsStateEnum.requestFeatureFailed,
                      requestFeatureFailure: l),
                ),
            (r) => emit(
                  state.copyWith(
                    settingsStateEnum: SettingsStateEnum.requestFeatureSuccess,
                  ),
                ));
      }else if (event is ReportIssueEvent) {
        emit(state.copyWith(settingsStateEnum: SettingsStateEnum.loading));
        final result = await _reportIssueUseCase(event.params);
        result.fold(
                (l) => emit(
              state.copyWith(
                  settingsStateEnum: SettingsStateEnum.reportIssueFailed,
                  reportIssueFailure: l),
            ),
                (r) => emit(
              state.copyWith(
                settingsStateEnum: SettingsStateEnum.reportIssueSuccess,
              ),
            ));
      }
    });
  }
}
