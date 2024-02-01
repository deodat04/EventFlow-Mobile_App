

import 'package:eventflow/Model/event.dart';
import 'package:eventflow/Screens/deodat/screens/ticket_qr.dart';
import 'package:eventflow/Services/auth_Service.dart';
import 'package:eventflow/widgets/deodat/widgets/notification_provider.dart';
import 'package:eventflow/widgets/deodat/widgets/welcome_notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SucessScreenPage extends StatelessWidget {
  late int amount;
  // late String transactionId;
  late Event event;

  SucessScreenPage(
    this.amount,
    // this.transactionId,
    {
      Key? key,
      required this.event, // Assign event to the class variable
    }
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payement éffectué avec succès!"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Text("Vous avez éffectué votre payement pour le(s) ticket(s) avec succès. Merci", style: TextStyle(color: Colors.black,fontSize: 20),),

          SizedBox(height: 10,),
                    
          Text("Veuillez cliquer le bouton ci-dessous pour voir cotre code QR de payement", style: TextStyle(color: Colors.black,fontSize: 20),),

          

          SizedBox(height: 15.0,),
          ElevatedButton(
            onPressed: () async {
              AuthService _authService = AuthService();

              _authService.sendMail(event);

              final List<WelcomeNotification> welcomeNotifications = [];

              final newNotification = WelcomeNotification(
                titre: 'Paiement effectué : ${event.name}',
                message:
                  'Merci pour votre nouveau paiement pour l\'événement ${event.name}. Passez de bons moments ! \n L\'équipe EventFlow ',
              );
              welcomeNotifications.add(newNotification);

              final notificationProvider =
                Provider.of<NotificationProvider>(context, listen: false);
              notificationProvider.ajouterNotification(newNotification);

              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TicketQRPage(event: event))
              );

            },
            child: Text("Continuez pour voir votre QR")
          )
        ],
      )
    );
  }
}
