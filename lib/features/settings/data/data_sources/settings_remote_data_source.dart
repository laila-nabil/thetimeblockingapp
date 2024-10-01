import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/core/response_interceptor.dart';

import '../../../../core/network/network.dart';
import '../../../../core/network/supabase_header.dart';
import '../../../../core/print_debug.dart';
import '../../../auth/data/data_sources/auth_local_data_source.dart';
import '../../../auth/data/data_sources/auth_remote_data_source.dart';

abstract class SettingsRemoteDataSource{


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



}