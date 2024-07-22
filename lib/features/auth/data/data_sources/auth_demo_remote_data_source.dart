
import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/core/demo.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';
import '../../domain/use_cases/get_access_token_use_case.dart';
import '../../domain/use_cases/get_user_use_case.dart';
import '../models/access_token_model.dart';
import '../models/sign_in_result_model.dart';
import 'auth_remote_data_source.dart';


class AuthDemoRemoteDataSourceImpl implements AuthRemoteDataSource {

  @override
  Future<AccessTokenModel> getAccessToken(
      {required GetAccessTokenParams params}) async {
    return Demo.accessTokenModel;
  }

  @override
  Future<ClickupUserModel> getClickupUser({required GetClickupUserParams params}) async {
    return Demo.clickUpUser;
  }

  @override
  Future<SignInResultModel> signInSupabase({required SignInParams params}) async{
    return SignInResultModel(
        accessToken: Demo.accessTokenModel, user: Demo.supabaseUser);
  }

}
