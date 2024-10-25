// ignore_for_file: must_be_immutable

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:iluganmobile_conductors_and_inspector/conductor/homescreen_con.dart';
// import 'package:iluganmobile_conductors_and_inspector/conductor/notifications.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/reservations.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/scannerscreen.dart';
// import 'package:iluganmobile_conductors_and_inspector/conductor/scannerscreen.dart';
// import 'package:iluganmobile_conductors_and_inspector/screens/loginscreen.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';
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
          fontcolor: Colors.yellowAccent,
          fontweight: FontWeight.w500,
        ),
        actions: const [
          Image(
            image: AssetImage("assets/images/logo.png"),
            height: 50,
            width: 50,
          ),
        ],
        backgroundColor: Colors.redAccent,
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
        indicatorColor: Colors.redAccent,
        selectedIndex: currentpageindex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.pending, size: 40,),
            icon: Icon(Icons.pending),
            label: 'Pending',
          ),
          // NavigationDestination(
          //   icon: Badge(child: Icon(Icons.qr_code_scanner)),
          //   label: 'Scan Ticket',
          // ),
          NavigationDestination(
            icon: Badge(
              child: Icon(Icons.done, size: 40,),
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
          onPressed: () {
            // Define your action
          },
          tooltip: "Scan Passengers Ticket",
          child: const Icon(Icons.qr_code_scanner, size: 80, color: Colors.redAccent,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
