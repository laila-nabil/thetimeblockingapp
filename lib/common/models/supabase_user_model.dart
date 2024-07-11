import 'package:thetimeblockingapp/core/extensions.dart';

import '../entities/user.dart';


class SupabaseUserModel extends User {
  const SupabaseUserModel({
    super.id,
    super.email,
  });

  factory SupabaseUserModel.fromJson(Map<String,dynamic> json) {
    return SupabaseUserModel(
        id: (json['id']as Object?)?.toStringOrNull(),
        email: json['email'],);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    return map;
  }
}
