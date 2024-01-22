// Widgetbook file: widgetbook.dart
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
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
            const Locale(
              'en',
            ),
            const Locale(
              'ar',
            ),
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
        WidgetbookFolder(name: "App design", children: [
          WidgetbookComponent(
            name: 'Colors',
            useCases: [
              WidgetbookUseCase(
                  name: 'Colors Swatches',
                  builder: (context) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          colorSwatches(AppColors.secondary),
                          colorSwatches(AppColors.success),
                          colorSwatches(AppColors.error),
                          colorSwatches(AppColors.warning),
                          colorSwatches(AppColors.grey),
                          colorSwatches(AppColors.brown),
                          colorSwatches(AppColors.paletteYellow),
                          colorSwatches(AppColors.paletteGreen),
                          colorSwatches(AppColors.palettePurple),
                          colorSwatches(AppColors.paletteBlue),
                          colorSwatches(AppColors.palettePink),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ])
      ],
    );
  }

  Wrap colorSwatches(MaterialColor secondary) {
    return Wrap(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        color: secondary.shade50,
                        child: Text(secondary.shade50.toHex().toString()),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        color: secondary.shade100,
                        child: Text(secondary.shade100.toHex().toString()),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        color: secondary.shade200,
                        child: Text(secondary.shade200.toHex().toString()),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        color: secondary.shade300,
                        child: Text(secondary.shade300.toHex().toString()),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        color: secondary.shade400,
                        child: Text(secondary.shade400.toHex().toString()),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        color: secondary.shade500,
                        child: Text(secondary.shade50.toHex().toString()),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        color: secondary.shade600,
                        child: Text(secondary.shade600.toHex().toString()),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        color: secondary.shade700,
                        child: Text(secondary.shade700.toHex().toString()),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        color: secondary.shade800,
                        child: Text(secondary.shade800.toHex().toString()),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        color: secondary.shade900,
                        child: Text(secondary.shade900.toHex().toString()),
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
