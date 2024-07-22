import '../entities/user.dart';

/// id : 55230798
/// username : "Laila Nabil"
/// email : "laila.nabil.mustafa1@gmail.com"
/// color : "#7b68ee"
/// profilePicture : null
/// initials : "LN"
/// week_start_day : 0
/// global_font_support : true
/// timezone : "Africa/Cairo"

class ClickupUserModel extends User {
  const ClickupUserModel({
    super.id,
    super.username,
    super.email,
    super.color,
    super.profilePicture,
    super.initials,
    super.weekStartDay,
    super.timezone,
  });

  factory ClickupUserModel.fromJson(Map<String,dynamic> json) {
    return ClickupUserModel(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        color: json['color'],
        profilePicture: json['profilePicture'],
        initials: json['initials'],
        weekStartDay: json['week_start_day'],
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
    map['timezone'] = timezone;
    return map;
  }
}
