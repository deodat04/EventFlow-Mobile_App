import 'package:flutter/material.dart';

class Bienvenu1 extends StatefulWidget {
  const Bienvenu1({ Key? key }) : super(key: key);

  @override
  _Bienvenu1State createState() => _Bienvenu1State();
}

class _Bienvenu1State extends State<Bienvenu1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Text("EVENTFLOW",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40, color: Colors.blue),),
      ),
    );
  }
}