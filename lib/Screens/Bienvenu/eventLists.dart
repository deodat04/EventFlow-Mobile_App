// import 'package:flutter/material.dart';
// import 'package:eventflow/Screens/deodat/screens/events.dart';
// class EventLists extends StatefulWidget {
//   const EventLists({ Key? key }) : super(key: key);

//   @override
//   _EventListsState createState() => _EventListsState();
// }

// class _EventListsState extends State<EventLists> {
//    int currentIndex = 0;

//   final List<Widget> _screens = [
//     const EventScreen(),
//     // MyEventsScreen(),
//     // Settings(),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Nom de l'appli"),
//         backgroundColor: Colors.blue,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: "Accueil",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.event_available),
//             label: "Mes évènements",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: "Paramètres",
//           ),
//         ],
//         onTap: (int index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//       ),
//       body: _screens[currentIndex],
//     );
//   }
// }