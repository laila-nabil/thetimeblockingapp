import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_text_input_field.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../../core/launch_url.dart';
import '../../../schedule/presentation/pages/schedule_page.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_page_webview.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key, this.code}) : super(key: key);

  static const routeName = "/Auth";

  final String? code;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        printDebug("AuthBloc state listener $state");
        if (state.canGoSchedulePage == true) {
          context.go(SchedulePage.routeName,extra: true);
        }

      },
      builder: (context, state) {
        printDebug("AuthBloc state builder $state");
        final authBloc = BlocProvider.of<AuthBloc>(context);
        if (state.authStates.length == 1 && state.authStates.contains(AuthStateEnum.initial)) {

          ///in case saved locally
          authBloc.add(const GetClickupAccessToken(""));
        }else if (code?.isNotEmpty == true && state.isLoading == false) {
          authBloc.add(GetClickupAccessToken(code??""));
        }
        return ResponsiveScaffold(
          hideAppBarDrawer: true,
          responsiveScaffoldLoading: ResponsiveScaffoldLoading(
              responsiveScaffoldLoadingEnum:
                  ResponsiveScaffoldLoadingEnum.contentLoading,
              isLoading: state.isLoading),
          responsiveBody: ResponsiveTParams(
                small: Column(
                  children: [
                    const Expanded(child: Placeholder()),
                    Expanded(
                        child: ExplainClickupAuth(
                      authBloc: authBloc,
                    ))
                  ],
                ),
              large: Row(
                  children: [
                    Expanded(
                        child: ExplainClickupAuth(
                      authBloc: authBloc,
                    )),
                    const Expanded(child: Placeholder()),
                  ],
                )),
            context: context,);
      },
    );
  }
}

class ExplainClickupAuth extends StatelessWidget {
  ExplainClickupAuth({Key? key, required this.authBloc}) : super(key: key);

  final TextEditingController controller = TextEditingController();
  final AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(appLocalization.translate("whyConnectClickup",
                arguments: [appLocalization.translate("appName")])),
            CustomButton.noIcon(
                label: "Connect with Clickup",
                onPressed: () {
                  final url = "https://app.clickup.com/api?client_id=${Globals.clickupClientId}&redirect_uri=${Globals.clickupRedirectUrl}";
                  if (kIsWeb) {
                    launchWithURL(
                        url:
                            url);
                    if (true) {
                      authBloc.add(const ShowCodeInputTextField(true));
                    }
                  } else if (Platform.isAndroid || Platform.isIOS) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AuthPageWebView(
                        url: url,
                        getAccessToken: (String code) {
                          authBloc.add(GetClickupAccessToken(code));
                        },
                      );
                    }));
                  }
                }),
            Text(appLocalization.translate("agreeTermsConditions")),
            if (true)
              Row(
                children: [
                  Expanded(
                    child: CustomTextInputField(
                      controller: controller,
                    ),
                  ),
                  CustomButton.noIcon(
                    label:"submit",
                    onPressed: () {
                      authBloc.add(GetClickupAccessToken(controller.text));
                    },
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
