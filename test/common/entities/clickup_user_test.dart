// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:timezone/data/latest_all.dart'
    if (kIsWeb) 'core/mock_web_packages/mock_timezone.dart' as tz_not_web;
import 'package:timezone/timezone.dart';

void main() {
  setUp(() {
    tz_not_web.initializeTimeZones();
  });
  test('clickup user getTimezone', () {
    const user =  User(timezone: "Africa/Cairo");
    print("user ${user.getTimezone}");
    expect(user.getTimezone,
        const TimeZone(10800000, isDst: true, abbreviation: "EEST"));
  });
}