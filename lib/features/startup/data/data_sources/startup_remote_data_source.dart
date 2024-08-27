import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:thetimeblockingapp/common/models/priority_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_status_model.dart';
import 'package:thetimeblockingapp/core/network/network.dart';
import 'package:thetimeblockingapp/core/network/supabase_header.dart';
import 'package:thetimeblockingapp/features/startup/domain/use_cases/get_priorities_use_case.dart';
import 'package:thetimeblockingapp/features/startup/domain/use_cases/get_statuses_use_case.dart';

abstract class StartUpRemoteDataSource {
  Future<List<TaskStatusModel>> getStatuses(GetStatusesParams params);

  Future<List<TaskPriorityModel>> getPriorities(GetPrioritiesParams params);
}

class SupabaseStartUpRemoteDataSourceImpl implements StartUpRemoteDataSource {
  final String url;
  final String key;
  final Network network;

  SupabaseStartUpRemoteDataSourceImpl(
      {required this.url, required this.key, required this.network});

  ///TODO A "relation \"public.statuses\" does not exist"
  @override
  Future<List<TaskStatusModel>> getStatuses(GetStatusesParams params) async {
    final response = await network.get(
        uri: Uri.parse(
            "$url/rest/v1/statuses"),
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key));
    return taskStatusModelFromJson(json.decode(response.body)) ?? [];
  }

  ///TODO A "relation \"public.priorities\" does not exist"
  @override
  Future<List<TaskPriorityModel>> getPriorities(GetPrioritiesParams params) async {
    final response = await network.get(
        uri: Uri.parse(
            "$url/rest/v1/priorities"),
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key));
    return taskPriorityModelFromJson(json.decode(response.body)) ?? [];
  }
}
