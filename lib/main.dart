import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'core/bloc_observer.dart';
import 'core/globals.dart';
import 'core/localization/localization.dart';
import 'core/print_debug.dart';
import 'core/resources/app_theme.dart';
import 'core/injection_container.dart' as di;
import 'core/router.dart';
import 'features/startup/presentation/bloc/startup_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/mock_web_packages/mock_timezone.dart'
    if (kIsWeb) 'package:timezone/browser.dart' as tz_web;
import 'package:timezone/data/latest_all.dart'
    if (kIsWeb) 'core/mock_web_packages/mock_timezone.dart' as tz_not_web;

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appLocalization.ensureInitialized();
  di.initServiceLocator();
  di.reRegisterClickupVariables();
  await di.serviceLocator<Analytics>().initialize();
  if (kIsWeb) {
    await tz_web.initializeTimeZone();
  } else {
    tz_not_web.initializeTimeZones();
  }
  FlutterError.onError = (errorDetails) {
    printDebug(errorDetails,printLevel: PrintLevel.fatalError);//👾
  };
  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  Bloc.observer = MyBlocObserver();
  runApp(appLocalization.localizationSetup(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.serviceLocator<StartupBloc>(),
        ),
        BlocProvider(
          create: (context) => di.serviceLocator<AuthBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        title: Globals.appName,
        theme: appTheme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        onGenerateTitle: (BuildContext context) {
          return Globals.appName;
        },
        scrollBehavior: MyCustomScrollBehavior(),
      ),
    );
  }
}

///TO FIX DRAGGING NOT WORKING WITH MOUSE
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus
      };
}
