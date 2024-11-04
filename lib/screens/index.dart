import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluganmobile_conductors_and_inspector/helpers/screenselector.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/landingscreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor:Colors.greenAccent,
      splash:  const Center(
        child: Image(
                    image: AssetImage(
                      "assets/images/logo.png",
                    ),
        ),
      ),
    splashIconSize: 300,
    nextScreen: FirebaseAuth.instance.currentUser == null ? const LandingScreen() : HomeScreenSelector()
    );
  }
}