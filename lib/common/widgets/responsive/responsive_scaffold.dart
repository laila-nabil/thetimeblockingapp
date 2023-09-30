import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/widgets/custom_drawer.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';

import '../../../features/startup/presentation/bloc/startup_bloc.dart';
import '../custom_app_bar.dart';

class ResponsiveScaffold extends Scaffold {
  final BuildContext context;
  final bool showSmallDesign;
  final List<PopupMenuEntry<int>>? pageActions;
  ///[responsiveBody] overrides [body]
  final ResponsiveTParams<Widget> responsiveBody;

  // ignore: prefer_const_constructors_in_immutables
  ResponsiveScaffold({
    super.key,
    required this.responsiveBody,
    required this.context,
    required this.showSmallDesign,
    this.pageActions,
  });

  @override
  Widget? get body {
    final responsiveT = Responsive.responsiveT(
        params: responsiveBody, context: context);
    if (showSmallDesign) {
      return responsiveT;
    } else {
      return BlocBuilder<StartupBloc, StartupState>(
        builder: (context, state) {
          if(state.drawerLargerScreenOpen){
            return Row(
              children: [
                const CustomDrawer(),
                Expanded(child: responsiveT,),
              ],
            );
          }
          return responsiveT;
        },
      );
    }
  }

  @override
  Widget? get drawer =>
      showSmallDesign ? const CustomDrawer() : null;

  @override
  PreferredSizeWidget? get appBar => CustomAppBar(pageActions: pageActions,);
}
