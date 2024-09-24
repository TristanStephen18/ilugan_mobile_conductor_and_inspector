import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class TicketScanner extends StatefulWidget {
  TicketScanner({super.key});

  @override
  State<TicketScanner> createState() => _TicketScannerState();
}

class _TicketScannerState extends State<TicketScanner> {

  @override
  void initState() {
    super.initState();
    openScanner();
  }

  void openScanner() async {
    final lineColor = '#ffffff';
    final cancelButtonText = 'CANCEL';
    final isShowFlashIcon = true;
    final scanMode = ScanMode.DEFAULT;
    final qr = await FlutterBarcodeScanner.scanBarcode(
        lineColor, cancelButtonText, isShowFlashIcon, scanMode).then((value) {
          // setState(() {
          //   output = value;
          // });
          // ignore: avoid_print
          print(value);
        },
        );
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(

      ),
    );
  }
}