import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/widgets/custom_drop_down.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive_scaffold.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/change_language_use_case.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_design.dart';
import '../../../../core/resources/text_styles.dart';
import '../bloc/settings_bloc.dart';

///TODO V3 add task from siri shortcuts functionality
///TODO V3 add task from email
///TODO V2 change language (arabic, german)
///TODO V2 navigate to about me page with github and twitter links and why app created
///TODO V1 changing workspace and space here and remove from drawer
///TODO V1 sign out

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const routeName = "/Settings";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {      },
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
                              color: AppColors.grey(context.isDarkMode).shade900,
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
                      SizedBox(height: AppSpacing.x2Small4.value,),
                      CustomDropDownMenu(
                          initialSelection: appLocalization
                              .languagesEnumToLocale(appLocalization
                                  .getCurrentLanguagesEnum(context)!),
                          dropdownMenuEntries: context.supportedLocales
                              .map<DropdownMenuEntry>((e) => DropdownMenuEntry(
                                  value: e,
                                  label: appLocalization
                                      .translate(e.languageCode)))
                              .toList(),
                          onSelected: (selected) {
                            bloc.add(ChangeLanguageEvent(ChangeLanguageParams(
                                locale: selected, context: context)));
                          }, isDarkMode: (context.isDarkMode),),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalization.translate("theme"),
                        style: AppTextStyle.getTextStyle(AppTextStyleParams(
                            appFontSize: AppFontSize.paragraphSmall,
                            color: AppColors.grey(context.isDarkMode).shade900,
                            appFontWeight: AppFontWeight.medium)),
                      ),
                      SizedBox(height: AppSpacing.x2Small4.value,),
                      CustomDropDownMenu(
                          initialSelection: state.themeMode,
                          dropdownMenuEntries: ThemeMode.values
                              .map<DropdownMenuEntry>((e) =>
                                  DropdownMenuEntry(
                                      value: e,
                                      label: appLocalization.translate(e.name)))
                              .toList(),
                          onSelected: (selected) {
                            bloc.add(ChangeThemeEvent(selected));
                          }, isDarkMode: (context.isDarkMode),),
                    ],
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
