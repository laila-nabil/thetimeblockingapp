import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.child,required this.onPressed})
      : super(key: key);
  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(onPressed: onPressed, child: child);
  }
}
