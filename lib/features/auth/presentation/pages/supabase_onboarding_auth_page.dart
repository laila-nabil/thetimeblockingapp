
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/widgets/custom_text_input_field.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/assets_paths.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:thetimeblockingapp/features/privacy_policy/privacy_policy_page.dart';
import 'package:thetimeblockingapp/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:thetimeblockingapp/features/terms_conditions/terms_conditions_page.dart';

import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_drop_down.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';

import '../../../../core/launch_url.dart';
import '../../../../core/localization/localization.dart';
import '../../../settings/domain/use_cases/change_language_use_case.dart';
import '../bloc/auth_bloc.dart';

enum OnBoardingAndAuthStep {
  first(1),
  second(2),
  third(3);

  static OnBoardingAndAuthStep get auth => third;

  const OnBoardingAndAuthStep(this.number);

  final int number;
}

String _demoUrl =
    "https://demoo-timeblocking.web.app";

class SupabaseOnBoardingAndAuthPage extends StatefulWidget {
  const SupabaseOnBoardingAndAuthPage(
      {super.key, required this.authBloc, required this.settingsBloc});

  final AuthBloc authBloc;
  final SettingsBloc settingsBloc;

  @override
  State<SupabaseOnBoardingAndAuthPage> createState() =>
      _SupabaseOnBoardingAndAuthPageState();
}

