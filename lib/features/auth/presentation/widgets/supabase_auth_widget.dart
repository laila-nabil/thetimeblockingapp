import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_text_input_field.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/assets_paths.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/update_user_use_case.dart';

import '../bloc/auth_bloc.dart';

///TODO Z Sign in with magic link maybe
///TODO Z Sign in anon maybe ??

class SupabaseAuthWidget extends StatefulWidget {
  const SupabaseAuthWidget({
    super.key,
    required this.authBloc,
    required this.isSignIn,
    required this.emailController,
    required this.emailFocusNode,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.submitFocusNode,
    required this.changeAuthModeFocusNode,
    required this.toggleSignInMode,
  });

  final AuthBloc authBloc;
  final bool isSignIn;
  final TextEditingController? emailController;
  final FocusNode? emailFocusNode;
  final TextEditingController? passwordController;
  final FocusNode? passwordFocusNode;
  final FocusNode? submitFocusNode;
  final FocusNode? changeAuthModeFocusNode;
  final void Function() toggleSignInMode;

  @override
  State<SupabaseAuthWidget> createState() => _SupabaseAuthWidgetState();
}

class _SupabaseAuthWidgetState extends State<SupabaseAuthWidget> {
   late TextEditingController emailController;
   late FocusNode emailFocusNode;
   late TextEditingController passwordController;
   late FocusNode passwordFocusNode;
   late FocusNode submitFocusNode;
   late FocusNode changeAuthModeFocusNode;
  @override
  void initState() {
     emailController = widget.emailController ?? TextEditingController();
     emailFocusNode = widget.emailFocusNode ?? FocusNode();
     passwordController = widget.passwordController ?? TextEditingController();
     passwordFocusNode = widget.passwordFocusNode ?? FocusNode();
     submitFocusNode = widget.submitFocusNode ?? FocusNode();
     changeAuthModeFocusNode = widget.changeAuthModeFocusNode ?? FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    if(widget.emailController == null){
      emailController.dispose();
    }
    if(widget.emailFocusNode == null){
      emailFocusNode.dispose();
    }
    if(widget.passwordController == null){
      passwordController.dispose();
    }
    if(widget.passwordFocusNode == null){
      passwordFocusNode.dispose();
    }
    if(widget.submitFocusNode == null){
      submitFocusNode.dispose();
    }
    if(widget.changeAuthModeFocusNode == null){
      changeAuthModeFocusNode.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final showSmallDesign = context.showSmallDesign;
    bool anonymousUserAlreadySignedIn = widget.emailController == null;
    return Container(
      constraints: BoxConstraints(maxWidth: showSmallDesign ? 400 : 500),
      padding: EdgeInsets.all(AppSpacing.medium16.value),
      child: ListView(
        children: [
          if(anonymousUserAlreadySignedIn == false)Center(
            child: Image.asset(
              AppAssets.logo(context.isDarkMode),
              width: showSmallDesign ? 180 : 200,
            ),
          ),
          if(anonymousUserAlreadySignedIn == false)SizedBox(
            height: AppSpacing.large40.value,
          ),
          Center(
            child: Text(
              widget.isSignIn
                  ? appLocalization.translate("signIn")
                  : appLocalization.translate("signUp"),
              style: AppTextStyle.getTextStyle(AppTextStyleParams(
                  color: AppColors.grey(context.isDarkMode).shade900,
                  appFontWeight: AppFontWeight.medium,
                  appFontSize: AppFontSize.heading5)),
            ),
          ),
          SizedBox(
            height: AppSpacing.medium16.value,
          ),

          //email
          Text(
            appLocalization.translate('email'),
            style: AppTextStyle.getTextStyle(AppTextStyleParams(
                color: AppColors.grey(context.isDarkMode).shade900,
                appFontWeight: AppFontWeight.medium,
                appFontSize: AppFontSize.paragraphMedium)),
          ),
          CustomTextInputField(
            controller: emailController,
            focusNode: emailFocusNode,
            hintText: "email@gmail.com",
          ),

          SizedBox(
            height: AppSpacing.xBig24.value,
          ),

          //password
          Text(appLocalization.translate('password'),
              style: AppTextStyle.getTextStyle(AppTextStyleParams(
                  color: AppColors.grey(context.isDarkMode).shade900,
                  appFontWeight: AppFontWeight.medium,
                  appFontSize: AppFontSize.paragraphMedium))),
          CustomTextInputField(
            controller: passwordController,
            focusNode: passwordFocusNode,
            hintText: appLocalization.translate("password"),
            isPassword: true,
          ),
          SizedBox(
            height: AppSpacing.x3Big32.value,
          ),
          CustomButton.noIcon(
              focusNode: submitFocusNode,
              analyticsEvent: widget.isSignIn
                  ? AnalyticsEvents.signIn
                  : AnalyticsEvents.signUp,
              label: widget.isSignIn
                  ? appLocalization.translate("signIn")
                  : appLocalization.translate("signUp"),
              onPressed: () {
                printDebug(
                    "${emailController.text} : ${passwordController.text}");
                if (widget.isSignIn) {
                  widget.authBloc.add(SignInEvent(SignInParams(
                    email: emailController.text,
                    password: passwordController.text,
                    accessToken:
                        const AccessToken(accessToken: '', tokenType: ''),
                  )));
                } else if(anonymousUserAlreadySignedIn == false) {
                  widget.authBloc.add(SignUpEvent(SignUpParams(
                    email: emailController.text,
                    password: passwordController.text,
                    accessToken: widget.authBloc.state.accessToken,
                  )));
                } else if(anonymousUserAlreadySignedIn == true) {
                  widget.authBloc.add(UpdateUserEvent(UpdateUserParams(
                    email: emailController.text,
                    password: passwordController.text,
                    accessToken: widget.authBloc.state.accessToken,
                  )));
                  context.pop();
                }
              }),
          SizedBox(
            height: AppSpacing.xBig24.value,
          ),
          if(anonymousUserAlreadySignedIn == false)Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  widget.isSignIn
                      ? appLocalization.translate('areYouNewHere?')
                      : appLocalization.translate('alreadyHaveAnAccount?'),
                  style: AppTextStyle.getTextStyle(AppTextStyleParams(
                      color: AppColors.grey(context.isDarkMode).shade500,
                      appFontWeight: AppFontWeight.medium,
                      appFontSize: AppFontSize.paragraphSmall))),
              if (showSmallDesign == false)
                SizedBox(
                  width: AppSpacing.x2Small4.value,
                ),
              CustomButton.noIcon(
                  focusNode: changeAuthModeFocusNode,
                  type: CustomButtonType.primaryTextLabel,
                  label: widget.isSignIn
                      ? appLocalization.translate("createNewAccount")
                      : appLocalization.translate("tryToSignIn"),
                  onPressed: () {
                    widget.toggleSignInMode();
                  }),
            ],
          )
        ],
      ),
    );
  }
}
