
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/presentation/pages/onboarding_auth_page.dart';
import 'package:thetimeblockingapp/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../schedule/presentation/pages/schedule_page.dart';
import '../bloc/auth_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key, this.code});

  static const routeName = "/Auth";

  final String? code;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {},
      builder: (context, settingsState) {
        final settingsBloc = BlocProvider.of<SettingsBloc>(context);
        printDebug("SettingsBloc state builder $settingsState");
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            printDebug("AuthBloc state listener $state");
            if (state.canGoSchedulePage == true) {
              context.go(SchedulePage.routeName, extra: true);
            }
          },
          builder: (context, state) {
            printDebug("AuthBloc state builder $state");
            final authBloc = BlocProvider.of<AuthBloc>(context);
            if (state.authStates.length == 1 &&
                state.authStates.contains(AuthStateEnum.initial)) {

              ///in case saved locally
              authBloc.add(const GetAccessToken(""));
            } else if (code?.isNotEmpty == true && state.isLoading == false) {
              authBloc.add(GetAccessToken(code ?? ""));
            }
            return OnBoardingAndAuthPage(
              authBloc: authBloc, settingsBloc: settingsBloc,);
          },
        );
      },
    );
  }
}
