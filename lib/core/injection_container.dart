import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:thetimeblockingapp/core/network/network_http.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';
import 'package:thetimeblockingapp/features/startup/presentation/bloc/startup_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../common/enums/auth_mode.dart';
import '../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repo_impl.dart';
import '../features/auth/domain/use_cases/get_clickup_access_token_use_case.dart';
import '../features/auth/domain/use_cases/get_clickup_user_use_case.dart';
import '../features/auth/domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../features/tasks/data/data_sources/tasks_remote_data_source.dart';
import '../features/tasks/data/repositories/tasks_repo_impl.dart';
import '../features/tasks/domain/use_cases/get_clickup_tasks_in_workspace_use_case.dart';
import 'network/clickup_exception_handler.dart';
import 'network/network.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart';

final serviceLocator = GetIt.instance;

enum NamedInstances {
  appName,
  authMode,
  clickUpClientId,
  clickUpClientSecret,
  clickUpRedirectUrl,
  clickUpAuthAccessToken,
  clickUpUrl
}

void _initServiceLocator({required Network network}) {
  /// Globals
  serviceLocator.registerSingleton(Logger());
  serviceLocator.registerSingleton('Time blocking app',
      instanceName: NamedInstances.appName.name);
  serviceLocator.registerSingleton('https://api.clickup.com/api/v2/',
      instanceName: NamedInstances.clickUpUrl.name);
  serviceLocator.registerSingleton<AuthMode>(AuthMode.clickUpOnly,
      instanceName: NamedInstances.authMode.name);
  serviceLocator.registerSingleton("", instanceName: NamedInstances.clickUpClientId.name);
  serviceLocator.registerSingleton("",
      instanceName: NamedInstances.clickUpClientSecret.name);
  serviceLocator.registerSingleton("",
      instanceName: NamedInstances.clickUpRedirectUrl.name);
  serviceLocator.registerSingleton("",
      instanceName: NamedInstances.clickUpAuthAccessToken.name);

  /// Bloc
  serviceLocator.registerFactory(() => StartupBloc());

  /// UseCases

  serviceLocator.registerLazySingleton(() => GetClickUpAccessTokenUseCase(serviceLocator(),));
  serviceLocator.registerLazySingleton(() => GetClickUpUserUseCase(serviceLocator(),));
  serviceLocator.registerLazySingleton(() => GetClickUpWorkspacesUseCase(serviceLocator(),));

  serviceLocator.registerLazySingleton(() => GetClickUpTasksInWorkspaceUseCase(serviceLocator(),));

  /// Repos
  serviceLocator.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(serviceLocator()));
  serviceLocator.registerLazySingleton<TasksRepo>(() => TasksRepoImpl(serviceLocator()));

  /// DataSources
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        network: serviceLocator(),
        clickUpClientId: getClickUpClientId,
        clickUpClientSecret: getClickUpClientSecret,
        clickUpUrl: getClickUpUrl,
        clickUpAccessToken: getClickUpAuthAccessToken
      ));

  serviceLocator.registerLazySingleton<TasksRemoteDataSource>(() => TasksRemoteDataSourceImpl(
      network: serviceLocator(),
      clickUpClientId: getClickUpClientId,
      clickUpClientSecret: getClickUpClientSecret,
      clickUpUrl: getClickUpUrl,
      clickUpAccessToken: getClickUpAuthAccessToken
  ));

  /// External
}

String get getClickUpClientSecret =>
    serviceLocator.get(instanceName: NamedInstances.clickUpClientSecret.name);

String  get getClickUpClientId =>
    serviceLocator.get(instanceName: NamedInstances.clickUpClientId.name);

String get  getAppName =>
    serviceLocator.get(instanceName:  NamedInstances.appName.name);

String  get  getClickUpUrl =>
    serviceLocator.get(instanceName:  NamedInstances.clickUpUrl.name);

String  get  getClickUpAuthAccessToken =>
    serviceLocator.get(instanceName:  NamedInstances.clickUpAuthAccessToken.name);

void initServiceLocator() {
  _initServiceLocator(
      network: NetworkHttp(
          httpClient: Client(), responseHandler: clickUpResponseHandler));
}

@visibleForTesting
void initServiceLocatorTesting({required Network mockNetwork}) {
  _initServiceLocator(network: mockNetwork);
}
