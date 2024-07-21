// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/features/startup/presentation/bloc/startup_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/space.dart';

import '../../core/resources/app_colors.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import 'custom_pop_up_menu.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {Key? key, this.pageActions, required this.showSmallDesign, required this.isDarkMode})
      : super(key: key);
  final List<CustomPopupItem>? pageActions;
  final bool showSmallDesign;
  final bool isDarkMode;
  @override
  Widget build(BuildContext context) {
    printDebug("CustomAppBar isDarkMode $isDarkMode");
    final startupBloc = BlocProvider.of<StartupBloc>(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<StartupBloc, StartupState>(
          builder: (context, state) {
            if (state.reSelectWorkspace(authState.authStates
                .contains(AuthStateEnum.triedGetSelectedWorkspacesSpace))) {
              startupBloc.add(SelectWorkspaceAndGetSpacesTagsLists(
                  workspace:
                      Globals.selectedWorkspace ?? Globals.defaultWorkspace!,
                  accessToken: Globals.accessToken));
            }
            return CustomAppBarWidget(
              selectClickupWorkspace: (selected) {
                if (selected is Workspace && state.isLoading == false) {
                  startupBloc.add(SelectWorkspaceAndGetSpacesTagsLists(
                      workspace: selected,
                      accessToken: Globals.accessToken));
                }
              },
              openDrawer: () {
                startupBloc.add(ControlDrawerLargerScreen(
                    !startupBloc.state.drawerLargerScreenOpen));
              },
              showSmallDesign: showSmallDesign,
              selectClickupSpace: (selected) {
                if (selected != null && state.isLoading == false) {
                  startupBloc.add(SelectSpace(
                      space: selected,
                      accessToken: Globals.accessToken));
                }
              },
              pageActions: pageActions,
              isDarkMode: isDarkMode,
            );
          },
        );
      },
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(CustomAppBarWidget.height(showSmallDesign));
}

class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget({
    Key? key,
    this.pageActions,
    required this.showSmallDesign,
    required this.openDrawer,
    required this.selectClickupSpace,
    required this.selectClickupWorkspace,
    required this.isDarkMode,
  }) : super(key: key);
  final bool showSmallDesign;
  final void Function() openDrawer;
  final void Function(Space? clickupSpace) selectClickupSpace;
  final void Function(Workspace? clickupWorkspace)
      selectClickupWorkspace;
  final List<CustomPopupItem>? pageActions;
  final bool isDarkMode;
  ///TODO app bar different height based on size as design
  static double height(bool showSmallDesign) => 52;
  // static double height(bool showSmallDesign) => showSmallDesign ? 52 : 64;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background(isDarkMode),
      surfaceTintColor: AppColors.background(isDarkMode),
      elevation: 0,
      leading: showSmallDesign
          ? null
          : IconButton(
              onPressed: openDrawer,
              icon: const Icon(
                Icons.menu,
                color: Colors.deepPurpleAccent,
              )),
      actions: [
        /*if (showSmallDesign == false &&
            Globals.clickupWorkspaces?.isNotEmpty == true)
          DropdownButton(
            value: Globals.selectedWorkspace,
            onChanged: (selected) {
              if (selected is ClickupWorkspace) {
                selectClickupWorkspace(selected);
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
              return selectClickupSpace(selected);
            },
            items: Globals.clickupSpaces
                    ?.map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name ?? ""),
                        ))
                    .toList() ??
                [],
            hint: Text(appLocalization.translate("spaces")),
          ),*/

        ///TODO search tasks,tags, lists and folders
        // ignore: dead_code
        if (false)
          IconButton(
              onPressed: () {
               
              },
              icon: const Icon(Icons.search)),
        if (pageActions?.isNotEmpty == true)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                0, 0, showSmallDesign ? 0 : AppSpacing.xBig24.value, 0),
            child: CustomPopupMenu(
                items: pageActions ?? [],
               ),
          ),
      ],
    );

  }
}
