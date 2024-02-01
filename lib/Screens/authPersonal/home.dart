


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eventflow/Screens/login.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auth with firebase!!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
      ),
      body: Center(child: SingleChildScrollView(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
              child: Text("Hello friend! Welcome!!",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 25,),
             
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Container(
                child: ElevatedButton(
                  onPressed: ()async{
                      await FirebaseAuth.instance.signOut().then((value){
                        print("User logout successfully");
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                      }).onError((error, stackTrace){
            
                        print("Error ${error.toString()}");
                      });
                  }, 
                  child: Text("Logout")
                  ),
              )
            ],
            ),
          Row()
        ],),
      ),),
      
    );
  }
}
