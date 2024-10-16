import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:thetimeblockingapp/features/terms_conditions/terms_html.dart';

class TermsConditionsPage extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  TermsConditionsPage({super.key});

  static const routeName = "/TermsConditions";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: HtmlWidget(termsHtml),
    )));
  }
}
