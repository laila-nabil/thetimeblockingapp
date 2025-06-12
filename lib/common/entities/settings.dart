class Settings {
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

  num? id;
  String? langCode;
  bool? syncWithGoogleCalendar;
  bool? syncWithOutlookCalendar;
  num? startWeekDaySat;
  dynamic textSize;
  bool? isDarkMode;
  bool? enableAnalytics;
  dynamic activeWorkspaceId;
  String? userId;


}