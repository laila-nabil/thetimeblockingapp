import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/models/supabase_settings_model.dart';

class Settings extends Equatable {
  Settings({
    this.id,
    this.langCode,
    this.syncWithGoogleCalendar,
    this.syncWithOutlookCalendar,
    this.startWeekDaySat,
    this.textSize,
    this.isDarkMode,
    this.enableAnalytics,
    this.activeWorkspaceId,
    this.userId,
  });

  final num? id;
  final String? langCode;
  final bool? syncWithGoogleCalendar;
  final bool? syncWithOutlookCalendar;
  final num? startWeekDaySat;
  final dynamic textSize;
  final bool? isDarkMode;
  final bool? enableAnalytics;
  final dynamic activeWorkspaceId;
  final String? userId;

  SupabaseSettingsModel get toModel{
    return SupabaseSettingsModel(
      userId: userId,
      activeWorkspaceId: activeWorkspaceId,
      enableAnalytics: enableAnalytics,
      id: id,
      isDarkMode: isDarkMode,
      langCode: langCode,
      startWeekDaySat: startWeekDaySat,
      syncWithGoogleCalendar: syncWithGoogleCalendar,
      syncWithOutlookCalendar: syncWithOutlookCalendar,
      textSize: textSize
    );
  }

  @override
  List<Object?> get props =>
      [
        id,
        langCode,
        syncWithGoogleCalendar,
        syncWithOutlookCalendar,
        startWeekDaySat,
        textSize,
        isDarkMode,
        enableAnalytics,
        activeWorkspaceId,
        userId,
      ];
}
