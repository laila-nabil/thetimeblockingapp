import 'package:equatable/equatable.dart';

class ClickUpAccessToken extends Equatable {
  final String accessToken;
  final String tokenType;

  const ClickUpAccessToken(this.accessToken,this.tokenType);

  @override
  List<Object?> get props => [accessToken,tokenType];
}
