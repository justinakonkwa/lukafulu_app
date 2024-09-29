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
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/null_data2.png'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
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

                            String incidentDate =
                                incident['incident_date'] ?? '';
                            String formattedDate = 'Date non disponible';

                            if (incidentDate.isNotEmpty) {
                              try {
                                DateTime parsedDate =
                                    DateTime.parse(incidentDate);
                                formattedDate = DateFormat('dd-MM-yyyy à HH:mm')
                                    .format(parsedDate);
                              } catch (e) {
                                print('Erreur de format de date: $e');
                              }
                            }

                            return GestureDetector(
                              onTap: () {
                                showIncidentDetails(context, incident);
                              },
                              child: Container(
                                height: 80,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).highlightColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey,
                                        child: AppTextLarge(
                                            text: incident['incident_title']
                                                [0]),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                              text:
                                                  incident['incident_title'] ??
                                                      'Titre non disponible'),
                                          AppText(text: formattedDate),
                                        ],
                                      ),
                                      Spacer(),
                                      Icon(CupertinoIcons.arrow_right_circle),
                                    ],
                                  ),
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

void showIncidentDetails(BuildContext context, Map<String, dynamic> incident) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      final String title = incident['incident_title'] ?? 'Titre non disponible';
      final String description =
          incident['incident_description'] ?? 'Description non disponible';
      final String incidentDate = incident['incident_date'] != null
          ? DateTime.parse(incident['incident_date'])
              .toLocal()
              .toString()
              .split(' ')[0] // Formatage de la date
          : 'Date non disponible';

      // Récupération des catégories
      final List<dynamic> categories = incident['categories'] ?? [];
      // Récupération des nuisances
      final List<dynamic> nuisances = incident['nuisances'] ?? [];
      // Récupération des situations
      final Map<String, dynamic> situations = incident['situations'] ?? {};

      return Container(
        padding: EdgeInsets.only(left: 15.0,right: 15.0,bottom: 30,top: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 8.0,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTextLarge(text: 'Detail Incident'),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                  ),
                )
              ],
            ),

            sizedbox,
            sizedbox,
            AppText(
              text: title,
            ),
            SizedBox(height: 8),
            SizedBox(height: 8),
            Text(
              'Date de l\'incident : $incidentDate',
            ),
            SizedBox(height: 16),
            Row(

              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: Icon(Icons.check_circle_outline),
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: Theme.of(context).highlightColor,
                    ),
                  ),
                ),
                sizedbox2,
                AppTextLarge(text: 'Situations :',size: 16,),
              ],
            ),
            if (situations.isNotEmpty) ...[
              Text(
                  '1. ${situations['form_response'] ?? 'Réponse non disponible'}'), // Numéroter la situation
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Aucune situation disponible.'),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: Icon(Icons.security),
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: Theme.of(context).highlightColor,
                    ),
                  ),
                ),
                sizedbox2,
                AppTextLarge(text:'Catégories :',size: 16 ),
              ],
            ),
            if (categories.isNotEmpty)
              ...categories.asMap().entries.map((entry) {
                int index = entry.key + 1; // Numéroter à partir de 1
                var category = entry.value;
                return Text(
                    '$index. ${category['category_title'] ?? 'Catégorie non disponible'}');
              }).toList()
            else ...[
              Text('Aucune catégorie disponible.'),
            ],
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: Icon(Icons.local_florist_outlined),
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: Theme.of(context).highlightColor,
                    ),
                  ),
                ),
                sizedbox2,
                AppTextLarge(text:'Nuisances :',size: 16,),
              ],
            ),
            if (nuisances.isNotEmpty)
              ...nuisances.asMap().entries.map((entry) {
                int index = entry.key + 1; // Numéroter à partir de 1
                var nuisance = entry.value;
                return Text(
                    '$index. ${nuisance['form_response'] ?? 'Nuisance non disponible'}');
              }).toList()
            else ...[
              Text('Aucune nuisance disponible.'),
            ],
          ],
        ),
      );
    },
  );
}
