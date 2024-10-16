import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:thetimeblockingapp/features/privacy_policy/privacy_html.dart';

class PrivacyPolicyPage extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  PrivacyPolicyPage({super.key});

  static const routeName = "/PrivacyPolicy";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: HtmlWidget(privacyHtml),
            )));
  }
}
