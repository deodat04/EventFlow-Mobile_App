
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Screens/Bienvenu/bienvenu2.dart';
import 'package:eventflow/Screens/Bienvenu/notifications.dart';
import 'package:eventflow/Screens/admin/homepageadmin.dart';
import 'package:eventflow/Screens/organizators/homepageorganizer.dart';
import 'package:eventflow/Screens/user/homepageuser.dart';
import 'package:eventflow/Services/auth_Service.dart';
import 'package:eventflow/widgets/deodat/widgets/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:eventflow/Model/event.dart';



class TicketQRPage extends StatelessWidget {
  final Event event;
  

  TicketQRPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color(0xFF252323),
      appBar: AppBar(
        title: const Text("Votre identifiant QR"),
        backgroundColor: Colors.blue,
       




         actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color:  Color(0xFF252323),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PageNotification()),
                  );
                  Provider.of<NotificationProvider>(context, listen: false)
                      .marquerToutesCommeLues();
                },
              ),
              if (Provider.of<NotificationProvider>(context)
                      .nombreNotificationsNonLues >
                  0)
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Text(
                      Provider.of<NotificationProvider>(context)
                          .nombreNotificationsNonLues
                          .toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],


      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                event.name,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFF40),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35.0),
              QrImageView(
                data: event.key,
                version: QrVersions.auto,
                size: 200,
                foregroundColor: Colors.white,
              ),
              const SizedBox(height: 40.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: Color(0xFFFFFF40),
                  ),
                  const SizedBox(width: 1),
                  Text(
                    event.location,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    event.date,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 
                  Text(
                    '${event.time} heures',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Material(
                color: const Color(0xFF252323),
                borderRadius: BorderRadius.circular(10.0),
                child: Center(
                  child: Text(
                    'Votre code Qr est également disponible sur votre adresse mail. Merci pour votre confiance !',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                    color: Color(0xFFFFFF40),
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Material(
                color: const Color(0xFFFFFF40),
                child: MaterialButton(
                  child: const Text(
                    'Voir d\'autres évenements',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF252323),
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () async {
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

                  },
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}




