// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:flutter/material.dart';

import 'package:eventflow/Model/event.dart';
import 'package:eventflow/Screens/Bienvenu/paymentWithKKIAPAY.dart';


class PassageAuPayement extends StatefulWidget {
  final Event event;
  const PassageAuPayement({super.key, required this.event});

  @override
  _PassageAuPayementState createState() => _PassageAuPayementState();
}

class _PassageAuPayementState extends State<PassageAuPayement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: App(event:widget.event),
    );
  }
}