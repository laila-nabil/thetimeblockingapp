import 'package:thetimeblockingapp/common/entities/access_token.dart';

Map<String, String>? supabaseHeader(
    {required AccessToken accessToken, required String apiKey}) {
  return {
    "apiKey": apiKey,
    "Authorization": "${accessToken.tokenType} ${accessToken.accessToken}",
    "Content-Type": "application/json"
  };
}
