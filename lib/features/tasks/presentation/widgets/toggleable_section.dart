import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_icons.dart';
import 'package:thetimeblockingapp/core/resources/assets_paths.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/task_component.dart';

import '../../../../common/widgets/custom_drop_down.dart';
import '../../../../core/resources/text_styles.dart';

class ToggleableSectionButtonParams {
  final String title;
  final void Function() onTap;

  ToggleableSectionButtonParams({required this.title, required this.onTap});
}

class ToggleableSection extends StatefulWidget {
  const ToggleableSection(
      {super.key,
      required this.children,
      required this.title,
      this.buttons,
      this.actions});

  final List<Widget> children;
  final List<ToggleableSectionButtonParams>? buttons;
  final String title;
  final List<CustomDropDownItem>? actions;

  @override
  State<ToggleableSection> createState() => _ToggleableSectionState();
}

class _ToggleableSectionState extends State<ToggleableSection> {
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.grey.shade100, width: 1),
          borderRadius: BorderRadius.circular(AppBorderRadius.large.value),
          boxShadow: AppShadow.xSmall.shadows),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            child: Container(
              margin: isOpen
                  ? EdgeInsets.only(bottom: AppSpacing.medium16.value)
                  : EdgeInsets.zero,
              padding: widget.actions?.isNotEmpty == true
                  ? EdgeInsetsDirectional.only(
                      top: AppSpacing.medium16.value,
                      bottom: AppSpacing.medium16.value,
                      start: AppSpacing.medium16.value,
                      end: AppSpacing.xSmall8.value)
                  : EdgeInsets.all(AppSpacing.medium16.value),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: isOpen
                          ? BorderSide(color: AppColors.grey.shade200, width: 1)
                          : BorderSide.none)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          isOpen
                              ? AppIcons.chevrondown
                              : AppIcons.chevronright,
                          color: AppColors.grey.shade500,
                          size: 20,
                        ),
                      ),
                      Text(
                        widget.title,
                        style: AppTextStyle.getTextStyle(AppTextStyleParams(
                            appFontSize: AppFontSize.paragraphMedium,
                            color: AppColors.grey.shade900,
                            appFontWeight: AppFontWeight.semiBold)),
                      )
                    ],
                  ),
                  if (widget.actions?.isNotEmpty == true)
                    CustomDropDownMenu(
                        items: widget.actions ?? [],
                        listButton: Icon(
                          AppIcons.dotsv,
                          size: 16,
                          color: AppColors.grey.shade500,
                        ))
                ],
              ),
            ),
          ),
          if (isOpen)
            ...(widget.children +
                    (widget.buttons
                            ?.map((button) => CustomButton.noIcon(
                                  label: button.title,
                                  onPressed: button.onTap,
                                  type: CustomButtonType.greyTextLabel,
                                ))
                            .toList() ??
                        []))
                .map((e) => Padding(
                      padding:
                          EdgeInsets.only(bottom: AppSpacing.medium16.value),
                      child: e,
                    ))
        ],
      ),
    );
  }
}
