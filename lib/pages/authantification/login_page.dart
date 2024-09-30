import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lukafulu/main_page.dart';
import 'package:lukafulu/pages/authantification/signup_page.dart';
import 'package:lukafulu/widgets/app_text.dart';
import 'package:lukafulu/widgets/app_text_large.dart';
import 'package:http/http.dart' as http;
import 'package:lukafulu/widgets/bouton_next.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool visibility = false;
  bool isLoading = false;

  Future<void> _loginUser() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://api-kinmap.tzedtech.com/api/v1/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      final responseData = json.decode(response.body);

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200 || responseData['status'] == 200) {
        // Connexion réussie
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connexion réussie!')),
        );
        final prefs = await SharedPreferences.getInstance();

        bool emailSaved = await prefs.setString('email', responseData['data']['user']['email']);
        bool nameSaved = await prefs.setString('name', responseData['data']['user']['name'] ?? '');
        bool userIdSaved = await prefs.setString('userId', responseData['data']['user']['id'].toString());

        // Afficher les logs
        print("Email sauvegardé : $emailSaved");
        print("Nom sauvegardé : $nameSaved");
        print("ID utilisateur sauvegardé : $userIdSaved");

        // Redirection vers la page principale
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        // Gérer les erreurs
        String errorMessage = responseData['message'] ?? 'Erreur de connexion. Veuillez réessayer.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Gérer les erreurs réseau
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de réseau. Veuillez réessayer.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 10),
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
                      text:  translate("login.signup"),
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 16,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CupertinoTextField(
                  controller: _emailController,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  placeholder: 'Email',
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Icon(CupertinoIcons.mail),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 40,
                  child: CupertinoTextField(
                    controller: _passwordController,
                    obscureText: !visibility,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    placeholder: 'password',
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Icon(CupertinoIcons.lock_shield),
                    ),
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          visibility = !visibility;
                        });
                      },
                      icon: Icon(
                        visibility
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                NextButton(
                  onTap: isLoading ? null : _loginUser,
                  child: isLoading
                      ? CupertinoActivityIndicator()
                      :  AppText(
                    text:  translate("login.signup"),
                    color: Theme.of(context).colorScheme.onBackground,
                  ),

                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    AppText(
                      text: translate("login.notHaveAccount"),
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return const SignUpPage();
                          },
                        );
                      },
                      child: AppText(
                        text: translate("login.signin"),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
