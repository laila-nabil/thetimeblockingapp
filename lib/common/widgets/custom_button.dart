import 'package:flutter/material.dart';

enum CustomButtonEnum { primary, secondary }

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.customButtonEnum = CustomButtonEnum.primary})
      : super(key: key);
  final Widget child;
  final void Function()? onPressed;
  final CustomButtonEnum customButtonEnum;

  @override
  Widget build(BuildContext context) {
    if (customButtonEnum == CustomButtonEnum.secondary) {
      return OutlinedButton(onPressed: onPressed, child: child);
    }
    return FilledButton(onPressed: onPressed, child: child);
  }
}
