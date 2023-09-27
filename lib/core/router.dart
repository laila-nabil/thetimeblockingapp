import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import '../common/widgets/responsive/responsive_scaffold.dart';
import '../features/auth/presentation/pages/auth_page.dart';
import '../features/schedule/presentation/pages/schedule_page.dart';
import 'globals.dart';

// GoRouter configuration
final router = GoRouter(
    // refreshListenable: ValueNotifier<Locale>(sl<LanguageBloc>().state.currentLocale),
    initialLocation: AuthPage.routeName,
    debugLogDiagnostics: true,
    observers: [MyNavObserver()],
    errorBuilder: (context, state) {
      String errorMessage = LocalizationImpl().translate("pageNotFound");
      return ResponsiveScaffold(
          responsiveBody: ResponsiveTParams(
              mobile: Text(errorMessage), laptop: Text(errorMessage)),
          context: context);
    },
    redirect: (context, GoRouterState? state) {
      if (state?.queryParameters != null &&
          state?.queryParameters["Code"] != null) {
        ///TODO
      }else if (Globals.clickUpAuthAccessToken.accessToken.isEmpty ||
          Globals.clickUpUser == null ||
          Globals.clickUpWorkspaces?.isNotEmpty == false) {
        return AuthPage.routeName;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AuthPage.routeName,
        builder: (context, state) => const AuthPage(),
          redirect: (context, state) async {
            if (Globals.clickUpAuthAccessToken.accessToken.isNotEmpty &&
                Globals.clickUpUser != null &&
                Globals.clickUpWorkspaces?.isNotEmpty == true) {
              return SchedulePage.routeName;
            }
            return null;
          }
      ),
      GoRoute(
        path: SchedulePage.routeName,
        builder: (context, state) => const SchedulePage(),
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
