// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
//
// class AuthVerification extends StatefulWidget {
//   const AuthVerification({super.key});
//
//   @override
//   State<AuthVerification> createState() => _AuthVerificationState();
// }
//
// class _AuthVerificationState extends State<AuthVerification> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.active) {
//             if (snapshot.hasData) {
//               User? user = snapshot.data;
//               if (user != null) {
//                 return const MainPage(); // Redirection directe vers MainPage
//               } else {
//                 return const Intro(); // Retour à la page d'intro si l'utilisateur est null
//               }
//             } else {
//               return const Intro(); // Retour à la page d'intro si pas de données
//             }
//           } else {
//             return const Center(child: CupertinoActivityIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
