import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:thetimeblockingapp/core/network/network_http.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:thetimeblockingapp/features/startup/presentation/bloc/startup_bloc.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/bloc/task_pop_up_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../features/auth/data/data_sources/auth_local_data_source.dart';
import '../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repo_impl.dart';
import '../features/auth/domain/use_cases/get_clickup_access_token_use_case.dart';
import '../features/auth/domain/use_cases/get_clickup_user_use_case.dart';
import '../features/auth/domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/tasks/data/data_sources/tasks_remote_data_source.dart';
import '../features/tasks/data/repositories/tasks_repo_impl.dart';
import '../features/tasks/domain/use_cases/get_clickup_tasks_in_all_workspaces_use_case.dart';
import '../features/tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import 'globals.dart';
import 'local_data_sources/local_data_source.dart';
import 'local_data_sources/shared_preferences_local_data_source.dart';
import 'network/clickup_exception_handler.dart';
import 'network/network.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart';

final serviceLocator = GetIt.instance;

///TODO
// Future<void> updateInstance<T>({
//   required Object? instance,
//   required Object? updateInstance,
//   String? instanceName,
// }) async {
//   if(serviceLocator.isRegistered(instance: instance,instanceName: instanceName)){
//     await serviceLocator.unregister(instance: instance,instanceName: instanceName);
//   }
// serviceLocator.registerSingleton(updateInstance);
// }


void _initServiceLocator({required Network network}) {
  serviceLocator.allowReassignment=true;

  /// Globals
  serviceLocator.registerSingleton(
      Logger(printer:logPrinter ));

  /// Bloc
  serviceLocator.registerFactory(() => StartupBloc());
  serviceLocator.registerFactory(
      () => AuthBloc(serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => ScheduleBloc(
        serviceLocator(),serviceLocator(),
      ));
  serviceLocator.registerFactory(() => TaskPopUpBloc());
  /// UseCases

  serviceLocator.registerLazySingleton(() => GetClickUpAccessTokenUseCase(
        serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => GetClickUpUserUseCase(
        serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => GetClickUpWorkspacesUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => GetClickUpTasksInSingleWorkspaceUseCase(
        serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => GetClickUpTasksInAllWorkspacesUseCase(
    serviceLocator(),
  ));

  /// Repos
  serviceLocator.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(serviceLocator(), serviceLocator()));
  serviceLocator
      .registerLazySingleton<TasksRepo>(() => TasksRepoImpl(serviceLocator()));

  /// DataSources
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(() =>
      AuthRemoteDataSourceImpl(
          network: serviceLocator(),
          clickUpClientId: Globals.clickUpClientId,
          clickUpClientSecret: Globals.clickUpClientSecret,
          clickUpUrl: Globals.clickUpUrl,));
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(serviceLocator()));

  serviceLocator.registerLazySingleton<TasksRemoteDataSource>(() =>
      TasksRemoteDataSourceImpl(
          network: serviceLocator(),
          clickUpClientId: Globals.clickUpClientId,
          clickUpClientSecret: Globals.clickUpClientSecret,
          clickUpUrl: Globals.clickUpUrl,));

  /// External

  serviceLocator.registerLazySingleton<LocalDataSource>(
      () => SharedPrefLocalDataSource());

  serviceLocator.registerLazySingleton<Network>(() => network);
}

void reRegisterClickupVariables() async {
  Globals.clickUpClientId =
      const String.fromEnvironment("clickUpClientId", defaultValue: "");
  Globals.clickUpClientSecret =
      const String.fromEnvironment("clickUpClientSecret", defaultValue: "");
  Globals.clickUpRedirectUrl =
      const String.fromEnvironment("clickUpRedirectUrl", defaultValue: "");
}

void initServiceLocator() {
  _initServiceLocator(
      network: NetworkHttp(
          httpClient: Client(), responseHandler: clickUpResponseHandler));
}

@visibleForTesting
void initServiceLocatorTesting({required Network mockNetwork}) {
  _initServiceLocator(network: mockNetwork);
}
