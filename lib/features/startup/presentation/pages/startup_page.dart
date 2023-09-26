import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/widgets/responsive.dart';
import 'package:thetimeblockingapp/core/globals.dart';


class StartUpPage extends StatelessWidget {
  StartUpPage({Key? key}) : super(key: key);
  static const routeName = "/";

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
        key: scaffoldKey,
        drawer: const Text("drawer"),
        responsiveBody: ResponsiveTParams(
            mobile: Column(
              children: [
                Text(
                    Globals.appName,
                    style: const TextStyle(color: Colors.black)),
                TextButton(onPressed: (){
                  scaffoldKey.currentState?.openDrawer();
                }, child: const Text("open drawer"))
              ],
            ),
            laptop: Column(
              children: [
                Text(
                    Globals.appName,
                    style: const TextStyle(color: Colors.blue)),
                TextButton(onPressed: (){
                  scaffoldKey.currentState?.openDrawer();
                }, child: const Text("open drawer"))
              ],
            )),
        context: context);
  }
}
