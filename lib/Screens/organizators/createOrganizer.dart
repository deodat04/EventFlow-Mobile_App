// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:eventflow/Screens/organizators/homepageorganizer.dart';
import 'package:eventflow/Services/auth_Service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CreateOrg extends StatefulWidget {
  const CreateOrg({super.key});

  @override
  State<CreateOrg> createState() => _CreateOrgState();
}

class _CreateOrgState extends State<CreateOrg> {

  final CollectionReference _organizators = FirebaseFirestore.instance.collection("organisateurs");
  final AuthService _authService = AuthService();
  final profKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();

  final TextEditingController countryController = TextEditingController();

  final GlobalKey<FormBuilderState> birthKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text("Créer un profil organisateur"),
            backgroundColor: Colors.yellow,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Form(
                      key: profKey,
                      child: Column(
                        children: [
                          //Nom
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: usernameController,
                            decoration: InputDecoration(
                              hintText: "Tapez votre nom",
                              labelText: "Nom",
                            ),
                            validator: (String? value) {
                              return (value == null || value == "")
                                  ? "Ce champ est obligatoire"
                                  : null;
                            },
                          ),
                          //Prénom
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: cellphoneController,
                            decoration: InputDecoration(
                              hintText: "Tapez votre numéro de téléphone",
                              labelText: "Téléphone",
                            ),
                            validator: (String? value) {
                              return (value == null || value == "")
                                  ? "Ce champ est obligatoire"
                                  : null;
                            },
                          ),
                          
                        
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: countryController,
                            decoration: InputDecoration(
                              hintText:
                                  "Entrez votre pays", //d'au moins 8 caractères comportant des caractères spéciaux",
                              labelText: "pays",
                            ),
                            validator: (String? value) {
                              return (value == null || value == "")
                                  ? "Ce champ est obligatoire"
                                  : null;
                            },
                          ),
                          
                        ],
                      )),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (profKey.currentState!.validate()) {
                             

                              await _organizators.add({'username': usernameController.text,"cellphone": cellphoneController.text,"country": countryController.text, "userId":_authService.currentUser!.uid});  //create a new instance

                              usernameController.text = "";
                              countryController.text = "";
                              cellphoneController.text = "";

                              await Fluttertoast.showToast(
                                  msg: "Compte Organisateur créé avec succès",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.TOP,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.yellow,
                                  fontSize: 16.0);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreenOrganizer()),
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.yellow), // Couleur du bouton
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.black), // Couleur du texte
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                            ), // Espacement interne
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Bordure arrondie
                              ),
                            ),
                          ),
                          child: Text("Valider"))
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}