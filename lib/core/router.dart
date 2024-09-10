import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/entities/tasks_list.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/presentation/pages/supabase_auth_page.dart';
import 'package:thetimeblockingapp/features/global/presentation/bloc/global_bloc.dart';
import 'package:thetimeblockingapp/features/lists/presentation/bloc/lists_page_bloc.dart';
import 'package:thetimeblockingapp/features/lists/presentation/pages/list_page.dart';
import 'package:thetimeblockingapp/features/lists/presentation/pages/lists_page.dart';
import 'package:thetimeblockingapp/features/tags/presentation/bloc/tags_page_bloc.dart';
import 'package:thetimeblockingapp/features/tags/presentation/pages/tags_page.dart';
import 'package:thetimeblockingapp/features/terms_conditions/terms_conditions_page.dart';
import 'package:thetimeblockingapp/features/trash/presentation/pages/trash_page.dart';

import '../common/widgets/responsive/responsive_scaffold.dart';
import '../features/all/presentation/pages/all_tasks_page.dart';
import '../features/archive/presentation/pages/archive_page.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/help/presentation/pages/help_page.dart';
import '../features/maps/presentation/pages/maps_page.dart';
import '../features/privacy_policy/privacy_policy_page.dart';
import '../features/schedule/presentation/pages/schedule_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/all/presentation/pages/someday_page.dart';
import '../features/tags/presentation/pages/tag_page.dart';

// GoRouter configuration
final router = GoRouter(
    // refreshListenable: ValueNotifier<Locale>(sl<LanguageBloc>().state.currentLocale),
    initialLocation: SupabaseAuthPage.routeName,
    debugLogDiagnostics: true,
    observers: [MyNavObserver(),serviceLocator<Analytics>().navigatorObserver],
    errorBuilder: (context, state) {
      String errorMessage = appLocalization.translate("pageNotFound");
      return ResponsiveScaffold(
          responsiveBody: ResponsiveTParams(
              small: Text(errorMessage), large: Text(errorMessage)),
        context: context,
        onRefresh: () async {
          GoRouter.of(context).go(SupabaseAuthPage.routeName);
        },
      );
    },
    redirect: (context, GoRouterState? state) {
      printDebug("redirectAfterAuthRouteName ${serviceLocator(
          type: String,
          instanceName:
          ServiceLocatorName.redirectAfterAuthRouteName.name)}");
      printDebug("state?.uri ${state?.uri}");
      if (BlocProvider.of<AuthBloc>(context).state.accessToken == null ||
          BlocProvider.of<AuthBloc>(context).state.user == null) {
        if(state?.uri.toString() != SupabaseAuthPage.routeName){
          printDebug("state in redirect before authpage name:${state?.name},location:${state?.uri},extra:${state?.extra},fullPath:${state?.fullPath},matchedLocation:${state?.matchedLocation},pageKey:${state?.pageKey},pathParameters:${state?.pathParameters}");
          serviceLocator.registerSingleton<String>(state?.uri.toString()??"",
              instanceName: ServiceLocatorName.redirectAfterAuthRouteName.name);
        }
        return SupabaseAuthPage.routeName;
      }
      return null;
    },
    routes: [
      GoRoute(
          path: SupabaseAuthPage.routeName,
          builder: (context, state) {
            return SupabaseAuthPage();
          },
          redirect: (context, state) async {
            if (BlocProvider.of<AuthBloc>(context).state.accessToken != null &&
                BlocProvider.of<AuthBloc>(context).state.user != null &&
                BlocProvider.of<GlobalBloc>(context).state.workspaces?.isNotEmpty == true) {
              return SchedulePage.routeName;
            }
            return null;
          }),
      GoRoute(
        path: SchedulePage.routeName,
        builder: (context, state) {
          bool? waitForStartGetTasks;
          if(state.extra is bool){
            waitForStartGetTasks = state.extra as bool;
          }
          return SchedulePage(waitForStartGetTasks: waitForStartGetTasks??false,);
        },
        redirect: (context,state) async{
          final userLoggedIn = BlocProvider
              .of<AuthBloc>(context)
                        .state
                        .accessToken
                        ?.accessToken
                        .isNotEmpty ==
                    true &&
                BlocProvider.of<AuthBloc>(context).state.user != null &&
              BlocProvider.of<GlobalBloc>(context).state.workspaces?.isNotEmpty == true;
            var redirectAuth = serviceLocator.get(
                  type: String,
                  instanceName:
                  ServiceLocatorName.redirectAfterAuthRouteName.name);
            if (userLoggedIn && (redirectAuth as String).isNotEmpty) {
              String redirectAfterAuthRouteName = redirectAuth;

              serviceLocator.registerSingleton<String>("",
                  instanceName: ServiceLocatorName.redirectAfterAuthRouteName.name);


              return redirectAfterAuthRouteName;

          }
          return null;
        }
      ),
      GoRoute(
        path: AllTasksPage.routeName,
        builder: (context, state) => const AllTasksPage(),
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
        builder: (context, state) =>  const ListsPage(),
      ),
      GoRoute(
        path: ListPage.routeName,
        builder: (context, state) => ListPage(
                listsPageBloc: (state.extra as List)[0] as ListsPageBloc,
                list: (state.extra as List)[1] as TasksList,
              ),
          redirect: (context,state){
          if(state.extra == null){
            return ListsPage.routeName;
          }
          return null;
        }
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
        builder: (context, state) => TagPage(
            tagName: state.uri.queryParameters[TagPage.queryParametersList.first]
            as String,tagsPageBloc: state.extra as TagsPageBloc),
        redirect: (context,state){
          if(state.extra == null){
            return TagsPage.routeName;
          }
          return null;
        }
      ),
      GoRoute(
        path: TrashPage.routeName,
        builder: (context, state) => const TrashPage(),
      ),
      GoRoute(
        path: PrivacyPolicyPage.routeName,
        builder: (context, state) => PrivacyPolicyPage(),
      ),
      GoRoute(
        path: TermsConditionsPage.routeName,
        builder: (context, state) => TermsConditionsPage(),
      ),
    ]);

class MyNavObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printDebug('GoRouter didPush: ${route.str}, previousRoute= ${previousRoute?.str}');
  }

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
