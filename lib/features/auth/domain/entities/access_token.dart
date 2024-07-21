import 'package:equatable/equatable.dart';

class AccessToken extends Equatable {
  final String accessToken;
  final String tokenType;

  const AccessToken({required this.accessToken, required this.tokenType});


  bool get isEmpty => accessToken.isEmpty || tokenType.isEmpty;

  @override
  List<Object?> get props => [accessToken,tokenType];
}
