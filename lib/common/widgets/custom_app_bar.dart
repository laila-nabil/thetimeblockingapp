import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_folders_use_case.dart';
import 'package:thetimeblockingapp/features/startup/presentation/bloc/startup_bloc.dart';

///FIXME B overflow in android
///
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, this.pageActions}) : super(key: key);
  final List<PopupMenuEntry<Object?>>? pageActions;

  @override
  Widget build(BuildContext context) {
    final startUpBloc = BlocProvider.of<StartupBloc>(context);
    return AppBar(
      elevation: 0,
      leading: Responsive.showSmallDesign(context)
          ? null
          : IconButton(
              onPressed: () {
                startUpBloc.add(ControlDrawerLargerScreen(
                    !startUpBloc.state.drawerLargerScreenOpen));
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.deepPurpleAccent,
              )),
      actions: [
        if (Globals.clickupWorkspaces?.isNotEmpty == true)
          DropdownMenu(
              width: 170,
              ///TODO A should startUpBloc.add(SelectClickupWorkspace for initialSelection
              initialSelection: Globals.clickupWorkspaces?.first,
              onSelected: (selected) {
                if (selected is ClickupWorkspace) {
                startUpBloc.add(SelectClickupWorkspace(
                    clickupWorkspace: selected,
                    getClickupFoldersParams: GetClickupFoldersParams(
                        clickupAccessToken: Globals.clickupAuthAccessToken,
                        clickupWorkspace: selected)));
              }
              },
              dropdownMenuEntries: Globals.clickupWorkspaces
                      ?.map((e) => DropdownMenuEntry(
                            value: e,
                            label: e.name ?? "",
                          ))
                      .toList() ??
                  [],
            hintText: appLocalization.translate("workspaces"),
          ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        if (pageActions?.isNotEmpty == true)
          PopupMenuButton(itemBuilder: (context) {
            return pageActions ?? [];
          })
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(46.0);
}
