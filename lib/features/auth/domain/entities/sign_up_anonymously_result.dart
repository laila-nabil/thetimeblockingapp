import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';

import '../../../../common/entities/user.dart';

/// access_token : "eyJhbkhzbFJSUXJjOXR"
/// token_type : "bearer"
/// expires_in : 3600
/// expires_at : 1729884603
/// refresh_token : "fushLHmXj5s2yJg6Xy8D9g"
/// user : {"id":"48cf08fba8f-c38e08dbcad1","aud":"authenticated","role":"authenticated","email":"","phone":"","last_sign_in_at":"2024-10-25T18:30:03.612727056Z","app_metadata":{},"user_metadata":{},"identities":[],"created_at":"2024-10-25T18:30:03.607452Z","updated_at":"2024-10-25T18:30:03.619892Z","is_anonymous":true}

class SignUpAnonymouslyResult extends Equatable {
  SignUpAnonymouslyResult({
    this.accessToken,
    this.expiresIn,
    this.expiresAt,
    this.refreshToken,
    this.user,});


  final AccessToken? accessToken;
  final num? expiresIn;
  final num? expiresAt;
  final String? refreshToken;
  final User? user;



  @override
  List<Object?> get props =>
      [accessToken, expiresIn, expiresAt, refreshToken, user,];


}