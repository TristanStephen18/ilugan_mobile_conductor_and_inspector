// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:iluganmobile_conductors_and_inspector/conductor/alerting.dart';
import 'package:iluganmobile_conductors_and_inspector/helpers/notifications.dart';
// import 'package:iluganmobile_conductors_and_inspector/AuthService.dart';
// import 'package:iluganmobile_conductors_and_inspector/helpers/screenselector.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/index.dart';
// import 'package:iluganmobile_conductors_and_inspector/screens/loadingscreen.dart';
import 'firebase_options.dart';
// import 'package:iluganmobile_conductors_and_inspector/screens/landingscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Notifications.initializenotifications();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}