import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lukafulu/pages/menu/repport.dart';
import 'package:lukafulu/widgets/app_text.dart';
import 'package:lukafulu/widgets/app_text_large.dart';
import 'package:lukafulu/widgets/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _name = '';
  String _email = '';
  List<dynamic> _incidents = [];
  String _error = '';
  bool _isLoading = true; // État de chargement

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchIncidents(); // Récupérer les incidents lors de l'initialisation de la page
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    final email = prefs.getString('email');

    setState(() {
      _name = name ?? 'Nom inconnu';
      _email = email ?? 'Email inconnu';
    });
  }

  Future<void> _fetchIncidents() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    print('ID utilisateur récupéré: $userId');

    if (userId != null) {
      final url = Uri.parse(
          'http://api-kinmap.tzedtech.com/api/v1/users/$userId/incidents');

      try {
        final response = await http.get(url, headers: {
          'Accept': 'application/json',
        });

        print('Réponse de l\'API: ${response.statusCode}');

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          print('Données de réponse: $responseData');

          if (responseData['data'] != null && responseData['data'].isNotEmpty) {
            setState(() {
              _incidents = responseData['data'];
              _error = '';
            });
          } else {
            setState(() {
              _error = responseData['message'] ??
                  'Aucun incident trouvé pour cet utilisateur.';
            });
          }
        } else {
          setState(() {
            _error =
                'Erreur lors de la récupération des incidents: ${response.statusCode} - ${response.reasonPhrase}';
          });
          print(
              'Erreur lors de la récupération: ${response.statusCode} - ${response.reasonPhrase}');
        }
      } catch (error) {
        setState(() {
          _error = 'Erreur de connexion : $error';
        });
        print('Erreur de connexion: $error');
      } finally {
        setState(() {
          _isLoading = false; // Mettre à jour l'état de chargement
        });
      }
    } else {
      setState(() {
        _error = 'Utilisateur non connecté.';
        _isLoading = false; // Mettre à jour l'état de chargement
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(CupertinoIcons.bell),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextLarge(
                text: "LUKAFULU",
                size: 45.0,
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: CupertinoTextField(
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Theme.of(context).colorScheme.onBackground),
                  placeholder: 'Search',
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Icon(CupertinoIcons.search),
                  ),
                  suffix: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Icon(CupertinoIcons.mic_solid),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading) ...[
                      Expanded(
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 80,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).highlightColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey,
                                    ),
                                    const Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 10,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          decoration: BoxDecoration(
                                            borderRadius: borderRadius,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          height: 10,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          decoration: BoxDecoration(
                                            borderRadius: borderRadius,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ] else if (_error.isNotEmpty) ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 200,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/null_data2.png'),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          AppText(
                              text: 'Aucune donnée',
                              textAlign: TextAlign.center),
                        ],
                      )
                    ] else ...[
                      Expanded(
                        child: ListView.builder(
                          itemCount: _incidents.length,
                          itemBuilder: (context, index) {
                            final incident = _incidents[index];

                            // Récupérer la première catégorie, ou renvoyer "Catégorie non disponible" si elle n'existe pas
                            String categoryTitle = (incident['categories'] !=
                                        null &&
                                    incident['categories'].isNotEmpty)
                                ? incident['categories'][0]['category_title']
                                : 'Catégorie non disponible';

                            return Container(
                              height: 80,
                              margin: const EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).highlightColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey,
                                    ),
                                    const Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(incident['incident_title'] ??
                                            'Titre non disponible'),
                                        SizedBox(height: 10),
                                        Text(
                                            categoryTitle), // Affiche la première catégorie ou un message d'absence
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Theme.of(context).colorScheme.background,
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.86,
                  child: ReportFormPage(
                    fetchIncidents:
                        _fetchIncidents, // Passer la fonction pour récupérer les incidents après le rapport
                  ),
                );
              },
            );
          },
          child: const Icon(CupertinoIcons.add_circled_solid),
        ),
      ),
    );
  }
}
