import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:eventflow/Screens/deodat/screens/events.dart';
import 'package:eventflow/Model/event.dart';


class CustomTicketWidget extends StatelessWidget {
  final Event event;
  final String qrData;

  const CustomTicketWidget({Key? key, required this.event, required this.qrData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Billet d'événement"),
        backgroundColor: Colors.blue,
        actions: const <Widget>[],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 250,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 20,
                      child: Container(
                        height: 50,
                        width: 28,
                        alignment: Alignment.center,
                        color: const Color(0xFFFFFF40),
                        child: Text(
                          '${event.price}',
                          style: const TextStyle(
                            color: Color(0xFF252323),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFFFF40),
                          radius: 60,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 55,
                            backgroundImage: AssetImage(event.imageUrl),
                          ),
                        ),
                        Text(
                          event.name,
                          style: const TextStyle(
                            color: Color(0xFFFFFF40),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFFFFFF40), size: 18),
                            Text(
                              event.location,
                              style: const TextStyle(
                                color: Color(0xFF252323),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                QrImageView(
                                  //place where the QR Image will be shown
                                  data: qrData,
                                  version: QrVersions.auto,
                                  size: 200,
                                ),
                                const SizedBox(
                                  height: 40.0,
                                ),
                                const Text(
                                  "New QR Link Generator",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                TextField(
                                  controller: TextEditingController(text: qrData),
                                  enabled: false, // Disable editing
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
