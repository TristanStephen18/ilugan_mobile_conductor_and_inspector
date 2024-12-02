// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/accomplished.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/helpers.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:iluganmobile_conductors_and_inspector/conductor/homescreen_con.dart';
// import 'package:iluganmobile_conductors_and_inspector/conductor/notifications.dart';
// import 'package:iluganmobile_conductors_and_inspector/conductor/reservations.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/toaccomplish.dart';
// import 'package:iluganmobile_conductors_and_inspector/conductor/scannerscreen.dart';
// import 'package:iluganmobile_conductors_and_inspector/conductor/scannerscreen.dart';
// import 'package:iluganmobile_conductors_and_inspector/screens/loginscreen.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';
import 'package:status_alert/status_alert.dart';
// import 'package:status_alert/status_alert.dart';
// import 'package:status_alert/status_alert.dart';

class ReservationsScreen extends StatefulWidget {
  ReservationsScreen(
      {super.key,
      required this.companyId,
      required this.busnum,
      required this.conId});

  String companyId;
  String busnum;
  String conId;

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.companyId + " " + widget.busnum);
    print(DateTime.now());
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
          String resnum = value;
          var reservationQuery = FirebaseFirestore.instance
              .collection('companies')
              .doc(widget.companyId)
              .collection('buses')
              .doc(widget.busnum)
              .collection('reservations')
              .doc(resnum);

          DocumentSnapshot snapshot = await reservationQuery.get();
          print(snapshot);
          if(snapshot.exists){
            print("Data exists");
            var data = snapshot.data() as Map<String, dynamic>;
            print(data['accomplished']);
            if(data['accomplished'] == true){
               StatusAlert.show(context,
                    duration: const Duration(seconds: 1),
                    title: "Reservation Error",
                    subtitle: "Reservation has already been accomplished",
                    configuration:
                        const IconConfiguration(icon: Icons.warning_amber));
            }else{
              reservationQuery.update({'accomplished': true}).then((value) async {
            print("Reservation Accomplished");
            DocumentSnapshot<Map<String, dynamic>> snapshot =
                await reservationQuery.get();
            if (snapshot.exists) {
              var data = snapshot.data() as Map<String, dynamic>;
              FirebaseFirestore.instance
                  .collection('passengers')
                  .doc(data['passengerId'])
                  .update({
                'hasreservation': false,
                'currentlyonbus': true
              }).then((value) {
                print("${data['passengerId']} now has no current reservations");
                Conductor().onsuccessfulscanned(data['passengerId']);
                StatusAlert.show(context,
                    duration: const Duration(seconds: 1),
                    title: "Scanning Successful",
                    subtitle: "Reservation has been accomplished",
                    configuration:
                        const IconConfiguration(icon: Icons.check));
              });
            }
          });
            }
          }else{
            print("data does not exists");
          }

          //   print('Getting reservations');
          //   print('Reservation');
          // if (reservationQuery.exists) {
          //   // Get the reservation document reference
          //   var reservationData = reservationQuery.data() as Map<String, dynamic>;

          // //   await reservationDoc.update({'accomplished': true}).then((value)async{
          // //     await FirebaseFirestore.instance
          // //         .collection('passengers') // Specify the collection
          // //         .doc(passengerId) // Specify the document ID
          // //         .update({
          // //       'hasreservation': false,
          // //     }).then((value) {
          // //       Navigator.of(context).pop();
          // //     StatusAlert.show(context,
          // //     duration: const Duration(seconds: 1),
          // //     title: "Reservation Successful",
          // //     subtitle: "Passenger ID: $passengerId, Status: Accomplished",
          // //     configuration: const IconConfiguration(icon: Icons.check));
          // //   });
          // // });
          // } else {
          //   // No reservation found
          //   Navigator.of(context).pop();
          //   StatusAlert.show(context,
          //     duration: const Duration(seconds: 1),
          //     title: "Reservation Not Found",
          //     subtitle: "No reservation for Passenger ID: $passengerId",
          //     configuration: const IconConfiguration(icon: Icons.error));
          // }
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

  // void logout() async {
  //   await FirebaseAuth.instance.signOut();
  //   // ignore: use_build_context_synchronously
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  // }

  int currentpageindex = 0;
  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        title: CustomText(
          content: 'Reservations',
          fsize: 20,
          fontcolor: Colors.white,
          fontweight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Image(
            image: AssetImage("assets/images/logo.png"),
            height: 50,
            width: 50,
          ),
        ],
        backgroundColor: Colors.green,
        // drawer: Appdrawers(
        //   logoutfunc: logout,
        // ),
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 19,
        height: 90,
        // backgroundColor: Colors.redAccent,
        onDestinationSelected: (int index) {
          setState(() {
            currentpageindex = index;
          });
        },
        indicatorColor: Colors.greenAccent,
        selectedIndex: currentpageindex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.pending,
              size: 40,
            ),
            icon: Icon(Icons.pending),
            label: 'Pending',
          ),
          // NavigationDestination(
          //   icon: Badge(child: Icon(Icons.qr_code_scanner)),
          //   label: 'Scan Ticket',
          // ),
          NavigationDestination(
            icon: Badge(
              child: Icon(
                Icons.done,
                size: 40,
              ),
            ),
            label: 'Accomplished',
          ),
        ],
      ),
      body: <Widget>[
        ToAccomplish(companyId: widget.companyId, busNum: widget.busnum),
        // TicketScanner(),
        Accomplished(companyId: widget.companyId, busNum: widget.busnum)
      ][currentpageindex],
      floatingActionButton: SizedBox(
        height: 100, // Adjust height to make the FAB taller
        width: 100, // Adjust width if necessary
        child: FloatingActionButton(
          onPressed: openScanner,
          tooltip: "Scan Passengers Ticket",
          child: const Icon(
            Icons.qr_code_scanner,
            size: 80,
            color: Colors.green,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
