import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Appdrawers extends StatelessWidget {
  Appdrawers({
    super.key,
    required this.logoutfunc
    });

  VoidCallback logoutfunc;

  @override
  Widget build(BuildContext context) {
    return Drawer(   
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: const Text('Ilugan')
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              title: Text('Log out'),
              onTap: logoutfunc,
            ),
          )
        ],
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      ''
    );
  }
}