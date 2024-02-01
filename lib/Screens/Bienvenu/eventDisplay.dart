// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:eventflow/Screens/deodat/screens/event_detail.dart';
// // import 'package:eventflow/Screens/Bienvenu/eventDetail.dart';
// // import 'package:flutter/material.dart';
// // import 'dart:async';
// // import 'package:eventflow/Screens/deodat/screens/notifications.dart';
// // import 'package:eventflow/widgets/deodat/widgets/notification_provider.dart';
// // import 'package:provider/provider.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:eventflow/Model/event.dart';


// // class EventScreen extends StatefulWidget {
// //   const EventScreen({Key? key}) : super(key: key);

// //   @override
// //   State<EventScreen> createState() => _EventScreenState();
// // }


















import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Model/event.dart';
import 'package:eventflow/Screens/Bienvenu/eventDetail.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _eventsStream,
        builder: (context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            filteredEvents = streamSnapshot.data!.docs.where((event) {
              final validated = event['validated'].toString().toLowerCase();
              final eventCategory = event['eventType'].toString().toLowerCase();
              final eventName = event['name'].toString().toLowerCase();
              return (validated == "yes") && (selectedCategory == 'Toutes' || eventCategory == selectedCategory.toLowerCase()) &&
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





























// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eventflow/Model/event.dart';
// import 'package:eventflow/Screens/Bienvenu/eventDetail.dart';

// class EventScreen extends StatefulWidget {
//   const EventScreen({Key? key}) : super(key: key);

//   @override
//   State<EventScreen> createState() => _EventScreenState();
// }

// class _EventScreenState extends State<EventScreen> {
//   final CollectionReference _events = FirebaseFirestore.instance.collection("events");

//   final List<String> categories = [
//     'Toutes',
//     'Sport',
//     'Flemme',
//     'Festival',
//     'Chills',
//     'Concert'
//   ];

//   String selectedCategory = 'Toutes';
//   String search = "";
//   List<DocumentSnapshot> filteredEvents = [];
//   late CollectionReference _eventsCollection;

//   @override
//   void initState() {
//     _eventsCollection = _events;
//     super.initState();
//   }

//   void updateSearchResults(AsyncSnapshot<QuerySnapshot> streamSnapshot, String? searchValue) {
//     setState(() {
//       List<DocumentSnapshot> updatedFilteredEvents;

//       if (searchValue!.isEmpty) {
//         updatedFilteredEvents = streamSnapshot.data!.docs;
//       } else {
//         updatedFilteredEvents = streamSnapshot.data!.docs
//             .where((event) =>
//                 event['name']
//                     .toLowerCase()
//                     .contains(searchValue.toLowerCase()))
//             .toList();
//       }

//       filteredEvents = updatedFilteredEvents;
//       _eventsCollection = filteredEvents as CollectionReference<Object?>;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF252323),
//       body: StreamBuilder(
//         stream: _eventsCollection.snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//           if (streamSnapshot.hasData) {
//             filteredEvents = streamSnapshot.data!.docs;

//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16.0),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "EventFlow",
//                           style: TextStyle(
//                             color: Color(0xFFFFFF40),
//                             fontSize: 25.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 32),
//                         TextField(
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(Icons.search),
//                             hintText: "Rechercher un évenement",
//                             filled: true,
//                             fillColor: Colors.white,
//                           ),
//                           onChanged: (String value) {
//                             print("Search query changed: $value");
//                             setState(() {
//                               search = value;
//                               updateSearchResults(streamSnapshot, value);
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   Row(
//                     children: [
//                       const Padding(
//                         padding: EdgeInsets.all(16.0),
//                         child: Text(
//                           "Catégorie",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10.0),
//                       DropdownButton<String>(
//                         value: selectedCategory,
//                         icon: const Icon(Icons.arrow_drop_down),
//                         iconSize: 24,
//                         elevation: 16,
//                         style: const TextStyle(color: Color(0xFFFFFF40)),
//                         dropdownColor: const Color(0xFF252323),
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             selectedCategory = newValue!;
//                             updateSearchResults(streamSnapshot, newValue);
//                           });
//                         },
//                         items: categories.map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16.0),
//                   Container(
//                     padding: const EdgeInsets.all(16.0),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Événements",
//                           style: TextStyle(
//                             color: Color(0xFFFFFF40),
//                             fontSize: 22.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: filteredEvents.length,
//                     itemBuilder: (context, index) {
//                       return EventItem(
//                         event: filteredEvents[index],
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context){
//                                 Event event = extractEventFromDocumentSnapshot(filteredEvents[index]);
//                                 return EventDetailsPage(event: event);
//                               }
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           }
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }

//   Event extractEventFromDocumentSnapshot(DocumentSnapshot<Object?> snapshot) {
//     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//     return Event(
//       id: snapshot.id,
//       name: data['name'],
//       eventType: data['eventType'],
//       imageUrl: data['imageUrl'],
//       date: data['date'],
//       location: data['location'],
//       time: data['time'],
//       participants: data['participants'],
//       about: data['about'],
//       price: data['price'],
//     );
//   }
// }

// class EventItem extends StatelessWidget {
//   final DocumentSnapshot event;
//   final VoidCallback onTap;

//   const EventItem({required this.event, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
//         child: Container(
//           height: 100.0,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: const Color(0xFF252323),
//             borderRadius: BorderRadius.circular(35.0),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black,
//                 offset: Offset(0, 2),
//                 blurRadius: 5.0,
//               )
//             ],
//           ),
//           child: Stack(
//             alignment: Alignment.centerLeft,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.all(5.0),
//                     width: 100.0,
//                     height: 94.0,
//                     decoration: const BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30.0),
//                         bottomLeft: Radius.circular(30.0),
//                       ),
//                       color: Color(0xFF252323),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30.0),
//                         bottomLeft: Radius.circular(30.0),
//                       ),
//                       child: Image.network(
//                         event['imageUrl'],
//                         height: 94.0,
//                         width: 100.0,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: 140.0,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 4.0, top: 15.0),
//                           child: Text(
//                             event['name'],
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18.0,
//                               color: Color(0xFFFFFF40),
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Column(
//                             children: [
//                               Container(
//                                 width: 140.0,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 4.0),
//                                   child: Text(
//                                     event["date"],
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 13.0,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 width: 140.0,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 4.0),
//                                   child: Text(
//                                     event["eventType"],
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 12.0,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Container(
//                                 height: 40.0,
//                                 width: 40.0,
//                                 decoration: BoxDecoration(
//                                   color: Color(0xFFFFFF40),
//                                   borderRadius: BorderRadius.circular(5.0),
//                                 ),
//                                 child: const Center(
//                                   child: Icon(
//                                     Icons.arrow_forward,
//                                     color: Color(0xFF252323),
//                                     size: 20.0,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }














// class _EventScreenState extends State<EventScreen> {
//   late CollectionReference _events = FirebaseFirestore.instance.collection("events");

//   // Définissez les catégories disponibles
//   final List<String> categories = [
//     'Toutes',
//     'Sport',
//     'Flemme',
//     'Festival',
//     'Chills',
//     'Concert'
//   ];
//   String selectedCategory = 'Toutes'; // Catégorie sélectionnée par défaut

// // TextEditingController searchController = TextEditingController();
// String search="";
// List<DocumentSnapshot> filteredEvents = [];
// // late Timer _debounce;
// late CollectionReference _events_collection;
// @override
// void initState() {
//   _events_collection = _events;
//   super.initState();
//   // _debounce = Timer(const Duration(milliseconds: 500), () {});
// }


//   // void updateSearchResults() {
//   //   setState(() {
//   //     filteredEvents = filteredEvents
//   //         .where((event) =>
//   //             event['name']
//   //                 .toLowerCase()
//   //                 .contains(searchController.text.toLowerCase()))
//   //         .toList();
//   //   });
//   // }

//   // void updateSearchResults(AsyncSnapshot<QuerySnapshot> streamSnapshot, String? searchValue) {
//   //   setState(() {
//   //     if (search.isEmpty) {
//   //       // If search query is empty, show all events
//   //       filteredEvents = streamSnapshot.data!.docs;
//   //     } else {
//   //       // If there is a search query, filter events based on the name
//   //       filteredEvents = streamSnapshot.data!.docs
//   //           .where((event) =>
//   //               event['name']
//   //                   .toLowerCase()
//   //                   .contains(searchValue!.toLowerCase()))
//   //           .toList();
//   //     }
//   //   });
//   // }


//   void updateSearchResults(AsyncSnapshot<QuerySnapshot> streamSnapshot, String? searchValue) async{
//   setState(() async {
//     List<DocumentSnapshot> updatedFilteredEvents; // Declare a variable with the desired type

//     if (searchValue!.isEmpty) {
//       // If search query is empty, show all events
//       // ignore: await_only_futures
//       updatedFilteredEvents = await streamSnapshot.data!.docs;
//     } else {
//       // If there is a search query, filter events based on the name
//       updatedFilteredEvents = await streamSnapshot.data!.docs
//           .where((event) =>
//               event['name']
//                   .toLowerCase()
//                   .contains(searchValue!.toLowerCase()))
//           .toList();
//     }

//     filteredEvents = await updatedFilteredEvents; // Assign the value to filteredEvents
//     _events_collection = await filteredEvents as CollectionReference<Object?>;
//   });
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
   

//       backgroundColor: const Color(0xFF252323), // Couleur de fond noire


//       body: StreamBuilder(
//         stream: _events_collection.snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//           if (streamSnapshot.hasData) {
//             filteredEvents = streamSnapshot.data!.docs;

//             return SingleChildScrollView(
//               child: Column(
//                 children: [
                 




//                     Container(
//                       padding: const EdgeInsets.all(16.0),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "EventFlow",
//                             style: TextStyle(
//                               color: Color(0xFFFFFF40), // Couleur du texte
//                               fontSize: 25.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 32),
//                           SearchBar(
//                             leading: const Icon(Icons.search),
//                             hintText: "Rechercher un évenement",
//                             onChanged: (String? value)async {
//                               // Handle the text change here
//                               print("Search query changed: $value");
//                               search = value!;
//                               updateSearchResults(streamSnapshot, value);
//                             },
//                             backgroundColor: MaterialStateProperty.all(Colors.white),
                      
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 16.0),
//                     Row(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: Text(
//                             "Catégorie",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10.0),
//                         DropdownButton<String>(
//                           value: selectedCategory,
//                           icon: const Icon(Icons.arrow_drop_down),
//                           iconSize: 24,
//                           elevation: 16,
//                           style: const TextStyle(color: Color(0xFFFFFF40)),
//                           dropdownColor: const Color(0xFF252323),
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               selectedCategory = newValue!;
//                               updateSearchResults(streamSnapshot,newValue);
//                             });
//                           },
//                           items:
//                               categories.map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                         ),
//                       ],
//                     ),





//                   const SizedBox(height: 16.0),
//                   Container(
//                     padding: const EdgeInsets.all(16.0),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Événements",
//                           style: TextStyle(
//                             color: Color(0xFFFFFF40),
//                             fontSize: 22.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: filteredEvents.length,
//                     itemBuilder: (context, index) {
//                       return EventItem(
//                         event: filteredEvents[index],
//                         onTap: () {
//                           // Handle onTap
//                           Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context){
//                                // EventDetailsPage(event: filteredEvents[index]),
//                                 Event event = extractEventFromDocumentSnapshot(filteredEvents[index]);
//                                 return EventDetailsPage(event: event);
//                             }
                               
//                           ),
//                         );
                          
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           }
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }

 
//   //  @override
//   // void dispose() {
//   //   searchController.dispose();
//   //   _debounce.cancel();
//   //   super.dispose();
//   // }

