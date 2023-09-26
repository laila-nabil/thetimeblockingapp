import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/network/network_http.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';
import 'package:thetimeblockingapp/features/startup/presentation/bloc/startup_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../common/enums/auth_mode.dart';
import '../features/auth/data/data_sources/auth_local_data_source.dart';
import '../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repo_impl.dart';
import '../features/auth/domain/use_cases/get_clickup_access_token_use_case.dart';
import '../features/auth/domain/use_cases/get_clickup_user_use_case.dart';
import '../features/auth/domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/tasks/data/data_sources/tasks_remote_data_source.dart';
import '../features/tasks/data/repositories/tasks_repo_impl.dart';
import '../features/tasks/domain/use_cases/get_clickup_tasks_in_workspace_use_case.dart';
import 'local_data_sources/local_data_source.dart';
import 'local_data_sources/shared_preferences_local_data_source.dart';
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
  serviceLocator.registerSingleton(
      Logger(printer: PrettyPrinter(noBoxingByDefault: true, methodCount: 0)));
  serviceLocator.registerSingleton(LocalizationImpl().translate("Time blocking app"),
      instanceName: NamedInstances.appName.name);
  serviceLocator.registerSingleton('https://api.clickup.com/api/v2/',
      instanceName: NamedInstances.clickUpUrl.name);
  serviceLocator.registerSingleton<AuthMode>(AuthMode.clickUpOnly,
      instanceName: NamedInstances.authMode.name);
  serviceLocator.registerSingleton("",
      instanceName: NamedInstances.clickUpClientId.name);
  serviceLocator.registerSingleton("",
      instanceName: NamedInstances.clickUpClientSecret.name);
  serviceLocator.registerSingleton("",
      instanceName: NamedInstances.clickUpRedirectUrl.name);
  serviceLocator.registerSingleton("",
      instanceName: NamedInstances.clickUpAuthAccessToken.name);

  /// Bloc
  serviceLocator.registerFactory(() => StartupBloc());
  serviceLocator.registerFactory(
      () => AuthBloc(serviceLocator(), serviceLocator(), serviceLocator()));

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

  serviceLocator.registerLazySingleton(() => GetClickUpTasksInWorkspaceUseCase(
        serviceLocator(),
      ));

  /// Repos
  serviceLocator
      .registerLazySingleton<AuthRepo>(() => AuthRepoImpl(serviceLocator()));
  serviceLocator
      .registerLazySingleton<TasksRepo>(() => TasksRepoImpl(serviceLocator()));

  /// DataSources
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(() =>
      AuthRemoteDataSourceImpl(
          network: serviceLocator(),
          clickUpClientId: getClickUpClientId,
          clickUpClientSecret: getClickUpClientSecret,
          clickUpUrl: getClickUpUrl,
          clickUpAccessToken: getClickUpAuthAccessToken));
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(serviceLocator()));

  serviceLocator.registerLazySingleton<TasksRemoteDataSource>(() =>
      TasksRemoteDataSourceImpl(
          network: serviceLocator(),
          clickUpClientId: getClickUpClientId,
          clickUpClientSecret: getClickUpClientSecret,
          clickUpUrl: getClickUpUrl,
          clickUpAccessToken: getClickUpAuthAccessToken));

  /// External

  serviceLocator.registerLazySingleton<LocalDataSource>(
      () => SharedPrefLocalDataSource());

  serviceLocator.registerLazySingleton<Network>(() => network);
}

String get getClickUpClientSecret {
  String result = "";
  try {
    result = serviceLocator.get(
        instanceName: NamedInstances.clickUpClientSecret.name);
  } catch (e) {
    printDebug(e, printLevel: PrintLevel.error);
  }
  return result;
}

String get getClickUpClientId {
  String result = "";
  try {
    result =
        serviceLocator.get(instanceName: NamedInstances.clickUpClientId.name);
  } catch (e) {
    printDebug(e, printLevel: PrintLevel.error);
  }
  return result;
}

String get getAppName {
  String result = "";
  try {
    result = serviceLocator.get(instanceName: NamedInstances.appName.name);
  } catch (e) {
    printDebug(e, printLevel: PrintLevel.error);
  }
  return result;
}

String get getClickUpUrl {
  String result = "";
  try {
    result = serviceLocator.get(instanceName: NamedInstances.clickUpUrl.name);
  } catch (e) {
    printDebug(e, printLevel: PrintLevel.error);
  }
  return result;
}

String get getClickUpRedirectUrl {
  String result = "";
  try {
    result = serviceLocator.get(
        instanceName: NamedInstances.clickUpRedirectUrl.name);
  } catch (e) {
    printDebug(e, printLevel: PrintLevel.error);
  }
  return result;
}

String get getClickUpAuthAccessToken {
  String result = "";
  try {
    result = serviceLocator.get(
        instanceName: NamedInstances.clickUpAuthAccessToken.name);
  } catch (e) {
    printDebug(e, printLevel: PrintLevel.error);
  }
  return result;
}

Future<void> reRegisterClickupVariables() async {
  if (serviceLocator.isRegistered(instance: getClickUpClientId)) {
    await serviceLocator.unregister(
        instance: getClickUpClientId,
        instanceName: NamedInstances.clickUpClientId.name);
  }
  if (serviceLocator.isRegistered(instance: getClickUpClientSecret)) {
    await serviceLocator.unregister(
        instance: getClickUpClientSecret,
        instanceName: NamedInstances.clickUpClientSecret.name);
  }
  if (serviceLocator.isRegistered(instance: getClickUpRedirectUrl)) {
    await serviceLocator.unregister(
        instance: getClickUpRedirectUrl,
        instanceName: NamedInstances.clickUpRedirectUrl.name);
  }
  serviceLocator.registerSingleton(
      const String.fromEnvironment("clickUpClientId", defaultValue: ""),
      instanceName: NamedInstances.clickUpClientId.name);
  serviceLocator.registerSingleton(
      const String.fromEnvironment("clickUpClientSecret", defaultValue: ""),
      instanceName: "NamedInstances.clickUpClientSecret.name");
  serviceLocator.registerSingleton(
      const String.fromEnvironment("clickUpRedirectUrl", defaultValue: ""),
      instanceName: NamedInstances.clickUpRedirectUrl.name);
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
