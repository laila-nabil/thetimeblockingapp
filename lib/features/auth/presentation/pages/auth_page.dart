import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/widgets/responsive.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';

import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_input_field.dart';
import '../../../../core/launch_url.dart';
import '../bloc/auth_bloc.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);

  static const routeName = "/Auth";

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final authBloc = BlocProvider.of<AuthBloc>(context);
        return ResponsiveScaffold(
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
            context: context,
            key: key);
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
                        "https://app.clickup.com/api?client_id=${Globals.clickUpClientId}&redirect_uri=${Globals.clickUpRedirectUrl}");

                if (kDebugMode) {
                  authBloc.add(const ShowCodeInputTextField(true));
                }
              }),
          Text(LocalizationImpl().translate("agreeTermsConditions")),
          if (authBloc.state.authStates
              .contains(AuthStateEnum.showCodeInputTextField))
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
                    authBloc.add(SubmitClickUpCode(controller.text));
                  },
                )
              ],
            )
        ],
      ),
    );
  }
}
