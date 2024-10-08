import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/widgets/custom_alert_dialog.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_drop_down.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive_scaffold.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/assets_paths.dart';
import 'package:thetimeblockingapp/core/router.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thetimeblockingapp/features/auth/presentation/pages/supabase_onboarding_auth_page.dart';
import 'package:thetimeblockingapp/features/global/presentation/bloc/global_bloc.dart';
import 'package:thetimeblockingapp/features/privacy_policy/privacy_policy_page.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/change_language_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/delete_account_use_case.dart';


import '../../../../core/launch_url.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_design.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../terms_conditions/terms_conditions_page.dart';
import '../bloc/settings_bloc.dart';

///TODO Z create task from siri shortcuts functionality
///TODO Z create task from email
///TODO about me page with github and twitter links and why app created
///TODO Changing workspace in settings page
///TODO Create a new Workspace in settings page

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const routeName = "/Settings";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        final globalBloc = BlocProvider.of<GlobalBloc>(context);
        if (state.authState == AuthStateEnum.signOutSuccess ||
            state.authState == AuthStateEnum.deleteAccountSuccess) {
          globalBloc.add(const ControlDrawerLargerScreen(false));
          router.go(SupabaseOnBoardingAndAuthPage.routeName);
        }
      },
      builder: (context, state) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
        final bloc = BlocProvider.of<SettingsBloc>(context);
        final authBloc = BlocProvider.of<AuthBloc>(context);
        return ResponsiveScaffold(
            responsiveBody: ResponsiveTParams(
                small: Padding(
              padding: EdgeInsets.all(AppSpacing.x3Big32.value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
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
                        appLocalization.translate("email"),
                        style: AppTextStyle.getTextStyle(AppTextStyleParams(
                            appFontSize: AppFontSize.paragraphSmall,
                            color: AppColors.grey(context.isDarkMode).shade900,
                            appFontWeight: AppFontWeight.medium)),
                      ),
                      SizedBox(
                        height: AppSpacing.x2Small4.value,
                      ),
                      Text(
                        BlocProvider.of<AuthBloc>(context).state.user?.email??"",
                        style: AppTextStyle.getTextStyle(AppTextStyleParams(
                            appFontSize: AppFontSize.paragraphSmall,
                            color: AppColors.grey(context.isDarkMode).shade700,
                            appFontWeight: AppFontWeight.regular)),
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
                          inputDecorationTheme: InputDecorationTheme(
                            labelStyle: AppTextStyle.getTextStyle(AppTextStyleParams(
                                appFontSize: AppFontSize.paragraphSmall,
                                color: AppColors.grey(context.isDarkMode).shade900,
                                appFontWeight: AppFontWeight.regular)),
                            hintStyle: AppTextStyle.getTextStyle(AppTextStyleParams(
                                appFontSize: AppFontSize.paragraphSmall,
                                color: AppColors.error(context.isDarkMode).shade900,
                                appFontWeight: AppFontWeight.regular)),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            constraints: BoxConstraints.tight(const
                            Size.fromHeight(40)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: AppColors.grey(context.isDarkMode).shade300)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(false)Padding(
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
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppSpacing.medium16.value,
                    ),
                    child: CustomButton.noIcon(
                      label: appLocalization.translate("signOut"),
                      onPressed: () {
                        authBloc.add(SignOutEvent(BlocProvider.of<AuthBloc>(context)
                            .state
                            .accessToken));
                      },
                      type: CustomButtonType.destructiveFilledLabel,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppSpacing.xSmall8.value,
                    ),
                    child: CustomButton.noIcon(
                      label: appLocalization.translate("deleteAccount"),
                      onPressed: () {
                        showDialog<bool>(context: context, builder: (context){
                          return CustomAlertDialog(
                            loading: false,
                            actions: [
                              CustomButton.noIcon(
                                  label: appLocalization.translate("deleteAccount"),
                                  onPressed: () {
                                    authBloc.add(DeleteAccount(DeleteAccountParams(authBloc.state.user!)));
                                    Navigator.pop(context);
                                  },type: CustomButtonType.destructiveFilledLabel),
                              CustomButton.noIcon(
                                  label: appLocalization.translate("cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ],
                            content: Text(
                                appLocalization.translate("areYouSureDeleteYourAccount")),
                          );
                        });
                      },
                      type: CustomButtonType.destructiveTextLabel,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 22, right: 24, left: 24, bottom: 10),
                    child: Row(
                      children: [
                        InkWell(
                          child: Image.asset(
                            AppAssets.github,
                            width: 24,
                            height: 24,
                          ),
                          onTap: () =>
                              launchWithURL(url: "https://github.com/laila-nabil/"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          child: Image.asset(
                            AppAssets.twitter,
                            width: 24,
                            height: 24,
                          ),
                          onTap: () =>
                              launchWithURL(url: "https://twitter.com/laila_nabil_"),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      CustomButton.noIcon(
                        label: appLocalization.translate("termsOfUse"),
                        onPressed: () {
                          launchWithURL(
                              url:
                              "https://timeblocking.web.app/${TermsConditionsPage
                                  .routeName}");
                        },
                        type: CustomButtonType.greyTextLabel,
                      ),
                      CustomButton.noIcon(
                        label: appLocalization.translate("privacyPolicy"),
                        onPressed: () {
                          launchWithURL(
                              url:
                              "https://timeblocking.web.app/${PrivacyPolicyPage
                                  .routeName}");
                        },
                        type: CustomButtonType.greyTextLabel,
                      ),
                    ],
                  ),

                ],
              ),
            )),
            context: context,
                responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                    responsiveScaffoldLoadingEnum:
                        ResponsiveScaffoldLoadingEnum.overlayLoading,
                    isLoading: state.isLoading),
                onRefresh: () async {});
      },
    );
  },
);
  }
}
