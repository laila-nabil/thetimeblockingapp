// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thetimeblockingapp/common/entities/workspace.dart';

import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/features/global/presentation/bloc/global_bloc.dart';

import '../../core/resources/app_colors.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import 'custom_pop_up_menu.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key, this.pageActions, required this.showSmallDesign, required this.isDarkMode});
  final List<CustomPopupItem>? pageActions;
  final bool showSmallDesign;
  final bool isDarkMode;
  @override
  Widget build(BuildContext context) {
    final globalBloc = BlocProvider.of<GlobalBloc>(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<GlobalBloc, GlobalState>(
          builder: (context, state) {
            if (state.reSelectWorkspace(authState.authState ==
                AuthStateEnum.triedGetSelectedWorkspacesSpace,authState.accessToken)) {
              globalBloc.add(GetAllInWorkspaceEvent(
                  workspace:
                      state.selectedWorkspace!,
                  accessToken: authState.accessToken!));
            }
            return CustomAppBarWidget(
              selectWorkspace: (selected) {
                if (selected is Workspace && state.isLoading == false) {
                  globalBloc.add(GetAllInWorkspaceEvent(
                      workspace: selected,
                      accessToken: authState.accessToken!));
                }
              },
              openDrawer: () {
                globalBloc.add(ControlDrawerLargerScreen(
                    !globalBloc.state.drawerLargerScreenOpen));
              },
              showSmallDesign: showSmallDesign,
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
    super.key,
    this.pageActions,
    required this.showSmallDesign,
    required this.openDrawer,
    required this.selectWorkspace,
    required this.isDarkMode,
  });
  final bool showSmallDesign;
  final void Function() openDrawer;
  final void Function(Workspace? workspace)
      selectWorkspace;
  final List<CustomPopupItem>? pageActions;
  final bool isDarkMode;
  ///TODO D app bar different height based on size as design
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

        ///TODO D search tasks,tags, lists and folders
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
