import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:thetimeblockingapp/core/network/network_http.dart';
import '../common/enums/auth_mode.dart';
import 'network/network.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart';

final sl = GetIt.instance;

enum NamedInstances {
  appName,
  authMode,
  clickUpClientId,
  clickUpClientSecret,
  clickUpRedirectUrl,
  clickUpAuthAccessToken
}

void _initSl({required Network network}) {
  /// Globals
  sl.registerSingleton(Logger());
  sl.registerSingleton('Flutter Demo',
      instanceName: NamedInstances.appName.name);
  sl.registerSingleton<AuthMode>(AuthMode.clickUpOnly,
      instanceName: NamedInstances.authMode.name);
  sl.registerSingleton("", instanceName: NamedInstances.clickUpClientId.name);
  sl.registerSingleton("",
      instanceName: NamedInstances.clickUpClientSecret.name);
  sl.registerSingleton("",
      instanceName: NamedInstances.clickUpRedirectUrl.name);
  sl.registerSingleton("",
      instanceName: NamedInstances.clickUpAuthAccessToken.name);

  /// Bloc

  /// UseCases

  /// Repos

  /// DataSources

  /// External
}

void initSl() {
  _initSl(network: NetworkHttp(httpClient: Client()));
}

@visibleForTesting
void initSlTesting({required Network mockNetwork}) {
  _initSl(network: mockNetwork);
}
