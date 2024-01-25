// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const WidgetBookApp());
}

class WidgetBookApp extends StatelessWidget {
  const WidgetBookApp({super.key});

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
            Devices.android.samsungGalaxyS20,
            Devices.macOS.macBookPro,
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
        ]),
        WidgetbookFolder(name: "App components", children: [
          WidgetbookComponent(
            name: 'Buttons',
            useCases: [
              WidgetbookUseCase(
                  name: 'Buttons',
                  builder: (context) {
                    final label = context.knobs.string(
                      label: 'Label text',
                      initialValue: 'Label',
                    );
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Primary , Enabled , small",
                            style: TextStyle(color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton.noIcon(
                                label: label,
                                onPressed: () => print("on pressed"),
                              ),
                              CustomButton.leadingIcon(
                                label: label,
                                onPressed: () => print("on pressed"),
                                icon: Icons.add,
                              ),
                              CustomButton.trailingIcon(
                                label: label,
                                onPressed: () => print("on pressed"),
                                icon: Icons.add,
                              ),
                              CustomButton.iconOnly(
                                onPressed: () => print("on pressed"),
                                icon: Icons.add,
                              )
                            ],
                          ),
                          const Text(
                            "Primary , Disabled , small",
                            style: TextStyle(color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton.noIcon(
                                label: label,
                                onPressed: null,
                              ),
                              CustomButton.leadingIcon(
                                label: label,
                                onPressed: null,
                                icon: Icons.add,
                              ),
                              CustomButton.trailingIcon(
                                label: label,
                                onPressed: null,
                                icon: Icons.add,
                              ),
                              CustomButton.iconOnly(
                                onPressed: null,
                                icon: Icons.add,
                              )
                            ],
                          ),
                          const Text(
                            "Primary , Enabled , large",
                            style: TextStyle(color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton.noIcon(
                                label: label,
                                onPressed: () => print("on pressed"),
                                size: CustomButtonSize.large,
                              ),
                              CustomButton.leadingIcon(
                                label: label,
                                onPressed: () => print("on pressed"),
                                icon: Icons.add,
                                size: CustomButtonSize.large,
                              ),
                              CustomButton.trailingIcon(
                                label: label,
                                onPressed: () => print("on pressed"),
                                icon: Icons.add,
                                size: CustomButtonSize.large,
                              ),
                              CustomButton.iconOnly(
                                onPressed: () => print("on pressed"),
                                icon: Icons.add,
                                size: CustomButtonSize.large,
                              )
                            ],
                          ),
                          const Text(
                            "Primary , Disabled , large",
                            style: TextStyle(color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton.noIcon(
                                label: label,
                                onPressed: null,
                                size: CustomButtonSize.large,
                              ),
                              CustomButton.leadingIcon(
                                label: label,
                                onPressed: null,
                                icon: Icons.add,
                                size: CustomButtonSize.large,
                              ),
                              CustomButton.trailingIcon(
                                label: label,
                                onPressed: null,
                                icon: Icons.add,
                                size: CustomButtonSize.large,
                              ),
                              CustomButton.iconOnly(
                                onPressed: null,
                                icon: Icons.add,
                                size: CustomButtonSize.large,
                              )
                            ],
                          )
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
