import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/access_token.dart';

class SignOutResult extends Equatable{
  final AccessToken accessToken;
  final User user;

  const SignOutResult({required this.accessToken, required this.user});

  @override
  List<Object?> get props => [accessToken,user];
}