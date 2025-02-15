import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/custom_alert_dialog.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_text_input_field.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/report_issue_use_case.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/settings_bloc.dart';

Future<void> showReportIssueDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      TextEditingController controller = TextEditingController();
      return CustomAlertDialog(
        loading: false,
        title: Text(appLocalization.translate("reportIssue")),
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
                BlocProvider.of<SettingsBloc>(context).add(ReportIssueEvent(
                    ReportIssueParams(
                        BlocProvider.of<AuthBloc>(context).state.user!,
                        issueDetails: controller.text)));
                context.pop();
              },
              type: CustomButtonType.primaryLabel,
            ),
          ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextInputField(
              focusNode: FocusNode(),
              hintText: appLocalization.translate("issueDetails"),
              labelText: appLocalization.translate("issue"),
              maxLines: 4,
              controller:controller,
            )
          ],
        ),
      );
    }
  );
}
