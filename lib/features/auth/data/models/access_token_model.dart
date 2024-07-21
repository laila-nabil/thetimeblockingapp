import '../../domain/entities/access_token.dart';

class AccessTokenModel extends AccessToken {
  const AccessTokenModel({required super.accessToken, required super.tokenType});

  factory AccessTokenModel.fromJson(Map<String,dynamic> json) {
    return AccessTokenModel(
        accessToken: json["access_token"].toString(),tokenType:  json["token_type"].toString());
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = accessToken;
    map['token_type'] = tokenType;
    return map;
  }
}
