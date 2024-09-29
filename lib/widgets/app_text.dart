import 'package:flutter/material.dart';

// class du widget qui possede le text en normal et la police normale pour la plus par des texts dans l'apps
// ignore: must_be_immutable
class AppText extends StatelessWidget {
  AppText({
    Key? key,
    this.color,
    this.textAlign,
    required this.text,
  }) : super(key: key);
  final String? text;
  Color? color ;
  TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
        fontFamily: 'Outfit',
        letterSpacing: 0,
        color: color,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal,
      ),
      textAlign: textAlign,

    );
  }
}