import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';



class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay(
      {super.key,
      this.width = double.infinity,
      this.height = double.infinity,
      required this.color});
  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: CustomLoading(color: color ),
    );
  }
}

class CustomLoading extends StatelessWidget {
  const CustomLoading(
      {super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      color: color ??
          (context.isDarkMode
              ? AppColors.primary(context.isDarkMode, 50)
              : AppColors.primary(context.isDarkMode)),
    ));
  }
}