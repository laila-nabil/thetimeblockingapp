import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_local_data_source.dart';
import '../../domain/repositories/startup_repo.dart';
import '../data_sources/startup_remote_data_source.dart';

class StartUpRepoImpl with GlobalsWriteAccess implements StartUpRepo {
  final StartUpRemoteDataSource startUpRemoteDataSource;
  final TasksLocalDataSource tasksLocalDataSource;

  StartUpRepoImpl(
    this.startUpRemoteDataSource,
    this.tasksLocalDataSource,
  );


}
