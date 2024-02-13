import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/assets_paths.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_text_input_field.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../../core/globals.dart';
import '../../../../core/launch_url.dart';
import '../../../../core/localization/localization.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_page_webview.dart';

enum OnBoardingAndAuthStep {
  first(1),
  second(2),
  third(3),
  fourth(4);

  static OnBoardingAndAuthStep get auth => fourth;

  const OnBoardingAndAuthStep(this.number);

  final int number;
}

class OnBoardingAndAuthPage extends StatefulWidget {
  const OnBoardingAndAuthPage({super.key, required this.authBloc});

  final AuthBloc authBloc;

  @override
  State<OnBoardingAndAuthPage> createState() => _OnBoardingAndAuthPageState();
}

class _OnBoardingAndAuthPageState extends State<OnBoardingAndAuthPage> {
  OnBoardingAndAuthStep step = OnBoardingAndAuthStep.first;

  @override
  Widget build(BuildContext context) {
    final clickupAuthUrl =
        "https://app.clickup.com/api?client_id=${Globals.clickupClientId}&redirect_uri=${Globals.clickupRedirectUrl}";
    final titleStyleMobile = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.heading6,
        color: AppColors.text,
        appFontWeight: AppFontWeight.medium));
    final contentStyleMobile = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.paragraphLarge,
        color: AppColors.text,
        appFontWeight: AppFontWeight.medium));
    final titleStyleDesktop = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.heading3,
        color: AppColors.text,
        appFontWeight: AppFontWeight.medium));
    final contentStyleDesktop = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.heading6,
        color: AppColors.text,
        appFontWeight: AppFontWeight.medium));
    const boxConstraints = BoxConstraints(maxWidth: 510);
    return ResponsiveScaffold(
      hideAppBarDrawer: true,
      responsiveScaffoldLoading: ResponsiveScaffoldLoading(
          responsiveScaffoldLoadingEnum:
              ResponsiveScaffoldLoadingEnum.contentLoading,
          isLoading: widget.authBloc.state.isLoading),
      responsiveBody: switch (step) {
        OnBoardingAndAuthStep.first => ResponsiveTParams(
            small: Center(
              child: Container(
                constraints: boxConstraints,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.x2Big28.value),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(
                      flex: 86,
                    ),
                    Image.asset(
                      AppAssets.logo,
                      width: 258,
                      height: 39,
                      fit: BoxFit.contain,
                    ),
                    const Spacer(
                      flex: 34,
                    ),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppBorderRadius.x3Large.value),
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
                    Wrap(
                        children:
                            "${appLocalization.translate("welcomeTimeblockingapp")} ${appLocalization.translate("withThePowerOf")}"
                                    .split(" ")
                                    .toList()
                                    .map<Widget>((e) =>
                                        Text("$e ", style: contentStyleMobile))
                                    .toList() +
                                [Text(" ", style: contentStyleMobile)] +
                                [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: Image.asset(
                                      AppAssets.clickupLogo,
                                      width: 95,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )
                                ]),
                    const Spacer(
                      flex: 88,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        CustomButton.custom(
                          onPressed: () {
                            final url = clickupAuthUrl;
                            if (kIsWeb) {
                              launchWithURL(url: url);
                              if (true) {
                                widget.authBloc
                                    .add(const ShowCodeInputTextField(true));
                              }
                            } else if (Platform.isAndroid || Platform.isIOS) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return AuthPageWebView(
                                      url: url,
                                      getAccessToken: (String code) {
                                        widget.authBloc
                                            .add(GetClickupAccessToken(code));
                                      },
                                    );
                                  }));
                            }
                          },
                          type: CustomButtonType.secondaryLabel,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${appLocalization.translate("connectWithClickupNow")} ",
                                style: AppTextStyle.getTextStyle(
                                    AppTextStyleParams(
                                        color: AppColors.primary.shade500,
                                        appFontWeight: AppFontWeight.semiBold,
                                        appFontSize: AppFontSize.paragraphSmall)),
                              ),
                              Image.asset(
                                AppAssets.clickupLogoMin,
                                width: 20,
                                height: 20,
                              )
                            ],
                          ),
                        ),
                        CustomButton.noIcon(
                            label: appLocalization.translate("getStarted"),
                            onPressed: () {
                              setState(() {
                                step = OnBoardingAndAuthStep.second;
                              });
                            },
                            type: CustomButtonType.primaryLabel),
                      ],
                    ),
                    SizedBox(
                      height: AppSpacing.huge96.value,
                    )
                  ],
                ),
              ),
            ),
            large: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.4,
                  padding: EdgeInsetsDirectional.fromSTEB(
                      AppSpacing.x2Large64 .value, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(
                        flex: 105,
                      ),
                      Image.asset(
                        AppAssets.logo,
                        width: 258,
                        height: 39,
                        fit: BoxFit.contain,
                      ),
                      const Spacer(
                        flex: 70,
                      ),
                      Wrap(
                          children:
                              "${appLocalization.translate("welcomeTimeblockingapp")} ${appLocalization.translate("withThePowerOf")}"
                                      .split(" ")
                                      .toList()
                                      .map<Widget>((e) => Text("$e ",
                                          style: contentStyleDesktop))
                                      .toList() +
                                  [Text(" ", style: contentStyleDesktop)] +
                                  [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Image.asset(
                                        AppAssets.clickupLogo,
                                        width: 85,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )
                                  ]),
                      const Spacer(
                        flex: 390,
                      ),
                      Row(
                        children: [
                          CustomButton.custom(
                            size: CustomButtonSize.large,
                            onPressed: () {
                              final url = clickupAuthUrl;
                              if (kIsWeb) {
                                launchWithURL(url: url);
                                if (true) {
                                  widget.authBloc
                                      .add(const ShowCodeInputTextField(true));
                                }
                              } else if (Platform.isAndroid || Platform.isIOS) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return AuthPageWebView(
                                        url: url,
                                        getAccessToken: (String code) {
                                          widget.authBloc
                                              .add(GetClickupAccessToken(code));
                                        },
                                      );
                                    }));
                              }
                            },
                            type: CustomButtonType.secondaryLabel,
                            child: Row(
                              children: [
                                Text(
                                  "${appLocalization.translate("connectWithClickupNow")} ",
                                  style: AppTextStyle.getTextStyle(
                                      AppTextStyleParams(
                                          color: AppColors.primary.shade500,
                                          appFontWeight: AppFontWeight.semiBold,
                                          appFontSize: AppFontSize.paragraphSmall)),
                                ),
                                Image.asset(
                                  AppAssets.clickupLogoMin,
                                  width: 20,
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          CustomButton.noIcon(
                              size: CustomButtonSize.large,
                              label: appLocalization.translate("getStarted"),
                              onPressed: () {
                                setState(() {
                                  step = OnBoardingAndAuthStep.second;
                                });
                              },
                              type: CustomButtonType.primaryLabel),
                        ],
                      ),
                      SizedBox(
                        height: AppSpacing.xHuge128.value,
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
            )),
        OnBoardingAndAuthStep.second => ResponsiveTParams(
            small: Center(
              child: Container(
                constraints: boxConstraints,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.x2Big28.value),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(
                      flex: 36,
                    ),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppBorderRadius.x3Large.value),
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
                      appLocalization
                          .translate("timeBlockingAppStreamlinesTaskManagement"),
                      style: contentStyleMobile,
                    ),
                    const Spacer(
                      flex: 72,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton.noIcon(
                            size: CustomButtonSize.small,
                            label: appLocalization.translate("back"),
                            onPressed: () {
                              setState(() {
                                step = OnBoardingAndAuthStep.first;
                              });
                            },
                            type: CustomButtonType.secondaryLabel),
                        const SizedBox(
                          width: 8,
                        ),
                        CustomButton.noIcon(
                            size: CustomButtonSize.small,
                            label: appLocalization.translate("next"),
                            onPressed: () {
                              setState(() {
                                step = OnBoardingAndAuthStep.third;
                              });
                            },
                            type: CustomButtonType.primaryLabel),
                      ],
                    ),
                    SizedBox(
                      height: AppSpacing.huge96.value,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 18,
                          ),
                          CustomButton.noIcon(
                              size: CustomButtonSize.small,
                              label: appLocalization.translate("skip"),
                              onPressed: () {
                                setState(() {
                                  step = OnBoardingAndAuthStep.auth;
                                });
                              },
                              type: CustomButtonType.primaryTextLabel),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            large: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.4,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomButton.noIcon(
                                  size: CustomButtonSize.large,
                                  label: appLocalization.translate("back"),
                                  onPressed: () {
                                    setState(() {
                                      step = OnBoardingAndAuthStep.first;
                                    });
                                  },
                                  type: CustomButtonType.secondaryLabel),
                              const SizedBox(
                                width: 8,
                              ),
                              CustomButton.noIcon(
                                  size: CustomButtonSize.large,
                                  label: appLocalization.translate("next"),
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
                                CustomButton.noIcon(
                                    size: CustomButtonSize.large,
                                    label: appLocalization.translate("skip"),
                                    onPressed: () {
                                      setState(() {
                                        step = OnBoardingAndAuthStep.auth;
                                      });
                                    },
                                    type: CustomButtonType.primaryTextLabel),
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
            )),
        OnBoardingAndAuthStep.third => ResponsiveTParams(
            small: Center(
              child: Container(
                constraints: boxConstraints,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.x2Big28.value),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(
                      flex: 36,
                    ),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppBorderRadius.x3Large.value),
                      child: Image.asset(
                        AppAssets.onBoarding3mobile,
                        width: 246,
                        height: 290,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(
                      flex: 66,
                    ),
                    Text(
                      appLocalization.translate("seamlessClickUpIntegration"),
                      style: titleStyleMobile,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      appLocalization.translate("connectTimeblockingClickup"),
                      style: contentStyleMobile,
                    ),
                    const Spacer(
                      flex: 72,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton.noIcon(
                            size: CustomButtonSize.small,
                            label: appLocalization.translate("back"),
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
                            size: CustomButtonSize.small,
                            label: appLocalization.translate("next"),
                            onPressed: () {
                              setState(() {
                                step = OnBoardingAndAuthStep.fourth;
                              });
                            },
                            type: CustomButtonType.primaryLabel),
                      ],
                    ),
                    SizedBox(
                      height: AppSpacing.huge96.value,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 18,
                          ),
                          CustomButton.noIcon(
                              size: CustomButtonSize.small,
                              label: appLocalization.translate("skip"),
                              onPressed: () {
                                setState(() {
                                  step = OnBoardingAndAuthStep.auth;
                                });
                              },
                              type: CustomButtonType.primaryTextLabel),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            large: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.4,
                  padding: EdgeInsetsDirectional.fromSTEB(
                      AppSpacing.x2Large64.value, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(
                        flex: 228,
                      ),
                      Text(
                        appLocalization.translate("seamlessClickUpIntegration"),
                        style: titleStyleDesktop,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        appLocalization.translate("connectTimeblockingClickup"),
                        style: contentStyleDesktop,
                      ),
                      const Spacer(
                        flex: 390,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomButton.noIcon(
                                  size: CustomButtonSize.large,
                                  label: appLocalization.translate("back"),
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
                                  size: CustomButtonSize.large,
                                  label: appLocalization.translate("next"),
                                  onPressed: () {
                                    setState(() {
                                      step = OnBoardingAndAuthStep.fourth;
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
                                CustomButton.noIcon(
                                    size: CustomButtonSize.large,
                                    label: appLocalization.translate("skip"),
                                    onPressed: () {
                                      setState(() {
                                        step = OnBoardingAndAuthStep.auth;
                                      });
                                    },
                                    type: CustomButtonType.primaryTextLabel),
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
                    AppAssets.onBoarding3desktop,
                    fit: BoxFit.fitHeight,
                  ),
                )
              ],
            )),
        OnBoardingAndAuthStep.fourth => ResponsiveTParams(
            small: Center(
              child: Container(
                constraints: boxConstraints,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.x2Big28.value),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(
                      flex: 36,
                    ),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppBorderRadius.x3Large.value),
                      child: Image.asset(
                        AppAssets.onBoarding3mobile,
                        width: 246,
                        height: 290,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(
                      flex: 66,
                    ),
                    Text(
                      appLocalization.translate("dateSecurity"),
                      style: titleStyleMobile,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Rest easy knowing that all your task data is securely managed by ClickUp. Check out ClickUp\'s privacy and security policies for additional details',
                      style: contentStyleMobile,
                      overflow: TextOverflow.visible,
                    ),
                    const Spacer(
                      flex: 72,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton.custom(
                          size: CustomButtonSize.small,
                          onPressed: () {
                            final url = clickupAuthUrl;
                            if (kIsWeb) {
                              launchWithURL(url: url);
                              if (true) {
                                widget.authBloc
                                    .add(const ShowCodeInputTextField(true));
                              }
                            } else if (Platform.isAndroid || Platform.isIOS) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AuthPageWebView(
                                  url: url,
                                  getAccessToken: (String code) {
                                    widget.authBloc
                                        .add(GetClickupAccessToken(code));
                                  },
                                );
                              }));
                            }
                          },
                          type: CustomButtonType.primaryLabel,
                          child: Row(
                            children: [
                              Text(
                                "${appLocalization.translate("connectWithClickup")} ",
                                style: AppTextStyle.getTextStyle(
                                    AppTextStyleParams(
                                        color: AppColors.white,
                                        appFontWeight: AppFontWeight.semiBold,
                                        appFontSize: AppFontSize.paragraphSmall)),
                              ),
                              Image.asset(
                                AppAssets.clickupLogoMin,
                                width: 20,
                                height: 20,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        CustomButton.trailingIcon(
                          size: CustomButtonSize.small,
                          label: appLocalization.translate("copyLink"),
                          onPressed: () async {
                            await Clipboard.setData(
                                    ClipboardData(text: clickupAuthUrl))
                                .then((value) =>
                                    ScaffoldMessenger.maybeOf(context)
                                        ?.showSnackBar(SnackBar(
                                            content: Text(
                                      appLocalization.translate(
                                        "linkCopiedSuccessfully",
                                      ),
                                      style: AppTextStyle.getTextStyle(
                                          AppTextStyleParams(
                                              appFontSize:
                                                  AppFontSize.paragraphSmall,
                                              color: AppColors.grey.shade50,
                                              appFontWeight:
                                                  AppFontWeight.regular)),
                                    ))));
                          },
                          type: CustomButtonType.secondaryTrailingIcon,
                          icon: Icons.link,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSpacing.huge96.value,
                    )
                  ],
                ),
              ),
            ),
            large: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.4,
                  padding: EdgeInsetsDirectional.fromSTEB(
                      AppSpacing.x2Large64.value, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(
                        flex: 228,
                      ),
                      Text(
                        appLocalization.translate("dateSecurity"),
                        style: titleStyleDesktop,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        appLocalization
                            .translate("restEasyKnowingTasksSecured"),
                        style: contentStyleDesktop,
                      ),
                      const Spacer(
                        flex: 390,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomButton.custom(
                            size: CustomButtonSize.large,
                            onPressed: () {
                              final url = clickupAuthUrl;
                              if (kIsWeb) {
                                launchWithURL(url: url);
                                if (true) {
                                  widget.authBloc
                                      .add(const ShowCodeInputTextField(true));
                                }
                              } else if (Platform.isAndroid || Platform.isIOS) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AuthPageWebView(
                                    url: url,
                                    getAccessToken: (String code) {
                                      widget.authBloc
                                          .add(GetClickupAccessToken(code));
                                    },
                                  );
                                }));
                              }
                            },
                            type: CustomButtonType.primaryLabel,
                            child: Row(
                              children: [
                                Text(
                                  "${appLocalization.translate("connectWithClickup")} ",
                                  style: AppTextStyle.getTextStyle(
                                      AppTextStyleParams(
                                          color: AppColors.white,
                                          appFontWeight: AppFontWeight.semiBold,
                                          appFontSize:
                                              AppFontSize.paragraphLarge)),
                                ),
                                Image.asset(
                                  AppAssets.clickupLogoMin,
                                  width: 20,
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          CustomButton.trailingIcon(
                            size: CustomButtonSize.large,
                            label: appLocalization.translate("copyLink"),
                            onPressed: () async {
                              await Clipboard.setData(
                                      ClipboardData(text: clickupAuthUrl))
                                  .then((value) =>
                                      ScaffoldMessenger.maybeOf(context)
                                          ?.showSnackBar(SnackBar(
                                              content: Text(
                                        appLocalization.translate(
                                          "linkCopiedSuccessfully",
                                        ),
                                        style: AppTextStyle.getTextStyle(
                                            AppTextStyleParams(
                                                appFontSize:
                                                    AppFontSize.paragraphSmall,
                                                color: AppColors.grey.shade50,
                                                appFontWeight:
                                                    AppFontWeight.regular)),
                                      ))));
                            },
                            type: CustomButtonType.secondaryTrailingIcon,
                            icon: Icons.link,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppSpacing.xHuge128.value,
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppBorderRadius.x3Large.value),
                  child: Image.asset(
                    AppAssets.onBoarding3desktop,
                    fit: BoxFit.fitHeight,
                  ),
                )
              ],
            )),
      },
      context: context, onRefresh: ()async {},
    );
  }
}

