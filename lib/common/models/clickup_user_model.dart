import '../entities/clickup_user.dart';

/// id : 55230798
/// username : "Laila Nabil"
/// email : "laila.nabil.mustafa1@gmail.com"
/// color : "#7b68ee"
/// profilePicture : null
/// initials : "LN"
/// week_start_day : 0
/// global_font_support : true
/// timezone : "Africa/Cairo"

class ClickupUserModel extends ClickupUser {
  const ClickupUserModel({
    super.id,
    super.username,
    super.email,
    super.color,
    super.profilePicture,
    super.initials,
    super.weekStartDay,
    super.globalFontSupport,
    super.timezone,
  });

  factory ClickupUserModel.fromJson(dynamic json) {
    return ClickupUserModel(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        color: json['color'],
        profilePicture: json['profilePicture'],
        initials: json['initials'],
        weekStartDay: json['week_start_day'],
        globalFontSupport: json['global_font_support'],
        timezone: json['timezone']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['email'] = email;
    map['color'] = color;
    map['profilePicture'] = profilePicture;
    map['initials'] = initials;
    map['week_start_day'] = weekStartDay;
    map['global_font_support'] = globalFontSupport;
    map['timezone'] = timezone;
    return map;
  }
}
