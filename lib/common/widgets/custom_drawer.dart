import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/pages/schedule_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationImpl = LocalizationImpl();
    return Container(
      color: Colors.white,
      width: 200,
      child: ListView(
        children: [
          _DrawerItem(
              title: localizationImpl.translate("All"),
              iconPath: Icons.all_inbox,
              onPressed: () {},
              isSelected: GoRouter.of(context).location.contains("All")),
          _DrawerItem(
              title: localizationImpl.translate("Schedule"),
              iconPath: Icons.calendar_month,
              onPressed: () {
                context.go(SchedulePage.routeName);
              },
              isSelected: GoRouter.of(context).location.contains("Schedule")),
          _DrawerItem(
              title: localizationImpl.translate("Someday"),
              iconPath: Icons.calendar_today,
              onPressed: () {},
              isSelected: GoRouter.of(context).location.contains("Someday")),
          _DrawerItem(
              title: localizationImpl.translate("Lists"),
              iconPath: Icons.list_sharp,
              onPressed: () {},
              isSelected: GoRouter.of(context).location.contains("Lists")),
          _DrawerItem(
              title: localizationImpl.translate("Tags"),
              iconPath: Icons.tag_sharp,
              onPressed: () {},
              isSelected: GoRouter.of(context).location.contains("Tags")),
          _DrawerItem(
              title: localizationImpl.translate("Maps"),
              iconPath: Icons.map_outlined,
              onPressed: () {},
              isSelected: GoRouter.of(context).location.contains("Maps")),
          const Divider(),
          _DrawerItem(
              title: localizationImpl.translate("Archive"),
              iconPath: Icons.archive_outlined,
              onPressed: () {},
              isSelected: GoRouter.of(context).location.contains("Archive")),
          _DrawerItem(
              title: localizationImpl.translate("Trash"),
              iconPath: Icons.delete,
              onPressed: () {},
              isSelected: GoRouter.of(context).location.contains("Trash")),
          _DrawerItem(
              title: localizationImpl.translate("Help"),
              iconPath: Icons.help,
              onPressed: () {},
              isSelected: GoRouter.of(context).location.contains("Help")),
          _DrawerItem(
              title: localizationImpl.translate("Settings"),
              iconPath: Icons.settings,
              onPressed: () {},
              isSelected: GoRouter.of(context).location.contains("Settings")),
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
      child: SizedBox(
          height: 80,
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
          )),
    );
  }
}
