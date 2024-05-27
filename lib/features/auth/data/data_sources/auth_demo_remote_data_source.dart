
import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/core/demo.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import '../../domain/use_cases/get_clickup_access_token_use_case.dart';
import '../../domain/use_cases/get_clickup_user_use_case.dart';
import '../models/clickup_access_token_model.dart';
import 'auth_remote_data_source.dart';


class AuthDemoRemoteDataSourceImpl implements AuthRemoteDataSource {

  @override
  Future<ClickupAccessTokenModel> getClickupAccessToken(
      {required GetClickupAccessTokenParams params}) async {
    printDebug("params.code ${params.code}");
    return Demo.accessTokenModel;
  }

  @override
  Future<ClickupUserModel> getClickupUser({required GetClickupUserParams params}) async {
    return Demo.user;
  }

}
