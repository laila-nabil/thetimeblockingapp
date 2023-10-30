import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';

abstract class StartUpLocalDataSource {

}

class StartUpLocalDataSourceImpl implements StartUpLocalDataSource {
  final LocalDataSource localDataSource;

  StartUpLocalDataSourceImpl(this.localDataSource);

}
