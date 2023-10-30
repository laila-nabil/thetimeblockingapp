import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'injection_container.dart';

enum PrintLevel { trace, debug, info, warning, error, fatalError }

void printDebug(Object? object, {PrintLevel? printLevel = PrintLevel.trace}) {
  if (kDebugMode) {
    try {
      _printLogger(printLevel, object);
    } catch (e) {
      _printDebugPrint(object);
    }
  }
}

LogPrinter logPrinter = PrettyPrinter(
    noBoxingByDefault: true, methodCount: 0, errorMethodCount: 10);

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

void _printDebugPrint(
  Object? object,
) {
  if (kDebugMode) {
    debugPrint(object.toString());
  }
}

class SimpleLogPrinter extends LogPrinter {
  SimpleLogPrinter();
  @override
  List<String> log(LogEvent event) {
    AnsiColor color = PrettyPrinter().levelColors?[event.level] ??
        AnsiColor.fg(AnsiColor.grey(0.5));
    String emoji = PrettyPrinter().levelEmojis?[event.level] ?? "-";
    return [
      if(event.stackTrace!=null)"\n",
      if(event.stackTrace!=null)color('stackTrace: ${event.stackTrace}'),
      // color!('${DateFormat("hh:mm:ss:ms").format(event.time)} - ${event.message}'),
      color('$emoji ${event.message}'),
    ];
  }
}