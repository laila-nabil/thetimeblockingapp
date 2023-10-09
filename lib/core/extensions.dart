// ignore_for_file: dead_code

import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

extension ElementAtNullableOrEmpty<T> on List<T>? {
  T? tryElementAt(int index) {
    if (this != null &&
        this?.isNotEmpty == true &&
        (index < (this?.length ?? 0) == true)) {
      return this?.elementAt(index);
    } else {
      return null;
    }
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color? fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    final colorInt = int.tryParse(buffer.toString(), radix: 16);
    if (colorInt != null) {
      try {
        return Color(colorInt);
      } catch (e) {
        printDebug(e);
      }
    }
    return null;
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension DateTimeExtensions on DateTime {
  static DateTime fromMillisecondsSinceEpochTimeZone(int millisecondsSinceEpoch,
      {int millisecondsTimezoneOffset = 0}) {
    final result = DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch + millisecondsTimezoneOffset,
        isUtc: true);
    printDebug(
        "for $millisecondsSinceEpoch and timezoneoffset $millisecondsTimezoneOffset, the date $result");
    return result;
  }

  static DateTime? getDateTimeFromStringTimeZone(
      {String? date, int? millisecondsTimezoneOffset}) {
    int? dateInt = int.tryParse(date ?? "");
    if (dateInt == null) {
      return null;
    }
    return DateTimeExtensions.fromMillisecondsSinceEpochTimeZone(
      dateInt,
      millisecondsTimezoneOffset: millisecondsTimezoneOffset ?? 0,
    );
  }

  static DateTime? getDateTimeFromString(
      {String? date, int? millisecondsTimezoneOffset}) {
    int? dateInt = int.tryParse(date ?? "");
    if (dateInt == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(
      dateInt,
    );
  }
}

extension ListDateTimeExtensions on List<DateTime> {
  static bool datesAIncludesB(List<DateTime?> datesA, List<DateTime?> datesB) {
    datesA.sort();
    datesB.sort();
    var firstA = datesA.firstOrNull;
    var firstB = datesB.firstOrNull;
    var lastA = datesA.lastOrNull;
    var lastB = datesB.lastOrNull;
    return (firstA != null &&
            (firstB?.isAfter(firstA) == true ||
                firstB?.isAtSameMomentAs(firstA) == true)) &&
        (lastA != null &&
            (lastB?.isBefore(lastA) == true ||
                lastB?.isAtSameMomentAs(lastA) == true));
    var a = firstA != null;
    var b = firstB?.isAfter(firstA!) == true;
    var c = firstB?.isAtSameMomentAs(firstA!) == true;
    var d = lastA != null;
    var e = lastB?.isBefore(lastA!) == true;
    var f = lastB?.isAtSameMomentAs(lastA!) == true;
    return (a && (b || c)) && (d && (e || f));
    return (datesA.first != null &&
            (datesB.first?.isAfter(datesA.first!) == true ||
                datesB.first?.isAtSameMomentAs(datesA.first!) == true)) &&
        (datesA.last != null &&
            (datesB.last?.isAfter(datesA.last!) == true ||
                datesB.last?.isAtSameMomentAs(datesA.last!) == true));
  }
}

extension UriExtension on Uri {
  static Uri uriHttps(
      {required String url, Map<String, String>? queryParameters}) {
    return Uri(
        scheme: "https",
        host: "",
        path: url.replaceAll("https://", ""),
        queryParameters: queryParameters);
  }

  static Uri uriHttpsClickupAPI(
      {required String url,
      Map<String, Either<List, String>>? queryParameters}) {
    Map<String, String>? query;
    if(queryParameters?.isNotEmpty == true){
      query = {};
      queryParameters?.forEach((key, value) {
        value.fold((l) {
          String v = "";
          String separator = "&$key[]=";
          for (var element in l) { v = "$v$element$separator";}
          v = v.substring(0,v.length-separator.length);
          query?.addAll({"$key[]": v});
        }, (r) => query?.addAll({key: r}));
      });
    }

    return Uri(
        scheme: "https",
        host: "",
        path: url.replaceAll("https://", ""),
        queryParameters: query);
  }
}
