// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  NextButton({
    super.key,
    required this.onTap,
    required this.child,
    this.color,
    this.width,
    this.height,
    this.padding,
  });

  final void Function()? onTap;
  final Widget child;
  Color? color;
  double? width;
  double? height;
  final  padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        alignment: Alignment.center,
        width: width,
        height: height??50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //   color: Theme.of(context).colorScheme.secondary,
          // ),
          color: color ?? null,
        ),
        // padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }
}
