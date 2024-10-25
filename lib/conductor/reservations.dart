import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:status_alert/status_alert.dart';

class Reservations extends StatefulWidget {
  @override
  State<Reservations> createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  String? companyId;
  String? busNum;

  @override
  void initState() {
    super.initState();
    retrieveUserData();
    print(busNum);
    print(companyId);
  }

  Future<void> retrieveUserData() async {
    // Get current user's ID
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('ilugan_mobile_users')
        .doc(userId)
        .get();

    if (userDoc.exists) {
      setState(() {
        companyId = userDoc['companyId'];
        busNum = userDoc['inbus'];
      });
    }
  }

 void openScanner() async {
  const lineColor = '#ffffff';
  const cancelButtonText = 'CANCEL';
  const isShowFlashIcon = true;
  const scanMode = ScanMode.DEFAULT;

  // Scan QR code
  final qr = await FlutterBarcodeScanner.scanBarcode(
      lineColor, cancelButtonText, isShowFlashIcon, scanMode)
      .then((value) async {
        if (value.isEmpty) {
          StatusAlert.show(context,
            duration: const Duration(seconds: 1),
            title: "Exited",
            subtitle: "No QR code scanned",
            configuration: const IconConfiguration(icon: Icons.qr_code_scanner));
        } else {
          try {
            showloader();
            // Assuming value contains passengerId from the QR code
            String passengerId = value;

            // Query Firestore to find the reservation
            var reservationQuery = await FirebaseFirestore.instance
              .collection('companies')
              .doc(companyId)
              .collection('buses')
              .doc(busNum)
              .collection('reservations')
              .where('passengerId', isEqualTo: passengerId)
              .get();
              print('sample');
              print('ahsdkajd');
            if (reservationQuery.docs.isNotEmpty) {
              // Get the reservation document reference
              var reservationDoc = reservationQuery.docs.first.reference;

              // Update the 'accomplished' field to true
              await reservationDoc.update({'accomplished': true}).then((value)async{
                await FirebaseFirestore.instance
                    .collection('passengers') // Specify the collection
                    .doc(passengerId) // Specify the document ID
                    .update({
                  'hasreservation': false,
                }).then((value) {
                  Navigator.of(context).pop();
                StatusAlert.show(context,
                duration: const Duration(seconds: 1),
                title: "Reservation Successful",
                subtitle: "Passenger ID: $passengerId, Status: Accomplished",
                configuration: const IconConfiguration(icon: Icons.check));
              });
            });
            } else {
              // No reservation found
              Navigator.of(context).pop();
              StatusAlert.show(context,
                duration: const Duration(seconds: 1),
                title: "Reservation Not Found",
                subtitle: "No reservation for Passenger ID: $passengerId",
                configuration: const IconConfiguration(icon: Icons.error));
            }
          } catch (error) {
            // Handle error
             Navigator.of(context).pop();
            StatusAlert.show(context,
              duration: const Duration(seconds: 1),
              title: "Error",
              subtitle: error.toString(),
              configuration: const IconConfiguration(icon: Icons.error));
          }
        }
      }).catchError((error) {
        // Handle scanning error
         Navigator.of(context).pop();
        StatusAlert.show(context,
          duration: const Duration(seconds: 1),
          title: "Scanning Error",
          subtitle: error.toString(),
          configuration: const IconConfiguration(icon: Icons.error));
      });
}



  void showloader(){
    showDialog(context: context, 
    builder: (context) {
      return const AlertDialog(
        title: Text('Processing Reservation'),
        content: Image(image: AssetImage('assets/images/icons/loader2.gif'), height: 100, width: 100,),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Accomplished"),
            ],
          ),
        ),
        body: busNum == null || companyId == null
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(children: [
                ToAccomplish(companyId: companyId!, busNum: busNum!),
                Accomplished(companyId: companyId!, busNum: busNum!),
              ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Visibility(
              visible: true,
              child: SizedBox(
                  height: 80,
                  width: 80,
                  child: FloatingActionButton(
                    onPressed: openScanner,
                    child: const Icon(
                      Icons.qr_code_scanner_outlined,
                      size: 80,
                    ),
                  ))),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class ToAccomplish extends StatelessWidget {
  final String companyId;
  final String busNum;

  const ToAccomplish({required this.companyId, required this.busNum});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('companies')
          .doc(companyId)
          .collection('buses')
          .doc(busNum)
          .collection('reservations')
          .where('accomplished', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No pending reservations"));
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return Card(
              elevation: 10,
              child: ListTile(
                title: Column(
                  children: [
                    Text("From: ${doc['from']}"),
                    Text('To: ${doc['to']}')
                  ],
                ),
                subtitle: Text("Seats: ${doc['seats_reserved']}"),
                trailing: Text('P ${doc['amount'].toString()}', style: TextStyle(
                  fontSize: 20
                ),),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class Accomplished extends StatelessWidget {
  final String companyId;
  final String busNum;

  const Accomplished({required this.companyId, required this.busNum});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('companies')
          .doc(companyId)
          .collection('buses')
          .doc(busNum)
          .collection('reservations')
          .where('accomplished', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No accomplished reservations"));
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return Card(
              elevation: 10,
              child: ListTile(
                tileColor: Colors.green,
                title: Column(
                  children: [
                    Text("From: ${doc['from']}"),
                    Text('To: ${doc['to']}')
                  ],
                ),
                subtitle: Text("Seats: ${doc['seats_reserved']}"),
                trailing: Icon(Icons.check)
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
