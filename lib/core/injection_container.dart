import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:thetimeblockingapp/core/network/network_http.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';
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

final sl = GetIt.instance;

enum NamedInstances {
  appName,
  authMode,
  clickUpClientId,
  clickUpClientSecret,
  clickUpRedirectUrl,
  clickUpAuthAccessToken,
  clickUpUrl
}

void _initSl({required Network network}) {
  /// Globals
  sl.registerSingleton(Logger());
  sl.registerSingleton('Time blocking app',
      instanceName: NamedInstances.appName.name);
  sl.registerSingleton('https://api.clickup.com/api/v2/',
      instanceName: NamedInstances.clickUpUrl.name);
  sl.registerSingleton<AuthMode>(AuthMode.clickUpOnly,
      instanceName: NamedInstances.authMode.name);
  sl.registerSingleton("", instanceName: NamedInstances.clickUpClientId.name);
  sl.registerSingleton("",
      instanceName: NamedInstances.clickUpClientSecret.name);
  sl.registerSingleton("",
      instanceName: NamedInstances.clickUpRedirectUrl.name);
  sl.registerSingleton("",
      instanceName: NamedInstances.clickUpAuthAccessToken.name);

  /// Bloc

  /// UseCases

  sl.registerLazySingleton(() => GetClickUpAccessTokenUseCase(sl(),));
  sl.registerLazySingleton(() => GetClickUpUserUseCase(sl(),));
  sl.registerLazySingleton(() => GetClickUpWorkspacesUseCase(sl(),));

  sl.registerLazySingleton(() => GetClickUpTasksInWorkspaceUseCase(sl(),));

  /// Repos
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));
  sl.registerLazySingleton<TasksRepo>(() => TasksRepoImpl(sl()));

  /// DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        network: sl(),
        clickUpClientId: getClickUpClientId,
        clickUpClientSecret: getClickUpClientSecret,
        clickUpUrl: getClickUpUrl,
        clickUpAccessToken: getClickUpAuthAccessToken
      ));

  sl.registerLazySingleton<TasksRemoteDataSource>(() => TasksRemoteDataSourceImpl(
      network: sl(),
      clickUpClientId: getClickUpClientId,
      clickUpClientSecret: getClickUpClientSecret,
      clickUpUrl: getClickUpUrl,
      clickUpAccessToken: getClickUpAuthAccessToken
  ));

  /// External
}

String get getClickUpClientSecret =>
    sl.get(instanceName: NamedInstances.clickUpClientSecret.name);

String  get getClickUpClientId =>
    sl.get(instanceName: NamedInstances.clickUpClientId.name);

String get  getAppName =>
    sl.get(instanceName:  NamedInstances.appName.name);

String  get  getClickUpUrl =>
    sl.get(instanceName:  NamedInstances.clickUpUrl.name);

String  get  getClickUpAuthAccessToken =>
    sl.get(instanceName:  NamedInstances.clickUpAuthAccessToken.name);

void initSl() {
  _initSl(
      network: NetworkHttp(
          httpClient: Client(), responseHandler: clickUpResponseHandler));
}

@visibleForTesting
void initSlTesting({required Network mockNetwork}) {
  _initSl(network: mockNetwork);
}
