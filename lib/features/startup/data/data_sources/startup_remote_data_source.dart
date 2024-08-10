import 'package:thetimeblockingapp/core/network/network.dart';

abstract class StartUpRemoteDataSource {}

class SupabaseStartUpRemoteDataSourceImpl implements StartUpRemoteDataSource {
  final String url;
  final String key;
  final Network network;

  SupabaseStartUpRemoteDataSourceImpl(
      {required this.url, required this.key, required this.network});
}
