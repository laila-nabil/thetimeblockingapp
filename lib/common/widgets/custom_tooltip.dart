import 'package:flutter/material.dart';

class CustomToolTip extends StatelessWidget {
  const CustomToolTip({super.key, this.message, required this.child});
  final String? message;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Tooltip(message: message??"",child: child,);
  }
}
