import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'injection_container.dart';

enum PrintLevel { trace, debug, info, warning, error, fatalError }

void printDebug(Object? object, {PrintLevel? printLevel = PrintLevel.trace}) {
  if (kDebugMode) {
    _printLogger(printLevel, object);
  }
}

void _printLogger(PrintLevel? printLevel, Object? object) {
  final logger = serviceLocator<Logger>();
  switch (printLevel) {
    case (PrintLevel.trace):
      logger.t(object);
    case (PrintLevel.debug):
      logger.d(object);
    case (PrintLevel.info):
      logger.i(object);
    case (PrintLevel.warning):
      logger.w(object);
    case (PrintLevel.error):
      logger.e(object);
    case (PrintLevel.fatalError):
      logger.f(object);
    default:
      debugPrint(object.toString());
  }
}

// ignore: unused_element
void _printDebugPrint(
  Object? object,
) {
  if (kDebugMode) {
    debugPrint(object.toString());
  }
}
