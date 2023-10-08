import 'dart:convert';
import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';
import 'package:thetimeblockingapp/core/network/network.dart';
import '../../../../core/network/clickup_header.dart';
import '../../domain/use_cases/get_clickup_workspaces_use_case.dart';

abstract class StartUpRemoteDataSource {

  Future<List<ClickupWorkspaceModel>> getClickUpWorkspaces(
      {required GetClickUpWorkspacesParams params});
}

class StartUpRemoteDataSourceImpl implements StartUpRemoteDataSource {
  final Network network;
  final String clickUpClientId;
  final String clickUpClientSecret;
  final String clickUpUrl;

  StartUpRemoteDataSourceImpl({
    required this.network,
    required this.clickUpClientId,
    required this.clickUpClientSecret,
    required this.clickUpUrl,
  });


  @override
  Future<List<ClickupWorkspaceModel>> getClickUpWorkspaces(
      {required GetClickUpWorkspacesParams params}) async {
    List<ClickupWorkspaceModel> result = [];
    final response = await network.get(
        url: "$clickUpUrl/team",
        headers: clickUpHeader(clickUpAccessToken: params.clickUpAccessToken));
    for (var element in (json.decode(response.body)["teams"] as List)) {
      result.add(ClickupWorkspaceModel.fromJson(element));
    }
    return result;
  }
}
