import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Model/event.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Check if user is signed in
  User? get currentUser => _auth.currentUser;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;


  Future<void> sendMail(Event event) async {
    final email = _user?.email;
    if (email != null) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/qr_code.png');
      ByteData? qrBytes = await QrPainter(
        data: event.key,
        gapless: true,
        version: QrVersions.auto,
        color: Color.fromRGBO(0, 118, 191, 1),
        emptyColor: Colors.white,
      ).toImageData(878);

      final buffer = qrBytes!.buffer.asUint8List();
      await file.writeAsBytes(buffer);

      final server = gmail('eventflow24@gmail.com', 'eventflow@2024');

      final message = Message()
        ..from = Address('eventflow24@gmail.com', 'EventFlow')
        ..recipients.add(email)
        ..subject = 'Votre Pass pour ${event.name}'
         ..html = '''
          <p>Veuillez trouver ci-joint votre QR Code pour accéder à l'événement ${event.name}.</p>
          <img src="cid:qr_code_image">
        '''
        ..attachments.add(
          FileAttachment(File(file.path))
            ..location = Location.inline
            ..cid = '<qr_code_image>',
        );

      try {
        final sendReport = await send(message, server);
        print('Message envoyé: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message non envoyé.');
        for (var p in e.problems) {
          print('Problèmes: ${p.code}: ${p.msg}');
        }
      }
    }
  }
}


class FirestoreService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference organizersCollection = FirebaseFirestore.instance.collection('organisateurs');
  final CollectionReference adminsCollection = FirebaseFirestore.instance.collection('admins');
  final CollectionReference eventsCollection = FirebaseFirestore.instance.collection('events');
  final CollectionReference participantsCollection = FirebaseFirestore.instance.collection('participants');

  Future<DocumentSnapshot?> getUserByAttribute(String attributeName, dynamic attributeValue) async {
    try {
      QuerySnapshot querySnapshot = await usersCollection.where(attributeName, isEqualTo: attributeValue).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document with this attribute value
        return querySnapshot.docs.first;
      } else {
        return null;
      }
    } catch (e) {
      print("Error retrieving user: $e");
      return null;
    }
  }

  Future<DocumentSnapshot?> getOrganizerByUserID(String attributeName, dynamic attributeValue) async {
    try {
      QuerySnapshot querySnapshot = await organizersCollection.where(attributeName, isEqualTo: attributeValue).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document with this attribute value
        return querySnapshot.docs.first;
      } else {
        return null;
      }
    } catch (e) {
      print("Error retrieving user: $e");
      return null;
    }
  }


  Future<DocumentSnapshot?> getAdminByUserID(String attributeName, dynamic attributeValue) async {
    try {
      QuerySnapshot querySnapshot = await adminsCollection.where(attributeName, isEqualTo: attributeValue).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document with this attribute value
        return querySnapshot.docs.first;
      } else {
        return null;
      }
    } catch (e) {
      print("Error retrieving user: $e");
      return null;
    }
  }




 Future<List<DocumentSnapshot>> getParticipantsByEventId(String attributeName, dynamic attributeValue) async {
    try {
      QuerySnapshot querySnapshot = await participantsCollection.where(attributeName, isEqualTo: attributeValue).get();
      return querySnapshot.docs; // Return all documents that match the query
    } catch (e) {
      print("Error retrieving participants: $e");
      return []; // Return an empty list if there's an error
    }
  }


  // Get event based on the organizer owner id
  Future<List<DocumentSnapshot>> getEventBasedOnOrganizerId(String attributeName, dynamic attributeValue) async {
    try {
      QuerySnapshot querySnapshot = await eventsCollection.where(attributeName, isEqualTo: attributeValue).get();
      return querySnapshot.docs; // Return all documents that match the query
    } catch (e) {
      print("Error retrieving participants: $e");
      return []; // Return an empty list if there's an error
    }
  }
}





class CRUD_Services {
  final CollectionReference _firestoreEvent =
      FirebaseFirestore.instance.collection("events");

  Future<String> updateEventData({
    required String docId,
    required String name,
    required String eventType,
    required dynamic imgurl,
    required String date,
    required String location,
    required String time,
    required dynamic about,
    required int price,
    required dynamic country,
    required dynamic organizer,
    required dynamic validated,
    required dynamic userId,
    required dynamic key,
  }) async {
    String resp = "Some Error Occurred";

    try {
      await _firestoreEvent.doc(docId).update({
        'name': name,
        'eventType': eventType,
        'imageUrl': imgurl,
        'date': date,
        'location': location,
        'time': time,
        'about': about,
        'price': price,
        "country": country,
        "organizer": organizer,
        "validated": validated,
        "key": key,
        "userId": userId
      });

      resp = "success";
    } catch (err) {
      resp = err.toString();
      print(resp);
    }

    return resp;
  }
}
