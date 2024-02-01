

// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Model/createEvent.dart';
import 'package:eventflow/Screens/Bienvenu/notifications.dart';
import 'package:eventflow/Screens/admin/homepageadmin.dart';
import 'package:eventflow/Screens/organizators/homepageorganizer.dart';
import 'package:eventflow/Screens/user/homepageuser.dart';
import 'package:eventflow/Services/auth_Service.dart';
import 'package:eventflow/Utils/utils.dart';
import 'package:eventflow/widgets/deodat/widgets/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final eventKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController eventTypeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  // TextEditingController _picked = TextEditingController();
  
  late TimeOfDay _timeChosen;


  final AuthService _authService = AuthService();

   final FirestoreService _firestoreService = FirestoreService();


  // TextEditingController dateController = TextEditingController();

  Future<void> _selectDate()async{
  DateTime? _picked = await showDatePicker(
    context: context, 
    initialDate: DateTime.now(),
    firstDate: DateTime(2024), 
    lastDate: DateTime(2200));

  if (_picked != null){
    setState(() {
      dateController.text = _picked.toString().split(" ")[0];
      // print(dateController);
    });
  }
}



  String? _validateRequired(String? value) {
    return (value == null || value == "") ? "Ce champ est obligatoire" : null;
  }

   int _selectedIndex=0;



  Uint8List? _imageUrl;

  void selectImage()async{
      Uint8List img = await pickImage(ImageSource.gallery);
      
      setState(() {
        _imageUrl = img;
      });
  }

  void _pickTime(){
    showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now()
      ).then((value) {
        setState(() {
          _timeChosen = value!;
          print(_timeChosen.format(context).toString());
          print(_timeChosen);
        });
      });
  }






  void _submitForm() async{

    
  
   
    if (eventKey.currentState!.validate()) {
      // Form is valid, process the data

      String name = nameController.text;
      String eventType = _value;
      String location = locationController.text;
      String time = _timeChosen.format(context).toString();
      
      String about = aboutController.text;
      String date = dateController.text;
      String country = countryController.text;
      int price = int.tryParse(priceController.text) ?? 0;


       String resp;


      DocumentSnapshot? _Admin = await _firestoreService.getAdminByUserID("userId", _authService.currentUser!.uid);
      DocumentSnapshot? _Organizer = await _firestoreService.getOrganizerByUserID("userId", _authService.currentUser!.uid);
      String organizer ;
      
      if (_Admin != null && _Admin.exists){

      //  organizer =  (_Admin.data() as Map<String, dynamic>)['username'];
      organizer = _Admin.id;
       print(organizer);

        resp  = await StoreEvent().saveData(name: name, eventType: eventType, file: _imageUrl!, date: date, location: location,time: time, about: about, price: price, country: country,organizer: organizer,validated: "Yes",userId :_authService.currentUser!.uid );
      nameController.text="";
    eventTypeController.text="";
    locationController.text="";
    timeController.text="";
    priceController.text="";
    aboutController.text="";
    dateController.text="";
    countryController.text="";
    _imageUrl =null;
    organizer = "";


    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context)=> HomeScreenAdmin())
    );


      }else if(_Organizer!=null){

      // organizer =  (_Organizer.data() as Map<String, dynamic>)['username'];
      organizer = _Organizer.id;
      print(organizer);

      resp  = await StoreEvent().saveData(name: name, eventType: eventType, file: _imageUrl!, date: date, location: location,time: time, about: about, price: price, country: country,organizer: organizer,validated: "No",userId :_authService.currentUser!.uid);
    nameController.text="";
    eventTypeController.text="";
    locationController.text="";
    timeController.text="";
    priceController.text="";
    aboutController.text="";
    dateController.text="";
    countryController.text="";
    _imageUrl =null;
    organizer = "";


    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context)=> HomeScreenOrganizer())
    );


      }
      else{
        print("Vous n'avez pas les droits nécessaires pour créer un évènement. Veillez créer un compte organisateur ou contacter un administrateur!");
        await Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=> HomeScreenUser())
    );
      }
    }

    else{
      print("Please fill all fields above!");
    }
  }


