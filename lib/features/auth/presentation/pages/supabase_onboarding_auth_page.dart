import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';

import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_up_anonymously_use_case.dart';
import 'package:thetimeblockingapp/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../schedule/presentation/pages/schedule_page.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/supabase_auth_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/widgets/custom_alert_dialog.dart';
import 'package:thetimeblockingapp/common/widgets/custom_alert_widget.dart';
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
import '../../domain/use_cases/sign_up_use_case.dart';
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
  // ignore: prefer_const_constructors_in_immutables
  SupabaseOnBoardingAndAuthPage({
    super.key,
  });

  static const routeName = "/Auth";

  @override
  State<SupabaseOnBoardingAndAuthPage> createState() => _SupabaseOnBoardingAndAuthPageState();
}

class _SupabaseOnBoardingAndAuthPageState extends State<SupabaseOnBoardingAndAuthPage> {
  OnBoardingAndAuthStep step = OnBoardingAndAuthStep.first;
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
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {},
      builder: (context, settingsState) {
        printDebug("SettingsBloc state builder $settingsState");
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            printDebug("AuthBloc state listener $state");
            if (state.canGoSchedulePage == true) {
              context.go(SchedulePage.routeName, extra: true);
            }
            if(state.authState == AuthStateEnum.signUpSuccess &&
                serviceLocator<AppConfig>().confirmationEmailEnabled) {
              showCustomAlert(
                  customAlertType: CustomAlertType.information,
                  customAlertThemeType: CustomAlertThemeType.filled,
                  title:
                      "confirmation email sent to ${state.signUpResult?.email ?? ""}",
                  context: context);
            }
            if (state.authState == AuthStateEnum.signInFailed &&
                state.signInFailure is! EmptyCacheFailure &&
                state.signInFailure?.message.isNotEmpty == true) {
              showCustomAlert(
                      context: context,
                      customAlertType: CustomAlertType.warning,
                      customAlertThemeType: CustomAlertThemeType.filled,
                      title: state.signInFailure?.message??"");
            }
            if (state.authState == AuthStateEnum.signUpFailed &&
                state.signUpFailure is! EmptyCacheFailure &&
                state.signUpFailure?.message.isNotEmpty == true) {
              showCustomAlert(
                  context: context,
                  customAlertType: CustomAlertType.warning,
                  customAlertThemeType: CustomAlertThemeType.filled,
                  title: state.signUpFailure?.message??"");
            }
          },
          builder: (context, state) {
            printDebug("AuthBloc state builder $state");
            final authBloc = BlocProvider.of<AuthBloc>(context);
            final settingsBloc = BlocProvider.of<SettingsBloc>(context);
            if(state.authState == AuthStateEnum.initial){
              authBloc.add(CheckAlreadySignedInEvent());
            }
            if (state.authState == AuthStateEnum.signUpSuccess &&
                serviceLocator<AppConfig>().confirmationEmailEnabled == false) {
              authBloc.add(SignInEvent(SignInParams(
                  email: emailController.text,
                  password: passwordController.text,
                  accessToken: const AccessToken(accessToken: '', tokenType: ''))));
            }
            return ResponsiveScaffold(
              hideAppBarDrawer: true,
              responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                  responsiveScaffoldLoadingEnum:
                  ResponsiveScaffoldLoadingEnum.overlayLoading,
                  isLoading: authBloc.state.isLoading),
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
                                                appLocalization.translate("learnMore"),
                                                onPressed: () {
                                                  setState(() {
                                                    step = OnBoardingAndAuthStep.second;
                                                  });
                                                },
                                                type: CustomButtonType.secondaryLabel),
                                            CustomButton.noIcon(
                                              analyticsEvent: AnalyticsEvents
                                                  .onBoardingStep1SignInSupabase,
                                              onPressed: () {
                                                setState(() {
                                                  step = OnBoardingAndAuthStep.auth;
                                                });
                                              },
                                              type: CustomButtonType.primaryLabel,
                                              label: appLocalization.translate(
                                                  "signIn"),
                                            ),
                                          ],
                                        ),
                                        tryAppButton(
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
                            isSmall: true, settingsBloc: settingsBloc),
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
                                            
                                            label: appLocalization.translate(
                                                "learnMore"),
                                            onPressed: () {
                                              setState(() {
                                                step = OnBoardingAndAuthStep.second;
                                              });
                                            },
                                            type: CustomButtonType.secondaryLabel),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        CustomButton.noIcon(
                                          analyticsEvent:
                                          AnalyticsEvents.onBoardingStep1SignInSupabase,
                                          
                                          onPressed: () {
                                            setState(() {
                                              step = OnBoardingAndAuthStep.auth;
                                            });
                                          },
                                          type: CustomButtonType.primaryLabel,
                                          label: appLocalization.translate("signIn"),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    tryAppButton(
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
                          isSmall: false, settingsBloc: settingsBloc,
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
                                            CustomButton.noIcon(
                                                analyticsEvent:
                                                AnalyticsEvents.onBoardingStep2Next,
                                                size: CustomButtonSize.small,
                                                label: appLocalization.translate(
                                                    "signIn"),
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
                                              tryAppButton(
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
                            isSmall: true, settingsBloc: settingsBloc),
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
                                            ///TODO remove next button since onboarding only 2 steps
                                            CustomButton.noIcon(
                                                analyticsEvent:
                                                AnalyticsEvents.onBoardingStep2Next,
                                                
                                                label: appLocalization.translate(
                                                    "signIn"),
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
                                                  tryAppButton(
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
                          isSmall: false, settingsBloc: settingsBloc,
                        )),
                OnBoardingAndAuthStep.third =>
                    ResponsiveTParams(
                        small: changeLanguageWrapper(
                        child: SupabaseAuthWidget(
                            authBloc: authBloc,
                            isSignIn: isSignIn,
                            emailController: emailController,
                            emailFocusNode: emailFocusNode,
                            passwordController: passwordController,
                            passwordFocusNode: passwordFocusNode,
                            submitFocusNode: submitFocusNode,
                            changeAuthModeFocusNode: changeAuthModeFocusNode,
                            toggleSignInMode: (){
                              setState(() {
                                isSignIn = !isSignIn;
                              });
                            }),
                        isSmall: true,
                        settingsBloc: settingsBloc),
                    large: changeLanguageWrapper(
                      child: SupabaseAuthWidget(
                          authBloc: authBloc,
                          isSignIn: isSignIn,
                          emailController: emailController,
                          emailFocusNode: emailFocusNode,
                          passwordController: passwordController,
                          passwordFocusNode: passwordFocusNode,
                          submitFocusNode: submitFocusNode,
                          changeAuthModeFocusNode: changeAuthModeFocusNode,
                          toggleSignInMode: (){
                            setState(() {
                              isSignIn = !isSignIn;
                            });
                          }),
                      isSmall: false, settingsBloc: settingsBloc,
                        )),
              },
              context: context,
              onRefresh: null,
            );
          },
        );
      },
    );
  }

  Widget tryAppButton(AnalyticsEvents analyticsEvents) {
    return CustomButton.noIcon(
        analyticsEvent: analyticsEvents,
        label: appLocalization.translate("continueAsAGuest"),
        onPressed: () {
          BlocProvider.of<AuthBloc>(context).add(SignUpAnonymouslyEvent(
              SignUpAnonymouslyParams(captchaToken: null)));
        },
        type: CustomButtonType.primaryTextLabel);
  }

  Widget changeLanguageWrapper({required Widget child, required bool isSmall,required SettingsBloc settingsBloc}) {
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
                  settingsBloc.add(ChangeLanguageEvent(
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
                settingsBloc.add(ChangeLanguageEvent(
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
                    // context.go(TermsConditionsPage.routeName);
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
                    // context.go(PrivacyPolicyPage.routeName);
                  },
              ),
              TextSpan(
                  text:
                  " ${appLocalization.translate(
                      "andAutoOptInUsingAnalyticsForImproving")} "),
            ]));
  }
}
