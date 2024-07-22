import '../entities/user.dart';


class SupabaseUserModel extends User {
  const SupabaseUserModel({
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

  factory SupabaseUserModel.fromJson(Map<String,dynamic> json) {
    return SupabaseUserModel(
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
