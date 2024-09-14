import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/analytics/posthog_impl.dart';
import 'package:thetimeblockingapp/core/environment.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/network/network_http.dart';
import 'package:thetimeblockingapp/core/network/supabase_exception_handler.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/all/presentation/bloc/all_tasks_bloc.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';
import 'package:thetimeblockingapp/features/global/data/data_sources/global_remote_data_source.dart';
import 'package:thetimeblockingapp/features/global/data/repositories/global_repo_impl.dart';
import 'package:thetimeblockingapp/features/global/domain/repositories/global_repo.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/change_language_use_case.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/sign_out_use_case.dart';
import 'package:thetimeblockingapp/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_priorities_use_case.dart';
import 'package:thetimeblockingapp/features/global/presentation/bloc/global_bloc.dart';
import 'package:thetimeblockingapp/features/tags/presentation/bloc/tags_page_bloc.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/bloc/task_pop_up_bloc.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/views/task_popup.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/add_tags_to_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/duplicate_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/remove_tag_from_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/remove_tags_from_task_use_case.dart';
import '../features/auth/data/data_sources/auth_demo_remote_data_source.dart';
import '../features/auth/data/data_sources/auth_local_data_source.dart';
import '../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repo_impl.dart';
import '../features/auth/domain/use_cases/sign_in_use_case.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/lists/presentation/bloc/lists_page_bloc.dart';
import '../features/global/domain/use_cases/get_statuses_use_case.dart';
import '../features/tasks/data/data_sources/tasks_demo_remote_data_source.dart';
import '../features/tasks/domain/use_cases/create_list_in_folder_use_case.dart';
import '../features/tasks/domain/use_cases/add_tag_to_task_use_case.dart';
import '../features/tasks/domain/use_cases/create_tag_in_workspace_use_case.dart';
import '../features/tasks/domain/use_cases/delete_folder_use_case.dart';
import '../features/tasks/domain/use_cases/delete_list_use_case.dart';
import '../features/tasks/domain/use_cases/delete_tag_use_case.dart';
import '../features/global/domain/use_cases/get_all_in_workspace_use_case.dart';
import '../features/tasks/domain/use_cases/get_tags_in_workspace_use_case.dart';
import '../features/global/domain/use_cases/get_workspaces_use_case.dart';
import '../features/tasks/data/data_sources/tasks_remote_data_source.dart';
import '../features/tasks/data/repositories/tasks_repo_impl.dart';
import '../features/tasks/domain/use_cases/create_task_use_case.dart';
import '../features/tasks/domain/use_cases/delete_task_use_case.dart';
import '../features/tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../features/tasks/domain/use_cases/move_task_between_lists_use_case.dart';
import '../features/tasks/domain/use_cases/update_tag_use_case.dart';
import '../features/tasks/domain/use_cases/update_task_use_case.dart';
import 'analytics/analytics.dart';
import 'local_data_sources/local_data_source.dart';
import 'local_data_sources/shared_preferences_local_data_source.dart';
import 'network/network.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart';

final serviceLocator = GetIt.instance;

SupabaseGlobals _supabaseGlobals = SupabaseGlobals();

enum ServiceLocatorName {
  defaultEnv,
  env,
  isDemo,
  defaultTaskDuration,
  isWorkspaceAppWide,
  redirectAfterAuthRouteName
}

