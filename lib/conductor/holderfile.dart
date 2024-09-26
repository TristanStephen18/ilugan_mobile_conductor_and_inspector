import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/homescreen_con.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/reservations.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/scannerscreen.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/loginscreen.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

class ConductorScreens extends StatefulWidget {
  ConductorScreens({super.key, required this.companyId,required this.busnum, required this.conId});

  String companyId;
  String busnum;
  String conId;

  @override
  State<ConductorScreens> createState() => _ConductorScreensState();
}

class _ConductorScreensState extends State<ConductorScreens> {

   void logout() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  int currentpageindex= 0;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);  
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Texts(content: 'ILugan', color: Colors.white, fontsize: 20, weight: FontWeight.bold,),
          toolbarHeight: 50,
          iconTheme: const IconThemeData(
            color: Colors.white
          ),
          backgroundColor: Colors.green,
          actions: [
            IconButton(onPressed: (){}, icon: const Icon(Icons.notifications))
          ],
        ),
        drawer: Appdrawers(logoutfunc: logout,),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index){
            setState(() {
              currentpageindex = index;
            });
          },
          indicatorColor: Colors.green,
          selectedIndex: currentpageindex,
          destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(Icons.map_sharp),
                icon: Icon(Icons.home_outlined),
                label: 'Map',
              ),
              // NavigationDestination(
              //   icon: Badge(child: Icon(Icons.qr_code_scanner)),
              //   label: 'Scanner',
              // ),
              NavigationDestination(
                icon: Badge(
                  child: Icon(Icons.list_alt_rounded),
                ),
                label: 'Reservations',
              ),
            ],
        ),
        body: <Widget>[
          /// Home page
          Dashboard_Con(compId: widget.companyId, bus_num: widget.busnum, conID: widget.conId),
          // TicketScanner(),
          Reservations()       
          ][currentpageindex],
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Visibility(
            visible: true,
              child: SizedBox(
                height: 80,
                width:  80,
                  child: FloatingActionButton(
            onPressed: (){},
            child: const Icon(Icons.qr_code_scanner_outlined, size: 80,),
          ))),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}