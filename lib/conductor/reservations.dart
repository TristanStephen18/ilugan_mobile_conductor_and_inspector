import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gap/gap.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/homescreen_con.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';
import 'package:status_alert/status_alert.dart';

class Reservations extends StatefulWidget {
  Reservations({super.key});

  @override
  State<Reservations> createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  void openScanner() async {
    final lineColor = '#ffffff';
    final cancelButtonText = 'CANCEL';
    final isShowFlashIcon = true;
    final scanMode = ScanMode.DEFAULT;
    final qr = await FlutterBarcodeScanner.scanBarcode(
        lineColor, cancelButtonText, isShowFlashIcon, scanMode).then((value) {
          if(value == "sample"){
            StatusAlert.show(
            context,
            duration: Duration(seconds: 1),
            title: "Reservation Successful",
            subtitle: value,
            configuration: IconConfiguration(icon: Icons.check)
          );
          }else{
            StatusAlert.show(
            context,
            duration: Duration(seconds: 1),
            title: "Reservation unsuccessful",
            subtitle: value,
            configuration: IconConfiguration(icon: Icons.error)
          );
          }
        },
        ).catchError((error){
          StatusAlert.show(
            context,
            duration: Duration(seconds: 1),
            title: "Reservation Error",
            subtitle: error,
            configuration: IconConfiguration(icon: Icons.check)
          );
        });
  }

  // String compId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Texts(content: "Reservations", fontsize: 20, weight: FontWeight.bold,),
                      const Gap(20),
                      const Card(
                        elevation: 10,
                        child: ListTile(
                          tileColor: Color.fromARGB(255, 180, 248, 182),
                          leading: Icon(Icons.chair),
                          title: Text('Reservation 0001'),
                          subtitle: Text('This is a notification'),
                        ),
                      ),
                      const Card(
                        child: ListTile(
                          leading: Icon(Icons.chair),
                          title: Text('Reservation 0002'),
                          subtitle: Text('This is a notification'),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      floatingActionButton: 
      FloatingActionButton(
        onPressed: openScanner, 
        tooltip: 'Scan Reservation Ticket',
        isExtended: true,
        child: const Icon(Icons.qr_code_scanner),
        )
    );
  }
}