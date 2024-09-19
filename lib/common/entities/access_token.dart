import 'package:equatable/equatable.dart';

import '../models/access_token_model.dart';

class AccessToken extends Equatable {
  final String accessToken;
  final String tokenType;

  const AccessToken({required this.accessToken, required this.tokenType});

  AccessTokenModel get toModel{
    return AccessTokenModel(accessToken: accessToken, tokenType: tokenType);
}

  bool get isEmpty => accessToken.isEmpty || tokenType.isEmpty;

  @override
  List<Object?> get props => [accessToken,tokenType];
}
