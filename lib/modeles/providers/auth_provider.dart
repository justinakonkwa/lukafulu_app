// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// class AuthProvider with ChangeNotifier {
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   // Fonction pour se connecter
//   Future<void> login(String email, String password) async {
//     _setLoading(true);
//
//     final url = Uri.parse('http://api-kinmap.tzedtech.com/api/v1/login');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'email': email, 'password': password}),
//     );
//
//     _setLoading(false);
//
//     if (response.statusCode == 200) {
//       // Connexion réussie
//       print("Connexion réussie !");
//
//       // Sauvegardez les informations utilisateur dans SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       final responseData = json.decode(response.body);
//       await prefs.setString('name', responseData['name'] ?? 'Nom inconnu');
//       await prefs.setString('email', responseData['email'] ?? 'Email inconnu');
//       await prefs.setString('token', responseData['token'] ?? ''); // Assurez-vous que votre réponse contient un token
//
//       notifyListeners();
//     } else {
//       // Gestion des erreurs
//       throw Exception('Échec de la connexion : ${response.body}');
//     }
//   }
//
//   Future<void> signup(String name, String email, String password) async {
//     _setLoading(true);
//
//     final url = Uri.parse('http://api-kinmap.tzedtech.com/api/v1/register');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'name': name, 'email': email, 'password': password}),
//     );
//
//     _setLoading(false);
//
//     if (response.statusCode == 201) {
//       // Inscription réussie
//       print("Inscription réussie !");
//
//       // Sauvegardez les informations utilisateur dans SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       final responseData = json.decode(response.body);
//       await prefs.setString('name', responseData['name'] ?? 'Nom inconnu');
//       await prefs.setString('email', responseData['email'] ?? 'Email inconnu');
//       await prefs.setString('token', responseData['token'] ?? ''); // Assurez-vous que votre réponse contient un token
//
//       notifyListeners();
//     } else {
//       // Gestion des erreurs
//       throw Exception('Échec de l\'inscription : ${response.body}');
//     }
//   }
//
//
//   // Fonction pour définir l'état de chargement
//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
// }
