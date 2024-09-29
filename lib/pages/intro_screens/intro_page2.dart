// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:lukafulu/widgets/app_text_large.dart';
import 'package:lukafulu/widgets/constantes.dart';
import '../../generated/assets.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    List images = [
      Assets.introIntro7,
      Assets.introIntro3,
      Assets.introIntro2,
    ];
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          bottom: MediaQuery.of(context).size.height * 0.08,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        image: DecorationImage(
                            image: AssetImage(images[0]), fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: borderRadius,
                            image: DecorationImage(
                                image: AssetImage(images[1]), fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 20, top: 20),
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: borderRadius,
                            image: DecorationImage(
                                image: AssetImage(images[2]), fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            sizedbox,
            sizedbox,
            sizedbox,
            sizedbox,
            AppTextLarge(
              text: 'Nos services immobiliers',
              size: 20.0,
            ),
            sizedbox,
            sizedbox,
            Container(
              width: MediaQuery.of(context).size.width / 1.6,
              child: Text(
                'Explorez nos offres spéciales pour trouver la solution qui vous convient',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  letterSpacing: 0,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TypewriterAnimation extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  TypewriterAnimation({
    required this.text,
    required this.style,
    required this.duration,
  });

  @override
  _TypewriterAnimationState createState() => _TypewriterAnimationState();
}

class _TypewriterAnimationState extends State<TypewriterAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _textAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _textAnimation = IntTween(begin: 0, end: widget.text.length)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, child) {
        String animatedText = widget.text.substring(0, _textAnimation.value);

        return Text(
          animatedText,
          style: widget.style,
        );
      },
    );
  }
}
