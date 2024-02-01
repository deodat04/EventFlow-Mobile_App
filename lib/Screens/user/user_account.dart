


import 'package:eventflow/Screens/organizators/createOrganizer.dart';
import 'package:eventflow/Services/auth_Service.dart';
import 'package:eventflow/main.dart';
import 'package:flutter/material.dart';



class UserPage extends StatefulWidget {
  UserPage({ super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

late AuthService _authService;
  @override
  void initState() {
    super.initState();
    _authService = AuthService();
   
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
                      text: _authService.currentUser != null
                      ? TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                          children: [
                            TextSpan(
                              text: "${_authService.currentUser!.displayName ?? 'N/A'}\n",
                              // Replace 'username' with the actual attribute name
                            ),
                            // TextSpan(
                            //   text: "Pays: ${(_admin!.data() as Map<String, dynamic>?)?['country'] ?? 'N/A'}\n",
                            //   // Replace 'email' with the actual attribute name
                            // ),
                            // Add more TextSpans for other attributes
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
                                builder: (context) => CreateOrg()));//CreateOrg()
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
                        Text("Dévenir organisateur"),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded( // Pour que le bouton s'adapte à la largeur de l'écran
                    child: ElevatedButton(
                      onPressed: () async {
                            await  _authService.signOut();
                            await Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=> MyApp()));
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
                          Text("Déconnexion"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
             
           ]
             ),
           ),
          
          ),
      );
   }
}