import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';
import '../models/sign_in_result_model.dart';
import 'auth_remote_data_source.dart';


class AuthDemoRemoteDataSourceImpl implements AuthRemoteDataSource {

  @override
  Future<SignInResultModel> signInSupabase({required SignInParams params}) async{
    throw UnimplementedError();
    // return SignInResultModel(
    //     accessToken: Demo.accessTokenModel, user: Demo.supabaseUser);
  }

}
