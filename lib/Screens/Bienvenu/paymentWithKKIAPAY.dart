

import 'package:eventflow/Model/event.dart';
import 'package:eventflow/Screens/Bienvenu/bienvenu2.dart';
import 'package:eventflow/Screens/deodat/screens/ticket_qr.dart';
import 'package:eventflow/Services/auth_Service.dart';
import 'package:eventflow/widgets/deodat/widgets/notification_provider.dart';
import 'package:eventflow/widgets/deodat/widgets/welcome_notification.dart';
import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/src/widget_builder_view.dart';
import 'package:kkiapay_flutter_sdk/utils/config.dart';
import "package:eventflow/Screens/Bienvenu/paymentSuccess.dart";
import 'package:provider/provider.dart';






KKiaPay createKKiaPay(Event event) {
  return KKiaPay(
    amount: event.price,
    countries: ["BJ"],
    phone: "22961000000",
    name: "John Doe",
    email: "email@gmail.com",
    reason: 'transaction reason',
    data: 'Fake data',
    sandbox: true,
    apikey: public_api_key,
    callback: (response, context) => successCallback(response, context, event),
    theme: defaultTheme,
    partnerId: 'AxXxXXxId',
    paymentMethods: ["momo", "card"],
  );
}

void successCallback(dynamic response, dynamic context, Event event) {
  if (response == null || response['status'] == null) {
    // Handle null response or missing status
    return;
  }

  Navigator.pop(context);

  switch (response['status']) {
    case PAYMENT_CANCELLED:
      print(PAYMENT_CANCELLED);
      break;

    case PAYMENT_SUCCESS:
      if (response['requestData'] != null && response['requestData']['amount'] != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SucessScreenPage(
              response['requestData']['amount'],
              event: event,
            ),
          ),
        );
      }
      break;

    case PAYMENT_FAILED:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec du paiement. Veuillez réessayer.'),
          duration: Duration(seconds: 3),
        ),
      );
      break;

    default:



          

          // AuthService _authService= AuthService();

          // _authService.sendMail( event);

          // final List<WelcomeNotification> welcomeNotifications = [];

          // // Add a new notification to the list
          // final newNotification = WelcomeNotification(
          //   titre: 'Paiement effectué : ${event.name}',
          //   message:
          //       'Merci pour votre nouveau paiement pour l\'événement ${event.name}. Passez de bons moments ! \n L\'équipe EventFlow ',
          // );
          // welcomeNotifications.add(newNotification);

          // // Add the new notification to the NotificationProvider
          // final notificationProvider =
          //   Provider.of<NotificationProvider>(context,
          //         listen: false);
          // notificationProvider.ajouterNotification(newNotification);

          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context)=> TicketQRPage(event:event))
          // );


          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SucessScreenPage(
              event.price,
              event: event,
            ),
          ),
        );


      break;
  }
}



class App extends StatelessWidget {

  final Event event;

  const App({Key? key, required this.event}) : super(key: key);


  @override
  Widget build(BuildContext context) {
     
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: nColorPrimary,
          title: Text('Kkiapay Sample'),
          centerTitle: true,
        ),
        body: KkiapaySample(event: event),
      ),
    );
  }
}



class KkiapaySample extends StatelessWidget {
  final Event event;

  const KkiapaySample({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kkiapay = createKKiaPay(event);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonTheme(
            minWidth: 500.0,
            height: 100.0,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xff222F5A)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text(
                'Cliquez pour passer au formulaire de paiement',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => kkiapay),
                ).then((value) {
                  // Une fois le paiement terminé, appelez successCallback avec event
                  successCallback(value, context, event);
                });
              },
            ),
          )
        ],
      ),
    );
  }
}



