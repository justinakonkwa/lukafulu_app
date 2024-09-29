import 'dart:async';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:lukafulu/widgets/app_text.dart';
import 'package:lukafulu/widgets/bouton_next.dart';
import '../../widgets/constantes.dart';
import 'intro_page1.dart';
import 'intro_page2.dart';
import 'intro_page3.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final PageController _controller = PageController(initialPage: 0);

  List<Widget> introPages = [
    const IntroPage1(),
    const IntroPage2(),
    const IntroPage3(),
  ];
  int _currentPage = 0;
  bool last = false;

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      }
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 5000),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) => setState(() {
                last = (index == 2);
                _currentPage = index;
              }),
              children: introPages,
            ),
            Container(
              alignment: const Alignment(0, 0.75),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(introPages.length, (indexDots) {
                        return Container(
                          margin: const EdgeInsets.only(left: 1, right: 1),
                          width: _currentPage == indexDots ? 25 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: _currentPage == indexDots
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.3),
                          ),
                        );
                      }),
                    ),
                    last
                        ? NextButton(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/connexion', (route) => false);
                            },
                            child: AppText(
                              text: "START",
                            ),
                          )
                        : NextButton(
                            onTap: () => setState(() {
                              last = (_currentPage == 2);
                              _currentPage = _currentPage + 1;
                              _controller.animateToPage(
                                _currentPage,
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeInOut,
                              );
                            }),
                            child: Row(
                              children: [
                                AppText(
                                  text: 'NEXT',
                                ),
                                sizedbox2,
                                const Icon(
                                  FluentIcons.arrow_right_48_regular,
                                )
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
