// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';
import 'package:intl/intl.dart';
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
    print(DateTime.now());
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
            configuration:
                const IconConfiguration(icon: Icons.qr_code_scanner));
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
          print('Getting reservations');
          print('Scanning passenger ID');
          if (reservationQuery.docs.isNotEmpty) {
            // Get the reservation document reference
            var reservationDoc = reservationQuery.docs.first.reference;

            // Update the 'accomplished' field to true
            await reservationDoc
                .update({'accomplished': true}).then((value) async {
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
                    subtitle:
                        "Passenger ID: $passengerId, Status: Accomplished",
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

  void showloader() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Processing Reservation'),
            content: Center(
              child: CircularProgressIndicator(),
            ),
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

// String today = DateFormat.yMMMMd('en_US').format(DateTime.now());

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class ToAccomplish extends StatefulWidget {
  final String companyId;
  final String busNum;

  const ToAccomplish({required this.companyId, required this.busNum, super.key});

  @override
  State<ToAccomplish> createState() => _ToAccomplishState();
}

class _ToAccomplishState extends State<ToAccomplish> {
  List<Map<String, dynamic>> toAccomplishList = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    sample(); // Use sample function to fetch data
  }

  void sample() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.companyId)
          .collection('buses')
          .doc(widget.busNum)
          .collection('reservations')
          .where('accomplished', isEqualTo: false)
          .get();

      List<Map<String, dynamic>> filteredReservations = [];
      String today = DateFormat.yMMMMd('en_US').format(DateTime.now());

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String reservationDate =
            DateFormat.yMMMMd('en_US').format(data['date_time'].toDate());

        if (reservationDate == today) {
          filteredReservations.add({
            ...data,
            'id': doc.id, // Include document ID for display
          });
          print('Reservation for today: ${doc.id}');
        } else {
          print('Reservation not for today: ${doc.id}');
        }
      }

      setState(() {
        toAccomplishList = filteredReservations;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Failed to fetch data: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    if (toAccomplishList.isEmpty) {
      return const Center(child: Text("No pending reservations for today"));
    }

    // Display the list of reservations
    return ListView.builder(
      itemCount: toAccomplishList.length,
      itemBuilder: (context, index) {
        final reservation = toAccomplishList[index];
        final reservationDateTime =
            (reservation['date_time'] as Timestamp).toDate();

        return Card(
          elevation: 10,
          child: ListTile(
            title: Text('Reservation #${reservation['id']}'),
            subtitle: Text(
              'Date: ${DateFormat('MM-dd-yyyy - hh:mm a').format(reservationDateTime)}\n'
              'Amount: ${reservation['amount']} - From: ${reservation['from']} - To: ${reservation['to']}',
            ),
            trailing: const Icon(Icons.pending),
          ),
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
    final todayStart = DateTime.now();
    final todayEnd =
        DateTime(todayStart.year, todayStart.month, todayStart.day, 23, 59, 59);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('companies')
          .doc(companyId)
          .collection('buses')
          .doc(busNum)
          .collection('reservations')
          .where('accomplished', isEqualTo: true)
          .where('date_time', isGreaterThanOrEqualTo: todayStart)
          .where('date_time', isLessThanOrEqualTo: todayEnd)
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
                title: CustomText(content: 'Reservation #${doc.id}'),
                subtitle: CustomText(
                    content:
                        'Date: ${DateFormat('MM-dd-yyyy - hh:mm a').format(doc['date_time'].toDate())}'),
                trailing: const Icon(Icons.check),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
