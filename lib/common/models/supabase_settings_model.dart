import '../entities/settings.dart';

/// id : 6
/// lang_code : "en"
/// sync_with_google_calendar : false
/// sync_with_outlook_calendar : false
/// start_week_day_sat : 0
/// text_size : null
/// is_dark_mode : false
/// enable_analytics : true
/// active_workspace_id : null
/// user_id : "65ca2319-cb7f-4ea1-bbe1-b71a49f0d838"

class SupabaseSettingsModel extends Settings {
  SupabaseSettingsModel({
    super.langCode,
    super.syncWithGoogleCalendar,
    super.syncWithOutlookCalendar,
    super.startWeekDaySat,
    super.textSize,
    super.isDarkMode,
    super.enableAnalytics,
    super.activeWorkspaceId,
    super.userId,
  });

  factory SupabaseSettingsModel.fromJson(dynamic json) {
    return SupabaseSettingsModel(
      langCode: json['lang_code'],
      syncWithGoogleCalendar: json['sync_with_google_calendar'],
      syncWithOutlookCalendar: json['sync_with_outlook_calendar'],
      startWeekDaySat: json['start_week_day_sat'],
      textSize: json['text_size'],
      isDarkMode: json['is_dark_mode'],
      enableAnalytics: json['enable_analytics'],
      activeWorkspaceId: json['active_workspace_id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if(langCode != null)'lang_code': this.langCode,
      if(syncWithGoogleCalendar != null)'sync_with_google_calendar': this.syncWithGoogleCalendar,
      if(syncWithOutlookCalendar != null)'sync_with_outlook_calendar': this.syncWithOutlookCalendar,
      if(startWeekDaySat != null)'start_week_day_sat': this.startWeekDaySat,
      if(textSize != null)'text_size': this.textSize,
      if(isDarkMode != null)'is_dark_mode': this.isDarkMode,
      if(enableAnalytics != null)'enable_analytics': this.enableAnalytics,
      if(activeWorkspaceId != null)'active_workspace_id': this.activeWorkspaceId,
      if(userId != null)'user_id': this.userId,
    };
  }
}
