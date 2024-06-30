import 'package:thetimeblockingapp/common/entities/clickup_user.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';

enum Backend { clickup, supabaseTimeBlocking }

class ClickupGlobals {
  final String clickupUrl;

  final String clickupClientId;

  final String clickupClientSecret;

  final String clickupRedirectUrl;

  final ClickupAccessToken clickupAuthAccessToken;

  final ClickupUser? clickupUser;

  final ClickupWorkspace? selectedWorkspace;

  final ClickupSpace? selectedSpace;

  final List<ClickupWorkspace>? clickupWorkspaces;

  final List<ClickupSpace>? clickupSpaces;

  ClickupGlobals(
      {required this.clickupUrl,
      required this.clickupClientId,
      required this.clickupClientSecret,
      required this.clickupRedirectUrl,
      required this.clickupAuthAccessToken,
      this.clickupUser,
      this.selectedWorkspace,
      this.selectedSpace,
      this.clickupWorkspaces,
      this.clickupSpaces});

  String get clickupAuthUrl =>
      "https://app.clickup.com/api?client_id=$clickupClientId&redirect_uri=$clickupRedirectUrl";

  String clickupTerms = "https://clickup.com/terms";
  String clickupPrivacy = "https://clickup.com/terms/privacy";

  ClickupWorkspace? get defaultWorkspace => clickupWorkspaces?.firstOrNull;
  ClickupSpace? get defaultSpace => clickupSpaces?.firstOrNull;
  ClickupGlobals copyWith({
    String? clickupUrl,
    String? clickupClientId,
    String? clickupClientSecret,
    String? clickupRedirectUrl,
    ClickupAccessToken? clickupAuthAccessToken,
    ClickupUser? clickupUser,
    ClickupWorkspace? selectedWorkspace,
    ClickupSpace? selectedSpace,
    List<ClickupWorkspace>? clickupWorkspaces,
    List<ClickupSpace>? clickupSpaces,
  }) {
    return ClickupGlobals(
      clickupUrl: clickupUrl ?? this.clickupUrl,
      clickupClientId: clickupClientId ?? this.clickupClientId,
      clickupClientSecret: clickupClientSecret ?? this.clickupClientSecret,
      clickupRedirectUrl: clickupRedirectUrl ?? this.clickupRedirectUrl,
      clickupAuthAccessToken:
          clickupAuthAccessToken ?? this.clickupAuthAccessToken,
      clickupUser: clickupUser ?? this.clickupUser,
      selectedWorkspace: selectedWorkspace ?? this.selectedWorkspace,
      selectedSpace: selectedSpace ?? this.selectedSpace,
      clickupWorkspaces: clickupWorkspaces ?? this.clickupWorkspaces,
      clickupSpaces: clickupSpaces ?? this.clickupSpaces,
    );
  }
}
