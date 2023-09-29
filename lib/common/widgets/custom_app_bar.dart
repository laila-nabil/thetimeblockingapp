import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/globals.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: Responsive.showSmallDesign(context)
          ? null
          : IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
                color: Colors.deepPurpleAccent,
              )),
      actions: [
        if (Globals.clickUpWorkspaces?.isNotEmpty == true)
          DropdownMenu(
              label: const Text("workspaces"),
              dropdownMenuEntries: Globals.clickUpWorkspaces
                      ?.map((e) => DropdownMenuEntry(
                            value: e,
                            label: e.name ?? "",
                          ))
                      .toList() ??
                  []),
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(46.0);
}
