import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/entities/priority.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/common/entities/space.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import '../common/entities/user.dart';
import '../common/entities/workspace.dart';
import '../common/entities/access_token.dart';
import 'environment.dart';


Workspace? _selectedWorkspace;

///[isWorkspaceAndSpaceAppWide] Workspace and space is selected from appbar/drawer only and is global to app or not
bool _isWorkspaceAndSpaceAppWide = true;

Duration _defaultTaskDuration = const Duration(hours: 1);

List<Workspace>? _workspaces;

class Globals {


  static bool get isWorkspaceAndSpaceAppWide => _isWorkspaceAndSpaceAppWide;

  static Duration get defaultTaskDuration => _defaultTaskDuration;

  static String redirectAfterAuthRouteName = "";


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