import '../../domain/entities/clickup_access_token.dart';

class ClickUpAccessTokenModel extends ClickUpAccessToken {
  const ClickUpAccessTokenModel(super.accessToken, super.tokenType);

  factory ClickUpAccessTokenModel.fromJson(dynamic json) {
    return ClickUpAccessTokenModel(json["access_token"], json["token_type"]);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = accessToken;
    map['token_type'] = tokenType;
    return map;
  }
}
