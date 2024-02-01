
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Screens/Bienvenu/createEvenement.dart';
import 'package:eventflow/Screens/Bienvenu/scanQR.dart';
import 'package:eventflow/Screens/admin/eventNotValidated.dart';
import 'package:eventflow/Screens/admin/users.dart';
import 'package:eventflow/Services/auth_Service.dart';
import 'package:eventflow/main.dart';
import 'package:flutter/material.dart';

//import 'CreateOrg.dart';



class AdminPage extends StatefulWidget {
  AdminPage({ super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

late AuthService _authService;
  late FirestoreService _firestoreService;
  DocumentSnapshot<Object?>? _admin; // Change this to DocumentSnapshot<Object?>?

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _firestoreService = FirestoreService();
    _initializeAdmin();
  }

  Future<void> _initializeAdmin() async {
    _admin = await _firestoreService.getAdminByUserID("userId", _authService.currentUser!.uid);
    setState(() {
      // Update state variables here
    });
  }
  

 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Scaffold(
          // appBar: AppBar(),
          body: SingleChildScrollView(
              child: Column(
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.grey,
                child:Image.network(_authService.currentUser!.photoURL.toString()),
              ),
              const SizedBox(
                height: 20.0,
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: _admin != null && _admin!.exists
                      ? TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                          children: [
                            TextSpan(
                              text: "${(_admin!.data() as Map<String, dynamic>?)?['username'] ?? 'N/A'}\n",
                              // Replace 'username' with the actual attribute name
                            ),
                          ],
                        )
                      : TextSpan(
                          text: 'Loading...', // Placeholder text while data is loading or not available
                        ),
                      )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),






              Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Alignement des boutons sur l'horizontal
                children: <Widget>[
                  Expanded( // Pour que le bouton s'adapte à la largeur de l'écran
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateEvent()));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.yellow), // Couleur du bouton
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.black), // Couleur du texte
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                        ), // Espacement interne
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Bordure arrondie
                          ),
                        ),
                      ),
                      child: Column(children: [
                        Icon(Icons.add),
                        Text("Créer un événement"),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded( // Pour que le bouton s'adapte à la largeur de l'écran
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventToValidate()));
                        
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.yellow), // Couleur du bouton
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.black), // Couleur du texte
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                        ), // Espacement interne
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Bordure arrondie
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.event,
                          ),
                          Text("Valider les évènements"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

             SizedBox(
                height: 10.0,
              ),






              Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Alignement des boutons sur l'horizontal
                children: <Widget>[
                  Expanded( // Pour que le bouton s'adapte à la largeur de l'écran
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScanQR()));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.yellow), // Couleur du bouton
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.black), // Couleur du texte
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                        ), // Espacement interne
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Bordure arrondie
                          ),
                        ),
                      ),
                      child: Column(children: [
                        Icon(Icons.add),
                        Text("Scanner un QR"),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded( // Pour que le bouton s'adapte à la largeur de l'écran
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserListScreen()));
                        
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.yellow), // Couleur du bouton
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.black), // Couleur du texte
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                        ), // Espacement interne
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Bordure arrondie
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.event,
                          ),
                          Text("Votre Profil User"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
              const SizedBox(
                height: 10,
              ),

            // Deconnexion

            Padding(
            padding: EdgeInsets.all(10.0),
            child: SizedBox( // Définir une largeur spécifique au bouton
              width: MediaQuery.of(context).size.width * 0.6, // Utiliser 60% de la largeur de l'écran
              child: ElevatedButton(
                onPressed: () async{
                  // Action à effectuer lorsque le bouton est pressé
                 await  _authService.signOut();
                  await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=> MyApp())
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.yellow), // Couleur du bouton
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black), // Couleur du texte
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                  ), // Espacement interne
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Bordure arrondie
                    ),
                  ),
                ),
                child: Column(children: [
                  Icon(Icons.add),
                  Text("Déconnexion"),
                ]),
              ),
            ),
          ),

              ]
             ),
           ),
          ),
      );
   }
}