import 'package:flutter/material.dart';

class CustomTextInputField extends StatelessWidget {
  const CustomTextInputField({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
    );
  }
}
