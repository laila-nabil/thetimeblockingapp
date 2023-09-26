import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/widgets/responsive.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';

import '../../../../common/widgets/custom_button.dart';
import '../../../../core/launch_url.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);

  static const routeName = "/Auth";

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
        responsiveBody: ResponsiveTParams(
            mobile: const Column(
              children: [
                Expanded(child: Placeholder()),
                Expanded(child: ExplainClickupAuth())
              ],
            ),
            laptop: const Row(
              children: [
                Expanded(child: ExplainClickupAuth()),
                Expanded(child: Placeholder()),
              ],
            )),
        context: context,
        key: key);
  }
}

class ExplainClickupAuth extends StatelessWidget {
  const ExplainClickupAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(LocalizationImpl().translate("whyConnectClickup",
              arguments: [LocalizationImpl().translate("appName")])),
          CustomButton(
              child: const Text("Connect with Clickup"),
              onPressed: () {
                launchWithURL(
                    url:
                        "https://app.clickup.com/api?client_id=$getClickUpClientId&redirect_uri=$getClickUpRedirectUrl");
              }),
          Text(LocalizationImpl().translate("agreeTermsConditions"))
        ],
      ),
    );
  }
}
