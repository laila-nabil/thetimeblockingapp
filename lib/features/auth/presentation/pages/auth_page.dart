import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_input_field.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../../core/launch_url.dart';
import '../../../schedule/presentation/pages/schedule_page.dart';
import '../bloc/auth_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  static const routeName = "/Auth";


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        printDebug("AuthBloc state listener $state");
        if (state.isNotAuthed == false) {
          context.go(SchedulePage.routeName);
        }

      },
      builder: (context, state) {
        printDebug("AuthBloc state builder $state");
        final authBloc = BlocProvider.of<AuthBloc>(context);
        if (state.authStates.length == 1 && state.authStates.contains(AuthStateEnum.initial)) {

          ///in case saved locally
          authBloc.add(const GetClickupAccessToken(""));
        }
        return ResponsiveScaffold(
          hideAppBarDrawer: true,
          responsiveScaffoldLoading: ResponsiveScaffoldLoading(
              responsiveScaffoldLoadingEnum:
                  ResponsiveScaffoldLoadingEnum.contentLoading,
              isLoading: state.isLoading),
          responsiveBody: ResponsiveTParams(
                mobile: Column(
                  children: [
                    const Expanded(child: Placeholder()),
                    Expanded(
                        child: ExplainClickupAuth(
                      authBloc: authBloc,
                    ))
                  ],
                ),
                laptop: Row(
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
            CustomButton(
                child: const Text("Connect with Clickup"),
                onPressed: () {
                  ///TODO B webview in case of android
                  launchWithURL(
                      url:
                          "https://app.clickup.com/api?client_id=${Globals.clickupClientId}&redirect_uri=${Globals.clickupRedirectUrl}");

                  if (kDebugMode) {
                    authBloc.add(const ShowCodeInputTextField(true));
                  }
                }),
            Text(appLocalization.translate("agreeTermsConditions")),
            if (kDebugMode)
              Row(
                children: [
                  Expanded(
                    child: CustomTextInputField(
                      controller: controller,
                    ),
                  ),
                  CustomButton(
                    child: const Text("submit"),
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
