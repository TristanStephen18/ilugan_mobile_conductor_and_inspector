import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor_screens/logiscreen.dart';
import 'package:iluganmobile_conductors_and_inspector/inspector_screens/loginscreen.dart';

class Choosetypescreen extends StatefulWidget {
  const Choosetypescreen({super.key});

  @override
  State<Choosetypescreen> createState() => _ChoosetypescreenState();
}

class _ChoosetypescreenState extends State<Choosetypescreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(40),
              Center(
                child: Image(
                  image: const AssetImage('assets/images/logo.png'),
                  height: 250,
                  width: MediaQuery.sizeOf(context).width/2,
                  ),
              ),
              const Gap(10),
              const Text("I am a"),
              DropdownButton(
                hint: const Text("Choose your position"),
                iconSize: 10,
                icon: const Icon(Icons.arrow_downward),
                padding: const EdgeInsets.all(30),
                dropdownColor: Colors.white,
                items: const<DropdownMenuItem<String>>[
                  DropdownMenuItem(
                    value: "Conductor",
                    child: Text('Conductor'),
                  ),
                  DropdownMenuItem(
                    value: "Inspector",
                    child: Text('Inspector'),
                  ),
                ],
                onChanged: (value){
                  // print(value);
                  if(value == "Conductor"){
                    Navigator.of(context).push(CupertinoPageRoute(builder: (_)=>const LoginCon()));
                  }
                  if(value == "Inspector"){
                    Navigator.of(context).push(CupertinoPageRoute(builder: (_)=>const LoginIns()));
                  }
                }
                ),
            ],
          ),
          ),
        ),

    );
  }
}