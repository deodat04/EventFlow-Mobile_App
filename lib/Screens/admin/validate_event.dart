
import 'package:eventflow/Model/event.dart';
import 'package:eventflow/Screens/Bienvenu/notifications.dart';
import 'package:eventflow/widgets/deodat/widgets/notification_provider.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ValidateEvent extends StatelessWidget {
  final Event  event;

  const ValidateEvent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252323),
      appBar: AppBar(
        title: const Text("Valider à évènements"),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              transform: Matrix4.translationValues(0, -25, 0),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(event.imageUrl),
                    ),
                  ),
                  ),
                  Positioned(
                    right: 10,
                    top: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              16),
                            child: Text(
                              '${event.price} XOF',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFFFFF40),
                                fontSize: 18,
                              ),
                            ),
                         // ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFF40),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                            color: Colors.white),
                      ),
                      const Spacer(),
                      //const SizedBox(width: 10),
                      Text(
                        event.date,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${event.time} heures',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFFFFF40),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.about,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
     