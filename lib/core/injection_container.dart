import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/analytics/posthog_impl.dart';
import 'package:thetimeblockingapp/core/environment.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/network/network_http.dart';
import 'package:thetimeblockingapp/core/network/supabase_exception_handler.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/response_interceptor.dart';
import 'package:thetimeblockingapp/features/all/presentation/bloc/all_tasks_bloc.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_up_anonymously_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/update_user_use_case.dart';
import 'package:thetimeblockingapp/features/global/data/data_sources/global_demo_remote_data_source.dart';
import 'package:thetimeblockingapp/features/global/data/data_sources/global_remote_data_source.dart';
import 'package:thetimeblockingapp/features/global/data/repositories/global_repo_impl.dart';
import 'package:thetimeblockingapp/features/global/domain/repositories/global_repo.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/views/calendar.dart';
import 'package:thetimeblockingapp/features/settings/data/data_sources/settings_remote_data_source.dart';
import 'package:thetimeblockingapp/features/settings/domain/repositories/settings_repo.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/change_language_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/delete_account_use_case.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/request_feature_use_case.dart';
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
import '../features/auth/domain/use_cases/sign_up_use_case.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/lists/presentation/bloc/lists_page_bloc.dart';
import '../features/global/domain/use_cases/get_statuses_use_case.dart';
import '../features/settings/data/repositories/settings_repo_impl.dart';
import '../features/settings/domain/use_cases/report_issue_use_case.dart';
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

class AppConfig{
   static const Env _defaultEnv = Env.debugLocally;
   Env env = _defaultEnv;
   bool isDemo = false;
   Duration defaultTaskDuration = const Duration(minutes: 30);

   ///[isWorkspaceAppWide] Workspace is selected from appbar/drawer only and is global to app or not
   bool isWorkspaceAppWide = true;
   String redirectAfterAuthRouteName = '';
   String refreshToken = '';
   AccessToken accessToken = const AccessToken(accessToken: '', tokenType: '') ;
   bool confirmationEmailEnabled = false;
   ///TODO timezone
   String timezone = 'Africa/Cairo';
   Future<AppCalendar> appCalendarFuture = _getAppCalendarFlag(initialization: true);
   AppCalendar? appCalendar;


  static int firstDayOfWeek = 6;
}
Future<AppCalendar> _getAppCalendarFlag({required bool initialization}) async {
  printDebug("get appCalendar _getAppCalendarFlag $initialization");
  if(initialization){
    await Future.delayed(Duration(seconds: 1));
  }
  var featureFlag = await serviceLocator<Analytics>().featureFlag("Calendar_package");
  var result = featureFlag ==
        "syncfusion"
        ? AppCalendar.syncfusion
        : AppCalendar.kalender;
  serviceLocator<AppConfig>().appCalendar = result;
  return result;
}

void _initServiceLocator({required Network network}) {
  serviceLocator.allowReassignment = true;

  /// Globals
  serviceLocator.registerSingleton<AppConfig>(AppConfig());

  serviceLocator
      .registerSingleton<ResponseInterceptorFunc>(responseInterceptor);

  serviceLocator
      .registerSingleton(Logger(printer: PrettyPrinter(methodCount: 3)));

  serviceLocator
      .registerSingleton<BackendMode>(BackendMode.supabase);

  /// Bloc
  serviceLocator.registerFactory(() => GlobalBloc(
      serviceLocator(),serviceLocator(),serviceLocator(),serviceLocator()));
  serviceLocator.registerFactory(() => AuthBloc(
      serviceLocator(),serviceLocator(),serviceLocator(),serviceLocator()
      ,serviceLocator(),serviceLocator()
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
        serviceLocator(),serviceLocator(),serviceLocator()
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
        serviceLocator(), serviceLocator(),
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

  serviceLocator.registerLazySingleton(() => SignUpUseCase(serviceLocator()));

  serviceLocator.registerLazySingleton(() => SignUpAnonymouslyUseCase(serviceLocator()));

  serviceLocator.registerLazySingleton(() => UpdateUserUseCase(serviceLocator()));

  serviceLocator.registerLazySingleton(() => DeleteAccountUseCase(serviceLocator()));

  serviceLocator.registerLazySingleton(() => RequestFeatureUseCase(serviceLocator()));

  serviceLocator.registerLazySingleton(() => ReportIssueUseCase(serviceLocator()));

  /// Repos
  serviceLocator.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(serviceLocator(), serviceLocator(),serviceLocator()));
  serviceLocator.registerLazySingleton<TasksRepo>(
      () => TasksRepoImpl(serviceLocator(),));
  serviceLocator.registerLazySingleton<GlobalRepo>(
          () => GlobalRepoImpl(serviceLocator(),));
  serviceLocator.registerLazySingleton<SettingsRepo>(
          () => SettingsRepoImpl(serviceLocator(),serviceLocator(),serviceLocator()));

  /// DataSources
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
      () => authRemoteDataSource());
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(serviceLocator()));

  serviceLocator.registerLazySingleton<TasksRemoteDataSource>(
      () => tasksRemoteDataSource());

  serviceLocator.registerLazySingleton<GlobalRemoteDataSource>(
          () => globalRemoteDataSource());

  serviceLocator.registerLazySingleton<SettingsRemoteDataSource>(
          () => settingsRemoteDataSource());

  /// External

  serviceLocator.registerLazySingleton<LocalDataSource>(
      () => SharedPrefLocalDataSource());

  serviceLocator.registerLazySingleton<Network>(() => network);

  serviceLocator.registerLazySingleton<Analytics>(() => PostHogImpl());
}

