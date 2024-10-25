import 'package:thetimeblockingapp/core/extensions.dart';

import '../entities/user.dart';


class SupabaseUserModel extends User {
  const SupabaseUserModel({
    super.id,
    super.email,
    super.isAnonymous,
  });

  factory SupabaseUserModel.fromJson(Map<String,dynamic> json) {
    return SupabaseUserModel(
        id: (json['id']as Object?)?.toStringOrNull(),
        email: json['email'],
        isAnonymous: json['is_anonymous'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    map['is_anonymous'] = isAnonymous;
    return map;
  }
}
