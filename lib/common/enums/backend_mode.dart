enum BackendMode {
  demo,
  supabase,
  offlineWithCalendarSync;

  bool get syncWithGoogleCalendar =>
      this == BackendMode.supabase ||
      this == BackendMode.offlineWithCalendarSync;

  bool get syncWithOutlookCalendar =>
      this == BackendMode.supabase ||
      this == BackendMode.offlineWithCalendarSync;

  BackendMode get mode => this;

  static BackendMode getBackendMode(String string) {
    if (string == BackendMode.demo.name) {
      return BackendMode.demo;
    }
    if (string == BackendMode.supabase.name) {
      return BackendMode.supabase;
    }
    if (string == BackendMode.offlineWithCalendarSync.name) {
      return BackendMode.offlineWithCalendarSync;
    }
    return BackendMode.supabase;
  }
}


