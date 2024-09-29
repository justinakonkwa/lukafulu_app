import 'package:flutter/material.dart';
import 'package:lukafulu/generated/assets.dart';
import 'package:lukafulu/widgets/app_text_large.dart';
import 'package:lukafulu/widgets/constantes.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    List images = [
      Assets.introIntro8,
      Assets.introIntro5,
      Assets.introIntro8,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        image: DecorationImage(
                            image: AssetImage(images[0]), fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20, bottom: 20),
                        height: MediaQuery.of(context).size.height * 0.22,
                        width: MediaQuery.of(context).size.width / 2.7,
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          image: DecorationImage(
                              image: AssetImage(images[1]), fit: BoxFit.fill),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 20),
                          width: MediaQuery.of(context).size.width / 2.7,
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
              text: 'Trouvez votre prochain chez-vous',
              size: 20,
            ),
            sizedbox,
            sizedbox,
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.6,
              child: const Text(
                'Explorez une large sélection de propriétés à louer dans les meilleurs quartiers.',
                style: const TextStyle(
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
