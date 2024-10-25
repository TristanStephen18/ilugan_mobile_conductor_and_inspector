import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Image(image: AssetImage('assets/images/icons/loader2.gif'), height: 800, width: 800,)
      ),
    );
  }
}