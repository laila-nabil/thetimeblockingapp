import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/core/response_interceptor.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/report_issue_use_case.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/request_feature_use_case.dart';

import '../../../../core/network/network.dart';
import '../../../../core/network/supabase_header.dart';
import '../../../../core/print_debug.dart';
import '../../../auth/data/data_sources/auth_local_data_source.dart';
import '../../../auth/data/data_sources/auth_remote_data_source.dart';

abstract class SettingsRemoteDataSource{
  Future<dartz.Unit> requestFeature({required RequestFeatureParams params});

  Future<dartz.Unit> reportIssue({required ReportIssueParams params});


}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource{
  final String url;
  final String key;
  final Network network;

  final ResponseInterceptorFunc responseInterceptor;
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  SettingsRemoteDataSourceImpl(
      {required this.url,
      required this.key,
      required this.network,
      required this.responseInterceptor,
      required this.authRemoteDataSource,
      required this.authLocalDataSource});

  @override
  Future<dartz.Unit> requestFeature({required RequestFeatureParams params}) async {
    NetworkResponse response = await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.post(
            uri: Uri.parse("$url/rest/v1/features_requests"),
            body: params.toJson(),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    printDebug("response $response");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> reportIssue({required ReportIssueParams params}) async {
    NetworkResponse response = await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.post(
            uri: Uri.parse("$url/rest/v1/issues"),
            body: params.toJson(),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    printDebug("response $response");
    return dartz.unit;
  }

}