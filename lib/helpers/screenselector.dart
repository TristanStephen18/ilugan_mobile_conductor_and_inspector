import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluganmobile_conductors_and_inspector/AuthService.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/holderfile.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/homescreen_con.dart';
import 'package:iluganmobile_conductors_and_inspector/inspector_screens/homescreen_ins.dart';
import 'package:iluganmobile_conductors_and_inspector/main.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/landingscreen.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/loadingscreen.dart';

class HomeScreenSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    return FutureBuilder<Map<String, String>>(
      future: authService.getUserTypeAndCompanyId(FirebaseAuth.instance.currentUser!.email!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        } else if (snapshot.hasData) {
          String userType = snapshot.data!['type'] ?? '';
          String companyId = snapshot.data!['companyId'] ?? '';

          if (userType == 'conductor') {
            // return ConductorScreens(companyId: companyId, busnum: "", conId: FirebaseAuth.instance.currentUser!.uid,);
            return Dashboard_Con(compId: companyId, bus_num: "", conID: FirebaseAuth.instance.currentUser!.uid,);
          } else if (userType == 'inspector') {
            return Dashboard_Ins(compId: companyId);
          } else {
            return const LandingScreen();  // Fallback for unknown user types
          }
        } else {
          return const LandingScreen();  // In case of any errors or missing data
        }
      },
    );
  }
}