AuthRemoteDataSource authRemoteDataSource() {
  if (serviceLocator<AppConfig>().isDemo) {
    return AuthDemoRemoteDataSourceImpl();
  }
  switch (serviceLocator<BackendMode>().mode) {
    case BackendMode.supabase:
      return SupabaseAuthRemoteDataSourceImpl(
          network: serviceLocator(),
          key: _supabaseGlobals.key,
          url: _supabaseGlobals.url,
          accessTokenModel: serviceLocator<AppConfig>().accessToken.toModel,
          responseInterceptor: serviceLocator(), authLocalDataSource: serviceLocator());
    case BackendMode.offlineWithCalendarSync:
      throw UnimplementedError("offlineWithCalendarSync AuthRemoteDataSourceImpl");
  }
}
GlobalRemoteDataSource globalRemoteDataSource() {
  if (serviceLocator<AppConfig>().isDemo) {
    return GlobalDemoRemoteDataSourceImpl();
  }
  switch (serviceLocator<BackendMode>().mode) {
    case BackendMode.supabase:
      return SupabaseGlobalRemoteDataSourceImpl(
          network: serviceLocator(),
          key: _supabaseGlobals.key,
          url: _supabaseGlobals.url, responseInterceptor:serviceLocator(), authRemoteDataSource: serviceLocator(), authLocalDataSource: serviceLocator(),);
    case BackendMode.offlineWithCalendarSync:
      throw UnimplementedError("offlineWithCalendarSync GlobalRemoteDataSourceImpl");
  }
}

SettingsRemoteDataSourceImpl settingsRemoteDataSource() {

  switch (serviceLocator<BackendMode>().mode) {
    case BackendMode.supabase:
      return SettingsRemoteDataSourceImpl(
        network: serviceLocator(),
        key: _supabaseGlobals.key,
        url: _supabaseGlobals.url, responseInterceptor:serviceLocator(), authRemoteDataSource: serviceLocator(), authLocalDataSource: serviceLocator(),);
    case BackendMode.offlineWithCalendarSync:
      throw UnimplementedError("offlineWithCalendarSync SettingsRemoteDataSourceImpl");
  }
}

TasksRemoteDataSource tasksRemoteDataSource() {
  if (serviceLocator<AppConfig>().isDemo) {
    return TasksDemoRemoteDataSourceImpl();
  }
  switch (serviceLocator<BackendMode>().mode) {
    case BackendMode.supabase:
      return SupabaseTasksRemoteDataSourceImpl(
          network: serviceLocator(),
          key: _supabaseGlobals.key,
          url: _supabaseGlobals.url, responseInterceptor:serviceLocator(), authRemoteDataSource: serviceLocator(), authLocalDataSource: serviceLocator(),);
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
  serviceLocator<AppConfig>().env = Env.getEnv(
          const String.fromEnvironment("env", defaultValue: "debugLocally"));
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