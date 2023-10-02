import 'dart:ui';

import 'package:thetimeblockingapp/core/print_debug.dart';

extension ElementAtNullableOrEmpty<T> on List<T>?{
  T? get tryFirst{
    if(this!=null && this?.isNotEmpty == true){
      return this?.first;
    }else{
      return null;
    }
  }

  T?  tryElementAt(int index){
    if(this!=null && this?.isNotEmpty == true && (index < (this?.length ??0) == true)){
      return this?.elementAt(index);
    }else{
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
    if(colorInt != null){
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
        millisecondsSinceEpoch + millisecondsTimezoneOffset,isUtc: true);
    printDebug("for $millisecondsSinceEpoch and timezoneoffset $millisecondsTimezoneOffset, the date $result");
    return result;
  }

  static DateTime? getDateTimeFromStringTimeZone({String? date,int? millisecondsTimezoneOffset }){
    int? dateInt = int.tryParse(date ?? "");
    if(dateInt == null){
      return null;
    }
    return DateTimeExtensions.fromMillisecondsSinceEpochTimeZone(
        dateInt,
        millisecondsTimezoneOffset: millisecondsTimezoneOffset ?? 0,);
  }

  static DateTime? getDateTimeFromString({String? date,int? millisecondsTimezoneOffset }){
    int? dateInt = int.tryParse(date ?? "");
    if(dateInt == null){
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(
      dateInt,
    );
  }
}