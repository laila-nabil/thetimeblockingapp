import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/custom_drawer.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/assets_paths.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/features/all/presentation/pages/all_tasks_page.dart';
import 'package:thetimeblockingapp/features/help/presentation/pages/help_page.dart';
import 'package:thetimeblockingapp/features/lists/presentation/pages/list_page.dart';
import 'package:thetimeblockingapp/features/lists/presentation/pages/lists_page.dart';
import 'package:thetimeblockingapp/features/maps/presentation/pages/maps_page.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/pages/schedule_page.dart';
import 'package:thetimeblockingapp/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:thetimeblockingapp/features/settings/presentation/pages/settings_page.dart';
import 'package:thetimeblockingapp/features/tags/presentation/pages/tag_page.dart';
import 'package:thetimeblockingapp/features/tags/presentation/pages/tags_page.dart';
import 'package:thetimeblockingapp/features/trash/presentation/pages/trash_page.dart';

import '../../core/launch_url.dart';
import '../../core/resources/app_icons.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/widgets/supabase_auth_widget.dart';
import '../../features/global/presentation/bloc/global_bloc.dart';
import '../../features/lists/presentation/bloc/lists_page_bloc.dart';
import '../entities/workspace.dart';
import 'custom_alert_widget.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final list = customBottomNavBarItems(context);
    var iconSize = 20.0;
    return BottomNavigationBar(
        iconSize: iconSize,
        currentIndex: currentIndex(list, context),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (list[index].onTap != null) {
            list[index].onTap!();
          }
          if (list[index].extra == null) {
            context.go(list[index].path);
          } else {
            context.go(list[index].path, extra: list[index].extra);
          }
        },
        items: list
            .map((item) => BottomNavigationBarItem(
                icon: Icon(
                  item.icon,
                  size: iconSize,
                ),
                activeIcon: Icon(
                  item.activeIcon,
                  size: iconSize,
                ),
                label: appLocalization.translate(item.labelKey)))
            .toList());
  }

  int currentIndex(List<CustomBottomNavBarItem> list, BuildContext context) {
    printDebug("GoRouterState.of(context).fullPath : ${GoRouterState.of(context).fullPath}");
    printDebug("GoRouterState.of(context).topRoute?.path : ${GoRouterState.of(context).topRoute?.path}");
    final result = list.indexWhere((item) =>
          GoRouterState.of(context).topRoute?.path == item.path);
    if(result == -1){
      return list.length - 1;
    }
    return result;
  }

  List<CustomBottomNavBarItem> customBottomNavBarItems(BuildContext context) {
    var defaultList = BlocProvider.of<GlobalBloc>(context)
        .state
        .selectedWorkspace
        ?.defaultList;
    printDebug("defaultList $defaultList");
    return [
      CustomBottomNavBarItem(
          icon: AppIcons.calendar,
          activeIcon: AppIcons.calendar,
          labelKey: "Schedule",
          path: SchedulePage.routeName),
      CustomBottomNavBarItem(
          icon: Icons.inbox_outlined,
          activeIcon: Icons.inbox_rounded,
          labelKey: defaultList?.name ?? "Inbox",
          path: ListPage.inboxRouteName,
          extra: [BlocProvider.of<ListsPageBloc>(context), defaultList],
          onTap: () {
            BlocProvider.of<ListsPageBloc>(context)
                .add(NavigateToListPageEvent(defaultList!));
          }),
      CustomBottomNavBarItem(
          icon: AppIcons.list,
          activeIcon: AppIcons.listbold,
          labelKey: "Lists",
          path: ListsPage.routeName),
      CustomBottomNavBarItem(
          icon: AppIcons.hashtag,
          activeIcon: AppIcons.hashtagBold,
          labelKey: "Tags",
          path: TagsPage.routeName),
      CustomBottomNavBarItem(
          icon: AppIcons.dotshcircle,
          activeIcon:AppIcons.dotshcircle,
          labelKey: "More",
          path: MorePage.routeName)
    ];
  }
}

class CustomBottomNavBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String labelKey;
  final String path;
  final Object? extra;
  final void Function()? onTap;

  const CustomBottomNavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.labelKey,
    required this.path,
    this.extra,
    this.onTap,
  });
}
