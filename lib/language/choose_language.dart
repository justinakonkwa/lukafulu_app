// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lukafulu/language/language_preferences.dart';

void showLanguagePopup({required BuildContext context}) {
  showMenu<String>(
    context: context,
    position: const RelativeRect.fromLTRB(100, 325.0, 20, 0),
    items: [
      PopupMenuItem<String>(
        value: 'en_US',
        child: Container(
          height: 40, // Hauteur de chaque élément du menu
          child: Center(
            child: Text(translate('language.en')), // Texte pour l'anglais
          ),
        ),
      ),
      PopupMenuItem<String>(
        value: 'fr',
        child: Container(
          height: 40, // Hauteur de chaque élément du menu
          child: Center(
            child: Text(translate('language.fr')), // Texte pour le français
          ),
        ),
      ),
    ],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey, width: 1),
    ),
    color: Theme.of(context).colorScheme.background,
  ).then((String? value) {
    if (value != null) {
      TranslatePreferences(value);
      changeLocale(context, value);
    }
  });
}
