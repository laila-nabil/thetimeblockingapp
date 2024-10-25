import 'package:thetimeblockingapp/common/models/access_token_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_user_model.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/sign_up_anonymously_result.dart';

class SignUpAnonymouslyResultModel extends SignUpAnonymouslyResult {
  SignUpAnonymouslyResultModel(
      {super.accessToken,
      super.expiresAt,
      super.expiresIn,
      super.refreshToken,
      super.user});

  factory SignUpAnonymouslyResultModel.fromJson(dynamic json) {
    return SignUpAnonymouslyResultModel(
        accessToken: AccessTokenModel(accessToken: json['access_token'], tokenType: json['token_type']),
        expiresIn: json['expires_in'],
        expiresAt: json['expires_at'],
        refreshToken: json['refresh_token'],
        user: json['user'] != null
            ? SupabaseUserModel.fromJson(json['user'])
            : null);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = accessToken?.accessToken;
    map['token_type'] = accessToken?.tokenType;
    map['expires_in'] = expiresIn;
    map['expires_at'] = expiresAt;
    map['refresh_token'] = refreshToken;
    if (user != null) {
      map['user'] = (user as SupabaseUserModel?)?.toJson();
    }
    return map;
  }
}
