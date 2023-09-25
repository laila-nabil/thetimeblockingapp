import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'network/network.dart';
import 'package:logger/logger.dart';

final sl = GetIt.instance;

void initSl() {
  _initSl();
}

// void _initSl({required Network network}){
void _initSl() {
  /// Globals
  sl.registerSingleton(Logger());

  /// Bloc

  /// UseCases

  /// Repos

  /// DataSources

  /// External
}

@visibleForTesting
void initSlTesting({required Network mockNetwork}) {
  // _initSl();
}
