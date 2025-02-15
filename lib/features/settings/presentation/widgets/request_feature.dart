import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgetbook.dart';
import 'package:thetimeblockingapp/common/widgets/custom_alert_dialog.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_text_input_field.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/request_feature_use_case.dart';
import 'package:thetimeblockingapp/features/settings/presentation/bloc/settings_bloc.dart';

Future<void> showRequestFeatureDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return CustomAlertDialog(
          loading: false,
          title: Text(appLocalization.translate("requestFeature")),
          actions: [
            CustomButton.noIcon(
              label: appLocalization.translate("cancel"),
              onPressed: () {
                context.pop();
              },
              type: CustomButtonType.greyTextLabel,
            ),
            CustomButton.noIcon(
              label: appLocalization.translate("send"),
              onPressed: () {
                BlocProvider.of<SettingsBloc>(context).add(RequestFeatureEvent(
                    RequestFeatureParams(
                        BlocProvider.of<AuthBloc>(context).state.user!,
                        featureDetails: controller.text)));
                Navigator.pop(context);
              },
              type: CustomButtonType.primaryLabel,
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextInputField(
                focusNode: FocusNode(),
                controller: controller,
                hintText: appLocalization.translate("featureDetails"),
                labelText: appLocalization.translate("featureRequest"),
                maxLines: 4,
              )
            ],
          ),
        );
      });
}
