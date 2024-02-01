
// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Screens/user/homepageuser.dart';
import 'package:eventflow/Services/auth_Service.dart';
import 'package:eventflow/controller/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eventflow/widgets/deodat/widgets/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:eventflow/Screens/Bienvenu/bienvenu1.dart';
import 'package:eventflow/Screens/Bienvenu/bienvenu2.dart';
import 'firebase_options.dart';
import "package:eventflow/Screens/admin/homepageadmin.dart";
import "package:eventflow/Screens/organizators/homepageorganizer.dart";

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        // Other providers if any
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   final AuthService _authService = AuthService();

   final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), ()async {
      if (_authService.currentUser != null) {
        DocumentSnapshot? isAdmin = await _firestoreService.getAdminByUserID("userId", _authService.currentUser!.uid);
        DocumentSnapshot? isOrganizer = await _firestoreService.getOrganizerByUserID("userId", _authService.currentUser!.uid);
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
        
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Bienvenu2(),
        ));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  Bienvenu1()
    );

  }
}