class _SupabaseOnBoardingAndAuthPageState
    extends State<SupabaseOnBoardingAndAuthPage> {
  OnBoardingAndAuthStep step = OnBoardingAndAuthStep.first;

  @override
  Widget build(BuildContext context) {
    final titleStyleMobile = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.heading6,
        color: AppColors.text(context.isDarkMode),
        appFontWeight: AppFontWeight.medium));
    final contentStyleMobile = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.paragraphLarge,
        color: AppColors.text(context.isDarkMode),
        appFontWeight: AppFontWeight.medium));
    final titleStyleDesktop = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.heading3,
        color: AppColors.text(context.isDarkMode),
        appFontWeight: AppFontWeight.medium));
    final contentStyleDesktop = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.heading6,
        color: AppColors.text(context.isDarkMode),
        appFontWeight: AppFontWeight.medium));
    const boxConstraints = BoxConstraints(maxWidth: 510);
    return ResponsiveScaffold(
      hideAppBarDrawer: true,
      responsiveScaffoldLoading: ResponsiveScaffoldLoading(
          responsiveScaffoldLoadingEnum:
          ResponsiveScaffoldLoadingEnum.contentLoading,
          isLoading: widget.authBloc.state.isLoading),
      responsiveBody: switch (step) {
        OnBoardingAndAuthStep.first =>
            ResponsiveTParams(
                small: changeLanguageWrapper(
                    child: Center(
                      child: Container(
                        constraints: boxConstraints,
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.x2Big28.value),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(
                              flex: 86,
                            ),
                            Image.asset(
                              AppAssets.logo(context.isDarkMode),
                              width: 258,
                              height: 39,
                              fit: BoxFit.contain,
                            ),
                            const Spacer(
                              flex: 34,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  AppBorderRadius.x3Large.value),
                              child: Image.asset(
                                AppAssets.onBoarding1mobile,
                                width: 246,
                                height: 290,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const Spacer(
                              flex: 66,
                            ),
                            Text(
                                appLocalization.translate(
                                    "welcomeTimeblockingapp"),
                                style: contentStyleMobile),
                            const Spacer(
                              flex: 88,
                            ),
                            Wrap(
                              spacing: AppSpacing.xSmall8.value,
                              runSpacing: AppSpacing.xSmall8.value,
                              direction: Axis.vertical,
                              runAlignment: WrapAlignment.center,
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Wrap(
                                  spacing: AppSpacing.xSmall8.value,
                                  runSpacing: AppSpacing.xSmall8.value,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    CustomButton.noIcon(
                                        analyticsEvent:
                                        AnalyticsEvents.onBoardingStep1Start,
                                        label:
                                        appLocalization.translate("getStarted"),
                                        onPressed: () {
                                          setState(() {
                                            step = OnBoardingAndAuthStep.second;
                                          });
                                        },
                                        type: CustomButtonType.primaryLabel),
                                    CustomButton.noIcon(
                                      analyticsEvent: AnalyticsEvents
                                          .onBoardingStep1SignInSupabase,
                                      onPressed: () {
                                        setState(() {
                                          step = OnBoardingAndAuthStep.auth;
                                        });
                                      },
                                      type: CustomButtonType.secondaryLabel,
                                      label: appLocalization.translate(
                                          "signIn"),
                                    ),
                                  ],
                                ),
                                demoButton(
                                  AnalyticsEvents.onBoardingStep1Demo,
                                ),
                              ],
                            ),
                            Container(
                              height: AppSpacing.huge96.value,
                              alignment: Alignment.center,
                              child: agreeOurPrivacyTerms(),
                            )
                          ],
                        ),
                      ),
                    ),
                    isSmall: true),
                large: changeLanguageWrapper(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery
                            .sizeOf(context)
                            .width * 0.4,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            AppSpacing.x2Large64.value, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(
                              flex: 105,
                            ),
                            Image.asset(
                              AppAssets.logo(context.isDarkMode),
                              width: 258,
                              height: 39,
                              fit: BoxFit.contain,
                            ),
                            const Spacer(
                              flex: 70,
                            ),
                            Text(
                                appLocalization.translate(
                                    "welcomeTimeblockingapp"),
                                style: contentStyleDesktop),
                            const Spacer(
                              flex: 390,
                            ),
                            Row(
                              children: [
                                CustomButton.noIcon(
                                    analyticsEvent:
                                    AnalyticsEvents.onBoardingStep1Start,
                                    size: CustomButtonSize.large,
                                    label: appLocalization.translate(
                                        "getStarted"),
                                    onPressed: () {
                                      setState(() {
                                        step = OnBoardingAndAuthStep.second;
                                      });
                                    },
                                    type: CustomButtonType.primaryLabel),
                                const SizedBox(
                                  width: 8,
                                ),
                                CustomButton.noIcon(
                                  analyticsEvent:
                                  AnalyticsEvents.onBoardingStep1SignInSupabase,
                                  size: CustomButtonSize.large,
                                  onPressed: () {
                                    setState(() {
                                      step = OnBoardingAndAuthStep.auth;
                                    });
                                  },
                                  type: CustomButtonType.secondaryLabel,
                                  label: appLocalization.translate("signIn"),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            demoButton(
                              AnalyticsEvents.onBoardingStep1Demo,
                            ),
                            Container(
                              height: AppSpacing.xHuge128.value,
                              alignment: AlignmentDirectional.centerStart,
                              child: agreeOurPrivacyTerms(),
                            )
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(AppBorderRadius.x3Large.value),
                        child: Image.asset(
                          AppAssets.onBoarding1desktop,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    ],
                  ),
                  isSmall: false,
                )),
        OnBoardingAndAuthStep.second =>
            ResponsiveTParams(
                small: changeLanguageWrapper(
                    child: Center(
                      child: Container(
                        constraints: boxConstraints,
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.x2Big28.value),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(
                              flex: 36,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  AppBorderRadius.x3Large.value),
                              child: Image.asset(
                                AppAssets.onBoarding2mobile,
                                width: 246,
                                height: 290,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const Spacer(
                              flex: 66,
                            ),
                            Text(
                              appLocalization.translate("simplifyTasks"),
                              style: titleStyleMobile,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              appLocalization.translate(
                                  "timeBlockingAppStreamlinesTaskManagement"),
                              style: contentStyleMobile,
                            ),
                            const Spacer(
                              flex: 72,
                            ),
                            Wrap(
                              spacing: AppSpacing.xSmall8.value,
                              runSpacing: AppSpacing.xSmall8.value,
                              runAlignment: WrapAlignment.center,
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Wrap(
                                  spacing: AppSpacing.xSmall8.value,
                                  runSpacing: AppSpacing.xSmall8.value,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    CustomButton.noIcon(
                                        analyticsEvent:
                                        AnalyticsEvents.onBoardingStep2Back,
                                        size: CustomButtonSize.small,
                                        label: appLocalization.translate(
                                            "back"),
                                        onPressed: () {
                                          setState(() {
                                            step = OnBoardingAndAuthStep.first;
                                          });
                                        },
                                        type: CustomButtonType.secondaryLabel),
                                    ///TODO B remove next button since onboarding only 2 steps
                                    CustomButton.noIcon(
                                        analyticsEvent:
                                        AnalyticsEvents.onBoardingStep2Next,
                                        size: CustomButtonSize.small,
                                        label: appLocalization.translate(
                                            "next"),
                                        onPressed: () {
                                          setState(() {
                                            step = OnBoardingAndAuthStep.third;
                                          });
                                        },
                                        type: CustomButtonType.primaryLabel),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: AppSpacing.huge96.value,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  Wrap(
                                    children: [
                                      ///TODO B remove skip button since onboarding only 2 steps
                                      CustomButton.noIcon(
                                          analyticsEvent:
                                          AnalyticsEvents.onBoardingStep2Skip,
                                          size: CustomButtonSize.small,
                                          label: appLocalization.translate(
                                              "skip"),
                                          onPressed: () {
                                            setState(() {
                                              step = OnBoardingAndAuthStep.auth;
                                            });
                                          },
                                          type: CustomButtonType
                                              .primaryTextLabel),
                                      demoButton(
                                          AnalyticsEvents.onBoardingStep2Demo),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    isSmall: true),
                large: changeLanguageWrapper(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery
                            .sizeOf(context)
                            .width * 0.4,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            AppSpacing.x2Large64.value, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(
                              flex: 228,
                            ),
                            Text(
                              appLocalization.translate("simplifyTasks"),
                              style: titleStyleDesktop,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              appLocalization.translate(
                                  "timeBlockingAppStreamlinesTaskManagement"),
                              style: contentStyleDesktop,
                            ),
                            const Spacer(
                              flex: 390,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomButton.noIcon(
                                        analyticsEvent:
                                        AnalyticsEvents.onBoardingStep2Back,
                                        size: CustomButtonSize.large,
                                        label: appLocalization.translate(
                                            "back"),
                                        onPressed: () {
                                          setState(() {
                                            step = OnBoardingAndAuthStep.first;
                                          });
                                        },
                                        type: CustomButtonType.secondaryLabel),
                                    SizedBox(
                                      width: AppSpacing.xSmall8.value,
                                    ),
                                    ///TODO B remove next button since onboarding only 2 steps
                                    CustomButton.noIcon(
                                        analyticsEvent:
                                        AnalyticsEvents.onBoardingStep2Next,
                                        size: CustomButtonSize.large,
                                        label: appLocalization.translate(
                                            "next"),
                                        onPressed: () {
                                          setState(() {
                                            step = OnBoardingAndAuthStep.third;
                                          });
                                        },
                                        type: CustomButtonType.primaryLabel),
                                  ],
                                ),
                                SizedBox(
                                  height: AppSpacing.xHuge128.value,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      Row(
                                        children: [
                                          ///TODO B remove skip button since onboarding only 2 steps
                                          CustomButton.noIcon(
                                              analyticsEvent: AnalyticsEvents
                                                  .onBoardingStep2Skip,
                                              size: CustomButtonSize.large,
                                              label:
                                              appLocalization.translate("skip"),
                                              onPressed: () {
                                                setState(() {
                                                  step = OnBoardingAndAuthStep
                                                      .auth;
                                                });
                                              },
                                              type: CustomButtonType
                                                  .primaryTextLabel),
                                          SizedBox(
                                            width: AppSpacing.xSmall8.value,
                                          ),
                                          demoButton(
                                              AnalyticsEvents
                                                  .onBoardingStep2Demo),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(AppBorderRadius.x3Large.value),
                        child: Image.asset(
                          AppAssets.onBoarding2desktop,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    ],
                  ),
                  isSmall: false,
                )),
        OnBoardingAndAuthStep.third =>
            ResponsiveTParams(
                small: changeLanguageWrapper(child: Auth(authBloc: widget.authBloc), isSmall: true),
                large: changeLanguageWrapper(
                  child: Auth(authBloc: widget.authBloc),
                  isSmall: false,
                )),
      },
      context: context,
      onRefresh: () async {},
    );
  }

  CustomButton demoButton(AnalyticsEvents analyticsEvents) {
    return CustomButton.noIcon(
        analyticsEvent: analyticsEvents,
        label: appLocalization.translate("demo"),
        onPressed: () {
          final url = _demoUrl;
          launchWithURL(url: url);
        },
        type: CustomButtonType.primaryTextLabel);
  }

  Widget changeLanguageWrapper({required Widget child, required bool isSmall}) {
    if (isSmall) {
      return Column(
        children: [
          Row(
            children: [
              const Expanded(child: SizedBox()),
              CustomDropDownMenu(
                initialSelection: appLocalization.languagesEnumToLocale(
                    appLocalization.getCurrentLanguagesEnum(context)!),
                dropdownMenuEntries: context.supportedLocales
                    .map<DropdownMenuEntry>((e) =>
                    DropdownMenuEntry(
                        value: e,
                        label: appLocalization.translate(e.languageCode)))
                    .toList(),
                onSelected: (selected) {
                  widget.settingsBloc.add(ChangeLanguageEvent(
                      ChangeLanguageParams(
                          locale: selected, context: context)));
                },
                isDarkMode: (context.isDarkMode),
                inputDecorationTheme:
                const InputDecorationTheme(border: InputBorder.none),
              )
            ],
          ),
          Expanded(child: child)
        ],
      );
    }
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: SizedBox()),
            CustomDropDownMenu(
              initialSelection: appLocalization.languagesEnumToLocale(
                  appLocalization.getCurrentLanguagesEnum(context)!),
              dropdownMenuEntries: context.supportedLocales
                  .map<DropdownMenuEntry>((e) =>
                  DropdownMenuEntry(
                      value: e,
                      label: appLocalization.translate(e.languageCode)))
                  .toList(),
              onSelected: (selected) {
                widget.settingsBloc.add(ChangeLanguageEvent(
                    ChangeLanguageParams(locale: selected, context: context)));
              },
              isDarkMode: (context.isDarkMode),
              inputDecorationTheme:
              const InputDecorationTheme(border: InputBorder.none),
            )
          ],
        ),
        Expanded(child: child)
      ],
    );
  }

  Widget agreeOurPrivacyTerms() {
    final linkStyle = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.paragraphXSmall,
        color: AppColors.primary(context.isDarkMode),
        appFontWeight: AppFontWeight.bold))
        .copyWith(decoration: TextDecoration.underline);
    return RichText(
        text: TextSpan(
            style: AppTextStyle.getTextStyle(AppTextStyleParams(
                appFontSize: AppFontSize.paragraphXSmall,
                color: AppColors.grey(context.isDarkMode),
                appFontWeight: AppFontWeight.regular)),
            text: "${appLocalization.translate("byUsingTheAppAgreeOur")} ",
            children: [
              TextSpan(
                style: linkStyle,
                text: appLocalization.translate("termsOfUse"),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchWithURL(
                        url:
                        "https://timeblocking.web.app/${TermsConditionsPage
                            .routeName}");
                  },
              ),
              TextSpan(text: " ${appLocalization.translate("and")} "),
              TextSpan(
                style: linkStyle,
                text: appLocalization.translate("privacyPolicy"),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchWithURL(
                        url:
                        "https://timeblocking.web.app/${PrivacyPolicyPage
                            .routeName}");
                  },
              ),
              TextSpan(
                  text:
                  " ${appLocalization.translate(
                      "andAutoOptInUsingAnalyticsForImproving")} "),
            ]));
  }

}

