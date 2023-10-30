import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:timezone/timezone.dart' as tz;

/// id : 55230798
/// username : "Laila Nabil"
/// email : "laila.nabil.mustafa1@gmail.com"
/// color : "#7b68ee"
/// profilePicture : null
/// initials : "LN"
/// week_start_day : 0
/// global_font_support : true
/// timezone : "Africa/Cairo"

class ClickupUser extends Equatable {
  const ClickupUser({
    this.id,
    this.username,
    this.email,
    this.color,
    this.profilePicture,
    this.initials,
    this.weekStartDay,
    this.globalFontSupport,
    this.timezone,
  });

  final num? id;
  final String? username;
  final String? email;
  final String? color;
  final dynamic profilePicture;
  final String? initials;
  final num? weekStartDay;
  final bool? globalFontSupport;
  final String? timezone;

  ClickupAssignee get asAssignee => ClickupAssignee(
      id: id,
      email: email,
      color: color,
      initials: initials,
      username: username,
      profilePicture: profilePicture);

  tz.TimeZone get getTimezone  {
    final location = tz.getLocation(timezone??"");
    printDebug("location from time zone $location");
    final currentTimeZone = location.currentTimeZone;
    printDebug("currentTimeZone $currentTimeZone");
    return currentTimeZone;
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        color,
        profilePicture,
        initials,
        weekStartDay,
        globalFontSupport,
        timezone,
      ];
}
