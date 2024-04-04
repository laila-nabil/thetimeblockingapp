import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_drop_down.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive_scaffold.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/router.dart';
import 'package:thetimeblockingapp/features/auth/presentation/pages/auth_page.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/change_language_use_case.dart';

import '../../../../core/globals.dart';
import '../../../../core/launch_url.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_design.dart';
import '../../../../core/resources/text_styles.dart';
import '../bloc/settings_bloc.dart';

///TODO create task from siri shortcuts functionality
///TODO create task from email
///TODO about me page with github and twitter links and why app created
///TODO changing workspace and space in settings page
///TODO create a new Workspace/Space in settings page

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const routeName = "/Settings";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state.signOutSuccess) {
          router.go(AuthPage.routeName);
        }
      },
      builder: (context, state) {
        final bloc = BlocProvider.of<SettingsBloc>(context);
        return ResponsiveScaffold(
            responsiveBody: ResponsiveTParams(
                small: Padding(
              padding: EdgeInsets.all(AppSpacing.medium16.value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppSpacing.medium16.value),
                        margin:
                            EdgeInsets.only(bottom: AppSpacing.medium16.value),
                        child: Text(
                          appLocalization.translate("Settings"),
                          style: AppTextStyle.getTextStyle(AppTextStyleParams(
                              color:
                                  AppColors.grey(context.isDarkMode).shade900,
                              appFontWeight: AppFontWeight.medium,
                              appFontSize: AppFontSize.heading4)),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalization.translate("language"),
                        style: AppTextStyle.getTextStyle(AppTextStyleParams(
                            appFontSize: AppFontSize.paragraphSmall,
                            color: AppColors.grey(context.isDarkMode).shade900,
                            appFontWeight: AppFontWeight.medium)),
                      ),
                      SizedBox(
                        height: AppSpacing.x2Small4.value,
                      ),
                      CustomDropDownMenu(
                        initialSelection: appLocalization.languagesEnumToLocale(
                            appLocalization.getCurrentLanguagesEnum(context)!),
                        dropdownMenuEntries: context.supportedLocales
                            .map<DropdownMenuEntry>((e) => DropdownMenuEntry(
                                value: e,
                                label:
                                    appLocalization.translate(e.languageCode)))
                            .toList(),
                        onSelected: (selected) {
                          bloc.add(ChangeLanguageEvent(ChangeLanguageParams(
                              locale: selected, context: context)));
                        },
                        isDarkMode: (context.isDarkMode),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppSpacing.xSmall8.value,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocalization.translate("theme"),
                          style: AppTextStyle.getTextStyle(AppTextStyleParams(
                              appFontSize: AppFontSize.paragraphSmall,
                              color: AppColors.grey(context.isDarkMode).shade900,
                              appFontWeight: AppFontWeight.medium)),
                        ),
                        SizedBox(
                          height: AppSpacing.x2Small4.value,
                        ),
                        CustomDropDownMenu(
                          initialSelection: state.themeMode,
                          dropdownMenuEntries: ThemeMode.values
                              .map<DropdownMenuEntry>((e) => DropdownMenuEntry(
                                  value: e,
                                  label: appLocalization.translate(e.name)))
                              .toList(),
                          onSelected: (selected) {
                            bloc.add(ChangeThemeEvent(selected));
                          },
                          isDarkMode: (context.isDarkMode),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppSpacing.xSmall8.value,
                    ),
                    child: CustomButton.noIcon(
                      label: appLocalization.translate("termsOfUse"),
                      onPressed: () {
                        launchWithURL(url: Globals.clickupTerms);
                      },
                      type: CustomButtonType.greyTextLabel,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppSpacing.xSmall8.value,
                    ),
                    child: CustomButton.noIcon(
                      label: appLocalization.translate("privacyPolicy"),
                      onPressed: () {
                        launchWithURL(url: Globals.clickupPrivacy);
                      },
                      type: CustomButtonType.greyTextLabel,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppSpacing.xSmall8.value,
                    ),
                    child: CustomButton.noIcon(
                      label: appLocalization.translate("signOut"),
                      onPressed: () {
                        bloc.add(SignOutEvent());
                      },
                      type: CustomButtonType.destructiveFilledLabel,
                    ),
                  )
                ],
              ),
            )),
            context: context,
            onRefresh: () async {});
      },
    );
  }
}
