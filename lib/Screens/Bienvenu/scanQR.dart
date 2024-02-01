


import 'package:eventflow/widgets/deodat/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({ Key? key }) : super(key: key);

  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {


  String _scanResult = "Pas encore scanner";

  Future<void> scanCode()async {
      String barcodeScanResult;

      try{
        barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);
      } on PlatformException catch(e){
        barcodeScanResult = "Échec de scannage du code: $e";
      }

      setState(() {
        _scanResult = barcodeScanResult;
      });


  }
  @override
  Widget build(BuildContext context) {
    return

    

    // );
    Scaffold(
      appBar: AppBar(
        title: const Text("Bienvenu sur la page de code QR"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "Result",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              _scanResult,
              style: const TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20.0,
            ),
            DefaultButton(
              onPressed: () async {
                
                 scanCode();
            
              },
              child: const Text(
                "Ouvrir le Scanner",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}