///TODO C Sign in with magic link maybe
///TODO C Sign in anon maybe ??

class Auth extends StatefulWidget {
  const Auth({super.key, required this.authBloc});
  final AuthBloc authBloc;
  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isSignIn = true;
  final TextEditingController emailController =
      TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController passwordController =
      TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode submitFocusNode = FocusNode();
  final FocusNode changeAuthModeFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    submitFocusNode.dispose();
    changeAuthModeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showSmallDesign = context.showSmallDesign;
    return Container(
      constraints:
          BoxConstraints(maxWidth: showSmallDesign ? 400 : 500),
      padding: EdgeInsets.all(AppSpacing.medium16.value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              AppAssets.logo(context.isDarkMode),
              width: showSmallDesign ? 180 : 200,
            ),
          ),
          SizedBox(height: AppSpacing.large40.value,),
          Center(
            child: Text(
              isSignIn
                  ? appLocalization.translate("signIn")
                  : appLocalization.translate("signUp"),
              style: AppTextStyle.getTextStyle(AppTextStyleParams(
                  color: AppColors.grey(context.isDarkMode).shade900,
                  appFontWeight: AppFontWeight.medium,
                  appFontSize: AppFontSize.heading5)),
            ),
          ),
          SizedBox(height: AppSpacing.medium16.value,),

