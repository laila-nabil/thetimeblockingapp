import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/features/all/presentation/pages/all_page.dart';
import 'package:thetimeblockingapp/features/archive/presentation/pages/archive_page.dart';
import 'package:thetimeblockingapp/features/help/presentation/pages/help_page.dart';
import 'package:thetimeblockingapp/features/lists/presentation/pages/list_page.dart';
import 'package:thetimeblockingapp/features/lists/presentation/pages/lists_page.dart';
import 'package:thetimeblockingapp/features/maps/presentation/pages/maps_page.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/pages/schedule_page.dart';
import 'package:thetimeblockingapp/features/settings/presentation/pages/settings_page.dart';
import 'package:thetimeblockingapp/features/someday/presentation/pages/someday_page.dart';
import 'package:thetimeblockingapp/features/tags/presentation/pages/tag_page.dart';
import 'package:thetimeblockingapp/features/tags/presentation/pages/tags_page.dart';
import 'package:thetimeblockingapp/features/trash/presentation/pages/trash_page.dart';

import '../../core/globals.dart';
import '../../features/startup/presentation/bloc/startup_bloc.dart';
import '../../features/tasks/domain/entities/clickup_space.dart';
import '../entities/clickup_workspace.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationImpl = appLocalization;
    final startupBloc = BlocProvider.of<StartupBloc>(context);
    return BlocBuilder<StartupBloc, StartupState>(
      builder: (context, state) {
        return Drawer(
          width: 200,
          child: ListView(
            children: [
              const _Logo(),
              if (Responsive.showSmallDesign(context) &&
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
              if (Responsive.showSmallDesign(context) &&
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
              _DrawerItem(
                  title: localizationImpl.translate("All"),
                  iconPath: Icons.all_inbox,
                  onPressed: () {
                    context.go(AllPage.routeName);
                  },
                  isSelected: GoRouter.of(context)
                      .location
                      .contains(AllPage.routeName)),
              _DrawerItem(
                  title: localizationImpl.translate("Schedule"),
                  iconPath: Icons.calendar_month,
                  onPressed: () {
                    context.go(SchedulePage.routeName);
                  },
                  isSelected: GoRouter.of(context)
                      .location
                      .contains(SchedulePage.routeName)),
              _DrawerItem(
                  title: localizationImpl.translate("Someday"),
                  iconPath: Icons.calendar_today,
                  onPressed: () {
                    context.go(SomedayPage.routeName);
                  },
                  isSelected: GoRouter.of(context)
                      .location
                      .contains(SomedayPage.routeName)),
              _DrawerItem(
                  title: localizationImpl.translate("Lists"),
                  iconPath: Icons.list_sharp,
                  onPressed: () {
                    context.go(ListsPage.routeName);
                  },
                  isSelected: GoRouter.of(context)
                          .location
                          .contains(ListsPage.routeName) ||
                      GoRouter.of(context)
                          .location
                          .contains(ListPage.routeName)),
              _DrawerItem(
                  title: localizationImpl.translate("Tags"),
                  iconPath: Icons.tag_sharp,
                  onPressed: () {
                    context.go(TagsPage.routeName);
                  },
                  isSelected: GoRouter.of(context)
                          .location
                          .contains(TagsPage.routeName) ||
                      GoRouter.of(context)
                          .location
                          .contains(TagPage.routeName)),
              _DrawerItem(
                  title: localizationImpl.translate("Maps"),
                  iconPath: Icons.map_outlined,
                  onPressed: () {
                    context.go(MapsPage.routeName);
                  },
                  isSelected: GoRouter.of(context)
                      .location
                      .contains(MapsPage.routeName)),
              const Divider(),
              _DrawerItem(
                  title: localizationImpl.translate("Archive"),
                  iconPath: Icons.archive_outlined,
                  onPressed: () {
                    context.go(ArchivePage.routeName);
                  },
                  isSelected: GoRouter.of(context)
                      .location
                      .contains(ArchivePage.routeName)),
              _DrawerItem(
                  title: localizationImpl.translate("Trash"),
                  iconPath: Icons.delete,
                  onPressed: () {
                    context.go(TrashPage.routeName);
                  },
                  isSelected: GoRouter.of(context)
                      .location
                      .contains(TrashPage.routeName)),
              _DrawerItem(
                  title: localizationImpl.translate("Help"),
                  iconPath: Icons.help,
                  onPressed: () {
                    context.go(HelpPage.routeName);
                  },
                  isSelected: GoRouter.of(context)
                      .location
                      .contains(HelpPage.routeName)),
              _DrawerItem(
                  title: localizationImpl.translate("Settings"),
                  iconPath: Icons.settings,
                  onPressed: () {
                    context.go(SettingsPage.routeName);
                  },
                  isSelected: GoRouter.of(context)
                      .location
                      .contains(SettingsPage.routeName)),
            ],
          ),
        );
      },
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem(
      {required this.title,
      required this.iconPath,
      required this.onPressed,
      required this.isSelected});

  final String title;
  final IconData iconPath;
  final void Function() onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
            (states) => isSelected ? Colors.grey : Colors.white),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(iconPath),
          ),
          Text(title),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios),
          const SizedBox(
            width: 8,
          )
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          const Placeholder(
            fallbackHeight: 35,
            fallbackWidth: 35,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(child: Text(appLocalization.translate("appName")))
        ],
      ),
    );
  }
}
