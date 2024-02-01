import 'package:eventflow/Screens/Bienvenu/notifications.dart';
import 'package:eventflow/Screens/admin/validate_event.dart';
import 'package:eventflow/widgets/deodat/widgets/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Model/event.dart';
import 'package:eventflow/Services/auth_Service.dart';
import 'package:provider/provider.dart';

class EventToValidate extends StatefulWidget {
  const EventToValidate({Key? key}) : super(key: key);

  @override
  State<EventToValidate> createState() => _EventToValidateState();
}

class _EventToValidateState extends State<EventToValidate> {




  final CollectionReference _events = FirebaseFirestore.instance.collection("events");


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

  @override
  void initState() {
    _eventsStream = _events.snapshots();
    super.initState();
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
      
      body: StreamBuilder<QuerySnapshot>(
        stream: _eventsStream,
        builder: (context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            filteredEvents = streamSnapshot.data!.docs.where((event) {
              final validated = event['validated'].toString().toLowerCase();
              final eventCategory = event['eventType'].toString().toLowerCase();
              final eventName = event['name'].toString().toLowerCase();
              return (validated == "no") && (selectedCategory == 'Toutes' || eventCategory == selectedCategory.toLowerCase()) &&
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
                          "Évènement à Valider",
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
                                return ValidateEvent(event: event);
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
  const EventItem({super.key, required this.event, required this.onTap});


  

  

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
                          // Remplacer l'icône de la flèche par une icône de crayon
                          GestureDetector(
                            onTap: () {
                              // Ajouter la logique pour la modification ici
                              // Par exemple, afficher un dialogue de modification
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Modifier Validated"),
                                    content: Text("Modifier le champ Validated de l'événement de 'NO' à 'YES'"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("Valider"),
                                        onPressed: () async {
                                          // Mettre à jour le champ Validated dans la base de données
                                          // Ajouter votre logique de mise à jour ici
                                          CRUD_Services crud_services = CRUD_Services();
                                          // print(event.id);
                                          await crud_services.updateEventData(docId: event.id, name: event['name'], eventType: event['eventType'], imgurl: event['imageUrl'], date: event['date'], location: event['location'], time: event['time'], about: event['about'], price: event['price'], country: event['country'], organizer: event['organizer'], validated: 'Yes', userId: event['userId'], key: event['key']);

                                          final snackBar = await SnackBar(content: Text("L'évènement est mise à jour avac succès!"));
                                          await ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Annuler"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFF40),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const Center(
                                // Remplacer l'icône de la flèche par une icône de crayon
                                child: Icon(
                                  Icons.edit,
                                  color: Color(0xFF252323),
                                  size: 20.0,
                                ),
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
        ),
      ),
    );
  }
}
