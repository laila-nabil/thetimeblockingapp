import 'package:equatable/equatable.dart';

class ClickUpAccessToken extends Equatable {
  final String accessToken;

  const ClickUpAccessToken(this.accessToken);

  @override
  List<Object?> get props => [accessToken];
}
