import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'core/bloc_observer.dart';
import 'core/injection_container.dart';
import 'core/localization/localization.dart';
import 'core/resources/app_theme.dart';
import 'core/injection_container.dart' as di;
import 'core/router.dart';
import 'features/startup/presentation/bloc/startup_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizationImpl().ensureInitialized();
  di.initServiceLocator();
  await di.reRegisterClickupVariables();

  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  Bloc.observer = MyBlocObserver();
  runApp(LocalizationImpl().localizationSetup(const MyApp()));
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
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        title: di.getAppName,
        theme: appTheme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        onGenerateTitle: (BuildContext context) {
          return di.getAppName;
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
