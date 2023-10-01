import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/features/startup/presentation/bloc/startup_bloc.dart';

///Fix overflow in android
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
        if (Globals.clickUpWorkspaces?.isNotEmpty == true)
          DropdownMenu(
              initialSelection: Globals.clickUpWorkspaces?.first,
              onSelected: (selected) {
                if (selected is ClickupWorkspace) {
                  startUpBloc.add(SelectClickupWorkspace(selected));
                }
              },
              label: const Text("workspaces"),
              dropdownMenuEntries: Globals.clickUpWorkspaces
                      ?.map((e) => DropdownMenuEntry(
                            value: e,
                            label: e.name ?? "",
                          ))
                      .toList() ??
                  []),
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
