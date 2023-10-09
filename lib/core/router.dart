import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/lists/presentation/pages/list_page.dart';
import 'package:thetimeblockingapp/features/lists/presentation/pages/lists_page.dart';
import 'package:thetimeblockingapp/features/tags/presentation/pages/tags_page.dart';
import 'package:thetimeblockingapp/features/trash/presentation/pages/trash_page.dart';

import '../common/widgets/responsive/responsive_scaffold.dart';
import '../features/all/presentation/pages/all_page.dart';
import '../features/archive/presentation/pages/archive_page.dart';
import '../features/auth/presentation/pages/auth_page.dart';
import '../features/help/presentation/pages/help_page.dart';
import '../features/maps/presentation/pages/maps_page.dart';
import '../features/schedule/presentation/pages/schedule_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/someday/presentation/pages/someday_page.dart';
import '../features/tags/presentation/pages/tag_page.dart';
import 'globals.dart';

// GoRouter configuration
final router = GoRouter(
    // refreshListenable: ValueNotifier<Locale>(sl<LanguageBloc>().state.currentLocale),
    initialLocation: AuthPage.routeName,
    debugLogDiagnostics: true,
    observers: [MyNavObserver()],
    errorBuilder: (context, state) {
      String errorMessage = appLocalization.translate("pageNotFound");
      return ResponsiveScaffold(
          responsiveBody: ResponsiveTParams(
              mobile: Text(errorMessage), laptop: Text(errorMessage)),
          context: context);
    },
    redirect: (context, GoRouterState? state) {
      if (state?.queryParameters != null &&
          state?.queryParameters["Code"] != null) {
        ///TODO
      }else if (Globals.clickupAuthAccessToken.accessToken.isEmpty ||
          Globals.clickupUser == null ||
          Globals.clickupWorkspaces?.isNotEmpty == false) {
        return AuthPage.routeName;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AuthPage.routeName,
        builder: (context, state) => const AuthPage(),
          redirect: (context, state) async {
            if (Globals.clickupAuthAccessToken.accessToken.isNotEmpty &&
                Globals.clickupUser != null &&
                Globals.clickupWorkspaces?.isNotEmpty == true) {
              return SchedulePage.routeName;
            }
            return null;
          }
      ),
      GoRoute(
        path: SchedulePage.routeName,
        builder: (context, state) => const SchedulePage(),
      ),
      GoRoute(
        path: AllPage.routeName,
        builder: (context, state) => const AllPage(),
      ),
      GoRoute(
        path: ArchivePage.routeName,
        builder: (context, state) => const ArchivePage(),
      ),
      GoRoute(
        path: HelpPage.routeName,
        builder: (context, state) => const HelpPage(),
      ),
      GoRoute(
        path: ListsPage.routeName,
        builder: (context, state) => const ListsPage(),
      ),
      GoRoute(
        path: ListPage.routeName,
        builder: (context, state) => const ListPage(),
      ),
      GoRoute(
        path: MapsPage.routeName,
        builder: (context, state) => const MapsPage(),
      ),
      GoRoute(
        path: MapsPage.routeName,
        builder: (context, state) => const MapsPage(),
      ),
      GoRoute(
        path: SettingsPage.routeName,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: SomedayPage.routeName,
        builder: (context, state) => const SomedayPage(),
      ),
      GoRoute(
        path: TagsPage.routeName,
        builder: (context, state) => const TagsPage(),
      ),
      GoRoute(
        path: TagPage.routeName,
        builder: (context, state) => const TagPage(),
      ),
      GoRoute(
        path: TrashPage.routeName,
        builder: (context, state) => const TrashPage(),
      ),
    ]);

class MyNavObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => printDebug(
      'GoRouter didPush: ${route.str}, previousRoute= ${previousRoute?.str}');

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => printDebug(
      'GoRouter didPop: ${route.str}, previousRoute= ${previousRoute?.str}');

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) => printDebug(
      'GoRouter didRemove: ${route.str}, previousRoute= ${previousRoute?.str}');

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      printDebug(
          'GoRouter didReplace: new= ${newRoute?.str}, old= ${oldRoute?.str}');

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) =>
      printDebug('GoRouter didStartUserGesture: ${route.str}, '
          'previousRoute= ${previousRoute?.str}');

  @override
  void didStopUserGesture() => printDebug('GoRouter didStopUserGesture');
}

extension on Route<dynamic> {
  String get str => 'route(${settings.name}: ${settings.arguments})';
}