void _initServiceLocator({required Network network}) {
  serviceLocator.allowReassignment = true;

  /// Globals
  serviceLocator
      .registerSingleton(Logger(printer: PrettyPrinter(methodCount: 3)));

  serviceLocator
      .registerSingleton<BackendMode>(BackendMode.supabase);

  serviceLocator.registerSingleton<Env>(Env.debugLocally,
      instanceName: ServiceLocatorName.defaultEnv.name);

  serviceLocator
      .registerSingleton<Env>(
      (serviceLocator.get(instanceName: ServiceLocatorName.defaultEnv.name,type: Env) as Env),
      instanceName: ServiceLocatorName.env.name);

  serviceLocator
      .registerSingleton<bool>(false,instanceName: ServiceLocatorName.isDemo.name);

  serviceLocator.registerSingleton<Duration>(const Duration(hours: 1),
      instanceName: ServiceLocatorName.defaultTaskDuration.name);

  serviceLocator.registerSingleton<String>("",
      instanceName: ServiceLocatorName.redirectAfterAuthRouteName.name);

  ///[isWorkspaceAppWide] Workspace is selected from appbar/drawer only and is global to app or not

  serviceLocator.registerSingleton<bool>(true,
      instanceName:ServiceLocatorName.isWorkspaceAppWide.name);

  /// Bloc
  serviceLocator.registerFactory(() => GlobalBloc(
      serviceLocator(),serviceLocator(),serviceLocator(),serviceLocator()));
  serviceLocator.registerFactory(() => AuthBloc(
      serviceLocator(),serviceLocator()
));
  serviceLocator.registerFactory(() => ScheduleBloc(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ));
  serviceLocator.registerFactoryParam<TaskPopUpBloc, TaskPopupParams, dynamic>(
      (TaskPopupParams s, dynamic i) => TaskPopUpBloc(taskPopupParams: s));

  serviceLocator.registerFactory(() => ListsPageBloc(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => TagsPageBloc(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => AllTasksBloc(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => SettingsBloc(
        serviceLocator(),
        serviceLocator(),
      ));

  /// UseCases

  serviceLocator.registerLazySingleton(() => GetWorkspacesUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => GetTasksInSingleWorkspaceUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => GetTagsInWorkspaceUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => GetAllInWorkspaceUseCase(
        serviceLocator(),
      ));
serviceLocator.registerLazySingleton(() => GetStatusesUseCase(
        serviceLocator(),
      ));
serviceLocator.registerLazySingleton(() => GetPrioritiesUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => CreateTaskUseCase(
        serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => DuplicateTaskUseCase(
        serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => UpdateTaskUseCase(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => DeleteTaskUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => DeleteListUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => DeleteFolderUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => CreateListInFolderUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => CreateFolderlessListUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => MoveTaskBetweenListsUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => CreateFolderInWorkspaceUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => AddTagToTaskUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => AddTagsToTaskUseCase(
        serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => RemoveTagFromTaskUseCase(
        serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => RemoveTagsFromTaskUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => CreateTagInWorkspaceUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => UpdateTagUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => DeleteTagUseCase(
        serviceLocator(),
      ));

  serviceLocator
      .registerLazySingleton(() => ChangeLanguageUseCase(appLocalization));

  serviceLocator.registerLazySingleton(() => SignOutUseCase(serviceLocator()));

  serviceLocator.registerLazySingleton(() => SignInUseCase(serviceLocator()));

  /// Repos
  serviceLocator.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(serviceLocator(), serviceLocator()));
  serviceLocator.registerLazySingleton<TasksRepo>(
      () => TasksRepoImpl(serviceLocator(),));
  serviceLocator.registerLazySingleton<GlobalRepo>(
          () => GlobalRepoImpl(serviceLocator(),));

  /// DataSources
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
      () => authRemoteDataSource());
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(serviceLocator()));

  serviceLocator.registerLazySingleton<TasksRemoteDataSource>(
      () => tasksRemoteDataSource());

  serviceLocator.registerLazySingleton<GlobalRemoteDataSource>(
          () => globalRemoteDataSource());

  /// External

  serviceLocator.registerLazySingleton<LocalDataSource>(
      () => SharedPrefLocalDataSource());

  serviceLocator.registerLazySingleton<Network>(() => network);

  serviceLocator.registerLazySingleton<Analytics>(() => PostHogImpl());
}

AuthRemoteDataSource authRemoteDataSource() {
  if (serviceLocator<bool>(instanceName: ServiceLocatorName.isDemo.name)) {
    return AuthDemoRemoteDataSourceImpl();
  }
  switch (serviceLocator<BackendMode>().mode) {
    case BackendMode.supabase:
      return SupabaseAuthRemoteDataSourceImpl(
          network: serviceLocator(),
          key: _supabaseGlobals.key,
          url: _supabaseGlobals.url);
    case BackendMode.offlineWithCalendarSync:
      throw UnimplementedError("offlineWithCalendarSync AuthRemoteDataSourceImpl");
  }
}
GlobalRemoteDataSource globalRemoteDataSource() {

  switch (serviceLocator<BackendMode>().mode) {
    case BackendMode.supabase:
      return SupabaseGlobalRemoteDataSourceImpl(
          network: serviceLocator(),
          key: _supabaseGlobals.key,
          url: _supabaseGlobals.url);
    case BackendMode.offlineWithCalendarSync:
      throw UnimplementedError("offlineWithCalendarSync GlobalRemoteDataSourceImpl");
  }
}

TasksRemoteDataSource tasksRemoteDataSource() {
  if (serviceLocator<bool>(instanceName: ServiceLocatorName.isDemo.name)) {
    return TasksDemoRemoteDataSourceImpl();
  }
  switch (serviceLocator<BackendMode>().mode) {
    case BackendMode.supabase:
      return SupabaseTasksRemoteDataSourceImpl(
          network: serviceLocator(),
          key: _supabaseGlobals.key,
          url: _supabaseGlobals.url);
    case BackendMode.offlineWithCalendarSync:
      throw UnimplementedError("offlineWithCalendarSync TasksRemoteDataSourceImpl");
  }
}

void updateFromEnv() async {
  _supabaseGlobals = _supabaseGlobals.copyWith(
    url: const String.fromEnvironment("supabaseUrl", defaultValue: ""),
    key: const String.fromEnvironment("supabaseKey", defaultValue: ""),
  );
  printDebug("supabaseGlobals url ${_supabaseGlobals.url}");
  printDebug("supabaseGlobals key ${_supabaseGlobals.key}");
  serviceLocator
      .registerSingleton<Env>(Env.getEnv(
          const String.fromEnvironment("env", defaultValue: "debugLocally")),
      instanceName: ServiceLocatorName.defaultEnv.name);
}

void initServiceLocator() {
  _initServiceLocator(
      network:
          NetworkHttp(httpClient: Client(), responseHandler: responseHandler));
}

Future<NetworkResponse> responseHandler(
    {required Future<Response> Function() httpResponse}) {
  switch (serviceLocator<BackendMode>().mode) {
    case BackendMode.supabase:
      return supabaseResponseHandler(httpResponse: httpResponse);
    case BackendMode.offlineWithCalendarSync:
      throw UnimplementedError("offlineWithCalendarSync response handler");
  }
}

@visibleForTesting
void initServiceLocatorTesting({required Network mockNetwork}) {
  _initServiceLocator(network: mockNetwork);
}


class SupabaseGlobals {
  final String url;
  final String key;

  SupabaseGlobals({this.url = "", this.key = ""});

  SupabaseGlobals copyWith({
    String? url,
    String? key,
  }) {
    return SupabaseGlobals(
      url: url ?? this.url,
      key: key ?? this.key,
    );
  }
}