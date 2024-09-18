import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/loginscreen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Gap(40),
              Image(
                image: const AssetImage('assets/images/logo.png'),
                height: 250,
                width: MediaQuery.sizeOf(context).width/2,
                ),
              const Gap(10),
              const Text("ELEVATE YOUR TRAVEL",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                  ),
              const Text(
                "EXPERIENCE HERE",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                const Gap(10),
                const Text(
                "We are comitted to make your journey convenient",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const Text(
                "easier and smarter",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const Gap(180),
                OutlinedButton(
                  onPressed: (){
                    Navigator.of(context).push(CupertinoPageRoute(builder: (_)=>const LoginScreen()));
                  }, 
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 44, 104, 46),
                    foregroundColor: Colors.white,
                    fixedSize: Size(MediaQuery.sizeOf(context).width - 70, 70),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 92, 252, 0),
                    )
                  ),
                  child: const Text("Let's get started",
                  style: TextStyle(
                    fontSize: 24
                  ),
                  ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}