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
            mobile: Text(
                serviceLocator.get(instanceName: NamedInstances.appName.name),
                style: TextStyle(color: Colors.black)),
            laptop: Text(
                serviceLocator.get(instanceName: NamedInstances.appName.name),
                style: TextStyle(color: Colors.blue))),
        context: context);
  }
}
