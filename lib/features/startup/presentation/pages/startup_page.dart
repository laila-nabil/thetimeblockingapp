import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/widgets/responsive.dart';

import '../../../../core/injection_container.dart';

class StartUpPage extends StatelessWidget {
  const StartUpPage({Key? key}) : super(key: key);
  static const routeName = "/";
  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
        responsiveBody: ResponsiveTParams(
            mobile: Text(sl.get(instanceName: NamedInstances.appName.name)),
            laptop: Text(sl.get(instanceName: NamedInstances.appName.name))),
        context: context);
  }
}