// Value initialisation for event type 
var _value = null;


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
        title: const Text("Espace creer évènement"),
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Column(children: <Widget>[
                  Form(
                key: eventKey,
                child: Column(
                  children: [
                    
                     SizedBox(height: 22),
                     Text("Choisissez une image de votre choix qui illustre votre évènement"),
                     SizedBox(height: 12.0,),
                    Stack(
                      children: [
                        _imageUrl != null?
                        CircleAvatar(
                          radius: 74,
                          backgroundImage: MemoryImage(_imageUrl!),
                        ):
                        CircleAvatar(
                          radius: 74,
                          backgroundImage: NetworkImage(
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"
                            ),
                          ),
                          Positioned(
                            child: IconButton(
                              onPressed: selectImage, 
                            icon: Icon(Icons.add_a_photo
                            )),
                            bottom: -10,
                            left: 80,
                            )
                      ],
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: nameController,
                      // decoration: InputDecoration(labelText: "Nom ou denomination de l'évènement"),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2)
                        ),
                        labelText: "Nom ou denomination de l'évènement"
                      ),
                      
                      validator: _validateRequired,
                    ),
                    const SizedBox(height: 18.0),


                    DropdownButtonFormField(

                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2)
                        ),
                        labelText: "Choisissez une catégorie"
                      ),
                      value: _value,
                      items: [
                        DropdownMenuItem<String>(
                          child: Text('Toutes'),
                          value: 'Toutes',
                          ),
                           DropdownMenuItem<String>(
                          child: Text('Sport'),
                          value: 'Sport',
                          ),
                           DropdownMenuItem<String>(
                          child: Text('Flemme',),
                          value: 'Flemme',
                          ),

                           DropdownMenuItem<String>(
                          child: Text('Festival'),
                          value: 'Festival',
                          ),
                          DropdownMenuItem<String>(
                          child: Text('Chills'),
                          value: 'Chills',
                          ),
                          DropdownMenuItem<String>(
                          child: Text('Concert'),
                          value: 'Concert',
                          ),
                      ], 
                      onChanged: (newvalue){
                        setState(() {
                          _value = newvalue;
                          print(_value);
                        });
                      }
                      ),
                    const SizedBox(height: 18.0),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: dateController,
                      decoration: InputDecoration(
                        labelText: "Date",
                        filled: true,
                        prefixIcon: Icon(Icons.calendar_today),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          // borderRadius: BorderRadius.all(10)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)
                        )
                        ),
                      // validator: _validateRequired,
                      readOnly: true,
                      onTap: (){
                        _selectDate();
                      },
                    ),
                    const SizedBox(height: 18.0),
                     TextFormField(
                      keyboardType: TextInputType.text,
                      controller: locationController,
                      // decoration: InputDecoration(labelText: "Lieu ou Place"),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2)
                        ),
                        labelText: "Lieu ou Place"
                      ),
                      validator: _validateRequired,
                    ),
                    
                    SizedBox(height: 18.0),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: countryController,
                      // decoration: InputDecoration(labelText: "Pays"),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2)
                        ),
                        labelText: "Pays"
                      ),
                      validator: _validateRequired,
                    ),
                    SizedBox(height: 18.0),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: aboutController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2)
                        ),
                        labelText: "Un petit mot sur l'évènement"
                      ),
                      validator: _validateRequired,
                    ),

                    SizedBox(height: 18.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2)
                        ),
                        labelText: "Prix du ticket"
                      ),
                      validator: _validateRequired,
                    ),
                    SizedBox(height: 18.0),
                    
                  ],
                ),
              ),
              
                    //],
                    //),
                    SizedBox(height: 18.0),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Background color
                      onPrimary: Colors.white, // Text color
                      fixedSize: Size(200.0, 50.0), // Set height and width here
                    ),
                      onPressed: _pickTime, 
                      child: Text("Choisissez l'heure"),
                      
                      ),

                    SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () =>_submitForm(),
                      child: Text('Ajouter'),
                    ),
                    SizedBox(height: 20.0,)
                ]),)
            ),
          )
    )
    ;
  }



 
}



