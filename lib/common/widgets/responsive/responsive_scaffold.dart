import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/widgets/custom_drawer.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';

import '../../../features/startup/presentation/bloc/startup_bloc.dart';
import '../custom_app_bar.dart';
import '../custom_loading.dart';

enum ResponsiveScaffoldLoadingEnum {
  overlayLoading,contentLoading,
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
  final List<PopupMenuEntry<Object?>>? pageActions;
  ///[responsiveBody] overrides [body]
  final ResponsiveTParams<Widget> responsiveBody;

  final ResponsiveScaffoldLoading? responsiveScaffoldLoading;
  // ignore: prefer_const_constructors_in_immutables
  ResponsiveScaffold({
    super.key,
    required this.responsiveBody,
    required this.context,
    this.pageActions,
    this.responsiveScaffoldLoading,
  });

  Widget _responsiveT() {
    final actualResponsiveBody = Responsive.responsiveT(
        params: responsiveScaffoldLoading?.isLoadingContent == true
            ? ResponsiveTParams(
                mobile: CustomLoading(color: Theme.of(context).primaryColor),
                laptop: CustomLoading(color: Theme.of(context).primaryColor))
            : responsiveBody,
        context: context);
    return (responsiveScaffoldLoading?.isLoadingOverlay == true)
        ? Stack(
            children: [const LoadingOverlay() , actualResponsiveBody],
          )
        : actualResponsiveBody;
  }

  @override
  Widget? get body {
    if (Responsive.showSmallDesign(context)) {
      return _responsiveT();
    } else {
      return BlocBuilder<StartupBloc, StartupState>(
        builder: (context, state) {
          if(state.drawerLargerScreenOpen){
            return Row(
              children: [
                const CustomDrawer(),
                Expanded(child: _responsiveT(),),
              ],
            );
          }
          return _responsiveT();
        },
      );
    }
  }

  @override
  Widget? get drawer =>
      Responsive.showSmallDesign(context) ? const CustomDrawer() : null;

  @override
  PreferredSizeWidget? get appBar => CustomAppBar(pageActions: pageActions,);
}
