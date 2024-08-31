import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../schedule/presentation/pages/schedule_page.dart';
import '../bloc/auth_bloc.dart';
import 'supabase_onboarding_auth_page.dart';

class SupabaseAuthPage extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  SupabaseAuthPage({
    super.key,
  });

  static const routeName = "/Auth";

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
            BlocProvider.of<AuthBloc>(context);
            if (state.canGoSchedulePage == true) {
              context.go(SchedulePage.routeName, extra: true);
            }
          },
          builder: (context, state) {
            printDebug("AuthBloc state builder $state");
            final authBloc = BlocProvider.of<AuthBloc>(context);
            return SupabaseOnBoardingAndAuthPage(
              authBloc: authBloc,
              settingsBloc: settingsBloc,
            );
          },
        );
      },
    );
  }
}
