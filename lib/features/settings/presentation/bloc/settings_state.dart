part of 'settings_bloc.dart';

enum SettingsStateEnum {
  initial,
  loading,
  requestFeatureSuccess,
  requestFeatureFailed,
  reportIssueSuccess,
  reportIssueFailed,
  updateSettingsFailed,
  updateSettingsSuccess
}

class SettingsState extends Equatable {
  final Locale? currentLanguage;
  final ThemeMode themeMode;
  final SettingsStateEnum settingsStateEnum;
  final Failure? requestFeatureFailure;
  final Failure? updateSettingsFailure;
  final Failure? reportIssueFailure;

  const SettingsState({
    this.currentLanguage,
    this.themeMode = ThemeMode.light,
    required this.settingsStateEnum,
    this.requestFeatureFailure,
    this.updateSettingsFailure,
    this.reportIssueFailure,
  });

  @override
  List<Object?> get props => [
        currentLanguage,
        themeMode,
        settingsStateEnum,
        requestFeatureFailure,
        updateSettingsFailure,
        reportIssueFailure,
      ];

  SettingsState copyWith({
    Locale? currentLanguage,
    ThemeMode? themeMode,
    SettingsStateEnum? settingsStateEnum,
    Failure? requestFeatureFailure,
    Failure? reportIssueFailure,
    Failure? updateSettingsFailure,
  }) {
    return SettingsState(
      currentLanguage: currentLanguage ?? this.currentLanguage,
      themeMode: themeMode ?? this.themeMode,
      settingsStateEnum: settingsStateEnum ?? this.settingsStateEnum,
      requestFeatureFailure: requestFeatureFailure,
      reportIssueFailure: reportIssueFailure,
      updateSettingsFailure: updateSettingsFailure,
    );
  }
}
