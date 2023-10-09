import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:thetimeblockingapp/core/network/network_http.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:thetimeblockingapp/features/startup/data/data_sources/startup_local_data_source.dart';
import 'package:thetimeblockingapp/features/startup/data/data_sources/startup_remote_data_source.dart';
import 'package:thetimeblockingapp/features/startup/presentation/bloc/startup_bloc.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/bloc/task_pop_up_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../features/auth/data/data_sources/auth_local_data_source.dart';
import '../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repo_impl.dart';
import '../features/auth/domain/use_cases/get_clickup_access_token_use_case.dart';
import '../features/auth/domain/use_cases/get_clickup_user_use_case.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/startup/data/repositories/startup_repo_impl.dart';
import '../features/startup/domain/repositories/startup_repo.dart';
import '../features/tasks/data/data_sources/tasks_local_data_source.dart';
import '../features/tasks/domain/use_cases/get_clickup_all_lists_in_folders_use_case.dart';
import '../features/tasks/domain/use_cases/get_clickup_folderless_lists_use_case.dart';
import '../features/tasks/domain/use_cases/get_clickup_folders_use_case.dart';
import '../features/tasks/domain/use_cases/get_clickup_lists_in_folder_use_case.dart';
import '../features/tasks/domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../features/tasks/data/data_sources/tasks_remote_data_source.dart';
import '../features/tasks/data/repositories/tasks_repo_impl.dart';
import '../features/tasks/domain/entities/clickup_task.dart';
import '../features/tasks/domain/use_cases/create_clickup_task_use_case.dart';
import '../features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';
import '../features/tasks/domain/use_cases/get_clickup_tasks_in_all_workspaces_use_case.dart';
import '../features/tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import '../features/tasks/domain/use_cases/update_clickup_task_use_case.dart';
import 'globals.dart';
import 'local_data_sources/local_data_source.dart';
import 'local_data_sources/shared_preferences_local_data_source.dart';
import 'network/clickup_exception_handler.dart';
import 'network/network.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart';

final serviceLocator = GetIt.instance;


void _initServiceLocator({required Network network}) {
  serviceLocator.allowReassignment = true;

  /// Globals
  serviceLocator.registerSingleton(Logger(printer: logPrinter));

  /// Bloc
  serviceLocator.registerFactory(
      () => StartupBloc(serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(
      () => AuthBloc(serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => ScheduleBloc(serviceLocator(),
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator.registerFactoryParam<TaskPopUpBloc, ClickupTask?, dynamic>(
      (ClickupTask? s, dynamic i) => TaskPopUpBloc(task: s));

  /// UseCases

  serviceLocator.registerLazySingleton(() => GetClickupAccessTokenUseCase(
        serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => GetClickupUserUseCase(
        serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => GetClickupWorkspacesUseCase(
        serviceLocator(),
      ));

  serviceLocator
      .registerLazySingleton(() => GetClickupTasksInSingleWorkspaceUseCase(
            serviceLocator(),
          ));
  serviceLocator
      .registerLazySingleton(() => GetClickupTasksInAllWorkspacesUseCase(
            serviceLocator(),
          ));

  serviceLocator.registerLazySingleton(() => CreateClickupTaskUseCase(
        serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => UpdateClickupTaskUseCase(
        serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => DeleteClickupTaskUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => GetClickupFoldersUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => GetClickupAllListsInFoldersUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => GetClickupListsInFolderUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => GetClickupFolderlessListsUseCase(
        serviceLocator(),
      ));

  /// Repos
  serviceLocator.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(serviceLocator(), serviceLocator()));
  serviceLocator.registerLazySingleton<TasksRepo>(
      () => TasksRepoImpl(serviceLocator(), serviceLocator()));

  serviceLocator.registerLazySingleton<StartUpRepo>(
      () => StartUpRepoImpl(serviceLocator(), serviceLocator()));

  /// DataSources
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
            network: serviceLocator(),
            clickupClientId: Globals.clickupClientId,
            clickupClientSecret: Globals.clickupClientSecret,
            clickupUrl: Globals.clickupUrl,
          ));
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(serviceLocator()));

  serviceLocator.registerLazySingleton<TasksRemoteDataSource>(
      () => TasksRemoteDataSourceImpl(
            network: serviceLocator(),
            clickupClientId: Globals.clickupClientId,
            clickupClientSecret: Globals.clickupClientSecret,
            clickupUrl: Globals.clickupUrl,
          ));

  serviceLocator.registerLazySingleton<StartUpRemoteDataSource>(
      () => StartUpRemoteDataSourceImpl(
            network: serviceLocator(),
            clickupClientId: Globals.clickupClientId,
            clickupClientSecret: Globals.clickupClientSecret,
            clickupUrl: Globals.clickupUrl,
          ));

  serviceLocator.registerLazySingleton<StartUpLocalDataSource>(
      () => StartUpLocalDataSourceImpl(serviceLocator()));

  serviceLocator.registerLazySingleton<TasksLocalDataSource>(
      () => TasksLocalDataSourceImpl(serviceLocator()));

  /// External

  serviceLocator.registerLazySingleton<LocalDataSource>(
      () => SharedPrefLocalDataSource());

  serviceLocator.registerLazySingleton<Network>(() => network);
}

void reRegisterClickupVariables() async {
  Globals.clickupClientId =
      const String.fromEnvironment("clickUpClientId", defaultValue: "");
  Globals.clickupClientSecret =
      const String.fromEnvironment("clickUpClientSecret", defaultValue: "");
  Globals.clickupRedirectUrl =
      const String.fromEnvironment("clickUpRedirectUrl", defaultValue: "");
}

void initServiceLocator() {
  _initServiceLocator(
      network: NetworkHttp(
          httpClient: Client(), responseHandler: clickupResponseHandler));
}

@visibleForTesting
void initServiceLocatorTesting({required Network mockNetwork}) {
  _initServiceLocator(network: mockNetwork);
}
