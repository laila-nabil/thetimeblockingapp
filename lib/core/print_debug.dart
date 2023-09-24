import 'package:flutter/foundation.dart';

void printDebug(Object? object) {
  if (kDebugMode) {
    debugPrint(object.toString());
  }
}
