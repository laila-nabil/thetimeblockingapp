part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final Locale? currentLanguage;
  final ThemeMode themeMode;
  final bool isLoading;

  const SettingsState(
      {this.currentLanguage,
      this.themeMode = ThemeMode.light,
      this.isLoading = false,
      });

  @override
  List<Object?> get props =>
      [currentLanguage, themeMode, isLoading,];

  SettingsState copyWith({
    Locale? currentLanguage,
    ThemeMode? themeMode,
    bool? isLoading,
  }) {
    return SettingsState(
      currentLanguage: currentLanguage ?? this.currentLanguage,
      themeMode: themeMode ?? this.themeMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
