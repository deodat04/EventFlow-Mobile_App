// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Screens/Bienvenu/bienvenu2.dart';
import 'package:eventflow/Screens/admin/homepageadmin.dart';
import 'package:eventflow/Screens/organizators/homepageorganizer.dart';
import 'package:eventflow/Screens/user/homepageuser.dart';
import 'package:eventflow/Services/auth_Service.dart';
import 'package:eventflow/main.dart';
import 'package:flutter/material.dart';
import 'package:eventflow/controller/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';






class Bienvenu4 extends StatefulWidget {
  const Bienvenu4({ Key? key }) : super(key: key);

  @override
  _Bienvenu4State createState() => _Bienvenu4State();
}

class _Bienvenu4State extends State<Bienvenu4> {

  
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor: Colors.black,

      body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                color: Colors.black,
                child: Column(
                  children: [
                    Container(

                      child: Image.asset("assets/Festival 1.png", width: screenWidth,height: 350, fit: BoxFit.cover),
                    ),
                    Container(
                      child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Text("EVENTFLOW",style: TextStyle(color: Colors.yellow, fontSize: 35,fontWeight: FontWeight.bold),),
                            SizedBox(height: 20,),
                            Text("Bienvenue sur EventFlow", style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                            SizedBox(height: 10,),
                            ElevatedButton.icon(
                              style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(
                                  color: Colors.yellow, // Specify the border color
                                  width: 2.0, // Specify the border width
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.black, // Specify the background color
                              ),
                            ),
                                onPressed:() async {
                                  final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                                  await provider.googleLogin();
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(builder: (context)=> MyApp())
                                  // );

                                  final AuthService _authService = AuthService();

                                  final FirestoreService _firestoreService = FirestoreService();
                                  DocumentSnapshot? isAdmin = await _firestoreService.getAdminByUserID("userId", _authService.currentUser!.uid);
                                  DocumentSnapshot? isOrganizer = await _firestoreService.getOrganizerByUserID("userId", _authService.currentUser!.uid);




                                  if (_authService.currentUser != null) {
                                    
                                 if(isAdmin!=null){

                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => const HomeScreenAdmin(),
                                  ));
                                  }
                                  else if(isOrganizer!=null){
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => const HomeScreenOrganizer(),
                                  ));
                                  }
                                  else{
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => const HomeScreenUser(),
                                  ));
                                  }
                                } else {
                                  // User is not signed in, show the login page
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => const Bienvenu2(),
                                  ));
                                }






                                  
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(builder: (context)=> EventScreen())
                                  // );
                                },

                                icon: FaIcon(FontAwesomeIcons.google),
                                label: Text("Continuez avec google", style: TextStyle(color: Colors.white, fontSize: 18)),
                            ),
                            SizedBox(height: 10,),
                          ]),

                    )
                  ],
                ),
              ),
            )
          )
      ),

    );
  }
}