import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/features/all/presentation/pages/all_tasks_page.dart';
import 'package:thetimeblockingapp/features/archive/presentation/pages/archive_page.dart';
import 'package:thetimeblockingapp/features/help/presentation/pages/help_page.dart';
import 'package:thetimeblockingapp/features/lists/presentation/pages/list_page.dart';
import 'package:thetimeblockingapp/features/lists/presentation/pages/lists_page.dart';
import 'package:thetimeblockingapp/features/maps/presentation/pages/maps_page.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/pages/schedule_page.dart';
import 'package:thetimeblockingapp/features/settings/presentation/pages/settings_page.dart';
import 'package:thetimeblockingapp/features/tags/presentation/pages/tag_page.dart';
import 'package:thetimeblockingapp/features/tags/presentation/pages/tags_page.dart';
import 'package:thetimeblockingapp/features/trash/presentation/pages/trash_page.dart';

import '../../core/globals.dart';
import '../../features/startup/presentation/bloc/startup_bloc.dart';
import '../../features/tasks/domain/entities/clickup_space.dart';
import '../entities/clickup_workspace.dart';

///TODO V1.5 in web,folders and list from here

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startupBloc = BlocProvider.of<StartupBloc>(context);
    return BlocBuilder<StartupBloc, StartupState>(
      builder: (context, state) {
        return CustomDrawerWidget(
            router: GoRouter.of(context),
            selectWorkspace: (selected) {
              if (selected is ClickupWorkspace && state.isLoading == false) {
                startupBloc.add(SelectClickupWorkspace(
                    clickupWorkspace: selected,
                    clickupAccessToken: Globals.clickupAuthAccessToken));
              }
            },
            selectSpace: (selected) {
              if (selected != null && state.isLoading == false) {
                startupBloc.add(SelectClickupSpace(
                    clickupSpace: selected,
                    clickupAccessToken: Globals.clickupAuthAccessToken));
              }
            },
            appLocalization: appLocalization);
      },
    );
  }
}

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({
    super.key,
    required this.appLocalization,
    required this.selectWorkspace,
    required this.selectSpace,
    required this.router,
  });

  final void Function(ClickupWorkspace? clickupWorkspace) selectWorkspace;
  final void Function(ClickupSpace? clickupSpace) selectSpace;
  final Localization appLocalization;
  final GoRouter? router;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      child: ListView(
        children: [
          const _Logo(),
          if (context.showSmallDesign &&
              Globals.clickupWorkspaces?.isNotEmpty == true)
            DropdownButton(
              value: Globals.selectedWorkspace,
              onChanged: (selected) {
                if (selected is ClickupWorkspace) {
                  selectWorkspace(selected);
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
          if (context.showSmallDesign &&
              Globals.isSpaceAppWide &&
              Globals.clickupSpaces?.isNotEmpty == true)
            DropdownButton<ClickupSpace?>(
              value: Globals.selectedSpace,
              onChanged: (selected) {
                if (selected != null) {
                  selectSpace(selected);
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
              title: appLocalization.translate("All"),
              iconPath: Icons.all_inbox,
              onPressed: () {
                context.go(AllTasksPage.routeName);
              },
              isSelected: router
                  ?.location
                  .contains(AllTasksPage.routeName) == true),
          _DrawerItem(
              title: appLocalization.translate("Schedule"),
              iconPath: Icons.calendar_month,
              onPressed: () {
                context.go(SchedulePage.routeName);
              },
              isSelected: router
                  ?.location
                  .contains(SchedulePage.routeName)== true),
          _DrawerItem(
              title: appLocalization.translate("Lists"),
              iconPath: Icons.list_sharp,
              onPressed: () {
                context.go(ListsPage.routeName);
              },
              isSelected: router
                      ?.location
                      .contains(ListsPage.routeName)== true ||
                  router?.location.contains(ListPage.routeName)== true),
          _DrawerItem(
              title: appLocalization.translate("Tags"),
              iconPath: Icons.tag_sharp,
              onPressed: () {
                context.go(TagsPage.routeName);
              },
              isSelected: router
                      ?.location
                      .contains(TagsPage.routeName)== true ||
                  router?.location.contains(TagPage.routeName)== true),
          // ignore: dead_code
          if (false)
            _DrawerItem(
                title: appLocalization.translate("Maps"),
                iconPath: Icons.map_outlined,
                onPressed: () {
                  context.go(MapsPage.routeName);
                },
                isSelected:
                    router?.location.contains(MapsPage.routeName)== true),
          const Divider(),
          // ignore: dead_code
          if (false)
            _DrawerItem(
                title: appLocalization.translate("Archive"),
                iconPath: Icons.archive_outlined,
                onPressed: () {
                  context.go(ArchivePage.routeName);
                },
                isSelected: router
                    ?.location
                    .contains(ArchivePage.routeName)== true),
          // ignore: dead_code
          if (false)
            _DrawerItem(
                title: appLocalization.translate("Trash"),
                iconPath: Icons.delete,
                onPressed: () {
                  context.go(TrashPage.routeName);
                },
                isSelected: router
                    ?.location
                    .contains(TrashPage.routeName)== true),
          // ignore: dead_code
          if (false)
            _DrawerItem(
                title: appLocalization.translate("Help"),
                iconPath: Icons.help,
                onPressed: () {
                  context.go(HelpPage.routeName);
                },
                isSelected:
                    router?.location.contains(HelpPage.routeName)== true),
          _DrawerItem(
              title: appLocalization.translate("Settings"),
              iconPath: Icons.settings,
              onPressed: () {
                context.go(SettingsPage.routeName);
              },
              isSelected: router
                  ?.location
                  .contains(SettingsPage.routeName)== true),
        ],
      ),
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
