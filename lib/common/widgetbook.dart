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
                    final tooltip = context.knobs.string(
                      label: 'Tooltip text',
                      initialValue: 'Tooltip message here',
                    );
                    return SingleChildScrollView(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///PRIMARY
                              const Text(
                                "Primary , Enabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Primary , Disabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Primary , Enabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    size: CustomButtonSize.large,
                                  )
                                ],
                              ),
                              const Text(
                                "Primary , Disabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    size: CustomButtonSize.large,
                                  )
                                ],
                              ),
                              const Divider(),

                              ///Grey Solid
                              const Text(
                                "Grey Solid, Enabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilled,
                                    onPressed: () => print("on pressed"),
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilled,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilled,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                  ),
                                  CustomButton.iconOnly(
                                    type: CustomButtonType.greyFilled,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Grey Solid , Disabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilled,
                                    onPressed: null,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilled,
                                    onPressed: null,
                                    icon: Icons.add,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilled,
                                    onPressed: null,
                                    icon: Icons.add,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    type: CustomButtonType.greyFilled,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Grey Solid , Enabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilled,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilled,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilled,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilled,
                                    size: CustomButtonSize.large,
                                  )
                                ],
                              ),
                              const Text(
                                "Grey Solid , Disabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilled,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilled,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilled,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    type: CustomButtonType.greyFilled,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    size: CustomButtonSize.large,
                                  ),
                                ],
                              ),
                              const Divider(),

                              ///Destructive Solid
                              const Text(
                                "Destructive Solid, Enabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.destructiveFilled,
                                    onPressed: () => print("on pressed"),
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.destructiveFilled,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.destructiveFilled,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                  ),
                                  CustomButton.iconOnly(
                                    type: CustomButtonType.destructiveFilled,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Destructive Solid , Disabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.destructiveFilled,
                                    onPressed: null,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.destructiveFilled,
                                    onPressed: null,
                                    icon: Icons.add,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.destructiveFilled,
                                    onPressed: null,
                                    icon: Icons.add,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    type: CustomButtonType.destructiveFilled,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Destructive Solid , Enabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.destructiveFilled,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.destructiveFilled,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.destructiveFilled,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    type: CustomButtonType.destructiveFilled,
                                    size: CustomButtonSize.large,
                                  )
                                ],
                              ),
                              const Text(
                                "Destructive Solid , Disabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.destructiveFilled,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.destructiveFilled,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.destructiveFilled,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    type: CustomButtonType.greyFilled,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    size: CustomButtonSize.large,
                                  ),
                                ],
                              ),
                              const Divider(),

                              ///Secondary
                              const Text(
                                "Secondary , Enabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.secondary,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,

                                    type: CustomButtonType.secondary,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.secondary,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.secondary,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Secondary , Disabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    type: CustomButtonType.secondary,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    type: CustomButtonType.secondary,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    type: CustomButtonType.secondary,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    type: CustomButtonType.secondary,
                                  )
                                ],
                              ),
                              const Text(
                                "Secondary , Enabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.secondary,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.secondary,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.secondary,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.secondary,
                                  )
                                ],
                              ),
                              const Text(
                                "Secondary , Disabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.secondary,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.secondary,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.secondary,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.secondary,
                                  )
                                ],
                              ),
                              const Divider(),
                              ///Grey Outlined
                              const Text(
                                "Grey Outlined , Enabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.greyOutlined,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,

                                    type: CustomButtonType.greyOutlined
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.greyOutlined
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.greyOutlined,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Grey Outlined , Disabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    type: CustomButtonType.greyOutlined
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    type: CustomButtonType.greyOutlined
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    type: CustomButtonType.greyOutlined
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyOutlined
                                  )
                                ],
                              ),
                              const Text(
                                "Grey Outlined , Enabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.greyOutlined
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.greyOutlined
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.greyOutlined
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.greyOutlined
                                  )
                                ],
                              ),
                              const Text(
                                "Grey Outlined , Disabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.greyOutlined
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.greyOutlined
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.greyOutlined
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.greyOutlined
                                  )
                                ],
                              ),
                              const Divider(),
                              ///Destructive Outlined
                              const Text(
                                "Destructive Outlined , Enabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.destructiveOutlined,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,

                                      type: CustomButtonType.destructiveOutlined
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      type: CustomButtonType.destructiveOutlined
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.destructiveOutlined,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Destructive Outlined , Disabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      type: CustomButtonType.destructiveOutlined
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType.destructiveOutlined
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType.destructiveOutlined
                                  ),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      type: CustomButtonType.destructiveOutlined
                                  )
                                ],
                              ),
                              const Text(
                                "Destructive Outlined , Enabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveOutlined
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveOutlined
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveOutlined
                                  ),
                                  CustomButton.iconOnly(
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveOutlined
                                  )
                                ],
                              ),
                              const Text(
                                "Destructive Outlined , Disabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveOutlined
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveOutlined
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveOutlined
                                  ),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveOutlined
                                  )
                                ],
                              ),
                              const Divider(),
                              ///Primary Text
                              const Text(
                                "Primary Text , Enabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.primaryText,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,

                                      type: CustomButtonType.primaryText
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      type: CustomButtonType.primaryText
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.primaryText,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Primary Text , Disabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      type: CustomButtonType.primaryText
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType.primaryText
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType.primaryText
                                  ),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      type: CustomButtonType.primaryText
                                  )
                                ],
                              ),
                              const Text(
                                "Primary Text , Enabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.primaryText
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.primaryText
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.primaryText
                                  ),
                                  CustomButton.iconOnly(
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.primaryText
                                  )
                                ],
                              ),
                              const Text(
                                "Primary Text , Disabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.primaryText
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.primaryText
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.primaryText
                                  ),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.primaryText
                                  )
                                ],
                              ),
                              const Divider(),
                              ///Destructive Text
                              const Text(
                                "Destructive Text , Enabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.destructiveText,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,

                                      type: CustomButtonType.destructiveText
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      type: CustomButtonType.destructiveText
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.destructiveText,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Destructive Text , Disabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      type: CustomButtonType.destructiveText
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType.destructiveText
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType.destructiveText
                                  ),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      type: CustomButtonType.destructiveText
                                  )
                                ],
                              ),
                              const Text(
                                "Destructive Text , Enabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveText
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveText
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveText
                                  ),
                                  CustomButton.iconOnly(
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveText
                                  )
                                ],
                              ),
                              const Text(
                                "Destructive Text , Disabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveText
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveText
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveText
                                  ),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.destructiveText
                                  )
                                ],
                              ),
                              const Divider(),
                              ///Grey Text
                              const Text(
                                "Grey Text , Enabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.greyText,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,

                                      type: CustomButtonType.greyText
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      type: CustomButtonType.greyText
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.greyText,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Grey Text , Disabled , small",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      type: CustomButtonType.greyText
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType.greyText
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType.greyText
                                  ),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      type: CustomButtonType.greyText
                                  )
                                ],
                              ),
                              const Text(
                                "Grey Text , Enabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.greyText
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.greyText
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.greyText
                                  ),
                                  CustomButton.iconOnly(
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.greyText
                                  )
                                ],
                              ),
                              const Text(
                                "Grey Text , Disabled , large",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.greyText
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.greyText
                                  ),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.greyText
                                  ),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.greyText
                                  )
                                ],
                              ),
                              const Divider(),
                            ]));
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
