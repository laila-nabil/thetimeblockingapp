import 'package:thetimeblockingapp/core/network/network.dart';

abstract class StartUpRemoteDataSource {

}

class ClickupStartUpRemoteDataSourceImpl implements StartUpRemoteDataSource {
  final Network network;
  final String clickupClientId;
  final String clickupClientSecret;
  final String clickupUrl;

  ClickupStartUpRemoteDataSourceImpl({
    required this.network,
    required this.clickupClientId,
    required this.clickupClientSecret,
    required this.clickupUrl,
  });

}
