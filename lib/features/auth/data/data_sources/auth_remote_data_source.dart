import 'dart:convert';

import 'package:thetimeblockingapp/core/network/network.dart';
import 'package:thetimeblockingapp/core/network/supabase_header.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';
import '../../../../common/models/access_token_model.dart';
import '../models/sign_in_result_model.dart';

abstract class AuthRemoteDataSource {

  Future<SignInResultModel> signInSupabase({required SignInParams params});
}

class SupabaseAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final String url;
  final String key;
  final Network network;

  SupabaseAuthRemoteDataSourceImpl(
      {required this.network, required this.url, required this.key});

  @override
  Future<SignInResultModel> signInSupabase(
      {required SignInParams params}) async {
    final result = await network.post(
        headers: supabaseHeader(
            accessToken: const AccessTokenModel(accessToken: "", tokenType: ""),
            apiKey: key),
        uri: Uri.parse("$url/auth/v1/token?grant_type=password"),
        body: {"email": params.email, "password": params.password});
    return SignInResultModel.fromJson(json.decode(result.body));
  }
}
