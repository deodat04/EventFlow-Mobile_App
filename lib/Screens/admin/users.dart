// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserListScreen extends StatefulWidget {
//   const UserListScreen({Key? key}) : super(key: key);

//   @override
//   _UserListScreenState createState() => _UserListScreenState();
// }

// class _UserListScreenState extends State<UserListScreen> {
//   final CollectionReference _usersCollection =
//       FirebaseFirestore.instance.collection("users");

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Liste des utilisateurs'),
//       ),
//       body: StreamBuilder(
//         stream: _usersCollection.snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Une erreur est survenue'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('Aucun utilisateur trouvé'));
//           }
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var userData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
//               var displayName = userData['displayName'] ?? 'N/A';
//               var email = userData['email'] ?? 'N/A';
//               var photoURL = userData['photoURL'] ?? ''; // Peut être null, à adapter selon les besoins

//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: NetworkImage(photoURL),
//                 ),
//                 title: Text(displayName),
//                 subtitle: Text(email),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des utilisateurs authentifiés'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: _auth.authStateChanges(),
              builder: (context, AsyncSnapshot<User?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Une erreur est survenue: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Text('Aucun utilisateur connecté');
                }
                var user = snapshot.data!;
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.photoURL ?? ''),
                    ),
                    SizedBox(height: 20),
                    Text('Nom: ${user.displayName ?? 'N/A'}'),
                    Text('Email: ${user.email ?? 'N/A'}'),
                    Text('ID: ${user.uid}'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
