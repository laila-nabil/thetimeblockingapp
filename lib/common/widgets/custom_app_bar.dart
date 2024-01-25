import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/features/startup/presentation/bloc/startup_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, this.pageActions}) : super(key: key);
  final List<PopupMenuEntry<Object?>>? pageActions;

  @override
  Widget build(BuildContext context) {
    final startupBloc = BlocProvider.of<StartupBloc>(context);
    return BlocBuilder<AuthBloc, AuthState>(
    builder: (context, authState) {
      return BlocBuilder<StartupBloc, StartupState>(
        builder: (context, state) {
            if (state.reSelectWorkspace(authState.authStates
                .contains(AuthStateEnum.triedGetSelectedWorkspacesSpace))) {
              startupBloc.add(SelectClickupWorkspace(
                clickupWorkspace:
                    Globals.selectedWorkspace ?? Globals.defaultWorkspace!,
                clickupAccessToken: Globals.clickupAuthAccessToken));
          }
          final showSmallDesign = context.showSmallDesign;
          return AppBar(
            elevation: 0,
            leading: showSmallDesign
                ? null
                : IconButton(
                    onPressed: () {
                      startupBloc.add(ControlDrawerLargerScreen(
                          !startupBloc.state.drawerLargerScreenOpen));
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.deepPurpleAccent,
                    )),
            actions: [
              if (showSmallDesign == false &&
                  Globals.clickupWorkspaces?.isNotEmpty == true)
                DropdownButton(
                  value: Globals.selectedWorkspace,
                  onChanged: (selected) {
                    if (selected is ClickupWorkspace &&
                        state.isLoading == false) {
                      startupBloc.add(SelectClickupWorkspace(
                          clickupWorkspace: selected,
                          clickupAccessToken: Globals.clickupAuthAccessToken));
                    }
                  },
                  items: Globals.clickupWorkspaces
                          ?.map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name ?? ""),
                              ))
                          .toList() ??
                      [],
                  hint: Text(appLocalization.translate("workspaces")),
                ),
              if (showSmallDesign == false &&
                  Globals.isSpaceAppWide &&
                  Globals.clickupSpaces?.isNotEmpty == true)
                DropdownButton<ClickupSpace?>(
                  value: Globals.selectedSpace,
                  onChanged: (selected) {
                    if (selected != null && state.isLoading == false) {
                      startupBloc.add(SelectClickupSpace(
                          clickupSpace: selected,
                          clickupAccessToken: Globals.clickupAuthAccessToken));
                    }
                  },
                  items: Globals.clickupSpaces
                          ?.map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name ?? ""),
                              ))
                          .toList() ??
                      [],
                  hint: Text(appLocalization.translate("spaces")),
                ),
              ///TODO V2 search tasks,tags, lists and folders
              // ignore: dead_code
              if(false)IconButton(onPressed: () {
                ///TODO V2 search
              }, icon: const Icon(Icons.search)),
              if (pageActions?.isNotEmpty == true)
                PopupMenuButton(itemBuilder: (context) {
                  return pageActions ?? [];
                })
            ],
          );
        },
      );
  },
);
  }

  @override
  Size get preferredSize => const Size.fromHeight(46.0);
}
