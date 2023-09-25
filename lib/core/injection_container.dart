import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:thetimeblockingapp/core/network/network_http.dart';
import 'network/network.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart';

final sl = GetIt.instance;

void _initSl({required Network network}) {
  /// Globals
  sl.registerSingleton(Logger());

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
