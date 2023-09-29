import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/widgets/custom_drawer.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';

import '../custom_app_bar.dart';

class ResponsiveScaffold extends Scaffold {
  final BuildContext context;
  final bool showSmallDesign;
  ///[responsiveBody] overrides [body]
  final ResponsiveTParams<Widget> responsiveBody;

  // ignore: prefer_const_constructors_in_immutables
  ResponsiveScaffold({
    super.key,
    required this.responsiveBody,
    required this.context,
    required this.showSmallDesign,
  });

  @override
  Widget? get body {
    final responsiveT = Responsive.responsiveT(params: responsiveBody, context: context);
    if (showSmallDesign) {
      return responsiveT;
    } else {
      return Row(
        children: [
          const CustomDrawer(),
          Expanded(child: responsiveT,),
        ],
      );
    }
  }

  @override
  Widget? get drawer =>
      showSmallDesign ? const CustomDrawer() : null;

  @override
  PreferredSizeWidget? get appBar => const CustomAppBar();
}
