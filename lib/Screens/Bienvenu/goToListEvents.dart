
// import 'package:eventflow/Screens/deodat/screens/events.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:eventflow/widgets/deodat/widgets/notification_provider.dart';
// // import 'package:provider/provider.dart';
// // import 'package:eventflow/Screens/deodat/screens/home_page.dart';
// import 'package:eventflow/widgets/deodat/widgets/app_logo.dart';
// import 'package:eventflow/widgets/deodat/widgets/my_circular_progress.dart';

// import 'package:flutter/material.dart';

// class GoToListEvents extends StatefulWidget {
//   const GoToListEvents({ Key? key }) : super(key: key);

//   @override
//   _GoToListEventsState createState() => _GoToListEventsState();
// }

// class _GoToListEventsState extends State<GoToListEvents> {

//   @override
//   void initState() {
//     super.initState();
//     // Utilisez Future.delayed pour rediriger automatiquement après un certain délai
//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (context) => const EventScreen(),
//       ));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           color: Colors.white,
//           child: const Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   AppLogo(),
//                   SizedBox(height: 10),
//                   Text("EventFlow",
//                       style:
//                           TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 5),
//                   Text("Vos évenements en un click",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 18, color: Colors.grey)),
//                   SizedBox(height: 20),
//                   MyCircularProgress()
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }