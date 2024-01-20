// Widgetbook file: widgetbook.dart
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const HotReload());
}

class HotReload extends StatelessWidget {
  const HotReload({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        // MaterialThemeAddon(
        //   themes: [
        //     WidgetbookTheme(
        //         name: 'Light',
        //         data: yourCustomLightTheme
        //     ),
        //     WidgetbookTheme(
        //         name: 'Dark',
        //         data: yourCustomTheme
        //     ),
        //   ],
        // ),
        TextScaleAddon(
          scales: [1.0, 2.0],
        ),
        LocalizationAddon(
          locales: [
            const Locale('en',),
            const Locale('ar',),
          ],
          localizationsDelegates: [
            DefaultWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
          ],
        ),
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhoneSE,
            Devices.ios.iPhone13,
          ],
        ),
        GridAddon(),
      ],
      directories: [
        WidgetbookComponent(
          name: 'CustomCard',
          useCases: [
            WidgetbookUseCase(
              name: 'Default Style',
              builder: (context) => const CustomCard(
                child: Text('This is a custom card'),
              ),
            ),
            WidgetbookUseCase(
              name: 'With Custom Background Color',
              builder: (context) => CustomCard(
                backgroundColor: Colors.green.shade100,
                child: const Text(
                  'This is a custom card with a custom background color',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double borderRadius;

  const CustomCard({
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderRadius = 8.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
