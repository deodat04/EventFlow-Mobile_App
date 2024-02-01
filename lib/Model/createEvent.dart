
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';





class StoreEvent{

final FirebaseStorage  _storage = FirebaseStorage.instance;

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<String> uploadImageToStorage(Uint8List? file)async{


  if (file == null) {
    return "File is null";
  }

  // Generate a unique name based on timestamp and random number
  String fileUniqueName = DateTime.now().millisecondsSinceEpoch.toString() +
      Random().nextInt(999999).toString();

  // print(file);
  // Reference ref = _storage.ref().child(childName).child('name');
   Reference ref = _storage.ref('coverEventImage/$fileUniqueName');
  UploadTask uploadTask = ref.putData(file);
  TaskSnapshot snapshot = await uploadTask;

  String downloadUrl  = await snapshot.ref.getDownloadURL();

  return downloadUrl;

}










Future<String> saveData({
  required String name, 
  required String eventType, 
  required Uint8List file, 
  required String date, 
  required String location, 
  required String time, 
  required about, 
  required int price,
  required country,
  required organizer,
  required validated,
  required userId
  })async{

    String  resp="Some Error Occured";

  try{

    String imageUrl = await uploadImageToStorage(file);
     String key = DateTime.now().millisecondsSinceEpoch.toString() +
      Random().nextInt(99999999).toString();

    await _firestore.collection("events").add({
      'name' : name,
      'eventType' : eventType,
      'imageUrl' : imageUrl,
      'date': date,
      'location' : location,
      'time' : time,
      'about' : about,
      'price' :  price,
      "country": country,
      "organizer": organizer,
      "validated": validated,
      "key":  key,
      "userId" : userId
  });

  resp = "success";

  }
  catch(err){
     resp = err.toString(); 
     print(resp) ;

     }

     return resp;

}

}