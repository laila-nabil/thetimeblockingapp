enum BackendMode {
  clickupOnly,
  supabase,
  offlineWithCalendarSync;

  bool get syncWithGoogleCalendar =>
      this == BackendMode.supabase ||
      this == BackendMode.offlineWithCalendarSync;


  bool get syncWithOutlookCalendar =>
      this == BackendMode.supabase ||
          this == BackendMode.offlineWithCalendarSync;
}
