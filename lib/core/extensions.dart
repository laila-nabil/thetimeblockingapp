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

  static String _fourDigits(int? n) {
    if (n == null) return "";
    int absN = n.abs();
    String sign = n < 0 ? "-" : "";
    if (absN >= 1000) return "$n";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }

  static String _twoDigits(int? n) {
    if (n == null) return "";
    if (n >= 10) return "$n";
    return "0$n";
  }

  static String? customToString(DateTime? dateTime,{bool includeTime = true}){
    if(dateTime == null){
      return null;
    }
    String y = _fourDigits(dateTime.year);
    String m = _twoDigits(dateTime.month);
    String d = _twoDigits(dateTime.day);
    String amPm = "am";
    var hour = dateTime.hour;
    if( hour > 12){
      hour -= 12;
      amPm = "pm";
    }
    String h = _twoDigits(hour);
    String min = _twoDigits(dateTime.minute);
    if (dateTime.isUtc == true) {
      return "$y-$m-$d ${includeTime ? "$h:$min $amPm.Z":""}";
    } else {
      return "$y-$m-$d ${includeTime ? "$h:$min $amPm" : ""}";
    }
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
    final urlWithoutScheme = url.replaceAll("https://", "");
    final host = urlWithoutScheme.split("/").first;
    final path =
        urlWithoutScheme.substring(host.length, urlWithoutScheme.length);

    return Uri(
        scheme: "https",
        host: host,
        path: path,
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
    final urlWithoutScheme = url.replaceAll("https://", "");
    final host = urlWithoutScheme.split("/").first;
    final path =
        urlWithoutScheme.substring(host.length, urlWithoutScheme.length);
    return Uri(scheme: "https", host: host, path: path, queryParameters: query);
  }
}

extension StringExtensions on Object? {
    String? toStringOrNull(){
      if(this == null){
        return null;
      }
      return toString();
    }
}