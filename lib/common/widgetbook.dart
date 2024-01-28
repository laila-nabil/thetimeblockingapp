// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_text_input_field.dart';
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
                    final customChild = Row(
                      children: [
                        Text(label),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Icons.add)
                      ],
                    );
                    return SingleChildScrollView(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///PRIMARY
                              const Text(
                                "Primary , Enabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.primaryLabel,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.primaryLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.primaryLeadingIcon,
                                    icon: Icons.add,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.primaryTrailingIcon,
                                    icon: Icons.add,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    type: CustomButtonType.primaryIcon,
                                  )
                                ],
                              ),
                              const Text(
                                "Primary , Disabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    type: CustomButtonType.primaryLabel,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: null,
                                    type: CustomButtonType.primaryLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    type: CustomButtonType.primaryLeadingIcon,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    type: CustomButtonType.primaryTrailingIcon,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    type: CustomButtonType.primaryIcon,
                                  )
                                ],
                              ),
                              const Text(
                                "Primary , Enabled , large",
                                style: TextStyle(color: Colors.blue),
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
                                    type: CustomButtonType.primaryLabel,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.primaryLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.primaryLeadingIcon,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.primaryTrailingIcon,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.primaryIcon,
                                  )
                                ],
                              ),
                              const Text(
                                "Primary , Disabled , large",
                                style: TextStyle(color: Colors.blue),
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
                                    type: CustomButtonType.primaryLabel,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.primaryLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.primaryLeadingIcon,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.primaryTrailingIcon,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.primaryIcon,
                                  )
                                ],
                              ),
                              const Divider(),

                              ///Grey Solid
                              const Text(
                                "Grey Solid, Enabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilledLabel,
                                    onPressed: () => print("on pressed"),
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilledLabel,
                                    onPressed: () => print("on pressed"),
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.greyFilledLeadingIcon,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.greyFilledTrailingIcon,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                  ),
                                  CustomButton.iconOnly(
                                    type: CustomButtonType.greyFilledIcon,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Grey Solid , Disabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilledLabel,
                                    onPressed: null,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilledLabel,
                                    onPressed: null,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.greyFilledLeadingIcon,
                                    onPressed: null,
                                    icon: Icons.add,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.greyFilledTrailingIcon,
                                    onPressed: null,
                                    icon: Icons.add,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    type: CustomButtonType.greyFilledIcon,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Grey Solid , Enabled , large",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilledLabel,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilledLabel,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.greyFilledLeadingIcon,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.greyFilledTrailingIcon,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilledIcon,
                                    size: CustomButtonSize.large,
                                  )
                                ],
                              ),
                              const Text(
                                "Grey Solid , Disabled , large",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilledLabel,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    type: CustomButtonType.greyFilledLabel,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.greyFilledLeadingIcon,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.greyFilledTrailingIcon,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    type: CustomButtonType.greyFilledIcon,
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
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.destructiveFilledLabel,
                                    onPressed: () => print("on pressed"),
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.destructiveFilledLabel,
                                    onPressed: () => print("on pressed"),
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType
                                        .destructiveFilledLeadingIcon,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType
                                        .destructiveFilledTrailingIcon,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                  ),
                                  CustomButton.iconOnly(
                                    type:
                                        CustomButtonType.destructiveFilledIcon,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Destructive Solid , Disabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.destructiveFilledLabel,
                                    onPressed: null,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.destructiveFilledLabel,
                                    onPressed: null,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType
                                        .destructiveFilledLeadingIcon,
                                    onPressed: null,
                                    icon: Icons.add,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType
                                        .destructiveFilledTrailingIcon,
                                    onPressed: null,
                                    icon: Icons.add,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    type:
                                        CustomButtonType.destructiveFilledIcon,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Destructive Solid , Enabled , large",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.destructiveFilledLabel,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.destructiveFilledLabel,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType
                                        .destructiveFilledLeadingIcon,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType
                                        .destructiveFilledTrailingIcon,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.destructiveFilledIcon,
                                    size: CustomButtonSize.large,
                                  )
                                ],
                              ),
                              const Text(
                                "Destructive Solid , Disabled , large",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.destructiveFilledLabel,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    type:
                                        CustomButtonType.destructiveFilledLabel,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType
                                        .destructiveFilledLeadingIcon,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    type: CustomButtonType
                                        .destructiveFilledTrailingIcon,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    type: CustomButtonType.greyFilledIcon,
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
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.secondaryLabel,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.secondaryLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.secondaryLeadingIcon,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type:
                                        CustomButtonType.secondaryTrailingIcon,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.secondaryIcon,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Secondary , Disabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    type: CustomButtonType.secondaryLabel,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: null,
                                    type: CustomButtonType.secondaryLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    type: CustomButtonType.secondaryLeadingIcon,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    type:
                                        CustomButtonType.secondaryTrailingIcon,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    type: CustomButtonType.secondaryIcon,
                                  )
                                ],
                              ),
                              const Text(
                                "Secondary , Enabled , large",
                                style: TextStyle(color: Colors.blue),
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
                                    type: CustomButtonType.secondaryLabel,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.secondaryLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.secondaryLeadingIcon,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type:
                                        CustomButtonType.secondaryTrailingIcon,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.secondaryIcon,
                                  )
                                ],
                              ),
                              const Text(
                                "Secondary , Disabled , large",
                                style: TextStyle(color: Colors.blue),
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
                                    type: CustomButtonType.secondaryLabel,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.secondaryLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.secondaryLeadingIcon,
                                  ),
                                  CustomButton.trailingIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: null,
                                    icon: Icons.add,
                                    size: CustomButtonSize.large,
                                    type:
                                        CustomButtonType.secondaryTrailingIcon,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: null,
                                    icon: Icons.add,
                                    tooltip: tooltip,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.secondaryIcon,
                                  )
                                ],
                              ),
                              const Divider(),

                              ///Grey Outlined
                              const Text(
                                "Grey Outlined , Enabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.greyOutlinedLabel,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.greyOutlinedLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .greyOutlinedLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .greyOutlinedTrailingIcon),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.greyOutlinedIcon,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Grey Outlined , Disabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      type: CustomButtonType.greyOutlinedLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: null,
                                    type: CustomButtonType.greyOutlinedLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .greyOutlinedLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .greyOutlinedTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      type: CustomButtonType.greyOutlinedIcon)
                                ],
                              ),
                              const Text(
                                "Grey Outlined , Enabled , large",
                                style: TextStyle(color: Colors.blue),
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
                                      type: CustomButtonType.greyOutlinedLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.greyOutlinedLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .greyOutlinedLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .greyOutlinedTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.greyOutlinedIcon)
                                ],
                              ),
                              const Text(
                                "Grey Outlined , Disabled , large",
                                style: TextStyle(color: Colors.blue),
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
                                      type: CustomButtonType.greyOutlinedLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.greyOutlinedLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .greyOutlinedLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .greyOutlinedTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.greyOutlinedIcon)
                                ],
                              ),
                              const Divider(),

                              ///Destructive Outlined
                              const Text(
                                "Destructive Outlined , Enabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType
                                        .destructiveOutlinedLabel,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType
                                        .destructiveOutlinedLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .destructiveOutlinedLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .destructiveOutlinedTrailingIcon),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType
                                        .destructiveOutlinedIcon,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Destructive Outlined , Disabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      type: CustomButtonType
                                          .destructiveOutlinedLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: null,
                                    type: CustomButtonType
                                        .destructiveOutlinedLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .destructiveOutlinedLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .destructiveOutlinedTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      type: CustomButtonType
                                          .destructiveOutlinedIcon)
                                ],
                              ),
                              const Text(
                                "Destructive Outlined , Enabled , large",
                                style: TextStyle(color: Colors.blue),
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
                                      type: CustomButtonType
                                          .destructiveOutlinedLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType
                                        .destructiveOutlinedLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .destructiveOutlinedLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .destructiveOutlinedTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .destructiveOutlinedIcon)
                                ],
                              ),
                              const Text(
                                "Destructive Outlined , Disabled , large",
                                style: TextStyle(color: Colors.blue),
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
                                      type: CustomButtonType
                                          .destructiveOutlinedLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType
                                        .destructiveOutlinedLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .destructiveOutlinedLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .destructiveOutlinedTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .destructiveOutlinedIcon)
                                ],
                              ),
                              const Divider(),

                              ///Primary Text
                              const Text(
                                "Primary Text , Enabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.primaryTextLabel,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.primaryTextLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .primaryTextLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .primaryTextTrailingIcon),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.primaryTextIcon,
                                    tooltip: tooltip,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type:
                                        CustomButtonType.primaryIconMinPadding,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Primary Text , Disabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      type: CustomButtonType.primaryTextLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: null,
                                    type: CustomButtonType.primaryTextLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .primaryTextLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .primaryTextTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      type: CustomButtonType.primaryTextIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      type: CustomButtonType
                                          .primaryIconMinPadding)
                                ],
                              ),
                              const Text(
                                "Primary Text , Enabled , large",
                                style: TextStyle(color: Colors.blue),
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
                                      type: CustomButtonType.primaryTextLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.primaryTextLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .primaryTextLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .primaryTextTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.primaryTextIcon),
                                  CustomButton.iconOnly(
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .primaryIconMinPadding)
                                ],
                              ),
                              const Text(
                                "Primary Text , Disabled , large",
                                style: TextStyle(color: Colors.blue),
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
                                      type: CustomButtonType.primaryTextLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.primaryTextLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .primaryTextLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .primaryTextTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.primaryTextIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .primaryIconMinPadding)
                                ],
                              ),
                              const Divider(),

                              ///Destructive Text
                              const Text(
                                "Destructive Text , Enabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.destructiveTextLabel,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.destructiveTextLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .destructiveTextLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .destructiveTextTrailingIcon),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.destructiveTextIcon,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Destructive Text , Disabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      type: CustomButtonType
                                          .destructiveTextLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: null,
                                    type: CustomButtonType.destructiveTextLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .destructiveTextLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .destructiveTextTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      type:
                                          CustomButtonType.destructiveTextIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      type: CustomButtonType
                                          .destructiveIconMinPadding)
                                ],
                              ),
                              const Text(
                                "Destructive Text , Enabled , large",
                                style: TextStyle(color: Colors.blue),
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
                                      type: CustomButtonType
                                          .destructiveTextLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.destructiveTextLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .destructiveTextLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .destructiveTextTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type:
                                          CustomButtonType.destructiveTextIcon),
                                  CustomButton.iconOnly(
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .destructiveIconMinPadding)
                                ],
                              ),
                              const Text(
                                "Destructive Text , Disabled , large",
                                style: TextStyle(color: Colors.blue),
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
                                      type: CustomButtonType
                                          .destructiveTextLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.destructiveTextLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .destructiveTextLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .destructiveTextTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type:
                                          CustomButtonType.destructiveTextIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .destructiveIconMinPadding)
                                ],
                              ),
                              const Divider(),

                              ///Grey Text
                              const Text(
                                "Grey Text , Enabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                    label: label,
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.greyTextLabel,
                                  ),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    type: CustomButtonType.greyTextLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      type:
                                          CustomButtonType.greyTextLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .greyTextTrailingIcon),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.greyTextIcon,
                                    tooltip: tooltip,
                                  ),
                                  CustomButton.iconOnly(
                                    onPressed: () => print("on pressed"),
                                    icon: Icons.add,
                                    type: CustomButtonType.greyIconMinPadding,
                                    tooltip: tooltip,
                                  )
                                ],
                              ),
                              const Text(
                                "Grey Text , Disabled , small",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton.noIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      type: CustomButtonType.greyTextLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: null,
                                    type: CustomButtonType.greyTextLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type:
                                          CustomButtonType.greyTextLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      type: CustomButtonType
                                          .greyTextTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      type: CustomButtonType.greyTextIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      type: CustomButtonType.greyIconMinPadding)
                                ],
                              ),
                              const Text(
                                "Grey Text , Enabled , large",
                                style: TextStyle(color: Colors.blue),
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
                                      type: CustomButtonType.greyTextLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: () => print("on pressed"),
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.greyTextLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type:
                                          CustomButtonType.greyTextLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .greyTextTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.greyTextIcon),
                                  CustomButton.iconOnly(
                                      onPressed: () => print("on pressed"),
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.greyIconMinPadding)
                                ],
                              ),
                              const Text(
                                "Grey Text , Disabled , large",
                                style: TextStyle(color: Colors.blue),
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
                                      type: CustomButtonType.greyTextLabel),
                                  CustomButton.custom(
                                    tooltip: tooltip,
                                    onPressed: null,
                                    size: CustomButtonSize.large,
                                    type: CustomButtonType.greyTextLabel,
                                    child: customChild,
                                  ),
                                  CustomButton.leadingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type:
                                          CustomButtonType.greyTextLeadingIcon),
                                  CustomButton.trailingIcon(
                                      label: label,
                                      tooltip: tooltip,
                                      onPressed: null,
                                      icon: Icons.add,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType
                                          .greyTextTrailingIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.greyTextIcon),
                                  CustomButton.iconOnly(
                                      onPressed: null,
                                      icon: Icons.add,
                                      tooltip: tooltip,
                                      size: CustomButtonSize.large,
                                      type: CustomButtonType.greyIconMinPadding)
                                ],
                              ),
                              const Divider(),
                            ]));
                  }),
            ],
          ),
          WidgetbookComponent(name: 'Input Text field', useCases: [
            WidgetbookUseCase(
                name: 'Input Text field',
                builder: (context) {
                  final hintText = context.knobs.string(
                    label: 'Hint text',
                    initialValue: 'Placeholder',
                  );
                  final helperText = context.knobs.string(
                    label: 'Helper text',
                    initialValue: 'Helper text',
                  );
                  final errorText = context.knobs.stringOrNull(
                    label: 'Error text',
                    initialValue: null,
                  );
                  return Container(
                    color: Colors.white,
                    height: double.infinity,
                    padding: EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text("Box small"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextInputField.box(
                                    size: CustomTextInputFieldSize.small,
                                    hintText: hintText,
                                    helperText: helperText,
                                    errorText:errorText
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text("Box large"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextInputField.box(
                                    size: CustomTextInputFieldSize.large,
                                    hintText: hintText,
                                    helperText: helperText,
                                    errorText:errorText
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text("Line small"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextInputField(),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text("Line large"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextInputField(),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                })
          ])
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