//   Event extractEventFromDocumentSnapshot(DocumentSnapshot<Object?> snapshot) {
//     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//     return Event(
//       id: snapshot.id,
//       name: data['name'],
//       eventType: data['eventType'],
//       imageUrl: data['imageUrl'],
//       date: data['date'],
//       location: data['location'],
//       time: data['time'],
//       participants: data['participants'],
//       about: data['about'],
//       price: data['price'],
//     );
//   }
// }



// class EventItem extends StatelessWidget {
//   final DocumentSnapshot event;
//   final VoidCallback onTap;

//   const EventItem({required this.event, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
//         child: Container(
//           height: 100.0,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: const Color(0xFF252323),
//             borderRadius: BorderRadius.circular(35.0),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black,
//                 offset: Offset(0, 2),
//                 blurRadius: 5.0,
//               )
//             ],
//           ),
//           child: Stack(
//             alignment: Alignment.centerLeft,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.all(5.0),
//                     width: 100.0,
//                     height: 94.0,
//                     decoration: const BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30.0),
//                         bottomLeft: Radius.circular(30.0),
//                       ),
//                       color: Color(0xFF252323),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30.0),
//                         bottomLeft: Radius.circular(30.0),
//                       ),
//                       child: Image.network(
//                         event['imageUrl'], // Utilisez le champ 'imageUrl' du document Firebase
//                         height: 94.0,
//                         width: 100.0,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: 140.0,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 4.0, top: 15.0),
//                           child: Text(
//                             event['name'], // Utilisez le champ 'name' du document Firebase
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18.0,
//                               color: Color(0xFFFFFF40),
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                       // ... autres champs à afficher







//                            Row(
//                         children: [
//                           Column(
//                             children: [
//                               Container(
//                                 width: 140.0,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 4.0),
//                                   child: Text(
//                                     event["date"],
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 13.0,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 width: 140.0,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 4.0),
//                                   child: Text(
//                                     event["eventType"],
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 12.0,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Container(
//                                 height: 40.0,
//                                 width: 40.0,
//                                 decoration: BoxDecoration(
//                                   color: Color(0xFFFFFF40),
//                                   borderRadius: BorderRadius.circular(5.0),
//                                 ),
//                                 child: const Center(
//                                   child: Icon(
//                                     Icons.arrow_forward,
//                                     color: Color(0xFF252323),
//                                     size: 20.0,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),









//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
