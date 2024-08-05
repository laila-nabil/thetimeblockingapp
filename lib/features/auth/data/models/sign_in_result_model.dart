import 'package:thetimeblockingapp/common/models/supabase_user_model.dart';
import 'package:thetimeblockingapp/common/models/access_token_model.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/sign_in_result.dart';

class SignInResultModel extends SignInResult {
  const SignInResultModel(
      {required AccessTokenModel super.accessToken,
      required SupabaseUserModel super.user});

  factory SignInResultModel.fromJson(Map<String, dynamic> json) {
    return SignInResultModel(
      accessToken: AccessTokenModel(
          accessToken: json['accessToken'], tokenType: json['tokenType']),
      user: SupabaseUserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['accessToken'] = accessToken.accessToken;
    map['tokenType'] = accessToken.tokenType;
    map['user'] = (user as SupabaseUserModel).toJson();
    return map;
  }
}
