import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/widgets/custom_drawer.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';

import '../../../features/startup/presentation/bloc/startup_bloc.dart';
import '../custom_app_bar.dart';
import '../custom_pop_up_menu.dart';
import '../custom_loading.dart';

enum ResponsiveScaffoldLoadingEnum {
  overlayLoading,
  contentLoading,
}

class ResponsiveScaffoldLoading {
  final ResponsiveScaffoldLoadingEnum responsiveScaffoldLoadingEnum;
  final bool isLoading;

  ResponsiveScaffoldLoading(
      {required this.responsiveScaffoldLoadingEnum, required this.isLoading});

  bool get isLoadingOverlay =>
      isLoading &&
      responsiveScaffoldLoadingEnum ==
          ResponsiveScaffoldLoadingEnum.overlayLoading;

  bool get isLoadingContent =>
      isLoading &&
      responsiveScaffoldLoadingEnum ==
          ResponsiveScaffoldLoadingEnum.contentLoading;
}

class ResponsiveScaffold extends Scaffold {
  final BuildContext context;
  final List<CustomPopupItem>? pageActions;

  ///[responsiveBody] overrides [body]
  final ResponsiveTParams<Widget> responsiveBody;

  final ResponsiveScaffoldLoading? responsiveScaffoldLoading;
  final bool hideAppBarDrawer;

  final Future<void> Function() onRefresh;
  // ignore: prefer_const_constructors_in_immutables
  ResponsiveScaffold( {
    super.key,
    required this.responsiveBody,
    required this.context,
    this.pageActions,
    this.responsiveScaffoldLoading,
    this.hideAppBarDrawer = false,
    required this.onRefresh,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
    super.floatingActionButtonAnimator,
    super.persistentFooterButtons,
    super.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    super.onDrawerChanged,
    super.endDrawer,
    super.onEndDrawerChanged,
    super.bottomNavigationBar,
    super.bottomSheet,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    super.primary = true,
    super.drawerDragStartBehavior = DragStartBehavior.start,
    super.extendBody = false,
    super.extendBodyBehindAppBar = false,
    super.drawerScrimColor,
    super.drawerEdgeDragWidth,
    super.drawerEnableOpenDragGesture = true,
    super.endDrawerEnableOpenDragGesture = true,
    super.restorationId,
  });

  @override
  Widget? get floatingActionButton =>
      responsiveScaffoldLoading?.isLoading == true
          ? null
          : super.floatingActionButton;

  @override
  Widget? get body {
    if (context.showSmallDesign == false) {
      return BlocBuilder<StartupBloc, StartupState>(
        builder: (context, state) {
          if (state.drawerLargerScreenOpen) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomDrawer(),
                Expanded(
                  child: _ResponsiveBody(
                    responsiveTParams: responsiveBody,
                    responsiveScaffoldLoading: responsiveScaffoldLoading,
                    onRefresh: onRefresh ,
                  ),
                ),
              ],
            );
          }
          return _ResponsiveBody(
            responsiveTParams: responsiveBody,
            responsiveScaffoldLoading: responsiveScaffoldLoading,
            onRefresh: onRefresh,
          );
        },
      );
    }
    return _ResponsiveBody(
      responsiveTParams: responsiveBody,
      responsiveScaffoldLoading: responsiveScaffoldLoading,
      onRefresh: onRefresh,
    );
  }

  @override
  Widget? get drawer => hideAppBarDrawer
      ? null
      : (context.showSmallDesign ? const CustomDrawer() : null);

  @override
  PreferredSizeWidget? get appBar => hideAppBarDrawer
      ? null
      : CustomAppBar(
          pageActions: pageActions,
          showSmallDesign: context.showSmallDesign,
        );
}

class _ResponsiveBody extends StatelessWidget {
  const _ResponsiveBody(
      {Key? key,
      this.responsiveScaffoldLoading,
      required this.responsiveTParams,
      required this.onRefresh})
      : super(key: key);
  final ResponsiveScaffoldLoading? responsiveScaffoldLoading;
  final ResponsiveTParams<Widget> responsiveTParams;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final actualResponsiveBody = RefreshIndicator(
        onRefresh: onRefresh,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: context.responsiveT(
        params: responsiveScaffoldLoading?.isLoadingContent == true
            ? ResponsiveTParams(
            small: CustomLoading(color: Theme.of(context).primaryColor),
            large: CustomLoading(color: Theme.of(context).primaryColor))
            : responsiveTParams));
    return (responsiveScaffoldLoading?.isLoadingOverlay == true)
        ? Stack(
      alignment: Alignment.center,
      children: [
        actualResponsiveBody,
        const LoadingOverlay(),
      ],
    )
        : actualResponsiveBody;
    final content = RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: onRefresh,
        child: context.responsiveT(params: responsiveTParams));
    return (responsiveScaffoldLoading?.isLoadingOverlay == true)
        ? Stack(
            alignment: Alignment.center,
            children: [
              content,
              const LoadingOverlay(),
            ],
          )
        : (responsiveScaffoldLoading?.isLoadingOverlay == true)
            ? context.responsiveT(
                params: ResponsiveTParams(
                    small: CustomLoading(color: Theme.of(context).primaryColor),
                    large:
                        CustomLoading(color: Theme.of(context).primaryColor)))
            : content;
  }
}
