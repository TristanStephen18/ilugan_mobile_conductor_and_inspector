import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iluganmobile_conductors_and_inspector/AuthService.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/homescreen_con.dart';
import 'package:iluganmobile_conductors_and_inspector/inspector_screens/homescreen_ins.dart';
import 'firebase_options.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/landingscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AwesomeNotifications().initialize(
    null,  // Set your notification icon here
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ],
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<User?>(
        future: AuthService().getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());  // Loading indicator
          } else if (snapshot.hasData) {
            return HomeScreenSelector();
          } else {
            return const LandingScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreenSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    return FutureBuilder<Map<String, String>>(
      future: authService.getUserTypeAndCompanyId(FirebaseAuth.instance.currentUser!.email!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          String userType = snapshot.data!['type'] ?? '';
          String companyId = snapshot.data!['companyId'] ?? '';

          if (userType == 'conductor') {
            return Dashboard_Con(compId: companyId, bus_num: "",);
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
