import '../../domain/entities/clickup_access_token.dart';

class ClickUpAccessTokenModel extends ClickUpAccessToken {
  const ClickUpAccessTokenModel({required super.accessToken, required super.tokenType});

  factory ClickUpAccessTokenModel.fromJson(dynamic json) {
    return ClickUpAccessTokenModel(
        accessToken: json["access_token"].toString(),tokenType:  json["token_type"].toString());
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = accessToken;
    map['token_type'] = tokenType;
    return map;
  }
}
