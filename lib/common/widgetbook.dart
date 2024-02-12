// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_pop_up_menu.dart';
import 'package:thetimeblockingapp/common/widgets/custom_text_input_field.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_folder.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/tag_component.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/task_component.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/toggleable_section.dart';
import 'package:widgetbook/widgetbook.dart';
import '../core/localization/localization.dart';
import '../core/resources/app_icons.dart';
import '../features/tasks/presentation/widgets/list_component.dart';
import '../features/tasks/presentation/widgets/tag_chip.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_drawer.dart';

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
          WidgetbookComponent(
            name: 'App icons',
            useCases: [
              WidgetbookUseCase(
                  name: 'App icons',
                  builder: (context) {
                    final iconSize = context.knobs.double.input(
                      label: 'iconSize',
                      initialValue: 30,
                    );
                    final iconColor = context.knobs.color(
                      label: "Color",
                      initialValue: Colors.black
                    );
                    return Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Wrap(
                          children:[
                            Icon(
                              AppIcons.bin,
                              size: iconSize,
                              color: iconColor,
                            ),
                            Icon(AppIcons.bin_bold,
                              size: iconSize,
                              color: iconColor,),
                            Icon(AppIcons.hashtag,
                              size: iconSize,
                              color: iconColor,),
                            Icon(AppIcons.list,
                              size: iconSize,
                              color: iconColor,),
                            Icon(AppIcons.hashtag,
                              size: iconSize,
                              color: iconColor,),
                            Icon(AppIcons.listbold,
                              size: iconSize,
                              color: iconColor,),

                          ],
                        ),
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
                  final labelText = context.knobs.string(
                    label: 'Label text',
                    initialValue: 'Label',
                  );
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
                  final successText = context.knobs.stringOrNull(
                    label: 'Success text',
                    initialValue: null,
                  );
                  final enabled = context.knobs.booleanOrNull(
                    label: 'Is enabled',
                    initialValue: true,
                  );
                  final prefixIconEnabled = context.knobs.booleanOrNull(
                    label: 'prefixIcon enabled',
                    initialValue: true,
                  );
                  return Container(
                    color: Colors.white,
                    height: double.infinity,
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("Box small"),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextInputField(
                                      prefixIcon: prefixIconEnabled == true
                                          ? Icons.search
                                          : null,
                                      buttonStyle:
                                          CustomTextInputFieldStyle.box,
                                      size: CustomTextInputFieldSize.small,
                                      focusNode: FocusNode(debugLabel: "b s"),
                                      controller: TextEditingController(),
                                      hintText: hintText,
                                      helperText: helperText,
                                      errorText: errorText,
                                      successText: successText,
                                      enabled: enabled,
                                      labelText: labelText),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("Box large"),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextInputField(
                                      prefixIcon: prefixIconEnabled == true
                                          ? Icons.search
                                          : null,
                                      buttonStyle:
                                          CustomTextInputFieldStyle.box,
                                      size: CustomTextInputFieldSize.large,
                                      focusNode: FocusNode(debugLabel: "b l"),
                                      hintText: hintText,
                                      helperText: helperText,
                                      errorText: errorText,
                                      successText: successText,
                                      enabled: enabled,
                                      labelText: labelText),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("Line small"),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextInputField(
                                      prefixIcon: prefixIconEnabled == true
                                          ? Icons.search
                                          : null,
                                      buttonStyle:
                                          CustomTextInputFieldStyle.line,
                                      size: CustomTextInputFieldSize.small,
                                      focusNode: FocusNode(debugLabel: "l s"),
                                      hintText: hintText,
                                      helperText: helperText,
                                      errorText: errorText,
                                      successText: successText,
                                      enabled: enabled,
                                      labelText: labelText),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("Line large"),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextInputField(
                                      prefixIcon: prefixIconEnabled == true
                                          ? Icons.search
                                          : null,
                                      buttonStyle:
                                          CustomTextInputFieldStyle.line,
                                      size: CustomTextInputFieldSize.large,
                                      focusNode: FocusNode(debugLabel: "l l"),
                                      hintText: hintText,
                                      helperText: helperText,
                                      errorText: errorText,
                                      successText: successText,
                                      enabled: enabled,
                                      labelText: labelText),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                })
          ]),
          WidgetbookComponent(name: 'App bar', useCases: [
            WidgetbookUseCase(
                name: 'App bar',
                builder: (context) {
                  final showSmallDesign = context.showSmallDesign;

                  return Theme(
                    data: appTheme,
                    child: Scaffold(
                      appBar: _CustomAppBar(
                        showSmallDesign: showSmallDesign,
                        pageActions: [
                          // CustomDropDownItem.text(
                          //     value: ,
                          //     title: "Filter by list", onTap: () {}),
                          // CustomDropDownItem.text(
                          //     title: "Filter by tag", onTap: () {})
                        ],
                      ),
                      drawer: Container(),
                      backgroundColor: Colors.black,
                    ),
                  );
                })
          ]),
          WidgetbookComponent(name: 'Drawer', useCases: [
            WidgetbookUseCase(
                name: 'Drawer',
                builder: (context) {
                  final showSmallDesign = context.showSmallDesign;

                  return Theme(
                    data: appTheme,
                    child: Scaffold(
                      appBar: _CustomAppBar(
                        showSmallDesign: showSmallDesign,
                        pageActions: [
                          // CustomDropDownItem.text(
                          //     title: "Filter by list", onTap: () {}),
                          // CustomDropDownItem.text(
                          //     title: "Filter by tag", onTap: () {})
                        ],
                      ),
                      drawer: CustomDrawerWidget(
                        showSmallDesign: context.showSmallDesign,
                        router: GoRouter.maybeOf(context),
                        appLocalization: appLocalization,
                        selectWorkspace: (s) => print("selectWorkspace $s"),
                        selectSpace: (s) => print("selectSpace $s"),
                      ),
                      backgroundColor: Colors.black,
                    ),
                  );
                })
          ]),
        ]),
        WidgetbookFolder(name: "Other widgets", children: [
          WidgetbookComponent(
            name: 'Task widget',
            useCases: [
              WidgetbookUseCase(
                  name: 'Task widget',
                  builder: (context) {
                    final taskName = context.knobs.string(
                      label: 'Task name',
                      initialValue: 'Create UI components for the app',
                    );
                    final listName = context.knobs.string(
                      label: 'List name',
                      initialValue: 'Development',
                    );
                    final folderName = context.knobs.stringOrNull(
                      label: 'Folder name',
                      initialValue: 'Time blocking app project',
                    );
                    final showList = context.knobs.boolean(
                      label: 'showList1',
                      initialValue: true,
                    );
                    final includeTag1 = context.knobs.boolean(
                      label: 'include Tag 1',
                      initialValue: true,
                    );
                    final includeTag2 = context.knobs.boolean(
                      label: 'include Tag 2',
                      initialValue: true,
                    );
                    List<ClickupTag> tags = [
                      const ClickupTag(name: "Milestone 1"),
                      const ClickupTag(name: "Personal projects"),
                    ];
                    if (includeTag1) {
                      tags.add(const ClickupTag(name: "UI dev"));
                    }
                    if (includeTag2) {
                      tags.add(const ClickupTag(
                          name: "Setup project", tagFg: "0xffe3effc"));
                    }
                    final task = ClickupTask(
                        name: taskName,
                        startDateUtcTimestamp: DateTime.now()
                            .subtract(const Duration(hours: 1))
                            .millisecondsSinceEpoch
                            .toString(),
                        dueDateUtcTimestamp:
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        list: ClickupList(name: listName),
                        folder: ClickupFolder(name: folderName),
                        tags: tags);
                    return ListView(
                      children: [
                        TaskWidget(
                          showList: showList,
                          clickupTask: task,
                          onTap: () {},
                        )
                      ],
                    );
                  }),
            ],
          ),
          WidgetbookComponent(
            name: 'Toggleable section',
            useCases: [
              WidgetbookUseCase(
                  name: 'Tasks section',
                  builder: (context) {
                    final taskName1 = context.knobs.string(
                      label: 'Task name',
                      initialValue: 'Create UI components for the app',
                    );
                    final listName1 = context.knobs.string(
                      label: 'List name',
                      initialValue: 'Development',
                    );
                    final folderName1 = context.knobs.stringOrNull(
                      label: 'Folder name',
                      initialValue: 'Time blocking app project',
                    );
                    final showList1 = context.knobs.boolean(
                      label: 'showList1',
                      initialValue: true,
                    );
                    final includeTag1_1 = context.knobs.boolean(
                      label: 'include Tag 1 for task 1',
                      initialValue: true,
                    );
                    final includeTag1_2 = context.knobs.boolean(
                      label: 'include Tag 2 for task 1',
                      initialValue: true,
                    );
                    List<ClickupTag> tags = [
                      const ClickupTag(name: "Milestone 1"),
                      const ClickupTag(name: "Personal projects"),
                    ];
                    if (includeTag1_1) {
                      tags.add(const ClickupTag(name: "UI dev"));
                    }
                    if (includeTag1_2) {
                      tags.add(const ClickupTag(
                          name: "Setup project", tagFg: "0xffe3effc"));
                    }
                    final task1 = ClickupTask(
                        name: taskName1,
                        startDateUtcTimestamp: DateTime.now()
                            .subtract(const Duration(hours: 1))
                            .millisecondsSinceEpoch
                            .toString(),
                        dueDateUtcTimestamp:
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        list: ClickupList(name: listName1),
                        folder: ClickupFolder(name: folderName1),
                        tags: tags);

                    final taskName2 = context.knobs.string(
                      label: 'Task name',
                      initialValue: 'Create Other UI components for the app',
                    );
                    final listName2 = context.knobs.string(
                      label: 'List name',
                      initialValue: 'Development',
                    );
                    final folderName2 = context.knobs.stringOrNull(
                      label: 'Folder name2',
                      initialValue: 'Time blocking app project',
                    );
                    final showList2 = context.knobs.boolean(
                      label: 'showList2',
                      initialValue: true,
                    );
                    final includeTag2_1 = context.knobs.boolean(
                      label: 'include Tag 1 for task 2',
                      initialValue: true,
                    );
                    final includeTag2_2 = context.knobs.boolean(
                      label: 'include Tag 2 for task 2',
                      initialValue: true,
                    );
                    List<ClickupTag> tags2 = [
                      const ClickupTag(name: "Milestone 1"),
                      const ClickupTag(name: "Personal projects"),
                    ];
                    if (includeTag2_1) {
                      tags2.add(const ClickupTag(name: "UI dev"));
                    }
                    if (includeTag2_2) {
                      tags2.add(const ClickupTag(
                          name: "Setup project", tagFg: "0xffe3effc"));
                    }
                    final task2 = ClickupTask(
                        name: taskName2,
                        startDateUtcTimestamp: DateTime.now()
                            .subtract(const Duration(hours: 1))
                            .millisecondsSinceEpoch
                            .toString(),
                        dueDateUtcTimestamp:
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        list: ClickupList(name: listName2),
                        folder: ClickupFolder(name: folderName2),
                        tags: tags2);
                    return ToggleableSection(
                      title: 'Overdue',
                      children: [
                        TaskWidget(
                          showList: showList1,
                          clickupTask: task1,
                          onTap: () {},
                        ),
                        TaskWidget(
                          showList: showList2,
                          clickupTask: task2,
                          onTap: () {},
                        )
                      ],
                    );
                  }),
              WidgetbookUseCase(
                  name: 'Lists section',
                  builder: (context) {
                    final folderName = context.knobs.string(
                        label: "Folder name",
                        initialValue: "Time blocking app folder");
                    final list1Name = context.knobs.string(
                        label: "List 1 name", initialValue: "Development");
                    final list2Name = context.knobs
                        .string(label: "List 1 name", initialValue: "UI/UX");
                    final list1 = ClickupList(name: list1Name);
                    final list2 = ClickupList(name: list2Name);
                    return ToggleableSection(
                      title: folderName,
                      buttons: [
                        ToggleableSectionButtonParams(
                            title: " + Create new folder", onTap: () {}),
                        ToggleableSectionButtonParams(
                            title: " + Create new list", onTap: () {})
                      ],
                      children: [
                        ListComponent(list: list1),
                        ListComponent(list: list2)
                      ],
                    );
                  }),
            ],
          ),
          WidgetbookComponent(
            name: 'Tag chip',
            useCases: [
              WidgetbookUseCase(
                  name: 'Tag chip',
                  builder: (context) {
                    final name = context.knobs.string(
                      label: 'Tag name',
                      initialValue: 'tag',
                    );

                    ClickupTag tag = ClickupTag(name: name,tagFg: "");

                    return TagChip(tagName: tag.name??"",color: Colors.red,);
                  }),
            ],
          ),
          WidgetbookComponent(
            name: 'TagComponent',
            useCases: [
              WidgetbookUseCase(
                  name: 'TagComponent',
                  builder: (context) {
                    final name = context.knobs.string(
                      label: 'Tag name',
                      initialValue: 'tag',
                    );

                    ClickupTag tag = ClickupTag(name: name,tagFg: "");

                    return TagComponent(tag: tag);
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

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar(
      {super.key, required this.showSmallDesign, this.pageActions});

  final bool showSmallDesign;
  final List<CustomPopupItem>? pageActions;

  @override
  Widget build(BuildContext context) {
    return CustomAppBarWidget(
      showSmallDesign: showSmallDesign,
      openDrawer: () => print("open drawer"),
      selectClickupSpace: (s) => print("select s"),
      selectClickupWorkspace: (s) => print("select s"),
      pageActions: pageActions,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(CustomAppBarWidget.height(showSmallDesign));
}