class ExplainClickupAuth extends StatelessWidget {
  ExplainClickupAuth({Key? key, required this.authBloc}) : super(key: key);

  final TextEditingController controller = TextEditingController();
  final AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(appLocalization.translate("whyConnectClickup",
                arguments: [appLocalization.translate("appName")])),
            CustomButton.noIcon(
                label: "Connect with Clickup",
                onPressed: () {
                  final url =
                      "https://app.clickup.com/api?client_id=${Globals.clickupClientId}&redirect_uri=${Globals.clickupRedirectUrl}";
                  if (kIsWeb) {
                    launchWithURL(url: url);
                    if (true) {
                      authBloc.add(const ShowCodeInputTextField(true));
                    }
                  } else if (Platform.isAndroid || Platform.isIOS) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AuthPageWebView(
                        url: url,
                        getAccessToken: (String code) {
                          authBloc.add(GetClickupAccessToken(code));
                        },
                      );
                    }));
                  }
                }),
            Text(appLocalization.translate("agreeTermsConditions")),
            if (true)
              Row(
                children: [
                  Expanded(
                    child: CustomTextInputField(
                      focusNode: FocusNode(),
                      controller: controller,
                    ),
                  ),
                  CustomButton.noIcon(
                    label: "submit",
                    onPressed: () {
                      authBloc.add(GetClickupAccessToken(controller.text));
                    },
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
