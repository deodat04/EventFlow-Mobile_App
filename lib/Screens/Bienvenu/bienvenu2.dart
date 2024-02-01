import 'package:eventflow/Screens/Bienvenu/bienvenu3.dart';
import 'package:flutter/material.dart';

class Bienvenu2 extends StatefulWidget {
  const Bienvenu2({ Key? key }) : super(key: key);

  @override
  _Bienvenu2State createState() => _Bienvenu2State();
}

class _Bienvenu2State extends State<Bienvenu2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(

        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
             Container(
            


              child: Image.asset("assets/pana.png"),
             ),
              Container(
                child: Column(
                  children: [
                  Text("Achétez vos billets en ligne",style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                  Text("En quelques clics réservez vos places pour tous genres d'évènements", style: TextStyle(color: Colors.white30),),
                  SizedBox(height: 60,),
                  ElevatedButton(
            
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>Bienvenu3())
                      );
                    }, 
                    child: Center(child: Text("Suivant",style: TextStyle(color: Colors.black),),)
                    ),

                ]),
              )
            ],
          ),
        )
        ),
      
    );
  }
}