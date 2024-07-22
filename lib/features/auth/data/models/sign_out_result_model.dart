import 'package:thetimeblockingapp/features/auth/domain/entities/sign_out_result.dart';

class SignOutResultModel extends SignOutResult{
  SignOutResultModel({required super.accessToken, required super.user});
  factory SignOutResultModel.fromJson(Map<String, dynamic> json) {
    return SignOutResultModel(
      accessToken: json['id'],
      user: UserModel,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['access'] = access;
    return map;
  }
}