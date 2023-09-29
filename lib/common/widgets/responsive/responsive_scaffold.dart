import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/widgets/custom_drawer.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';

import '../custom_app_bar.dart';

class ResponsiveScaffold extends Scaffold {
  final BuildContext context;

  ///[responsiveBody] overrides [body]
  final ResponsiveTParams<Widget> responsiveBody;

  const ResponsiveScaffold({
    super.key,
    required this.responsiveBody,
    required this.context,
  });

  @override
  Widget? get body {
    return Responsive.responsiveT(params: responsiveBody, context: context);
  }

  @override
  Widget? get drawer => const CustomDrawer();

  @override
  PreferredSizeWidget? get appBar => const CustomAppBar();
}
