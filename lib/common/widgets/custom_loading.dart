import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay(
      {super.key, this.width = double.infinity, this.height = double.infinity});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.black12,
      alignment: Alignment.center,
      child: CustomLoading(color: Theme.of(context).primaryColor),
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
          color: color ?? Theme.of(context).primaryColor,
        ));
  }
}