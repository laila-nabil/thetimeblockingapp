import 'package:equatable/equatable.dart';

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