          //email
          Text(appLocalization.translate('email'),
            style: AppTextStyle.getTextStyle(AppTextStyleParams(
                color: AppColors.grey(context.isDarkMode).shade900,
                appFontWeight: AppFontWeight.medium,
                appFontSize: AppFontSize.paragraphMedium)),),
          CustomTextInputField(controller: emailController, focusNode: emailFocusNode,),

          SizedBox(height: AppSpacing.xBig24.value,),

          //password
          Text(appLocalization.translate('password'),
              style: AppTextStyle.getTextStyle(AppTextStyleParams(
                  color: AppColors.grey(context.isDarkMode).shade900,
                  appFontWeight: AppFontWeight.medium,
                  appFontSize: AppFontSize.paragraphMedium))),
          ///TODO B secure input
          CustomTextInputField(controller: passwordController, focusNode: passwordFocusNode),
          SizedBox(height: AppSpacing.x3Big32.value,),
          CustomButton.noIcon(
              focusNode: submitFocusNode,
              analyticsEvent:
                  isSignIn ? AnalyticsEvents.signIn : AnalyticsEvents.signUp,
              label: isSignIn
                  ? appLocalization.translate("signIn")
                  : appLocalization.translate("signUp"),
              onPressed: () {
                printDebug(
                    "${emailController.text} : ${passwordController.text}");
                widget.authBloc.add(SignInEvent(SignInParams(
                  email: emailController.text,
                  password: passwordController.text,
                )));
              }),
          SizedBox(height: AppSpacing.xBig24.value,),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  isSignIn
                      ? appLocalization.translate('areYouNewHere?')
                      : appLocalization.translate('alreadyHaveAnAccount?'),
                  style: AppTextStyle.getTextStyle(AppTextStyleParams(
                      color: AppColors.grey(context.isDarkMode).shade500,
                      appFontWeight: AppFontWeight.medium,
                      appFontSize: AppFontSize.paragraphSmall))),
              if(showSmallDesign == false)SizedBox(width: AppSpacing.x2Small4.value,),
              CustomButton.noIcon(
                  focusNode: changeAuthModeFocusNode,
                  type: CustomButtonType.primaryTextLabel,
                  label: isSignIn
                      ? appLocalization.translate("createNewAccount")
                      : appLocalization.translate("tryToSignIn"),
                  onPressed: () {
                    setState(() {
                      isSignIn = !isSignIn;
                    });
                  }),
            ],
          )
        ],
      ),
    );
  }
}
