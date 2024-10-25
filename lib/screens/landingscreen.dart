// import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/loginscreen.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Spacer(),
              CustomText(content: "ILugan", fsize: 50, fontcolor: Colors.yellow, fontweight: FontWeight.bold,), 
              const Spacer(),
              Image(
                image: const AssetImage('assets/images/logo.png'),
                height: 250,
                width: MediaQuery.sizeOf(context).width / 2,
              ),
              const Spacer(),
              CustomText(
                content: "ELEVATE YOUR TRAVEL",
                fontcolor: Colors.white,
                fontweight: FontWeight.bold,
                fsize: 25,
              ),
              CustomText(
                content: "EXPERIENCE HERE",
                fontcolor: Colors.white,
                fontweight: FontWeight.bold,
                fsize: 25,
              ),
              const Gap(10),
              CustomText(
                content: "We are comitted to make your journey convenient",
                 fontcolor: Colors.white,
                fsize: 15,
              ),
              CustomText(
                content: "easier and smarter",
                 fontcolor: Colors.white,
                fsize: 15,
              ),
              const Gap(40),
              Ebuttons(
                func: () {
                  Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => const LoginScreen()));
                },
                label: "Enter Ilugan",
                width: MediaQuery.sizeOf(context).width/1.4,
                height: 60,
                fcolor: Colors.redAccent,
                fontweight: FontWeight.bold,
                bcolor: const Color.fromARGB(255, 255, 255, 255),
                
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
