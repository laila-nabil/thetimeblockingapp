import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
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
import '../entities/workspace.dart';
import 'custom_alert_widget.dart';

///TODO in desktop,show folders and list as sub to Lists

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final globalBloc = BlocProvider.of<GlobalBloc>(context);
    final showSmallDesign = context.showSmallDesign;
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return CustomDrawerWidget(
                showSmallDesign: showSmallDesign,
                router: GoRouter.of(context),
                selectWorkspace: (selected) {
                  if (selected is Workspace && state.settingsStateEnum == false) {
                    globalBloc.add(GetAllInWorkspaceEvent(
                        workspace: selected,
                        user: BlocProvider.of<AuthBloc>(context).state.user!));
                  }
                },
                appLocalization: appLocalization);
          },
        );
      },
    );
  }
}

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({
    super.key,
    required this.appLocalization,
    required this.selectWorkspace,
    required this.router,
    required this.showSmallDesign,
  });

  final void Function(Workspace? workspace) selectWorkspace;
  final Localization appLocalization;
  final GoRouter? router;
  final bool showSmallDesign;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return Drawer(
      width: 272,
      // width: showSmallDesign ? 272 : 392,
      backgroundColor: Colors.transparent,
      child: Container(
        color: AppColors.background(context.isDarkMode),
        padding: EdgeInsets.only(
            top: AppSpacing.medium16.value,
            left: AppSpacing.xSmall8.value,
            right: AppSpacing.xSmall8.value),
        child: Column(
          children: [
            const _Logo(),
            _DrawerItem(
                title: appLocalization.translate("Schedule"),
                iconPath: (isSelected) =>
                    isSelected ? AppIcons.calendarbold : AppIcons.calendar,
                onPressed: () {
                  context.go(SchedulePage.routeName);
                },
                isSelected: location.contains(SchedulePage.routeName) == true),

            _DrawerItem(
                title: appLocalization.translate("AllTasks"),
                iconPath: (isSelected) =>
                    isSelected ? AppIcons.folderbold : AppIcons.folder,
                onPressed: () {
                  context.go(AllTasksPage.routeName);
                },
                isSelected: location.contains(AllTasksPage.routeName) == true),
            _DrawerItem(
                title: appLocalization.translate("Lists"),
                iconPath: (isSelected) =>
                    isSelected ? AppIcons.listbold : AppIcons.list,
                onPressed: () {
                  context.go(ListsPage.routeName);
                },
                isSelected: location.contains(ListsPage.routeName) == true ||
                    location.contains(ListPage.routeName) == true),
            _DrawerItem(
                title: appLocalization.translate("Tags"),
                iconPath: (isSelected) =>
                    isSelected ? AppIcons.hashtagBold : AppIcons.hashtag,
                onPressed: () {
                  context.go(TagsPage.routeName);
                },
                isSelected: location.contains(TagsPage.routeName) == true ||
                    location.contains(TagPage.routeName) == true),
            // ignore: dead_code
            if (false)
              _DrawerItem(
                  title: appLocalization.translate("Maps"),
                  iconPath: (isSelected) =>
                      isSelected ? AppIcons.mapbold : AppIcons.map,
                  onPressed: () {
                    context.go(MapsPage.routeName);
                  },
                  isSelected: location.contains(MapsPage.routeName) == true),
            Divider(
              height: 1,
              color: AppColors.grey(context.isDarkMode).shade100,
            ),
            const Spacer(),
            // ignore: dead_code
            // if (false)
            // _DrawerItem(
            //     title: appLocalization.translate("Archive"),
            //     iconPath: Icons.archive_outlined,
            //     onPressed: () {
            //       context.go(ArchivePage.routeName);
            //     },
            //     isSelected:
            //         router?.location.contains(ArchivePage.routeName) == true),
            // ignore: dead_code
            if (false)
              _DrawerItem(
                  title: appLocalization.translate("Trash"),
                  iconPath: (isSelected) =>
                      isSelected ? AppIcons.binbold : AppIcons.bin,
                  onPressed: () {
                    context.go(TrashPage.routeName);
                  },
                  isSelected: location.contains(TrashPage.routeName) == true),
            _DrawerItem(
                title: appLocalization.translate("Settings"),
                iconPath: (isSelected) =>
                    isSelected ? AppIcons.settingsvbold : AppIcons.settingsv,
                onPressed: () {
                  context.go(SettingsPage.routeName);
                },
                isSelected: location.contains(SettingsPage.routeName) == true),
            // ignore: dead_code
            if (false)
              _DrawerItem(
                  title: appLocalization.translate("Help"),
                  iconPath: (isSelected) => isSelected
                      ? AppIcons.infocirclebold
                      : AppIcons.infocircle,
                  onPressed: () {
                    context.go(HelpPage.routeName);
                  },
                  isSelected: location.contains(HelpPage.routeName) == true),
            Container(
              margin: const EdgeInsets.only(
                   right: 24, left: 24, bottom: 10),
              child:Row(
                children: [
                  Expanded(
                    child: RichText(
                        textScaler: MediaQuery.textScalerOf(context),
                        text: TextSpan(
                      text: appLocalization.translate("madeWithLoveBy") + " ",
                      style: AppTextStyle.getTextStyle(AppTextStyleParams(
                          appFontSize: AppFontSize.paragraphX2Small,
                          color: AppColors.grey(context.isDarkMode),
                          appFontWeight: AppFontWeight.thin)),
                      children: <TextSpan>[
                        TextSpan(
                            text: appLocalization.translate("lailaNabil"),
                            style: TextStyle(
                                fontWeight: AppFontWeight.bold.value,
                                decoration: TextDecoration.underline),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () => launchWithURL(
                                  url: "https://bento.me/lailanabil")),
                        TextSpan(
                            text:
                                " " + appLocalization.translate("inCairoEgypt")),
                      ],
                    )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem(
      {required this.title,
      required this.iconPath,
      required this.onPressed,
      required this.isSelected,
      // ignore: unused_element
      this.hasSubPage = false,
      // ignore: unused_element
      this.isSubPage = false});

  final String title;
  final IconData Function(bool isSelected) iconPath;
  final void Function() onPressed;
  final bool isSelected;
  final bool hasSubPage;
  final bool isSubPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed)) {
                return AppColors.primary(context.isDarkMode).shade50;
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.grey(context.isDarkMode).shade50;
              }
              return AppColors.background(context.isDarkMode);
            }),
            foregroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              return AppColors.white(context.isDarkMode);
            }),
            padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
            shape: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              );
            })),
        child: Row(
          children: [
            Icon(
              iconPath(isSelected),
              size: 20,
              color: AppColors.black(context.isDarkMode),
            ),
            SizedBox(
              width: AppSpacing.small12.value,
            ),
            Text(
              title,
              style: AppTextStyle.getTextStyle(AppTextStyleParams(
                  appFontSize: AppFontSize.paragraphSmall,
                  color: AppColors.grey(context.isDarkMode).shade700,
                  appFontWeight: isSelected
                      ? AppFontWeight.semiBold
                      : AppFontWeight.regular)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final showSmallDesign = context.showSmallDesign;
    return SafeArea(
      child: Container(
        height: showSmallDesign ? 43 : 54,
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                  showSmallDesign ? 24 : 29, 0, 0, 0),
              child: Image.asset(
                AppAssets.logo(context.isDarkMode),
                width: showSmallDesign ? 180 : 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
