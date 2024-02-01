import 'package:eventflow/Screens/Bienvenu/bienvenu4.dart';
import 'package:eventflow/Screens/Bienvenu/createEvenement.dart';
import 'package:eventflow/widgets/deodat/widgets/notification_provider.dart';
import 'package:eventflow/widgets/deodat/widgets/welcome_notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bienvenu3 extends StatefulWidget {
  const Bienvenu3({ Key? key }) : super(key: key);

  @override
  _Bienvenu3State createState() => _Bienvenu3State();
}

class _Bienvenu3State extends State<Bienvenu3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
             Container(

              child: Image.asset("assets/cuate.png"),
             ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                  Text("Publiez vos évènements",style: TextStyle(color: Colors.white, fontSize: 18),),
                  SizedBox(height: 10,),
                  Center(
                    child: Text("Communiquez vos évènements et générez des e-tickets à travers notre plateforme", style: TextStyle(color: Colors.white30),),
                  ),
                  SizedBox(height: 30,),
                  ElevatedButton(
            
                    onPressed: ()async{

                       final List<WelcomeNotification> welcomeNotifications = [];

                    // Add a new notification to the list
                    final newNotification = WelcomeNotification(
                      titre: 'Message de bienvenu',
                      message:
                          "Soyez les bienvenu à EVENTFLOW",
                    );
                    welcomeNotifications.add(newNotification);

                    // Add the new notification to the NotificationProvider
                    final notificationProvider =
                        Provider.of<NotificationProvider>(context,
                            listen: false);
                    notificationProvider.ajouterNotification(newNotification);


                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>Bienvenu4())
                      );

                    }, 
                    child: Center(child: Text("Commencer",style: TextStyle(color: Colors.black),),)
                    ),

                 
                ]),
              )
            ],
          ),
        )
        ),
      
    );
  }
}