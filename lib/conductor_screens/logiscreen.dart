import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginCon extends StatefulWidget {
  const LoginCon({super.key});

  @override
  State<LoginCon> createState() => _LoginConState();
}

class _LoginConState extends State<LoginCon> {
var usernamecon = TextEditingController();
var passcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: const [
          Padding(
            padding: EdgeInsets.all(3.0),
            child: Image(image: AssetImage("assets/images/logo.png")),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello", 
            style: TextStyle(
              fontSize: 40,
              color: Colors.white
            ),
            ),
            const Gap(20),
            const Text("Welcome back! Kindly Enter your login details", 
             style: TextStyle(
              fontSize: 20,
              color: Colors.white
            ),
            ),
            const Gap(40),
            const Text("Username"),
            const Gap(5),
            TextField(
              controller: usernamecon,
              decoration: const InputDecoration(
                hoverColor: Colors.white,
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                filled: true,
                fillColor: Colors.white
              ),
            ),
            const Gap(20),
            const Text("Password"),
            const Gap(5),
            TextField(
              controller: passcon,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                filled: true,
                fillColor: Colors.white
              ),
            ),
            const Gap(50),
            Center(
              child: ElevatedButton(
                onPressed: (){}, 
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.sizeOf(context).width/2, 50)
                ),
                child: const Text("Log In")),
            )
          ],
        ),
      )
    );
  }
}