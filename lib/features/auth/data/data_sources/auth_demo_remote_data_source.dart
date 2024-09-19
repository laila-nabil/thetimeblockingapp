import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/models/access_token_model.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_up_use_case.dart';
import '../models/sign_in_result_model.dart';
import '../models/sign_up_result_model.dart';
import 'auth_remote_data_source.dart';
import 'package:dartz/dartz.dart' as dartz;


class AuthDemoRemoteDataSourceImpl implements AuthRemoteDataSource {

  @override
  Future<SignInResultModel> signInSupabase({required SignInParams params}) async{
    throw UnimplementedError();
    // return SignInResultModel(
    //     accessToken: Demo.accessTokenModel, user: Demo.supabaseUser);
  }

  @override
  Future<dartz.Unit> signOut() {
    throw UnimplementedError();
  }

  @override
  Future<SignUpResultModel> signUpSupabase({required SignUpParams params}) {
    // TODO: implement signUpSupabase
    throw UnimplementedError();
  }

  @override
  Future<SignInResultModel> refreshToken(
      {required String refreshToken, required AccessToken accessToken}) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }

}
