import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';

class SignInResult extends Equatable{
  final AccessToken accessToken;
  final User user;
  final String refreshToken;

  const SignInResult(
      {required this.accessToken,
      required this.user,
      required this.refreshToken});

  @override
  List<Object?> get props => [accessToken,user];
}