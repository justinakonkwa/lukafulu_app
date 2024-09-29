import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lukafulu/main_page.dart';
import 'package:lukafulu/pages/authantification/login_page.dart';
import 'package:lukafulu/pages/menu/chatpage.dart';
import 'package:lukafulu/widgets/app_text.dart';
import 'package:lukafulu/widgets/app_text_large.dart';
import 'package:lukafulu/widgets/bouton_next.dart';
import 'package:lukafulu/widgets/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(); // Changement ici
  final TextEditingController _passwordController = TextEditingController();
  bool visibility = false;
  bool isLoading = false;

  Future<void> _registerUser() async {
    print("Début de l'inscription de l'utilisateur...");

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://api-kinmap.tzedtech.com/api/v1/register');

    print("Données envoyées :");
    print({
      'email': _emailController.text,
      'password': _passwordController.text,
      'name': _nameController.text,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': _emailController.text,
        'password': _passwordController.text,
        'name': _nameController.text,
      }),
    );

    setState(() {
      isLoading = false;
    });

    print("Réponse du serveur : ${response.statusCode}");
    print("Corps de la réponse : ${response.body}");

    final responseData = json.decode(response.body);

    if (response.statusCode == 201 || responseData['status'] == 201) {
      // Inscription réussie
      final prefs = await SharedPreferences.getInstance();
      bool emailSaved = await prefs.setString('email', responseData['data']['user']['email']);
      bool nameSaved = await prefs.setString('name', responseData['data']['user']['name'] ?? '');

      // Convert user ID to String before saving
      bool userIdSaved = await prefs.setString('userId', responseData['data']['user']['user_id'].toString());

      print("Email sauvegardé : $emailSaved");
      print("Nom sauvegardé : $nameSaved");
      print("ID utilisateur sauvegardé : $userIdSaved"); // Log user ID save status

      print("Inscription réussie !");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inscription réussie!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (response.statusCode == 422) {
      // Gérer les erreurs de validation ici
      print("Erreur de validation.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur dans le formulaire. Veuillez réessayer.')),
      );
    } else {
      // Autres erreurs (codes 500, etc.)
      print("Erreur serveur !");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur du serveur. Veuillez réessayer plus tard.'),
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1.0,
              ),
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: 10, bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 8,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        Row(
                          children: [
                            AppTextLarge(
                              text: translate("connexion.signup"),
                              color: Theme.of(context).colorScheme.onBackground,
                              size: 16,
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                        sizedbox,
                        sizedbox,
                        SizedBox(
                          height: 40,
                          child: CupertinoTextField(
                            controller: _nameController,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            // keyboardType: TextInputType.phone,
                            placeholder: 'Entrer your name',
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefix: const Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Icon(CupertinoIcons.person),
                            ),
                          ),
                        ),
                        sizedbox,
                        sizedbox,
                        SizedBox(
                          height: 40,
                          child: CupertinoTextField(
                            controller: _emailController,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            keyboardType: TextInputType.name,
                            placeholder: 'Phone Number',
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefix: const Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Icon(CupertinoIcons.phone),
                            ),
                          ),
                        ),
                        sizedbox,
                        sizedbox,
                        SizedBox(
                          height: 40,
                          child: CupertinoTextField(
                            controller: _passwordController,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            obscureText: visibility,
                            // keyboardType: TextInputType.phone,
                            placeholder: 'Password',
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefix: const Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: Icon(CupertinoIcons.lock_shield),
                            ),
                            suffix: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    visibility = !visibility;
                                  });
                                },
                                icon: visibility
                                    ? const Icon(
                                        CupertinoIcons.eye,
                                      )
                                    : const Icon(
                                        CupertinoIcons.eye_slash,
                                      ),
                              ),
                            ),
                            onEditingComplete: () {},
                          ),
                        ),
                        sizedbox,
                        sizedbox,
                        NextButton(
                          color: Colors.red,
                          width: double.maxFinite,
                          onTap: () {
                            if (_nameController.text.isNotEmpty &&
                                _emailController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty) {
                              _registerUser();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Veuillez remplir tous les champs.')),
                              );
                            }
                          },
                          child: isLoading
                              ? CupertinoActivityIndicator(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                )
                              : AppText(
                                  text: translate("connexion.signup"),
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                        ),
                        Row(
                          children: [
                            AppText(
                                text: translate("connexion.compte"),
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return const LoginPage();
                                  },
                                );
                              },
                              child: AppText(
                                text: translate("connexion.login"),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
