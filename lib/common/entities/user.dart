import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';
import 'package:timezone/timezone.dart' as tz;

class User extends Equatable {
  const User({
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

  tz.TimeZone? get getTimezone  {
    if(timezone?.isNotEmpty == false){
      return null;
    }
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
