import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../../../../main.dart';

class ThemeTile extends StatelessWidget {
  const ThemeTile({super.key});

  @override
  Widget build(BuildContext context) {
    var settingsBloc = BlocProvider.of<SettingsBloc>(context);
    var settingsState = settingsBloc.state;
    return ListTile(
      title: const Text('Theme'),
      trailing: IconButton.filledTonal(
        onPressed: () {
          return settingsBloc.add(ChangeThemeEvent(
              settingsState.themeMode == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark));
        },
        icon: Icon(
          settingsState.themeMode == ThemeMode.dark
              ? Icons.brightness_2_rounded
              : Icons.brightness_7_rounded,
        ),
      ),
    );
  }
}
