import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/responsive.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import '../features/startup/presentation/pages/startup_page.dart';

// GoRouter configuration
final router = GoRouter(
    // refreshListenable: ValueNotifier<Locale>(sl<LanguageBloc>().state.currentLocale),
    initialLocation: StartUpPage.routeName,
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
      }
      return null;
    },
    routes: [
      GoRoute(
        path: StartUpPage.routeName,
        builder: (context, state) => const StartUpPage(),
      )
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
