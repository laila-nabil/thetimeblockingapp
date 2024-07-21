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

class ClickupGlobals {
  final String clickupUrl;

  final String clickupClientId;

  final String clickupClientSecret;

  final String clickupRedirectUrl;

  final String clickupTerms = "https://clickup.com/terms";
  final String clickupPrivacy = "https://clickup.com/terms/privacy";
  String get clickupAuthUrl =>
      "https://app.clickup.com/api?client_id=$clickupClientId&redirect_uri=$clickupRedirectUrl";

  ClickupGlobals(
      {this.clickupUrl = "",
      this.clickupClientId = "",
      this.clickupClientSecret = "",
      this.clickupRedirectUrl = ""});

  ClickupGlobals copyWith({
    String? clickupUrl,
    String? clickupClientId,
    String? clickupClientSecret,
    String? clickupRedirectUrl,
  }) {
    return ClickupGlobals(
      clickupUrl: clickupUrl ?? this.clickupUrl,
      clickupClientId: clickupClientId ?? this.clickupClientId,
      clickupClientSecret: clickupClientSecret ?? this.clickupClientSecret,
      clickupRedirectUrl: clickupRedirectUrl ?? this.clickupRedirectUrl,
    );
  }
}
