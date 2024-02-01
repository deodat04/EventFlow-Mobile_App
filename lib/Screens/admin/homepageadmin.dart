import 'package:eventflow/Screens/admin/adminEvents.dart';
import 'package:flutter/material.dart';
import 'package:eventflow/Screens/Bienvenu/eventDisplay.dart';
import 'package:eventflow/Screens/admin/admin_account.dart';

import "package:eventflow/Screens/Bienvenu/notifications.dart";
import 'package:eventflow/widgets/deodat/widgets/notification_provider.dart';
import 'package:provider/provider.dart';


class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  int currentIndex = 0;

  final List<Widget> _screens = [
    const EventScreen(),
    EventAdmin(),
    AdminPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Espace administrateur"),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: "Mes évènements",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Mon compte",
          ),
        ],
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: _screens[currentIndex],
    );
  }
}
