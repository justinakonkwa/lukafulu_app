import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:lukafulu/main_page.dart';
import 'package:lukafulu/widgets/app_text.dart';
import 'package:lukafulu/widgets/app_text_large.dart';
import 'package:lukafulu/widgets/bouton_next.dart';
import 'package:lukafulu/widgets/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportFormPage extends StatefulWidget {
  final Function fetchIncidents;
  ReportFormPage({required this.fetchIncidents});

  @override
  _ReportFormPageState createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<ReportFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _location = '';
  List<Map<String, dynamic>> _categories =
      []; // Catégories sous forme de Map avec 'id' et 'title'
  List<Map<String, dynamic>> _nuisances =
      []; // Nuisances sous forme de Map avec 'id' et 'name'
  List<String> _situations = []; // Situations sous forme de liste de chaînes
  List<int> _selectedCategories = []; // Sélection des ID de catégories
  List<int> _selectedNuisances = []; // Sélection des ID de nuisances
  List<String> _selectedSituations = []; // Sélection des situations
  List<XFile> _images = []; // Liste pour stocker les images
  String? _userId;
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchSituations();
    fetchNuisances();
    _getUserId(); // Récupération de l'ID utilisateur
  }

  // Récupération de l'ID utilisateur depuis SharedPreferences
  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Renvoie l'ID ou null
  }

  // Récupération des catégories
  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('http://api-kinmap.tzedtech.com/api/v1/report/categories'),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['data'] is List) {
          setState(() {
            _categories = List<Map<String, dynamic>>.from(responseData['data']);
          });
        }
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  // Récupération des situations
  Future<void> fetchSituations() async {
    try {
      final response = await http.get(
        Uri.parse('http://api-kinmap.tzedtech.com/api/v1/report/situations'),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['data']['values'] is List) {
          setState(() {
            _situations = List<String>.from(responseData['data']['values']);
          });
        }
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  // Récupération des nuisances
  Future<void> fetchNuisances() async {
    try {
      final response = await http.get(
        Uri.parse('http://api-kinmap.tzedtech.com/api/v1/report/nuisances'),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['data'] is List) {
          setState(() {
            _nuisances = List<Map<String, dynamic>>.from(responseData['data']);
          });
        }
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  Future<void> _submitForm() async {
    _formKey.currentState?.save();

    if (_formKey.currentState?.validate() ?? false) {
      // Vérifications pour s'assurer que les champs sont remplis
      if (_title.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Le titre est requis.')),
        );
        return;
      }

      if (_images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veuillez sélectionner au moins une image.')),
        );
        return;
      }

      if (_selectedCategories.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Veuillez sélectionner au moins une catégorie.')),
        );
        return;
      }

      if (_selectedSituations.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Veuillez sélectionner au moins une situation.')),
        );
        return;
      }

      if (_selectedNuisances.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Veuillez sélectionner au moins une nuisance.')),
        );
        return;
      }

      // Récupérer l'ID de l'utilisateur
      _userId = await _getUserId(); // Assurez-vous d'attendre le résultat
      print('ID utilisateur récupéré : $_userId'); // Débogage de l'ID

      // Si vous souhaitez aussi traiter les incidents sans ID utilisateur
      if (_userId == null || _userId!.isEmpty) {
        // Optionnel : afficher un message ou gérer le cas
        print('Aucun ID utilisateur trouvé, soumission sans ID.');
      }

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://api-kinmap.tzedtech.com/api/v1/report/submit'),
        );

        // Ajout des champs au formulaire
        request.fields['title'] = _title;
        request.fields['latitude'] = _latitude.toString();
        request.fields['longitude'] = _longitude.toString();
        request.fields['location'] = _location;
        request.fields['user_id'] =
            _userId ?? ''; // Utilisez l'ID utilisateur ou une chaîne vide

        // Ajout des listes de catégories, situations et nuisances
        request.fields['categories[]'] = jsonEncode(_selectedCategories);
        request.fields['situations[]'] = jsonEncode(
            _selectedSituations.map((situation) => situation.trim()).toList());
        request.fields['nuisances[]'] = jsonEncode(_selectedNuisances);

        // Ajout des images
        for (var image in _images) {
          if (image.path.endsWith('.jpg') ||
              image.path.endsWith('.jpeg') ||
              image.path.endsWith('.png') ||
              image.path.endsWith('.gif')) {
            var file =
                await http.MultipartFile.fromPath('images[]', image.path);
            request.files.add(file);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Format de fichier non valide pour ${image.path}')),
            );
            return; // Sortez si un fichier n'est pas valide
          }
        }

        // Imprimer les données à envoyer
        print('Données à envoyer :');
        print('Titre: $_title');
        print('Latitude: $_latitude');
        print('Longitude: $_longitude');
        print('Localisation: $_location');
        print('Catégories: ${jsonEncode(_selectedCategories)}');
        print('Situations: ${jsonEncode(_selectedSituations)}');
        print('Nuisances: ${jsonEncode(_selectedNuisances)}');
        print('Images: ${_images.map((img) => img.path).toList()}');
        print('User ID: $_userId');

        final response = await request.send();

        // Récupération de la réponse
        final responseData = await http.Response.fromStream(response);

        // Imprimer la réponse de l'API
        print('Réponse de l\'API : ${responseData.body}');

        if (responseData.statusCode == 200 || responseData.statusCode == 201) {
          final responseJson = jsonDecode(responseData.body);

          // Vérifiez si le message existe avant d'y accéder
          if (responseJson.containsKey('message')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Message : ${responseJson['message']}')),
            );
          }

          // Utiliser le code de succès renvoyé par l'API
          if (responseJson['status'] == 201) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Rapport soumis avec succès !')),
            );

            // Appeler la fonction pour récupérer les incidents
            widget.fetchIncidents();

            // Naviguer vers la page principale après la soumission
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Erreur lors de la soumission : ${responseJson['message']}')),
            );
            print("---------------${responseJson['message']}");
          }
        } else {
          print("---------------*******${responseData.reasonPhrase}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erreur lors de la soumission : ${responseData.reasonPhrase}')),
          );
        }
      } catch (e) {
        print('Erreur de connexion : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion : $e')),
        );
      }
    }
  }

  // Sélection des images
  Future<void> _pickImage() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _images.addAll(selectedImages);
      });
    }
  }

  // Construction de la page
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: 8.0,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: Colors.grey,
                ),
              ),
              sizedbox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTextLarge(text: 'AJOUT  RAPPORT',size: 16,),
                      GestureDetector(
                        onTap: (){
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
                  // Titre
                  _buildTextField(
                    'Titre',
                    CupertinoIcons
                        .textformat, // Ici vous spécifiez l'icône (par exemple, un crayon)
                    (value) {
                      _title =
                          value; // Assurez-vous que la valeur est bien assignée
                    },
                  ),
                  sizedbox,
                  sizedbox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: _buildTextField(
                          'Latitude',
                          CupertinoIcons.location,
                          (value) {
                            _latitude = double.tryParse(value) ?? 0.0;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: _buildTextField(
                            'Longitude', CupertinoIcons.location_solid,
                            (value) {
                          _longitude = double.tryParse(value) ?? 0.0;
                        }),
                      ),
                    ],
                  ),
                  sizedbox,
                  sizedbox,
                  _buildTextField('Localisation', CupertinoIcons.map, (value) {
                    _location = value;
                  }),
                  sizedbox,

                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.all(
                          0), // Optionnel : pour supprimer le remplissage

                      title: Container(
                        padding: EdgeInsets.only(left: 12.0),
                        alignment: Alignment.centerLeft,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          border: Border.all(
                            color: Theme.of(context).highlightColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.security),
                            sizedbox2,
                            sizedbox2,
                            AppText(
                              text: 'Catégories',
                            ),
                          ],
                        ),
                      ),
                      children: _categories.map((category) {
                        return CheckboxListTile(
                          title: Text(category['category_title']),
                          value: _selectedCategories.contains(category['id']),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedCategories.add(category['id']);
                              } else {
                                _selectedCategories.remove(category['id']);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.all(
                          0), // Optionnel : pour supprimer le remplissage

                      title: Container(
                        padding: EdgeInsets.only(left: 12.0),
                        alignment: Alignment.centerLeft,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          border: Border.all(
                            color: Theme.of(context).highlightColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline),
                            sizedbox2,
                            sizedbox2,
                            AppText(
                              text: 'Situations',
                            ),
                          ],
                        ),
                      ),
                      children: _situations.map((situation) {
                        return CheckboxListTile(
                          title: Text(situation),
                          value: _selectedSituations.contains(situation),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedSituations.add(situation);
                              } else {
                                _selectedSituations.remove(situation);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      collapsedBackgroundColor: Colors.transparent,
                      tilePadding: EdgeInsets.all(
                          0), // Optionnel : pour supprimer le remplissage
                      title: Container(
                        height: 40, // Hauteur fixe de 40 pixels
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 12.0),
                          alignment: Alignment.centerLeft,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: borderRadius,
                              border: Border.all(
                                color: Theme.of(context).highlightColor,
                              )),
                          child: Row(
                            children: [
                              Icon(Icons.local_florist_outlined),
                              sizedbox2,
                              sizedbox2,
                              AppText(
                                text: 'Nuisances',
                              ),
                            ],
                          ),
                        ),
                      ),
                      children: _nuisances.map((nuisance) {
                        return CheckboxListTile(
                          title: Text(nuisance['field_name']),
                          value: _selectedNuisances.contains(nuisance['id']),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedNuisances.add(nuisance['id']);
                              } else {
                                _selectedNuisances.remove(nuisance['id']);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  sizedbox,

                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        child: Icon(Icons.warning),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          border: Border.all(
                            color: Theme.of(context).highlightColor,
                          ),
                        ),
                      ),
                      sizedbox2,
                      sizedbox2,
                      Flexible(
                        flex: 2,
                        child: AppText(
                          text:
                              'Ajouter une ou plusieurs image pour une bonne visibilié',
                        ),
                      ),
                    ],
                  ),
                  sizedbox,
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).highlightColor,
                          ),
                          borderRadius: borderRadius),
                      child: const Icon(
                        Icons.add_a_photo_outlined,
                        size: 50,
                      ),
                    ),
                  ),

                  Wrap(
                    spacing: 8.0,
                    children: _images.map((image) {
                      return Image.file(
                        File(image.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  ),

                  // Soumission du formulaire
                  SizedBox(height: 20),
                  NextButton(
                    onTap: _submitForm,
                    child: AppText(text: 'Soumettre'),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  CupertinoTextField _buildTextField(
      String label, IconData icon, Function(String) onSaved) {
    return CupertinoTextField(
      placeholder: label,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).highlightColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      onChanged: (value) {
        if (value.isNotEmpty) {
          onSaved(value);
        }
      },
      prefix: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Icon(icon), // Utilisation correcte de `icon` de type `IconData`
      ),
    );
  }

// Fonction pour générer les champs texte
  // TextFormField _buildTextField(String label, Function(String) onSaved) {
  //   return
  //
  //
  //
  //     TextFormField(
  //     decoration: InputDecoration(labelText: label),
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return 'Veuillez entrer une valeur';
  //       }
  //       return null;
  //     },
  //     onSaved: (value) => onSaved(value!),
  //   );
  // }
}
