import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';

import 'custom_loading.dart';

Future showDialogOrBottomSheet({
  required BuildContext context,
  required CustomAlertDialog Function(BuildContext context) builder,
  bool isDismissible = true}) async {
  if (context.showSmallDesign) {
    return showModalBottomSheet(
      isScrollControlled: true,
        isDismissible: isDismissible, context: context, builder: (ctx){
        var customAlertDialog = builder(ctx);
        return SafeArea(
          minimum: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.x3Big32.value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(vertical:AppSpacing.medium16.value),
                      child: customAlertDialog.title ?? const SizedBox(),
                    ),
                    customAlertDialog.content??const SizedBox(),
                  SizedBox(height: AppSpacing.xSmall8.value,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical:AppSpacing.xSmall8.value),
                    alignment: AlignmentDirectional.centerEnd,
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      runAlignment: WrapAlignment.end,
                      spacing: AppSpacing.xSmall8.value,
                      children: customAlertDialog.actions ?? [],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
    });
  }
  return showDialog(
      barrierDismissible: isDismissible, context: context, builder: builder);
}

//since responsiveScaffoldLoading overlayLoading does not cover a pop up
class CustomAlertDialog extends AlertDialog {
  const CustomAlertDialog({
    super.key,
    required this.loading,
    super.icon,
    super.iconColor,
    super.iconPadding,
    super.title,
    super.titlePadding,
    super.titleTextStyle,
    super.content,
    super.contentPadding,
    super.contentTextStyle,
    super.actions,
    super.actionsPadding,
    super.actionsAlignment,
    super.actionsOverflowAlignment,
    super.actionsOverflowDirection,
    super.actionsOverflowButtonSpacing,
    super.buttonPadding,
    super.backgroundColor,
    super.elevation,
    super.shadowColor,
    super.surfaceTintColor,
    super.semanticLabel,
    super.insetPadding,
    super.clipBehavior,
    super.shape,
    super.alignment,
    super.scrollable,
  });
  ///[loading] in case loading is from Bloc's state,
  ///[CustomAlertDialog] must be wrapped with BlocBuilder and state.isLoading is passed
  final bool loading;

  @override
  Widget? get content {
    if (super.content == null) {
      return null;
    } else {
      if (loading) {
        printDebug("alert loading");
        return const CustomLoading();
      } else {
        printDebug("alert not loading");
        return super.content!;
      }
    }
  }
}
