import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/globals.dart';

import '../../../../common/widgets/responsive.dart';

class SchedulePage extends StatelessWidget {
  SchedulePage({Key? key}) : super(key: key);
  static const routeName = "/Schedule";

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
        key: scaffoldKey,
        responsiveBody: ResponsiveTParams(
            mobile: const _SchedulePageContent(),
            laptop:  const _SchedulePageContent()),
        context: context);
  }
}

class _SchedulePageContent extends StatelessWidget {
  const _SchedulePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(Globals.clickUpUser.toString()),
        Text(Globals.clickUpWorkspaces.toString()),
      ],
    );
  }
}

