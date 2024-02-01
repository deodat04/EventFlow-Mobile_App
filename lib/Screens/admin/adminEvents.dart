import 'package:eventflow/Screens/Bienvenu/eventDetail.dart';
import 'package:eventflow/Services/auth_Service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Model/event.dart';


class EventAdmin extends StatefulWidget {
  const EventAdmin({Key? key}) : super(key: key);

  @override
  State<EventAdmin> createState() => _EventAdminState();
}




class _EventAdminState extends State<EventAdmin> {
  final CollectionReference _events = FirebaseFirestore.instance.collection("events");

  

  // Définissez les catégories disponibles
  final List<String> categories = [
    'Toutes',
    'Sport',
    'Flemme',
    'Festival',
    'Chills',
    'Concert'
  ];
  String selectedCategory = 'Toutes';
  String search = "";
  List<DocumentSnapshot> filteredEvents = [];
  late Stream<QuerySnapshot> _eventsStream;
  final AuthService _authService = AuthService();
  late dynamic _admin;
    late FirestoreService _firestoreService;



    


  @override
  void initState(){
    _eventsStream = _events.snapshots();
    super.initState();
   _firestoreService = FirestoreService(); // Initialisation de FirestoreService dans initState
    initializeAdmin();
   
  }

  void initializeAdmin() async {
    DocumentSnapshot? admin = await _firestoreService.getAdminByUserID("userId", _authService.currentUser!.uid);
    setState(() {
      _admin = admin;
    });
  }

  void updateSearchResults(String value) {
    setState(() {
      search = value.toLowerCase();
    });
  }


  

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252323),
      body: StreamBuilder<QuerySnapshot>(
        stream: _eventsStream,
        builder: (context, streamSnapshot) {
          if (streamSnapshot.hasData) {

            

            filteredEvents = streamSnapshot.data!.docs.where((event) {
              

              final admin_userId = _authService.currentUser!.uid;
              // final adminId = _admin.id;
              // final organizerId = event["organizer"];
              final organizer_userId = event["userId"];
              final validated = event['validated'].toString().toLowerCase();
              final eventCategory = event['eventType'].toString().toLowerCase();
              final eventName = event['name'].toString().toLowerCase();
              return (admin_userId == organizer_userId) && (validated == "yes") && (selectedCategory == 'Toutes' || eventCategory == selectedCategory.toLowerCase()) &&
                  (search.isEmpty || eventName.contains(search));
            }).toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "EventFlow",
                          style: TextStyle(
                            color: Color(0xFFFFFF40),
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: "Rechercher un évenement",
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: updateSearchResults,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Catégorie",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      DropdownButton<String>(
                        value: selectedCategory,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Color(0xFFFFFF40)),
                        dropdownColor: const Color(0xFF252323),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                        items: categories.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Événements",
                          style: TextStyle(
                            color: Color(0xFFFFFF40),
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      return EventItem(
                        event: filteredEvents[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                Event event = extractEventFromDocumentSnapshot(filteredEvents[index]);
                                return EventDetailsPage(event: event);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Event extractEventFromDocumentSnapshot(DocumentSnapshot<Object?> snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Event(
      id: snapshot.id,
      name: data['name'],
      eventType: data['eventType'],
      imageUrl: data['imageUrl'],
      date: data['date'],
      location: data['location'],
      time: data['time'],
      about: data['about'],
      price: data['price'],
       key: data['key'],
    );
  }
}

class EventItem extends StatelessWidget {
  final DocumentSnapshot event;
  final VoidCallback onTap;

  const EventItem({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
        child: Container(
          height: 100.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF252323),
            borderRadius: BorderRadius.circular(35.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0, 2),
                blurRadius: 5.0,
              )
            ],
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    width: 100.0,
                    height: 94.0,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                      ),
                      color: Color(0xFF252323),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                      ),
                      child: Image.network(
                        event['imageUrl'],
                        height: 94.0,
                        width: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0, top: 15.0),
                          child: Text(
                            event['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Color(0xFFFFFF40),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 140.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    event["date"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Container(
                                width: 140.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    event["eventType"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFFF40),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF252323),
                                    size: 20.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
