import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'core/bloc_observer.dart';
import 'core/localization/localization.dart';
import 'core/resources/app_theme.dart';
import 'core/injection_container.dart' as di;
import 'core/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizationImpl().ensureInitialized();
  di.initSl();
  di.sl.registerSingleton(
      const String.fromEnvironment('clickUpClientId', defaultValue: ""),
      instanceName: "clickUpClientId");
  di.sl.registerSingleton(
      const String.fromEnvironment('clickUpClientSecret', defaultValue: ""),
      instanceName: "clickUpClientSecret");
  di.sl.registerSingleton(
      const String.fromEnvironment('clickUpRedirectUrl', defaultValue: ""),
      instanceName: "clickUpRedirectUrl");

  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  Bloc.observer = MyBlocObserver();
  runApp(LocalizationImpl().localizationSetup(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig : router,
      title: di.getAppName,
      theme: appTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateTitle: (BuildContext context){
        return di.getAppName;
      },
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}

///TO FIX DRAGGING NOT WORKING WITH MOUSE
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus
      };
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  static const routeName = "/";
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
