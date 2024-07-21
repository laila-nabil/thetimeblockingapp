import '../../domain/entities/access_token.dart';

class ClickupAccessTokenModel extends AccessToken {
  const ClickupAccessTokenModel({required super.accessToken, required super.tokenType});

  factory ClickupAccessTokenModel.fromJson(Map<String,dynamic> json) {
    return ClickupAccessTokenModel(
        accessToken: json["access_token"].toString(),tokenType:  json["token_type"].toString());
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = accessToken;
    map['token_type'] = tokenType;
    return map;
  }
}
