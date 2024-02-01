
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Screens/Bienvenu/createEvenement.dart';
import 'package:eventflow/Screens/Bienvenu/scanQR.dart';
import 'package:eventflow/Screens/admin/createAdmin.dart';
import 'package:eventflow/Services/auth_Service.dart';
import 'package:eventflow/main.dart';
import 'package:flutter/material.dart';


class OrgPage extends StatefulWidget {
 
  OrgPage({ super.key});

  @override
  State<OrgPage> createState() => _OrgPageState();
}

class _OrgPageState extends State<OrgPage> {

 late AuthService _authService;
  late FirestoreService _firestoreService;
  DocumentSnapshot<Object?>? _organisateur; // Change this to DocumentSnapshot<Object?>?

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _firestoreService = FirestoreService();
    _initializeAdmin();
  }

  Future<void> _initializeAdmin() async {
    _organisateur = await _firestoreService.getOrganizerByUserID("userId", _authService.currentUser!.uid);
    setState(() {
      // Update state variables here
    });
  }
  

  int _selectedIndex=0;

  void _redirectPage(int index){
    /*Doit rediriger sur une page en fonction de l'index
    Exemple:
    if(index==0){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>CreateOrg())
       );
      }*/
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Scaffold(
          appBar: AppBar(),
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
                       text: _organisateur != null && _organisateur!.exists
                      ? TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                          children: [
                            TextSpan(
                              text: "${(_organisateur!.data() as Map<String, dynamic>?)?['username'] ?? 'N/A'}\n",
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
                                  builder: (context) => CreateAdmin()))
                        ;
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
                          Text("Dévenir administrateur"),
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
                        /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListEvent()))*/
                        ;
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
                          Text("Mes événements"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),





            // const SizedBox(
            //     height: 10,
            //   ),





            //  Padding(
            //   padding: EdgeInsets.all(10.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Alignement des boutons sur l'horizontal
            //     children: <Widget>[
            //       Expanded( // Pour que le bouton s'adapte à la largeur de l'écran
            //         child: ElevatedButton(
            //           onPressed: () {
            //             // Navigator.push(
            //             //     context,
            //             //     MaterialPageRoute(
            //             //         builder: (context) => CreateEvent()));
            //           },
            //           style: ButtonStyle(
            //             backgroundColor: MaterialStateProperty.all<Color>(
            //                 Colors.yellow), // Couleur du bouton
            //             foregroundColor: MaterialStateProperty.all<Color>(
            //                 Colors.black), // Couleur du texte
            //             padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            //               EdgeInsets.symmetric(
            //                   horizontal: 10.0, vertical: 10.0),
            //             ), // Espacement interne
            //             shape: MaterialStateProperty.all<OutlinedBorder>(
            //               RoundedRectangleBorder(
            //                 borderRadius:
            //                     BorderRadius.circular(10.0), // Bordure arrondie
            //               ),
            //             ),
            //           ),
            //           child: Column(children: [
            //             Icon(Icons.add),
            //             Text("Créer un événement"),
            //           ]),
            //         ),
            //       ),
            //       SizedBox(
            //         width: 20.0,
            //       ),
            //       Expanded( // Pour que le bouton s'adapte à la largeur de l'écran
            //         child: ElevatedButton(
            //           onPressed: () {
            //             /*Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                       builder: (context) => ListEvent()))*/
            //             ;
            //           },
            //           style: ButtonStyle(
            //             backgroundColor: MaterialStateProperty.all<Color>(
            //                 Colors.yellow), // Couleur du bouton
            //             foregroundColor: MaterialStateProperty.all<Color>(
            //                 Colors.black), // Couleur du texte
            //             padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            //               EdgeInsets.symmetric(
            //                   horizontal: 10.0, vertical: 10.0),
            //             ), // Espacement interne
            //             shape: MaterialStateProperty.all<OutlinedBorder>(
            //               RoundedRectangleBorder(
            //                 borderRadius:
            //                     BorderRadius.circular(10.0), // Bordure arrondie
            //               ),
            //             ),
            //           ),
            //           child: Column(
            //             children: [
            //               Icon(
            //                 Icons.event,
            //               ),
            //               Text("Mes événements"),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),


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