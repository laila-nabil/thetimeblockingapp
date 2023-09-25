import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:thetimeblockingapp/core/network/network_http.dart';
import '../common/enums/auth_mode.dart';
import '../features/auth/data/data_sources/auth_remote_data_source.dart';
import 'network/clickup_exception_handler.dart';
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
  clickUpAuthAccessToken,
  clickUpUrl
}

void _initSl({required Network network}) {
  /// Globals
  sl.registerSingleton(Logger());
  sl.registerSingleton('Flutter Demo',
      instanceName: NamedInstances.appName.name);
  sl.registerSingleton('https://api.clickup.com/api/v2/',
      instanceName: NamedInstances.clickUpUrl.name);
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
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        network: sl(),
        clickUpClientId: getClickUpClientId,
        clickUpClientSecret: getClickUpClientSecret,
        clickUpUrl: getClickUpUrl
      ));

  /// External
}

String get getClickUpClientSecret =>
    sl.get(instanceName: NamedInstances.clickUpClientSecret.name);

String  get getClickUpClientId =>
    sl.get(instanceName: NamedInstances.clickUpClientId.name);

String get  getAppName =>
    sl.get(instanceName:  NamedInstances.appName.name);

String  get  getClickUpUrl =>
    sl.get(instanceName:  NamedInstances.clickUpUrl.name);

void initSl() {
  _initSl(
      network: NetworkHttp(
          httpClient: Client(), responseHandler: clickUpResponseHandler));
}

@visibleForTesting
void initSlTesting({required Network mockNetwork}) {
  _initSl(network: mockNetwork);
}
